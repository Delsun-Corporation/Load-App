//
//  TrainingSettingsViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 30/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class TrainingSettingsViewModel: RaceTimeDelegate {
    
    //MARK:- Variables
    fileprivate weak var theController:TrainingSettingsVC!
    
    let headerArray: [String] = ["MEASUREMENT", "CARDIO", "RESISTANCE"]
    let titleArray: [[String]] = [["Units", "Height", "Weight", "BMI","Physical activity level"], ["Auto-Pause","Heart rate","VO2 max","Running time","Bike setting"], ["Time under tension"]]
    var textArray: [[String]] = [["", "", "", "",""], ["","","","",""], [""]]

    var trainingResponse: SettingProgramModelClass?
    
    var txtHRMax:String = ""
    var isHrMaxIsEstimated = true
    var txtHRRest: String = ""
    var txtHeight:String = ""
    var txtWeight:String = ""
    var raceDistanceId:String = ""
    var raceTime:String = ""
    var txtTypes:String = ""
    var txtTypesId:Int = 0
    
    var bikeWeight: CGFloat = 0.0
    var bikeWheelDiameter: CGFloat = 0.0
    var bikeFrontChainWheel = 0
    var bikeRearFreeWheel = 0
    
    var isRunAutoPause = false
    var isCycleAutoPause = false
    var selectedPhysicalActivityId = 0
    var vo2MaxCustomeValue = ""
    var isVO2MaxIsEstimated = true

    
    //MARK:- Functions
    init(theController:TrainingSettingsVC) {
        self.theController = theController
    }
    
    func setupUI() {
        /*
        self.textArray[1][0] = (getUserDetail().data?.user?.dateOfBirth ?? "") == "" ? "" : self.getHRMax(date: getUserDetail().data?.user?.dateOfBirth ?? "")
        self.txtHRMax = self.textArray[1][0]
        */
        self.textArray[0][1] = getUserDetail()?.data?.user?.height?.stringValue ?? ""
        self.txtHeight = self.textArray[0][1]
        
        self.textArray[0][2] = getUserDetail()?.data?.user?.weight?.stringValue ?? ""
        self.txtWeight = self.textArray[0][2]
        
        self.apiCallGetSettingProgram(isLoading: true)
    }
    
    func setupNavigationbar(title:String) {
        
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = false
            vwnav.btnSave.isHidden = true
            
            //Call this method if Client want to remove auto save functionality
            //It is apply when write btnSave.isHidden = false
//            vwnav.btnSave.isHidden = self.theController.btnSave.isHidden
//            if let viewWithTag = self.theController.navigationController!.view.viewWithTag(102) {
//                self.theController.navigationSaveButtonShowOrHide()
//            }
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: CGFloat(hightOfView), width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: 61)
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 16, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            
            vwnav.lblTitle.textColor = .black
            
            vwnav.tag = 102
            vwnav.delegate = self
            
            self.theController.navigationController?.view.addSubview(vwnav)
            
        }
    }

    func apiCallGetSettingProgram(isLoading:Bool = true) {
        let param = ["": ""] as [String : Any]
        print(param)
        
        ApiManager.shared.MakeGetAPI(name: GET_SETTING_PROGRAM , params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.trainingResponse = SettingProgramModelClass(JSON: data.dictionaryObject!)
                    self.txtTypesId = Int(self.trainingResponse?.trainingUnitIds?.first ?? "0") ?? 0
//                    self.textArray[0][0] = self.trainingResponse?.hrMax?.stringValue ?? ""
                    /*
                    self.textArray[1][0] = (getUserDetail().data?.user?.dateOfBirth ?? "") == "" ? "" : self.getHRMax(date: getUserDetail().data?.user?.dateOfBirth ?? "")
                     */
                    self.textArray[0][1] = self.trainingResponse?.height?.stringValue ?? ""
                    self.textArray[0][2] = self.trainingResponse?.weight?.stringValue ?? ""
                    self.textArray[1][2] = self.trainingResponse?.VO2Max?.stringValue ?? ""
                    
                    self.txtHRMax = self.trainingResponse?.hrMax?.stringValue ?? ""
                    self.txtHRRest = self.trainingResponse?.hrRest?.stringValue ?? ""
                    self.isHrMaxIsEstimated = self.trainingResponse?.isHrMaxIsEstimated ?? true
                    
//                    let txtHRMax = self.trainingResponse?.hrMax?.doubleValue ?? 0
//                    self.txtHRMax = txtHRMax == 0 ? self.textArray[0][0] : "\(txtHRMax.rounded(toPlaces: 0))".replace(target: ".0", withString: "")
//                    self.textArray[0][0] = self.txtHRMax
                    self.txtHeight = self.trainingResponse?.height?.stringValue ?? ""
                    self.txtWeight = self.trainingResponse?.weight?.stringValue ?? ""
                    self.raceDistanceId = self.trainingResponse?.raceDistanceId?.stringValue ?? ""
                    self.raceTime = self.trainingResponse?.raceTime ?? ""
                    self.vo2MaxCustomeValue = self.trainingResponse?.VO2Max?.stringValue ?? ""

                    self.isRunAutoPause = self.trainingResponse?.runAutoPause ?? false
                    self.isCycleAutoPause = self.trainingResponse?.cycleAutoPause ?? false
                    
                    self.selectedPhysicalActivityId = self.trainingResponse?.physicalAcitivityId ?? 0
                    
                    self.bikeWeight = self.theController.setOneDigitWithFloorInCGFLoat(value: self.trainingResponse?.bikeWeight ?? 0.0)
                    
                    self.bikeWheelDiameter = self.theController.setOneDigitWithFloorInCGFLoat(value: self.trainingResponse?.bikeWheelDiameter ?? 0.0)
                    
                    self.bikeRearFreeWheel = self.trainingResponse?.bikeRearFreeWheel ?? 0
                    self.bikeFrontChainWheel = self.trainingResponse?.bikeFrontChainWheel ?? 0

                    
                    let view = (self.theController.view as? TrainingSettingsView)
                    view?.tableView.reloadData {
                        if IS_OPEN_RACETIME {
                            IS_OPEN_RACETIME = false
                            self.moveRaceTime()
                        }
                    }
                }
                else {

                }
            }
        })
    }
    
    func getHRMax(date:String) -> String {
        let now = Date().toString(dateFormat: "yyyy")
        let birthday: String = convertDateFormater(date, format: "dd-MM-yyyy", dateFormat: "yyyy")
        let age = Int(now)! - Int(birthday)!
//        let calendar = Calendar.current
//        let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
//        let age = ageComponents.year!
        let value = Int(206.9 - (0.67 * Double(age)))
        return "\(value)".replace(target: ".00", withString: "")
    }
    
    func apiCallSettingCreateUpdateProgram() {
//        var param = ["hr_max": hrMax, "height": height, "weight": weight, "race_distance_id": raceDistanceId, "race_time": raceTime] as [String : Any]
   /*
        if self.txtHeight == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_height_key"))
            return
        }
        else if Int(self.txtHeight) == 0 {
            makeToast(strMessage: getCommonString(key: "Please_enter_height_key"))
            return
        }
        else if self.txtWeight == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_weight_key"))
            return
        }
        else if Int(self.txtWeight) == 0 {
            makeToast(strMessage: getCommonString(key: "Please_enter_weight_key"))
            return
        }
*/
        
        var trainingUnitIds:[Int] = []
        if self.txtTypesId != 0 {
            trainingUnitIds.append(self.txtTypesId)
        }
        
        var param = ["height": self.txtHeight,
                     "weight": self.txtWeight,
                     "race_distance_id": self.raceDistanceId,
                     "race_time": self.raceTime,
                     "training_unit_ids" : trainingUnitIds,
                     "run_auto_pause": self.isRunAutoPause,
                     "cycle_auto_pause": self.isCycleAutoPause,
                     "hr_max" : self.txtHRMax,
                     "hr_rest": self.txtHRRest,
                     "is_hr_max_is_estimated" : self.isHrMaxIsEstimated,
                     "training_physical_activity_level_ids" : self.selectedPhysicalActivityId,
                     "vo2_max" :  self.isVO2MaxIsEstimated == true ? "" : self.vo2MaxCustomeValue,
                     "is_vo2_max_is_estimated" : self.isVO2MaxIsEstimated,
                     "bike_weight": self.bikeWeight,
                     "bike_wheel_diameter" : self.bikeWheelDiameter,
                     "bike_front_chainwheel": self.bikeFrontChainWheel,
                     "bike_rear_freewheel": self.bikeRearFreeWheel
                    ] as [String : Any]

        if raceDistanceId == "" {
            param.removeValue(forKey: "race_distance_id")
        }
        
        if raceTime == "" {
            param.removeValue(forKey: "race_time")
        }
        
//        if self.vo2MaxCustomeValue == ""{
//            param.removeValue(forKey: "vo2_max")
//        }
        
        print(param)
        
        ApiManager.shared.MakePostAPI(name: SETTING_CREATE_UPDATE_PROGRAM , params: param as [String : Any], progress: false, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.trainingResponse = SettingProgramModelClass(JSON: data.dictionaryObject!)
//                    self.textArray[0][0] = self.trainingResponse?.hrMax?.stringValue ?? ""
                   
                    /*
                    self.textArray[1][0] = (getUserDetail().data?.user?.dateOfBirth ?? "") == "" ? "" : self.getHRMax(date: getUserDetail().data?.user?.dateOfBirth ?? "")
                    */
                    
                    self.textArray[0][1] = self.trainingResponse?.height?.stringValue ?? ""
                    self.textArray[0][2] = self.trainingResponse?.weight?.stringValue ?? ""
                    self.textArray[1][2] = self.trainingResponse?.VO2Max?.stringValue ?? ""
                    
                    self.txtHRMax = self.trainingResponse?.hrMax?.stringValue ?? ""
                    self.txtHRRest = self.trainingResponse?.hrRest?.stringValue ?? ""

                    self.isHrMaxIsEstimated = self.trainingResponse?.isHrMaxIsEstimated ?? true
                    
//                    self.txtHRMax = txtHRMax == 0 ? self.textArray[0][0] : "\(txtHRMax.rounded(toPlaces: 0))".replace(target: ".0", withString: "")
//                    self.textArray[0][0] = self.txtHRMax

//                    self.txtHRMax = self.textArray[0][0]//self.trainingResponse?.hrMax?.stringValue ?? ""
                    self.txtHeight = self.trainingResponse?.height?.stringValue ?? ""
                    self.txtWeight = self.trainingResponse?.weight?.stringValue ?? ""
                    self.raceDistanceId = self.trainingResponse?.raceDistanceId?.stringValue ?? ""
                    self.raceTime = self.trainingResponse?.raceTime ?? ""
                    self.vo2MaxCustomeValue = self.trainingResponse?.VO2Max?.stringValue ?? ""
                    
                    self.isRunAutoPause = self.trainingResponse?.runAutoPause ?? false
                    self.isCycleAutoPause = self.trainingResponse?.cycleAutoPause ?? false
                    self.selectedPhysicalActivityId = self.trainingResponse?.physicalAcitivityId ?? 0
                    
                    self.bikeWeight = self.theController.setOneDigitWithFloorInCGFLoat(value: self.trainingResponse?.bikeWeight ?? 0.0)
                    
                    self.bikeWheelDiameter = self.theController.setOneDigitWithFloorInCGFLoat(value: self.trainingResponse?.bikeWheelDiameter ?? 0.0)
                    
                    self.bikeRearFreeWheel = self.trainingResponse?.bikeRearFreeWheel ?? 0
                    self.bikeFrontChainWheel = self.trainingResponse?.bikeFrontChainWheel ?? 0
                    
                    let view = (self.theController.view as? TrainingSettingsView)
                    view?.tableView.reloadData()
                }
                else {
                    let error = json.getString(key: .message)
                    makeToast(strMessage: error)
                }
            }
        })
    }
    
    func validateDetails() {
//        if self.txtHRMax == "" {
//            makeToast(strMessage: getCommonString(key: "Please_enter_HR_max_key"))
//        }
//        else
        if self.txtHeight == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_height_key"))
        }
        else if Int(self.txtHeight) == 0 {
            makeToast(strMessage: getCommonString(key: "Please_enter_height_key"))
        }
        else if self.txtWeight == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_weight_key"))
        }
        else if Int(self.txtWeight) == 0 {
            makeToast(strMessage: getCommonString(key: "Please_enter_weight_key"))
        }
        else {
            self.theController.btnSave.isHidden = true
            self.apiCallSettingCreateUpdateProgram()
        }
    }
    
    func moveRaceTime() {
        let obj: RaceTimeVC = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "RaceTimeVC") as! RaceTimeVC
        obj.mainModelView.delegate = self
        obj.mainModelView.raceDistanceId = self.raceDistanceId
        obj.mainModelView.raceTime = self.raceTime
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func RaceTimeFinish(raceDistanceId: String, raceTime: String) {
        if self.raceDistanceId != raceDistanceId || self.raceTime != raceTime {
            self.theController.btnSave.isHidden = false
        }
        self.raceDistanceId = raceDistanceId
        self.raceTime = raceTime
        
        self.apiCallSettingCreateUpdateProgram()

    }

}


//MARK: - navigation delegate
extension TrainingSettingsViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.backButtonAction()
    }
    
    func CustomNavigationSave() {
        self.validateDetails()
    }

}

