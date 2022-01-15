//
//  CalendarTrainingLogResistanceSummaryViewModel.swift
//  Load
//
//  Created by iMac on 20/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

class CalendarTrainingLogResistanceSummaryViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:CalendarTrainingLogResistanceSummaryVc!

    init(theController:CalendarTrainingLogResistanceSummaryVc) {
        self.theController = theController
    }
    
    var delegateDismissTrainingLogSummary : delegateDismissCalendarTrainingLogSummary?

    var resistanceSummaryDetails : ResistanceSummaryDetail?
    var trainingLogId = ""
    var isComeFromCalendar = false
    var date = ""
    
    func setupUI(){
        apiCallForGetSwummaryDetails()
    }
    
}

//MARK: - API calling

extension CalendarTrainingLogResistanceSummaryViewModel{
    
    func apiCallForGetSwummaryDetails() {
    
        let param = ["id": self.trainingLogId] as [String : Any]
        
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: GET_TRAINING_LOG_SUMMAARY_DETAILS, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let model = ResistanceSummaryDataModel(JSON: json.dictionaryObject!)
                self.resistanceSummaryDetails = model?.data
                self.setupData()
            }
        }
    }

    func setupData(){
        
        let view = (self.theController.view as? CalendarTrainingLogResistanceSummaryView)
        
//        view?.lblTotalDurationValue.text = self.resistanceSummaryDetails?.totalDuration
        
//        let formattedString = NSMutableAttributedString()
//        formattedString.normal( self.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.totalDistance ?? 0.0,digit: 2)).normal12(" \(self.cardioSummaryDetails?.totalDistaneUnit ?? "")", font: themeFont(size: 14, fontname: .ProximaNovaBold))
//        view?.lblTotalDistancekmValue.attributedText = formattedString
//
        
        view?.imgUser.sd_setImage(with: self.resistanceSummaryDetails?.userDetails?.photo!.toURL(), completed: nil)
        
        view?.lblCompletedVolumeValue.attributedText = setFontOfKg(mainString: "\(Int(self.resistanceSummaryDetails?.completedVolume ?? 0.0)) \(self.resistanceSummaryDetails?.completedVolumeUnit ?? "")", stringToColor: "\(self.resistanceSummaryDetails?.completedVolumeUnit ?? "")")
        
        view?.lblTargetVolumeValue.attributedText = setFontOfKg(mainString: "\(Int(self.resistanceSummaryDetails?.targetedVolume ?? 0.0)) \(self.resistanceSummaryDetails?.targetedVolumeUnit ?? "")", stringToColor: "\(self.resistanceSummaryDetails?.targetedVolumeUnit ?? "")")
        
        view?.lblTotalDurationValue.text = self.resistanceSummaryDetails?.totalDuration ?? ""
        view?.lblDummyTotalDurationValue.text = self.resistanceSummaryDetails?.totalDuration ?? ""

        view?.lblTitle.text = self.resistanceSummaryDetails?.workoutName ?? ""
        view?.lblDate.text =  convertDateFormater(self.resistanceSummaryDetails?.date ?? "", dateFormat: "dd EEEE yyyy")
        
        view?.lblTrainingGoalValue.text = self.resistanceSummaryDetails?.trainingGoal?.name ?? "-"
        view?.lblIntensityValue.text = self.resistanceSummaryDetails?.trainingIntensity?.name ?? "-"
        view?.lblRPEValue.text = String(self.resistanceSummaryDetails?.RPE ?? "-")
//        view?.lblTotalVolumeValue.text = oneDigitAfterDecimal(value: self.resistanceSummaryDetails?.totalVolume ?? 0) + " " + (self.resistanceSummaryDetails?.totalVolumeUnit ?? "")
        view?.lblAvgWeightLiftedValue.text = self.theController.oneDigitAfterDecimal(value: self.resistanceSummaryDetails?.averageWeightLifted ?? 0) + " " + (self.resistanceSummaryDetails?.averageWeightLiftedUnit ?? "")
        
        view?.txtvwComment.text = self.resistanceSummaryDetails?.comments
        
        if view?.txtvwComment.text.toTrim().count != 0{
            view?.lblPlaceholder.isHidden = true
        }
        
        view?.tableView.reloadData()
        
    }

    func setFontOfKg(mainString: String, stringToColor: String) -> NSAttributedString {
        let range = (mainString as NSString).range(of: stringToColor)
        
        let attribute = NSMutableAttributedString.init(string: mainString)
        attribute.addAttribute(NSAttributedString.Key.font, value: themeFont(size: 17, fontname: .ProximaNovaBold) , range: range)
        return attribute
    }
    
    func deleteLog() {
        let alertController = UIAlertController(title: getCommonString(key: "Load_key"), message: getCommonString(key: "Are_you_sure_want_to_delete_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            self.apiCallDeleteLog()
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.theController.present(alertController, animated: true, completion: nil)
    }
    
    func apiCallDeleteLog() {
        let param = ["":""]
        
        ApiManager.shared.MakeGetAPI(name: TRAINING_LOG_DELETE + "/" + (self.trainingLogId), params: param, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                self.theController.dismiss(animated: false, completion: {
                    makeToast(strMessage: json.getString(key: .message))
                    self.delegateDismissTrainingLogSummary?.dismissCalendarTrainingLogSummary()
                    if self.isComeFromCalendar{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
                    }
                })
            }
        })
    }
    
    
    func saveSummaryResistancelog(){
        
        let view = (self.theController.view as? CalendarTrainingLogResistanceSummaryView)
        
        var param = [
            "comments": view?.txtvwComment.text.toTrim(),
            ] as [String : Any]
        
        ApiManager.shared.MakePutAPI(name: COMPLETE_TRAINING_LOG + "/" + trainingLogId, params: param as [String : Any], progress: true, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
    }


}
