
//
//  TrainingProgramConfirmationPageViewModel.swift
//  Load
//
//  Created by iMac on 03/06/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

class TrainingProgramConfirmationPageViewModel: CustomNavigationDelegate {
    
    fileprivate weak var theController:TrainingProgramConfirmationPageVc!

    init(theController:TrainingProgramConfirmationPageVc) {
        self.theController = theController
    }
    
    //We used same delegate method as we added in ConfimrationPageVc(Training program screen)
    var delegateConfirmation: dismissConfirmationPageDelegate?
    var trainingLogId = ""
    
    var confirmationData: confirmationDetails?
    
    var isAvgPaceSelect = false
    
    var enteredTotalDistance = ""
    var enteredTotalDuration = ""
    var enteredAvgSpeed = ""
    var enteredAvgPace = ""
    
    //MARK: - SetupUI
    
    func setupUI(){
        self.apiCallGetAndUpdateData(txtTotalDuration: "", txtTotalDistance: "", txtAvgSpeed: "", txtAvgPace: "")
    }
    
    //MARK: setupNavigation Bar
    
    func setupNavigationbar(title:String) {
        //add for push
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationController?.setColor()
        self.theController.navigationItem.hidesBackButton = true
        self.theController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        if let vwnav = ViewNav.instanceFromNib() as? ViewNav {
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 20
            }
            else {
                hightOfView = -4
            }
            
            vwnav.frame = CGRect(x: 0, y: 0, width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height + CGFloat(hightOfView))
            
            vwnav.leadingConstraintLabelConstant.constant = 30
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 20, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            vwnav.btnClose.isHidden = true
            
            vwnav.tag = 1000
            vwnav.delegate = self
            self.theController.navigationController?.view.addSubview(vwnav)
        }
    }
    
    func CustomNavigationClose() {
        self.theController.dismiss(animated: true, completion: nil)
    }

    func showThirdTextFieldAccordingToActivityName(){
        
        let avgSpeedUnit = self.confirmationData?.generatedCalculations?.avgSpeedUnit ?? ""
        let avgPaceUnit = self.confirmationData?.generatedCalculations?.avgPaceUnit ?? ""
        
        if let vw = self.theController.view as? TrainingProgramConfirmationPageView{
            
            vw.vwAvgSpeed.isHidden = false
            
            if self.isAvgPaceSelect == true {
                
                vw.lblAvgSpeedUnit.text = avgPaceUnit
                
                let strColon = self.confirmationData?.generatedCalculations?.avgPace
                
                var arrayPace = strColon?.split(separator: ":")
                var valueOfFirstIndex = ""
                
                if arrayPace?.count == 2{
                    if Int(arrayPace?[0] ?? "") ?? 0 <= 9 {
                        valueOfFirstIndex = "0\(Int(String(arrayPace?[0] ?? "0")) ?? 0)"
                    }else{
                        valueOfFirstIndex = String(arrayPace?[0] ?? "00")
                    }
                    
                    let checkValue = "\(valueOfFirstIndex):\(arrayPace?[1] ?? "00")"
                    
                    //            print("Total Duration:\(checkValue)")
                    
                    vw.txtAvgSpeed.text = checkValue.replacingOccurrences(of: ":", with: "  ")
                }
                
            } else {
                vw.lblAvgSpeedUnit.text = avgSpeedUnit
                
                vw.txtAvgSpeed.text = self.theController.setOneDigitWithFloor(value: self.confirmationData?.generatedCalculations?.avgSpeed ?? 0.0)
                
            }
            
            if self.isAvgPaceSelect == true {
                self.enteredAvgPace = (vw.txtAvgSpeed.text ?? "").replacingOccurrences(of: "  ", with: ":")
            } else {
                self.enteredAvgSpeed = vw.txtAvgSpeed.text ?? ""
            }
        }
        
        self.theController.changeColorAccordingToClickable()
    }
}

//MARK: - API calling

