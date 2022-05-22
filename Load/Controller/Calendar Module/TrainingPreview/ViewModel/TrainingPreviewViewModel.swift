//
//  TrainingPreviewViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 07/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class TrainingPreviewViewModel {
    
    fileprivate weak var theController:TrainingPreviewVC!
    var previewData: TrainingProgramModel?
    weak var delegate:DismissPreviewDelegate?
    var listArray:Int = 0
    var raceDistanceId:Double?
    var raceTime:Double?
    var programId:String = ""
    var isSpeedSelected:Bool = false
    var expandedDate:String = ""
    var weekday:Int = 0
    var weekNumber:Int = 0
    
    var isStatusCardio = false
    var isTypePreset = false
    var isClickOnCompleteButton = false
    
    var selectedActivityTypeName = ""
    var currentWorkedIndex = 0
    var coverdDistanceOfLapWithPedometer : CGFloat = 0.0
    
    var totalDistanceWithPedometer : Double = 0.0
    var totalAverageActivePacePedometer : Double?

    var netElevationGain = 0.0
    var weekdayWiseMainID = ""
    
    var isTrainingPreviewScreenOpen = true
    
    
    init(theController:TrainingPreviewVC) {
        self.theController = theController
    }
    
    //MARK:- Setup UI
    func setupUI() {
        self.apiCallDailyPrograms(programId: self.programId, workoutNumber: self.weekday)
    }
    
    func showDetails() {
        let view = (self.theController.view as? TrainingPreviewView)
        if previewData == nil {
            return
        }
        
        view?.imgProfile.sd_setImage(with: getUserDetail()?.data?.user?.photo?.toURL(), completed: nil)
//        view?.lblDate.text = getCountryName(id: getUserDetail().data?.user?.countryId ?? 0) + ". " + convertDateFormater(self.previewData?.date?.UTCToLocal() ?? Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss"), format: "yyyy-MM-dd HH:mm:ss", dateFormat: "EEEE, dd MMM yyyy")
        
//        view?.lblDate.text = convertDateFormater(self.previewData?.date ?? "", dateFormat: "EEEE, dd MMM yyyy 'at' hh:mm a")
        
        view?.lblDate.text = convertDateFormater(self.previewData?.date?.UTCToLocal() ?? Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss"), format: "yyyy-MM-dd HH:mm:ss", dateFormat: "EEEE, dd MMM yyyy")
        
        let image = getTrainingActivityPath(id: previewData?.weekWiseWorkoutDetail?.trainingActivityId?.intValue ?? 0)
        
        print("cardioTypeActivityId:\(self.previewData?.cardioTypeActivityId ?? 0)")
        print("selectedActivityTypeName:\(self.findActivityNameFromId(id: self.previewData?.cardioTypeActivityId ?? 0))")

        self.selectedActivityTypeName = self.findActivityNameFromId(id: self.previewData?.cardioTypeActivityId ?? 0)
        view?.lblWhen.text = self.previewData?.weekWiseWorkoutDetail?.name ?? ""
        view?.lblNotes.text = self.previewData?.weekWiseWorkoutDetail?.note ?? ""
        view?.lblTrainingGoal.text = getTrainingGoalName(id: self.previewData?.weekWiseWorkoutDetail?.trainingGoalId ?? 0)
        view?.lblIntensity.text = getIntensityName(id: self.previewData?.weekWiseWorkoutDetail?.trainingIntensityId ?? 0)
        view?.lblTargetHR.text = (self.previewData?.weekWiseWorkoutDetail?.calculatedTHR ?? "") + " bpm"
        
        self.weekdayWiseMainID = self.previewData?.id?.stringValue ?? ""
        
        if self.previewData?.programDetail?.status?.lowercased() ?? "" == "CARDIO".lowercased(){
            self.isStatusCardio = true
            view?.imgActivity.image = UIImage(named: "ic_run_red")
        }else{
            self.isStatusCardio = false
            view?.imgActivity.image = UIImage(named: "ic_gym_icon_select")
        }
        
        if self.previewData?.programDetail?.type?.lowercased() ?? "" == "PRESET".lowercased(){
            self.isTypePreset = true
        }else{
            self.isTypePreset = false
        }
        
        if let count = previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?.count{
            view?.lblLaps.text = "\(count) Laps"
        }
        
        self.updateMainArray()
        
        self.getCurrenIndexOfCurrentLap()
        
        if let view = (self.theController.view as? TrainingPreviewView){
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
//                if view.scrollView.contentSize.height-102 <= view.safeAreaHeight{
//                    view.isSetAlphaOrNOt(isSet: true)
//                }else{
//                    view.isSetAlphaOrNOt(isSet: false)
//                }
                
                if (self.theController.setOneDigitWithFloorInCGFLoat(value: view.scrollView.contentOffset.y) >= self.theController.setOneDigitWithFloorInCGFLoat(value: (view.scrollView.contentSize.height - view.scrollView.frame.size.height))) || ( view.scrollView.contentSize.height-102 <= view.safeAreaHeight) {
                    view.isSetAlphaOrNOt(isSet: true)
                }else{
                    view.isSetAlphaOrNOt(isSet: false)
                }

            }
        }
        
        if self.checkIsExerciseStarted(){
            self.theController.btnEdit.setTitle(str: "Switch View")
            self.theController.btnEdit.setTitleColor(UIColor.appthemeRedColor, for: .normal)
            self.theController.btnEdit.setImage(nil, for: .normal)
            self.theController.btnEdit.contentHorizontalAlignment = .center
            self.theController.btnRightBarButton.width = 200
            view?.vwStartWorkout.isHidden = true
            view?.vwCompleteWorkout.isHidden = true
            view?.vwEndWorkout.isHidden = false
            
        }else{
            view?.vwStartWorkout.isHidden = false
            view?.vwCompleteWorkout.isHidden = false
            view?.vwEndWorkout.isHidden = true
            
            //No edit button now so don't need to write
            
            /*
            self.theController.btnEdit.setTitle(str: "")
//            self.theController.btnEdit.setImage(UIImage(named: "ic_edit_red"), for: .normal)
            self.theController.btnEdit.contentHorizontalAlignment = .right
            self.theController.btnRightBarButton.width = 50
            
            if let view = (self.theController.view as? TrainingPreviewView){
                
                if view.scrollView.contentSize.height+177 <= view.safeAreaHeight{
                    view.isSetAlphaOrNOt(isSet: true)
                }else{
                    view.isSetAlphaOrNOt(isSet: false)
                }
            }*/
        }
        
        self.theController.callMethodAfterAPI()

    }
    
    func getCurrenIndexOfCurrentLap(){
         if let array = self.previewData?.exercise{
            for i in 0..<array.count{
                let model = array[i]
                if model.startTime != "" && ((model.isCompleted == false || model.isCompleted == nil) || (model.isCompleted == true && (model.isCompletedRest == false || model.isCompletedRest == nil))){
                    self.currentWorkedIndex = i
                    return
                }
            }
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
    
    func findActivityIdFromName(name: String) -> Int{
        
        let arrayActivity = GetAllData?.data?.trainingProgramActivity
        
        for i in 0..<(arrayActivity?.count ?? 0){
            
            if name.lowercased() == arrayActivity?[i].name?.lowercased(){
                return Int(arrayActivity?[i].id ?? 0)
            }
        }
        
        return 0

        
        
    }
    
    
    func showSpeedOrPace(isSpeed:Bool) {
        let view = (self.theController.view as? TrainingPreviewView)
        
        if isSpeed {
            view?.lblSpeed.text = "Speed"
            view?.imgSpeed.image = UIImage(named: "ic_up_black")
            view?.lblSpeedUnit.text = "km/hr"
        }
        else {
            view?.lblSpeed.text = "Pace"
            view?.imgSpeed.image = UIImage(named: "ic_dropdown_black")
            view?.lblSpeedUnit.text = "min/km"
        }
    }
    
    func checkAllDone() -> Bool {
        for data in self.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails ?? [] {
            if data.isCompleted == false || data.isCompleted == nil{
                return false
            }
        }
        
        if self.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails == nil || self.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?.count == 0 {
            return false
        }
        return true
    }
    
    func checkIsExerciseStarted() -> Bool {
        for data in self.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails ?? [] {
            
            if data.startTime != ""{
                return true
            }
            
        }
        return false
    }
    
    func endWorkout() {
        if self.previewData?.isComplete == true {
            makeToast(strMessage: "Workout is already ended.")
        }
        else {
            self.previewData?.isComplete = true
            self.apiCallSaveDetails(programId: self.previewData?.id?.stringValue ?? "", isEndWorkout: true)
        }
    }
    
    //MARK:- API CALLING
    
    func apiCallDailyPrograms(programId: String, workoutNumber:Int, progress:Bool = true) {
        print(self.expandedDate)
        let param = [
            "program_id": programId,
            "week_number": weekNumber,
            "workout_number": workoutNumber,
            "start_date" : self.expandedDate.convertDateFormater(format: "yyyy-MM-dd", isUTC: false).setTimeZero()?.iso8601 ?? "",
            "end_date" : self.expandedDate.convertDateFormater(format: "yyyy-MM-dd", isUTC: false).setTimeEnd()?.iso8601 ?? ""
            ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CREATE_WEEK_WISE_DAILY_PROGRAMS, params: param as [String : Any], progress: progress, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.previewData = TrainingProgramModel(JSON: data.dictionaryObject!)
                    let view = (self.theController.view as? TrainingPreviewView)
                    view?.tableView.reloadData()
                    self.showDetails()
                    
                    if self.selectedActivityTypeName.lowercased() == "Outdoor".lowercased() {
                        self.getSaveDataFromLocalDatabase()
                        self.theController.checkLocationPermissionAvailableOrNot()
                    }
                    
                    if self.selectedActivityTypeName.lowercased() == "Outdoor".lowercased() {
                        
                        guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                            return
                        }
                        
                        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.weekdayWiseMainID)}
                        
                        if self.previewData?.exercise?.count ?? 0 > 0{
                            
                            if self.previewData?.exercise?[(self.previewData?.exercise?.count ?? 0) - 1].isCompleted == true && self.previewData?.exercise?[(self.previewData?.exercise?.count ?? 0) - 1].isCompletedRest == true{
                                
                                if routeObjects[0].isPauseAfterAllLapCompleted == false{
                                    if self.theController.timerForMotion == nil{
                                        self.theController.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self.theController, selector: #selector(self.theController.check10secondOrNot), userInfo: nil, repeats: true)
                                    }
                                }
                                
                            }else{
                                //TODO:- Add Comment here because If it's pause then Total Duration already continue

//                                if self.previewData?.exercise?[self.currentWorkedIndex].isPause == false{
                                    
                                if self.previewData?.exercise?[self.currentWorkedIndex].isCompleted == false || self.previewData?.exercise?[self.currentWorkedIndex].isCompleted == nil && (self.previewData?.exercise?[0].startTime != ""){
                                        
                                        if self.theController.timerForMotion == nil{
                                            self.theController.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self.theController, selector: #selector(self.theController.check10secondOrNot), userInfo: nil, repeats: true)
                                        }
                                    }
//                                }
                            }
                        }
                        
                        self.theController.totalDistancConverted = routeObjects[0].totalCoveredDistance
                        self.totalDistanceWithPedometer = routeObjects[0].totalCoveredDistance

                        self.theController.lapCoveredDistance = routeObjects[0].lapArray[self.currentWorkedIndex].lapCoverDistance
                        self.coverdDistanceOfLapWithPedometer  = CGFloat(self.theController.lapCoveredDistance)
                        
                        self.netElevationGain = routeObjects[0].elevationGain

                    }else {
                        
                        if self.isTrainingPreviewScreenOpen{
                            self.getCurrenIndexOfCurrentLap()
                        }
                        
                        if self.previewData?.exercise?[self.currentWorkedIndex].isPause == true{
                            //Not need to add condition of Completed and Duration/Distnace because it's only add in Distnace condition added in StartWorkoutVc
                            
                            if let valueForIndoor = Defaults.value(forKey: "trainingProgram Indoor \(Int(self.previewData?.id ?? 0))") as? Double{
                                self.coverdDistanceOfLapWithPedometer = CGFloat(valueForIndoor)
                            }
                        }
                        
                        let count = self.previewData?.exercise?.count ?? 0
                        self.totalDistanceWithPedometer = self.previewData?.exercise?[count-1].totalDistance ?? 0.0
                        
                    }
                    
                }
                else {
                    //                    let message = json.getString(key: .message)
                    //                    makeToast(strMessage: message)
                }
            }
        })
    }
    
    func apiCallSaveDetails(programId: String, isEndWorkout:Bool = false, progress:Bool = true) {
        let exercise: NSMutableArray = NSMutableArray()
        
        for (i, data) in (self.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails ?? []).enumerated() {
            
            let dict = NSMutableDictionary()
            dict.setValue(data.id?.stringValue, forKey: "common_programs_weeks_lap_id")
            dict.setValue(data.isCompleted, forKey: "is_completed")
            dict.setValue(data.updatedRest, forKey: "updated_rest")
            dict.setValue(data.updatedPercent, forKey: "updated_percentage")
            dict.setValue(data.updatedDuration, forKey: "updated_duration")
            dict.setValue(data.updatedDistance, forKey: "updated_distance")
            
            dict.setValue(data.isCompletedRest ?? false, forKey: "is_completed_rest")
            dict.setValue(data.startTime, forKey: "start_time")
            dict.setValue(data.addedStartTime, forKey: "added_start_time")
            dict.setValue(data.addedRestTime, forKey: "added_rest_time")
            dict.setValue(data.pauseTime, forKey: "pause_time")
            dict.setValue(data.isPause, forKey: "is_pause")
            dict.setValue(data.isCheckMarkAlreadyDone, forKey: "is_checkmark_done")
            dict.setValue(data.elapsedTime, forKey: "elapsedTime")
            dict.setValue(data.isClickOnPause, forKey: "isClickOnPause")
            dict.setValue(data.lineDraw, forKey: "lineDraw")
            dict.setValue(data.lastPauseTime, forKey: "lastPauseTime")
            
            dict.setValue(data.speed, forKey: "speed")
            dict.setValue(data.pace, forKey: "pace")
            
            if i == 0{
                
                dict.setValue(data.repeatTime, forKey: "repeat_time")
                dict.setValue(data.startTime, forKey: "start_time")
                dict.setValue(data.startLat, forKey: "start_lat")
                dict.setValue(data.startLong, forKey: "start_long")
                
                if let value = Defaults.value(forKey: self.weekdayWiseMainID + " " + "Program") as? Int{
                    dict.setValue(value, forKey: "deactive_duration")
                }
            }
            
            if i == (self.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails ?? []).count - 1{
                dict.setValue(data.endTime, forKey: "end_time")
                dict.setValue(data.endLat, forKey: "end_lat")
                dict.setValue(data.endLong, forKey: "end_long")
                
                dict.setValue(self.totalDistanceWithPedometer, forKey: "total_distance")
                dict.setValue(self.totalAverageActivePacePedometer, forKey: "avg_total_pace")
                dict.setValue(self.netElevationGain, forKey: "elevation_gain")
            }
            
            exercise.add(dict)
        }
        
        var param = [
            "exercise": exercise,
            "is_complete": false,
            "cardio_type_activity_id" :  self.findActivityIdFromName(name: self.selectedActivityTypeName.capitalized)
            ] as [String : Any]
        if exercise.count == 0 {
            param.removeValue(forKey: "exercise")
        }
        
        if selectedActivityTypeName.lowercased() == "Outdoor".lowercased() {
            
            guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                return
            }

            let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.weekdayWiseMainID)}

            if routeObjects.count > 0 {
                param["outdoor_route_data"] = String(routeObjects[0].allTrackRoute)
            }
        }
        
        if isEndWorkout {
            self.previewData?.isComplete = true
        }

        print(JSON(param))
        
        ApiManager.shared.MakePutAPI(name: UPDATE_WEEK_WISE_DAILY_PROGRAMS + "/" + programId, params: param as [String : Any], progress: progress, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let model = TrainingProgramModel(JSON: data.dictionaryObject!)
                    

                    if self.isClickOnCompleteButton == true{
                        AppDelegate.shared.locationManager.allowsBackgroundLocationUpdates = false
                        
                        self.theController.redirectionForOutdoor()
                        return
                    }
                    
                    if self.previewData?.isComplete ?? false{
//                        self.theController.redirectToCardioSummary()
                        AppDelegate.shared.locationManager.allowsBackgroundLocationUpdates = false
                        self.theController.redirectToRPESelection()
                    }

                    self.previewData?.exercise = model?.exercise
                    self.previewData?.isComplete = model?.isComplete
                    self.previewData?.cardioTypeActivityId = model?.cardioTypeActivityId ?? 0
                    
                    self.selectedActivityTypeName = self.findActivityNameFromId(id: model?.cardioTypeActivityId ?? 0)
                    
                    self.updateMainArray()

                    if self.selectedActivityTypeName.lowercased() == "Outdoor".lowercased() {
                        //MARK: set 0 othewise it's not working in logPReview screen

                        self.coverdDistanceOfLapWithPedometer = 0
                        self.getCurrenIndexOfCurrentLap()
                        self.getSaveDataFromLocalDatabase()
                    } else {
                        
                        if self.isTrainingPreviewScreenOpen{
                            self.getCurrenIndexOfCurrentLap()
                        }
                        
                        if self.previewData?.exercise?[self.currentWorkedIndex].isPause == false{
                            //MARK: set 0 othewise it's not working in logPReview screen

                            self.coverdDistanceOfLapWithPedometer = 0
                        }
                    }
                    
//                    self.showDetails()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
                        if let view = self.theController.view as? TrainingPreviewView{
                            if (view.scrollView.contentSize.height-102 <= view.safeAreaHeight) {
                                view.isSetAlphaOrNOt(isSet: true)
                            }else{
                                view.isSetAlphaOrNOt(isSet: false)
                            }
                        }
                    }

                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    func updateMainArray(){
        
        if let view = self.theController.view as? TrainingPreviewView{
            
            if previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?.count != 0 {
                
                if let dataValue = previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails{
                    
                    let value = dataValue[0]
                    
                    view.lblDistance.text = value.distance != nil ? "Distance" : "Duration"
                    view.lblDistanceUnit.text = value.distance != nil ? "km/hr" : "hh:mm:ss"
                }
                
                for (i,data) in (previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails ?? []).enumerated() {
                    
                    data.updatedDistance = previewData?.exercise?[i].updatedDistance
                    data.updatedDuration = previewData?.exercise?[i].updatedDuration
                    data.updatedRest = previewData?.exercise?[i].updatedRest
                    data.updatedPercent = previewData?.exercise?[i].updatedPercent
                    
                    data.isCompleted = previewData?.exercise?[i].isCompleted
                    data.isCompletedRest = previewData?.exercise?[i].isCompletedRest
                    data.addedStartTime = previewData?.exercise?[i].addedStartTime ?? ""
                    data.startTime = previewData?.exercise?[i].startTime ?? ""
                    data.addedRestTime = previewData?.exercise?[i].addedRestTime ?? ""
                    data.repeatTime = previewData?.exercise?[i].repeatTime ?? ""
                    data.elapsedTime = previewData?.exercise?[i].elapsedTime ?? 0
                    data.isPause = previewData?.exercise?[i].isPause ?? false
                    data.pauseTime = previewData?.exercise?[i].pauseTime ?? ""
                    data.isCheckMarkAlreadyDone = previewData?.exercise?[i].isCheckMarkAlreadyDone ?? false
                    data.isClickOnPause = previewData?.exercise?[i].isClickOnPause ?? false
                    data.lineDraw = previewData?.exercise?[i].lineDraw ?? false
                    data.lastPauseTime = previewData?.exercise?[i].lastPauseTime ?? ""
                    
                    if i == 0{
                        data.startTime = previewData?.exercise?[i].startTime ?? ""
                        data.startLat = previewData?.exercise?[i].startLat
                        data.startLong = previewData?.exercise?[i].startLong
                        
                    }
                    
                    if i == (self.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails ?? []).count - 1{
                        data.totalDistance = previewData?.exercise?[i].totalDistance ?? 0.0
                        data.endTime = previewData?.exercise?[i].endTime ?? ""
                        data.endLat = previewData?.exercise?[i].endLat
                        data.endLong = previewData?.exercise?[i].endLong
                    }
                    
                }
                
                view.heightTableView.constant = CGFloat((70 * (previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?.count ?? 0)))
                
                view.tableView.delegate = self.theController
                view.tableView.dataSource = self.theController
                view.tableView.reloadData()
                
            }
        }
    }
    
}


