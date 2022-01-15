//
//  CalendarTrainingLogSummaryViewModel.swift
//  Load
//
//  Created by iMac on 17/03/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON

protocol delegateDismissCalendarTrainingLogSummary {
    func dismissCalendarTrainingLogSummary()
}

class CalendarTrainingLogSummaryViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:CalendarTrainingLogSummaryVc!

    init(theController:CalendarTrainingLogSummaryVc) {
        self.theController = theController
    }
    
    var delegateDismissTrainingLogSummary : delegateDismissCalendarTrainingLogSummary?
    
    var date = ""
    var trainingLogId = ""
    var cardioSummaryDetails:CardioSummaryDetails?
    var activityName = ""
    var isComeFromCalendar = false
    
    var controllerMoveFrom = MOVE_FROM_GENERATED_CALCULATION_TRAINING_LOG_OR_PROGRAM.trainingLog
    
    //MARK: - SetupUI
    
    func setupUI() {
        
        apiCallForGetSwummaryDetails()
        print("lattitude:- \(String(describing: userCurrentLocation?.coordinate.latitude) ), longitude:- \(String(describing: userCurrentLocation?.coordinate.longitude))")
        
    }
    
    func setUpPinOnMap(lat:Double,long:Double) {
        let view = (self.theController.view as? CalendarTrainingLogSummaryView)
        view?.mapView.layoutIfNeeded()
        let cameraCoord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        view?.mapView.camera = GMSCameraPosition.camera(withTarget: cameraCoord, zoom: 15)
        let updateCamera = GMSCameraUpdate.setTarget(cameraCoord, zoom: 15)
        view?.mapView.animate(with: updateCamera)
        view?.mapView.layoutIfNeeded()
    }
    
    func getTotalLaps(total:Int) -> String {
        if total == 0 {
            return "# Lap"
        }
        else if total == 1 {
            return "1 Lap"
        }
        else {
            return "\(total) Laps"
        }
    }

    func apiCallForGetSwummaryDetails() {
    
        let param = ["id": self.trainingLogId] as [String : Any]
        
        print(JSON(param))
        
        var url = ""
        
        if self.controllerMoveFrom == .trainingLog {
            url = GET_TRAINING_LOG_SUMMAARY_DETAILS
        } else if self.controllerMoveFrom == .trainingProgram {
            url = GET_TRAINING_PROGRAM_SUMMAARY_DETAILS
        }
        
        (self.theController.view as? CalendarTrainingLogSummaryView)?.vwMain.isHidden = true
        
        ApiManager.shared.MakePostAPI(name: url, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
        
            (self.theController.view as? CalendarTrainingLogSummaryView)?.vwMain.isHidden = false
            
            if response != nil {
                let json = JSON(response!)
                print(json)
                let model = CardioSummaryDetailModel(JSON: json.dictionaryObject!)
                self.cardioSummaryDetails = model?.data
                self.setupData()
            }
        }
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
    
    func saveSummaryCardiolog(){
        
        let view = (self.theController.view as? CalendarTrainingLogSummaryView)
        
        var url = ""
        
        if self.controllerMoveFrom == .trainingLog {
            url = COMPLETE_TRAINING_LOG
        } else if self.controllerMoveFrom == .trainingProgram {
            url = UPDATE_WEEK_WISE_DAILY_PROGRAMS
        }
        
        let param = [
            "comments": view?.txtvwComment.text.toTrim(),
            ] as [String : Any]
        
        ApiManager.shared.MakePutAPI(name: url + "/" + trainingLogId, params: param as [String : Any], progress: true, vc: self.theController, isAuth:false) { (response, error) in
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
    
    func setupData(){
        
        let view = (self.theController.view as? CalendarTrainingLogSummaryView)

        if self.controllerMoveFrom == .trainingLog {
            self.activityName = self.cardioSummaryDetails?.trainingActivity?.name ?? ""
        } else if self.controllerMoveFrom == .trainingProgram {
            self.activityName = self.cardioSummaryDetails?.trainingProgramActivity?.name ?? ""
        }
        
        print("imageURl : \(SERVER_URL + (self.cardioSummaryDetails?.trainingActivity?.iconPathWhite ?? ""))")
        
//        print("Before Frame:\(self.theController.btnActivityImage.frame)")
//
//        self.theController.btnActivityImage.sd_setImage(with: URL(string: SERVER_URL + (self.cardioSummaryDetails?.trainingActivity?.iconPathWhite ?? "")), for: .normal, completed: nil)

//        print("After Frame:\(self.theController.btnActivityImage.frame)")
        
        view?.imgProfileUpper.sd_setImage(with: self.cardioSummaryDetails?.userDetails?.photo!.toURL(), completed: nil)

        view?.lblTotalDurationValue.text = self.cardioSummaryDetails?.totalDuration
        view?.lblDummyTotalDurationValue.text = self.cardioSummaryDetails?.totalDuration
        
        let formattedString = NSMutableAttributedString()
        formattedString.normal( self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.totalDistance ?? 0.0,digit: 1)).normal12(" \(self.cardioSummaryDetails?.totalDistaneUnit ?? "")", font: themeFont(size: 14, fontname: .ProximaNovaBold))
        view?.lblTotalDistancekmValue.attributedText = formattedString
        view?.lblTotalDistancekmValueUpper.attributedText = view?.lblTotalDistancekmValue.attributedText
        
        if self.cardioSummaryDetails?.trainingGoal?.name == nil || self.cardioSummaryDetails?.trainingGoal?.name == ""{
            view?.lblTrainingGoalValue.text = self.cardioSummaryDetails?.trainingGoalCustom == "" ? "-" : self.cardioSummaryDetails?.trainingGoalCustom
            
        }else{
            view?.lblTrainingGoalValue.text = self.cardioSummaryDetails?.trainingGoal?.name == "" ? "-" : self.cardioSummaryDetails?.trainingGoal?.name
        }
        
        view?.lblTargetHeartRateValue.text = self.cardioSummaryDetails?.targetedHr == "" ? "-" : (self.cardioSummaryDetails?.targetedHr ?? "") + " bpm"
        view?.lblIntensityValue.text = self.cardioSummaryDetails?.trainingIntensity?.name ?? ""
        view?.lblDayInterval.text = self.cardioSummaryDetails?.workoutName
        
        view?.lblTitleNameUpper.text = view?.lblDayInterval.text
        
        view?.lblKcalValue.text =  self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.totalKcal ?? 0.0, digit: 0)
        view?.lblRPEValue.text = String(self.cardioSummaryDetails?.RPE ?? "")
        
        view?.lblLaps.text = getTotalLaps(total: self.cardioSummaryDetails?.exercise?.count ?? 0)
        
        view?.txtvwComment.text = self.cardioSummaryDetails?.comment
        
        if view?.txtvwComment.text.toTrim().count != 0{
            view?.lblPlaceholder.isHidden = true
        }
        
        let routeValue = (self.cardioSummaryDetails?.outdoorRoute ?? "").replacingOccurrences(of: "\\", with: "\\", options: .literal, range: nil)
        print("proper or not:\(routeValue)")
        
        if routeValue != ""{
            view?.mapView.clear()
            
            let path1 = GMSPath(fromEncodedPath: routeValue)
            let polylineForPath = GMSPolyline(path: path1)
            polylineForPath.strokeWidth = 5.0
            polylineForPath.strokeColor = .appthemeOffRedColor
            polylineForPath.map =  view?.mapView // Google MapView
            
            DispatchQueue.main.async
                {
                    if  view?.mapView != nil
                    {
                        let bounds = GMSCoordinateBounds(path: path1!)
                        view?.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
                    }
            }
        }
        
        self.setLabelValueAccordingToActivity()
        
        if let firstExerciseData = self.cardioSummaryDetails?.exercise?.first{
            if let startLat = firstExerciseData.startLat{
                if let startLong = firstExerciseData.startLong{
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        
//                    self.setUpPinOnMap(lat: startLat, long: startLong)
                       
                        getPlacemark(forLocation: CLLocation(latitude: startLat, longitude: startLong), completionHandler: { (placemark, address) in
                            if placemark != nil {
                                view?.lblLocationName.text = address ?? ""
                                view?.lblLocationNameUpper.text = view?.lblLocationName.text
                            }
                        })
//                    }
                }
            }else{
                
//                self.setUpPinOnMap(lat: userCurrentLocation?.coordinate.latitude ?? 0.0, long: userCurrentLocation?.coordinate.longitude ?? 0.0)
                
                getPlacemark(forLocation: CLLocation(latitude: userCurrentLocation?.coordinate.latitude ?? 0.0, longitude: userCurrentLocation?.coordinate.longitude ?? 0.0), completionHandler: { (placemark, address) in
                     if placemark != nil {
                         view?.lblLocationName.text = address ?? ""
                        view?.lblLocationNameUpper.text = view?.lblLocationName.text
                     }
                 })
            }
        }
    }
    
    func setLabelValueAccordingToActivity(){
        
        //Design name structure
        /*
        lblAvgPacekm            |   lblTotalDistanceInkm
        lblAvgPacekmValue       |   lblTotalDistanceInkmValue
        lblAvgSpeedkmPerHr      |   lblInclination
        */
        
        let view = (self.theController.view as? CalendarTrainingLogSummaryView)
        view?.vwSwimmingStyle.isHidden = true
        view?.vwPower.isHidden = true
        view?.vwRelativePower.isHidden = true
        view?.vwAvgSpeed.isHidden = true
        view?.vwInclination.isHidden = true
        view?.vwGradient.isHidden = true
        view?.vwAvgRPM.isHidden = true
        view?.vwActiveDuration.isHidden = true
        
        switch activityName.lowercased() {
            
        case "Run (Outdoor)".lowercased(), "Outdoor".lowercased() :
            
            self.theController.setNavigationForOutdoor()
            self.theController.setLeftNavigationBarButton(image: UIImage(named: "run_white_image_summary")!)
            view?.vwUpperDetailsIndoor.isHidden = true
            view?.mapView.isHidden = false
            view?.vwDetailsBelowTotalDuration.isHidden = false
            view?.vwGradient.isHidden = false
            view?.vwActiveDuration.isHidden = false
            view?.btnActiveDuration.setImage(UIImage(named:"ic_run_active_duration"), for: .normal)
            
            
//            view?.vwAvgSpeed.isHidden = false
//            view?.vwInclination.isHidden = false

            view?.lblAvgPacekm.text = "AVERAGE PACE"
//            view?.lblAvgPacekmValue.text = self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.averagePace ?? 0.0,digit: 2)  == "0.0" ? "-" : self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.averagePace ?? 0.0,digit: 2) + " " + (self.cardioSummaryDetails?.avgPaceUnit ?? "")
            
            let formattedString = NSMutableAttributedString()
            formattedString.normal(self.cardioSummaryDetails?.averagePace ?? "").normal12(" \(self.cardioSummaryDetails?.avgPaceUnit ?? "")", font: themeFont(size: 14, fontname: .ProximaNovaBold))
            view?.lblAvgPacekmValue.attributedText = formattedString

            view?.lblAvgSpeedkmPerHr.text = "Avg Speed \(self.theController.oneDigitAfterDecimal(value: CGFloat(self.cardioSummaryDetails?.avgSpeed ?? 0.0), digit: 1))" + " " + (self.cardioSummaryDetails?.avgSpeedUnit ?? "")
            
            view?.lblAvgSpeedValueTextBox.text = "\(self.theController.oneDigitAfterDecimal(value: CGFloat(self.cardioSummaryDetails?.avgSpeed ?? 0.0), digit: 1))" + " " + (self.cardioSummaryDetails?.avgSpeedUnit ?? "")
            
            view?.lblTotalDistancekm.text = "TOTAL DISTANCE"
            view?.lblInclinationValueAboveTextBox.text = "\(self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.inclination ?? 0.0, digit: 0)) %"

            var elevationGain = ""
            
            if self.cardioSummaryDetails?.elevationGain ?? 0 == 0{
                elevationGain = "-"
            }else{
                elevationGain = "\(self.cardioSummaryDetails?.elevationGain ?? 0)\(self.cardioSummaryDetails?.elevationGainUnit ?? "")"
            }
            
            view?.lblInclination.text = "Elevation Gain \(elevationGain)"
            
            view?.lblGradientValue.text = "\(self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.gradient ?? 0.0))\(self.cardioSummaryDetails?.gradientUnit ?? "")"
            
            view?.lblActiveDurationValue.text = self.cardioSummaryDetails?.activeDuration
            
        case "Run (Indoor)".lowercased(), "Indoor".lowercased():
            
            self.theController.setNavigationForIndoor()
            self.theController.setLeftNavigationBarButton(image: UIImage(named: "run_white_image_summary")!)
            
            view?.vwUpperDetailsIndoor.isHidden = false
            view?.mapView.isHidden = true
            view?.vwDetailsBelowTotalDuration.isHidden = true
            view?.heightOfVwDetailsBelowTotalDuration.constant = 40
            
//            view?.vwAvgSpeed.isHidden = false
//            view?.vwInclination.isHidden = false
            
            view?.lblAvgPacekm.text = "AVERAGE PACE"
//            view?.lblAvgPacekmValue.text = self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.averagePace ?? 0.0,digit: 2)  == "0.0" ? "-" : self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.averagePace ?? 0.0,digit: 2) + " " + (self.cardioSummaryDetails?.avgPaceUnit ?? "")
            
            let formattedString = NSMutableAttributedString()
            formattedString.normal(self.cardioSummaryDetails?.averagePace ?? "").normal12(" \(self.cardioSummaryDetails?.avgPaceUnit ?? "")", font: themeFont(size: 14, fontname: .ProximaNovaBold))
            view?.lblAvgPacekmValue.attributedText = formattedString
            
//            view?.lblAvgSpeedkmPerHr.text = "Avg. speed \(self.theController.oneDigitAfterDecimal(value: CGFloat(self.cardioSummaryDetails?.avgSpeed ?? 0.0), digit: 2))" + " " + (self.cardioSummaryDetails?.avgSpeedUnit ?? "")
            
            view?.lblAvgSpeedValueTextBox.text = "\(self.theController.oneDigitAfterDecimal(value: CGFloat(self.cardioSummaryDetails?.avgSpeed ?? 0.0), digit: 1))" + " " + (self.cardioSummaryDetails?.avgSpeedUnit ?? "")

            view?.lblTotalDistancekm.text = "TOTAL DISTANCE"
            view?.lblInclinationValueAboveTextBox.text = "\(self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.inclination ?? 0.0, digit: 1)) %"

//            view?.lblInclination.text = "INCLINATION \(self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.inclination ?? 0.0, digit: 2))"
            
            view?.lblAvgPacekmUpper.text = view?.lblAvgPacekm.text
            view?.lblAvgPacekmValueUpper.attributedText = view?.lblAvgPacekmValue.attributedText
            
            view?.lblTotalDistancekmUpper.text = view?.lblTotalDistancekm.text
            
            view?.lblAvgSpeedkmPerHrUpper.text = "Avg Speed \(self.theController.oneDigitAfterDecimal(value: CGFloat(self.cardioSummaryDetails?.avgSpeed ?? 0.0), digit: 1))" + " " + (self.cardioSummaryDetails?.avgSpeedUnit ?? "")
            
            view?.lblInclinationUpper.text = "Gradient \(self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.gradient ?? 0.0)) \(self.cardioSummaryDetails?.gradientUnit ?? "")"
            
        case "Cycling (Indoor)".lowercased():
            
            self.theController.setNavigationForIndoor()
            self.theController.setLeftNavigationBarButton(image: UIImage(named: "cycle_white_image_summary")!)
            
            view?.vwUpperDetailsIndoor.isHidden = false
            view?.mapView.isHidden = true
            view?.vwDetailsBelowTotalDuration.isHidden = true
            view?.heightOfVwDetailsBelowTotalDuration.constant = 40

            view?.vwPower.isHidden = false
            view?.vwRelativePower.isHidden = false

            view?.lblAvgPacekm.text = "AVERAGE SPEED"
//            view?.lblAvgPacekmValue.text = self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.avgSpeed ?? 0.0,digit: 2)  == "0.0" ? "-" : self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.avgSpeed ?? 0.0,digit: 2) + " " + (self.cardioSummaryDetails?.avgSpeedUnit ?? "")
            
            let formattedString = NSMutableAttributedString()
            formattedString.normal( self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.avgSpeed ?? 0.0,digit: 1)).normal12(" \(self.cardioSummaryDetails?.avgSpeedUnit ?? "")", font: themeFont(size: 14, fontname: .ProximaNovaBold))
            view?.lblAvgPacekmValue.attributedText = formattedString

            view?.lblAvgSpeedkmPerHr.text = "Avg RPM \(self.theController.oneDigitAfterDecimal(value: CGFloat(self.cardioSummaryDetails?.totalRPM ?? 0.0), digit: 0))"

            view?.lblTotalDistancekm.text = "TOTAL DISTANCE"
            view?.lblInclination.text = "Level \(self.theController.oneDigitAfterDecimal(value: CGFloat(self.cardioSummaryDetails?.totalLevel ?? 0.0), digit: 0))"
            
            view?.lblPowerValue.text = self.cardioSummaryDetails?.avgPower == 0 ? "-" : "\(self.cardioSummaryDetails?.avgPower ?? 0) \(self.cardioSummaryDetails?.avgPowerUnit ?? "")"
            
            view?.lblRelativePowerValue.text = self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.totalRelativePower ?? 0.0) + " " + (self.cardioSummaryDetails?.totalRelativePowerUnit ?? "")
            
            view?.lblAvgPacekmUpper.text = view?.lblAvgPacekm.text
            view?.lblAvgPacekmValueUpper.attributedText = formattedString
            view?.lblAvgSpeedkmPerHrUpper.text = view?.lblAvgSpeedkmPerHr.text
            
            view?.lblTotalDistancekmUpper.text = view?.lblTotalDistancekm.text
            view?.lblInclinationUpper.text = view?.lblInclination.text
            
        case "Cycling (Outdoor)".lowercased():
            
            self.theController.setNavigationForOutdoor()
            self.theController.setLeftNavigationBarButton(image: UIImage(named: "cycle_white_image_summary")!)
            
            view?.vwUpperDetailsIndoor.isHidden = true
            view?.mapView.isHidden = false
            view?.vwDetailsBelowTotalDuration.isHidden = false
            
            view?.vwPower.isHidden = false
            view?.vwRelativePower.isHidden = false
            view?.vwGradient.isHidden = false
            view?.vwActiveDuration.isHidden = false
            view?.btnActiveDuration.setImage(UIImage(named:"ic_cycle_active_duration"), for: .normal)
            
            view?.lblAvgPacekm.text = "AVERAGE SPEED"
//            view?.lblAvgPacekmValue.text = self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.avgSpeed ?? 0.0,digit: 2)  == "0.0" ? "-" : self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.avgSpeed ?? 0.0,digit: 2) + " " + (self.cardioSummaryDetails?.avgSpeedUnit ?? "")

            let formattedString = NSMutableAttributedString()
            formattedString.normal( self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.avgSpeed ?? 0.0,digit: 1)).normal12(" \(self.cardioSummaryDetails?.avgSpeedUnit ?? "")", font: themeFont(size: 14, fontname: .ProximaNovaBold))
            view?.lblAvgPacekmValue.attributedText = formattedString
            
            view?.lblAvgSpeedkmPerHr.text = "Avg RPM \(self.theController.oneDigitAfterDecimal(value: CGFloat(self.cardioSummaryDetails?.totalRPM ?? 0.0), digit: 0))"
            
            view?.lblTotalDistancekm.text = "TOTAL DISTANCE"
            
            var elevationGain = ""
            
            if self.cardioSummaryDetails?.elevationGain ?? 0 == 0{
                elevationGain = "-"
            }else{
                elevationGain = "\(self.cardioSummaryDetails?.elevationGain ?? 0)\(self.cardioSummaryDetails?.elevationGainUnit ?? "")"
            }
            
            view?.lblInclination.text = "Elevation Gain \(elevationGain)"
            
            view?.lblPowerValue.text = self.cardioSummaryDetails?.avgPower == 0 ? "-" : "\(self.cardioSummaryDetails?.avgPower ?? 0) \(self.cardioSummaryDetails?.avgPowerUnit ?? "")"
            
            view?.lblRelativePowerValue.text = self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.totalRelativePower ?? 0.0) + " " + (self.cardioSummaryDetails?.totalRelativePowerUnit ?? "")
            
            view?.lblGradientValue.text = "\(self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.gradient ?? 0.0))\(self.cardioSummaryDetails?.gradientUnit ?? "")"

            view?.lblActiveDurationValue.text = self.cardioSummaryDetails?.activeDuration
            
        case "Swimming".lowercased():
            
            self.theController.setNavigationForIndoor()
            self.theController.setLeftNavigationBarButton(image: UIImage(named: "swimming_white_image_summary")!)
            
            view?.vwUpperDetailsIndoor.isHidden = false
            view?.mapView.isHidden = true
            view?.vwAvgSpeed.isHidden = false
            
            view?.vwDetailsBelowTotalDuration.isHidden = true
            view?.heightOfVwDetailsBelowTotalDuration.constant = 40

            view?.vwSwimmingStyle.isHidden = false
            
            view?.lblAvgPacekm.text = "AVERAGE PACE"

            let formattedString = NSMutableAttributedString()
            formattedString.normal(self.cardioSummaryDetails?.averagePace ?? "").normal12(" \(self.cardioSummaryDetails?.avgPaceUnit ?? "")", font: themeFont(size: 14, fontname: .ProximaNovaBold))
            view?.lblAvgPacekmValue.attributedText = formattedString
            
            view?.lblTotalDistancekm.text = "TOTAL DISTANCE"
            view?.lblSwimmingStyleValue.text = self.cardioSummaryDetails?.trainingLogStyle?.name
            
            view?.lblAvgPacekmUpper.text = view?.lblAvgPacekm.text
            view?.lblAvgPacekmValueUpper.attributedText = formattedString
            view?.lblTotalDistancekmUpper.text = view?.lblTotalDistancekm.text
            
            view?.lblAvgSpeedValueTextBox.text = "\(self.theController.oneDigitAfterDecimal(value: CGFloat(self.cardioSummaryDetails?.avgSpeed ?? 0.0), digit: 0))" + " " + (self.cardioSummaryDetails?.avgSpeedUnit ?? "")

        case "Others".lowercased():
            
            self.theController.setNavigationForOutdoor()
            self.theController.setLeftNavigationBarButton(image: UIImage(named: "others_white_image_summary")!)
            
            view?.vwUpperDetailsIndoor.isHidden = true
            view?.mapView.isHidden = false
            view?.vwDetailsBelowTotalDuration.isHidden = false
            view?.vwPower.isHidden = false
            view?.vwRelativePower.isHidden = false
            view?.vwAvgRPM.isHidden = false
            
            view?.lblAvgPacekm.text = "AVERAGE SPEED"
            
            if self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.avgSpeed ?? 0.0,digit: 1) == "0.0"{
                view?.lblAvgPacekmValue.text = "-"
            }else{
                let formattedString = NSMutableAttributedString()
                formattedString.normal( self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.avgSpeed ?? 0.0,digit: 1)).normal12(" \(self.cardioSummaryDetails?.avgSpeedUnit ?? "")", font: themeFont(size: 14, fontname: .ProximaNovaBold))
                view?.lblAvgPacekmValue.attributedText = formattedString
            }
            
            if self.cardioSummaryDetails?.averagePace ?? "" == "0:00"{
                view?.lblAvgSpeedkmPerHr.text = "Avg Pace -"
            }else{
                view?.lblAvgSpeedkmPerHr.text = "Avg Pace \(self.cardioSummaryDetails?.averagePace ?? "") \(self.cardioSummaryDetails?.avgPaceUnit ?? "")"
            }

            view?.lblTotalDistancekm.text = "TOTAL DISTANCE"

            if self.theController.oneDigitAfterDecimal(value: CGFloat(self.cardioSummaryDetails?.totalLevel ?? 0.0), digit: 0) == "0" {
                view?.lblInclination.text = "Level -"
            }else{
                view?.lblInclination.text = "Level \(self.theController.oneDigitAfterDecimal(value: CGFloat(self.cardioSummaryDetails?.totalLevel ?? 0.0), digit: 0))"
            }
            
            view?.lblPowerValue.text = self.cardioSummaryDetails?.avgPower == 0 ? "-" : "\(self.cardioSummaryDetails?.avgPower ?? 0) \(self.cardioSummaryDetails?.avgPowerUnit ?? "")"
            
            view?.lblRelativePowerValue.text = self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.totalRelativePower ?? 0.0) == "0.0" ? "-" : self.theController.oneDigitAfterDecimal(value: self.cardioSummaryDetails?.totalRelativePower ?? 0.0) + " " + (self.cardioSummaryDetails?.totalRelativePowerUnit ?? "")
                
            view?.lblAvgRPMValue.text = "\(self.cardioSummaryDetails?.avgRPM ?? 0)" == "0" ? "-" : "\(self.cardioSummaryDetails?.avgRPM ?? 0)"

        default:
            return
        }
        
    }
    
}