extension TrainingProgramConfirmationPageViewModel{
    
    
    func apiCallGetAndUpdateData(isForUpdate:Bool = false,txtTotalDuration:String,txtTotalDistance:String,txtAvgSpeed:String,txtAvgPace:String, progress:Bool = true) {
        
        var param = [String:Any]()
        
        if isForUpdate{
            param = [
            "id": trainingLogId
            ]
            
            if txtTotalDistance != ""{
                param["generated_calculations"] = ["total_distance": txtTotalDistance.toFloat()]
            }
            
            if txtTotalDuration != ""{
                param["generated_calculations"] = ["total_duration": txtTotalDuration]
            }
            
            if txtAvgSpeed != ""{
                param["generated_calculations"] = ["avg_speed": txtAvgSpeed.toFloat()]
            }
            
            if txtAvgPace != ""{
                param["generated_calculations"] = ["avg_pace": txtAvgPace]
            }
            
        }else{
            param = [
            "id": trainingLogId,
            "generated_calculations": []
            ] as [String : Any]
        }
        
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: GET_AND_UPDATE_CONFIRMATION_DATA_FOR_TRAINING_PROGRAM, params: param as [String : Any], progress: progress, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let model = GetAndUpdateConfirmationPageModel(JSON: json.dictionaryObject!)
                    self.confirmationData = model?.data
                    self.dataFillUp()
                }
                else {
                    self.theController.changeColorAccordingToClickable()
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            } else {
                self.theController.changeColorAccordingToClickable()
            }
        })
    }
    
    func dataFillUp(){
        
        if let vw = self.theController.view as? TrainingProgramConfirmationPageView{
            
            if self.isAvgPaceSelect == true{
                vw.lblColonChangeParameter.isHidden = false
            }else{
                vw.lblColonChangeParameter.isHidden = true
                vw.widthConstraintForChangeParamter.constant = CGFloat("\(CGFloat((self.confirmationData?.generatedCalculations?.avgSpeed ?? 0)))".count * 10)
                
                print("COnstant : \(vw.widthConstraintForChangeParamter.constant)")
            }


            vw.lblActivityName.text = self.findActivityNameFromId(id: self.confirmationData?.cardioActivityTypeId ?? 1)
           
            let strColon = self.confirmationData?.generatedCalculations?.totalDuration
            
            var arrayDuration = strColon?.split(separator: ":")
            var valueOfFirstIndex = ""

            if arrayDuration?.count == 3{
                
                if Int(arrayDuration?[0] ?? "") ?? 0 <= 9 {
                    valueOfFirstIndex = "0\(Int(String(arrayDuration?[0] ?? "0")) ?? 0)"
                }else{
                    valueOfFirstIndex = String(arrayDuration?[0] ?? "00")
                }

                let checkValue = "\(valueOfFirstIndex):\(arrayDuration?[1] ?? "00"):\(arrayDuration?[2] ?? "00")"

                print("Total Duration:\(checkValue)")
                
                vw.txtTotalDuration.text = checkValue.replacingOccurrences(of: ":", with: "  ")

            }
            
            vw.txtTotalDistance.text = self.theController.setOneDigitWithFloor(value: self.confirmationData?.generatedCalculations?.totalDistance ?? 0.0)
            vw.lblTotalDistanceUnit.text = self.confirmationData?.generatedCalculations?.totalDistanceUnit ?? ""
            
            self.enteredTotalDistance = self.theController.setOneDigitWithFloor(value: self.confirmationData?.generatedCalculations?.totalDistance ?? 0.0)
            self.enteredTotalDuration = (vw.txtTotalDuration.text ?? "").replacingOccurrences(of: "  ", with: ":")
            
            self.showThirdTextFieldAccordingToActivityName()
        }
        
    }

    func findActivityNameFromId(id:Int) -> String{
        
        let arrayActivity = GetAllData?.data?.trainingProgramActivity
        
        for i in 0..<(arrayActivity?.count ?? 0){
            
            if id == Int(arrayActivity?[i].id ?? 0){
                return arrayActivity?[i].name ?? ""
            }
        }
        
        return ""

    }

}