//MARK: - Local Data base
extension TrainingPreviewViewModel {
    
    func ActivityIncrementId() -> Int{
        guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
            return 0
        }
        return (routerArray.max(ofProperty: CardioActivityRouteTrainingProgram.primaryKey()) as Int? ?? 0) + 1
    }
    
//    func LapIncrementId() -> Int{
//        0
////        return (realm.objects(LapDetails.self).max(ofProperty: LapDetails.primaryKey()) as Int? ?? 0) + 1
//    }
    
    func setupDataToLocalDatabase(){
        
        guard let previewData = self.previewData else {
            return
        }
        
        //Write not use here because below method check data avaialable or not
        
        let objActivityRouteData = CardioActivityRouteTrainingProgram()
        
        let activityIncrementId = ActivityIncrementId()
        
        objActivityRouteData.id = activityIncrementId
        objActivityRouteData.userId = getUserDetail()?.data!.user!.id!.stringValue ?? ""
        objActivityRouteData.weekWiseProgramId = previewData.id?.intValue ?? 0
        
        let arrayLap = self.previewData!.exercise ?? []
        
        if arrayLap.count != 0{
            
            for i in 0..<arrayLap.count{
                let lapData = arrayLap[i]
                let objLapDetails = LapDetailsForTrainingProgram()
//                objLapDetails.id = LapIncrementId()
                objLapDetails.routeId = activityIncrementId
                objLapDetails.isCompleted = lapData.isCompleted ?? false
                
                objActivityRouteData.lapArray.append(objLapDetails)
//                realm.add(objLapDetails)
            }
            
            realm?.add(objActivityRouteData)

        }
    }
    
    func getSaveDataFromLocalDatabase(){
        
        guard let previewData = self.previewData else {
            return
        }
        
        guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
            return
        }

        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == previewData.id?.intValue}
        
        try? realm?.write{
            
            if routeObjects.count > 0{
//                print("reoutObjects:\(routeObjects)")

            }else{
                print("No Data Found in local database")
                setupDataToLocalDatabase()
            }
        }
    }
}
