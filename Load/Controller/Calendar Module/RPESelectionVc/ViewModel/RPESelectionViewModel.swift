//
//  RPMSelectionViewModel.swift
//  Load
//
//  Created by iMac on 25/04/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON

protocol delegateDismissRPESelection {
    func dismissdelegateDismissRPESelection()
}


class RPESelectionViewModel: CustomNavigationDelegate{
    
    //MARK:- Variables
    fileprivate weak var theController:RPESelectionVc!
    
    var delegateDismissRPESelection : delegateDismissRPESelection?

    var trainingLogId: String = ""
    var selectedRPESliderValue = 1
    
    var arrayData = ["Very, very easy",
                     "Easy",
                     "Moderate",
                     "Somewhat hard",
                     "Hard",
                     "Getting very hard",
                     "Very hard",
                     "Really hard",
                     "Extremely hard",
                     "Maximal"]
    
    
    var controllerMoveFrom = MOVE_FROM_GENERATED_CALCULATION_TRAINING_LOG_OR_PROGRAM.trainingLog
    
    //MARK:- Functions
    init(theController:RPESelectionVc) {
        self.theController = theController
    }

    func setupNavigationbar(title:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationController?.setColor()
        self.theController.navigationItem.hidesBackButton = true
        self.theController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        
        if let vwnav = ViewNav.instanceFromNib() as? ViewNav {
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: 0, width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height + CGFloat(hightOfView))
            
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
    }
    
    func saveSummaryCardiolog(){

        let param = [
            "RPE": "\(self.selectedRPESliderValue) (\(self.arrayData[self.selectedRPESliderValue-1]))" ,
            "is_complete" : true
            ] as [String : Any]
        
        
        var url = ""
        
        if self.controllerMoveFrom == .trainingLog{
            url = COMPLETE_TRAINING_LOG
        }else if self.controllerMoveFrom == .trainingProgram {
            url = UPDATE_WEEK_WISE_DAILY_PROGRAMS
        }
        
        ApiManager.shared.MakePutAPI(name: url + "/" + trainingLogId, params: param as [String : Any], progress: true, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    
                    AppDelegate.shared?.delegateUpadateLatLong = nil

                    if self.controllerMoveFrom == .trainingLog{
                        if let valueFound = Defaults.value(forKey: self.trainingLogId) {
                            Defaults.removeObject(forKey: self.trainingLogId)
                            Defaults.synchronize()
                        }
                        
                        guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
                            return
                        }
                        
                        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data?.user?.id?.stringValue && $0.activityId == self.trainingLogId}

                        if routeObjects.count > 0 {
                            guard let routerLapArray = realm?.objects(LapDetails.self) else {
                                return
                            }
                            
                            let lapObjects = Array(routerLapArray).filter { $0.routeId == routeObjects[0].id}

                            try? realm?.write{
                                realm?.delete(routeObjects[0])
                                realm?.delete(lapObjects)
                            }
                        }

                    } else if self.controllerMoveFrom == .trainingProgram {
                        
                        if let valueFound = Defaults.value(forKey: self.trainingLogId + " " + "Program"){
                            print("valueFound:\(valueFound)")
                            Defaults.removeObject(forKey: self.trainingLogId + " " + "Program")
                            Defaults.synchronize()
                        }
                        
                        guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                            return
                        }
                        
                        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data?.user?.id?.stringValue && $0.weekWiseProgramId == Int(self.trainingLogId)}

                        if routeObjects.count > 0{
                            
                            guard let routerLapArray = realm?.objects(LapDetails.self) else {
                                return
                            }
                            
                            let lapObjects = Array(routerLapArray).filter { $0.routeId == routeObjects[0].id}

                            try? realm?.write{
                                realm?.delete(routeObjects[0])
                                realm?.delete(lapObjects)
                            }
                        }

                    }
                    
                    self.delegateDismissRPESelection?.dismissdelegateDismissRPESelection()
                    self.theController.dismiss(animated: true, completion: nil)

                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
    }

    
}
