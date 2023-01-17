//
//  LogPreviewViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 07/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import RealmSwift

class LogPreviewViewModel {

    fileprivate weak var theController:LogPreviewVC!
    var previewData: TrainingLogModelClass?
    var trainingLogId: String = ""
    var expandedDate:String = ""
    var totalDistanceWithPedometer : Double = 0.0
    var totalAverageActivePacePedometer : Double?
    var currentWorkedIndex = 0
    var coverdDistanceOfLapWithPedometer : CGFloat = 0.0
    
    var isRepeatExercise : Bool = false
    var afterClickRepeatButtonVisible = 0    // 0 for notclick repeat 1 for click     // isRepeatExercise time set 1 and apiCallGetdetails time set 0
    
    weak var delegate:DismissPreviewDelegate?
    
    var isClickOnCompleteButton = false
    var netElevationGain = 0.0
    
    var isLogPreviewScreenOpen = true
    
    init(theController:LogPreviewVC?) {
        self.theController = theController
    }
    
    deinit {
        print("Deallocate :\(self)")
    }

    
    //MARK : - view life cycle
    func setupUI() {
        
        if previewData == nil {
            self.apiCallGetDetails()
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatedTraining(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.CARDIO_NOTIFICATION.rawValue), object: nil)

        let view = (self.theController.view as? LogPreviewView)
    
        view?.lblLapsTitle.text = self.getTotalLaps(total: self.previewData?.exercise?.count ?? 0)
        
        //Speed/pace for others set in hideShowUnitHeaderAccordingToActivity method in ViewController
        
        if previewData?.exercise?.first?.pace != nil && previewData?.exercise?.first?.pace != "" {
            view?.lblSpeed.text = "Pace"
        }else{
            view?.lblSpeed.text = "Speed"
        }
        
        if previewData?.exercise?.first?.distance != nil  {
            view?.lblDuration.text = "Distance"
            view?.lblDurationUnit.text = "km"
            view?.lblDurationUnit.textAlignment = .center
        }else{
            view?.lblDuration.text = "Duration"
            view?.lblDurationUnit.text = "hh:mm:ss"
        }
        
        if previewData?.exercise?.first?.watt != nil {
            view?.lblRPM.text = "Watt"
        }else{
            view?.lblRPM.text = "RPM"
        }
        
        view?.heightTableView.constant = CGFloat((70 * (self.previewData?.exercise?.count ?? 0)))
        view?.tableView.delegate = self.theController
        view?.tableView.dataSource = self.theController
        
        self.theController.setCompleteButtonColor()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
            
             let image = self.previewData?.userDetail?.photo ?? ""
             view?.imgProfile.sd_setImage(with: URL(string: image), completed: nil)
            
             let imageActivity = self.previewData?.trainingActivity?.iconPathRed ?? ""
             view?.imgActivity.sd_setImage(with: URL(string: SERVER_URL + imageActivity), completed: nil)
            
            view?.lblDate.text = convertDateFormater(self.previewData?.date ?? "", dateFormat: "EEEE, dd MMM yyyy 'at' hh:mm a")
//                (self.previewData?.date)!.UTCToLocal(returnFormat: "EEEE, dd MMM yyyy 'at' hh:mm a")
            
//             view?.lblDate.text = convertDateFormater(self.previewData?.date ?? "", dateFormat: "EEEE, dd MMM yyyy 'at' HH:mm a")
//                getCountryName(id: getUserDetail().data?.user?.countryId ?? 0) + ". " + convertDateFormater(self.previewData?.date ?? "", dateFormat: "EEEE, dd MMM yyyy 'at' HH:mm a")

             view?.lblWhen.text = self.previewData?.workoutName
             let trainigGoalCustom = self.previewData?.trainingGoalCustom
            
            view?.lblTrainingGoal.text = (self.previewData?.trainingGoal?.name ?? "") == "" ? trainigGoalCustom : self.previewData?.trainingGoal?.name
            view?.lblIntensity.text = self.previewData?.trainingIntensity?.name
            view?.lblTargetHR.text = (self.previewData?.targetedHr ?? "") + " bpm"
     
            print("BPM : \(self.previewData?.targetedHr ?? "")")

            view?.lblSubTitle.text = self.previewData?.notes == "" ? "-" : self.previewData?.notes
            
        }
        
        view?.layoutIfNeeded()
        
        getCurrenIndexOfCurrentLap()
        /*
        let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.trainingLogId)}

        if routeObjects.count > 0 {
            
            //We cannot Righ last index endTo because user also walk some km afrer complete lap so we have to take start of that repeat and recent value of Index passes
            //                        let lastIndex = routeObjects[0].lapArray.count - 1
            //                        routeObjects[0].lapArray[lastIndex].endTo
            
            self.totalDistanceWithPedometer = routeObjects[0].totalCoveredDistance
            self.theController.totalDistancConverted = routeObjects[0].totalCoveredDistance
            self.theController?.lapCoveredDistance = routeObjects[0].lapArray[self.currentWorkedIndex].lapCoverDistance
            self.coverdDistanceOfLapWithPedometer  = CGFloat(self.theController?.lapCoveredDistance ?? 0.0)
            
            
            makeToast(strMessage: "Total Distance ViewModel :\(routeObjects[0].totalCoveredDistance)")
            
        }*/

        checkRepeatClickableOrNot()
        
        //MARK: - yash changes
        self.theController.hideShowHeaderAccordingToActivity(name: self.previewData?.trainingActivity?.name?.lowercased() ?? "")
        self.theController.hideShowUnitHeaderAccordingToActivity(name: self.previewData?.trainingActivity?.name?.lowercased() ?? "")
        
        //    self.showExerciseHeader()
        view?.tableView.reloadData()
        
        if self.checkIsExerciseStarted(){
            self.theController.btnEdit.setTitle(str: "Switch View")
            self.theController.btnEdit.setTitleColor(UIColor.appthemeRedColor, for: .normal)
            self.theController.btnEdit.setImage(nil, for: .normal)
            self.theController.btnEdit.contentHorizontalAlignment = .center
            self.theController.btnRightBarButton.width = 200
            
            if let view = (self.theController.view as? LogPreviewView){
                
                view.ConstratintBottomViewHeigh.constant = 102
                
                view.isBottomDeleteShareShow(isShow: false)
                view.vwBottomHiddenShow(isHidden: true)
                
                if view.scrollView.contentSize.height+102 <= view.safeAreaHeight{
                    view.isSetAlphaOrNOt(isSet: true)
                }else{
                    view.isSetAlphaOrNOt(isSet: false)
                }
            }
            
        }else{
            self.theController.btnEdit.setTitle(str: "")
            self.theController.btnEdit.setImage(UIImage(named: "ic_edit_red"), for: .normal)
            self.theController.btnEdit.contentHorizontalAlignment = .right
            self.theController.btnRightBarButton.width = 50
            
            
            if let view = (self.theController.view as? LogPreviewView){
                
                view.vwBottomHiddenShow(isHidden: false)
                
                if view.scrollView.contentSize.height+177 <= view.safeAreaHeight{
                    view.isSetAlphaOrNOt(isSet: true)
                    view.isBottomDeleteShareShow(isShow: true)
                }else{
                    view.isSetAlphaOrNOt(isSet: false)
                    view.isBottomDeleteShareShow(isShow: false)
                }
            }
        }
        
        self.theController.callMethodAfterAPI()

//        self.theController.btnEdit.isHidden = self.checkIsExerciseStarted()
        
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
    
    func checkIsExerciseStarted() -> Bool {
        for data in self.previewData?.exercise ?? [] {
            //Yash comment
            /*
            if data.isCompleted == true {
                return true
            }*/
            
            if data.startTime != ""{
                return true
            }
            
        }
        return false
    }
    
    func checkIsCompleted() -> Bool {
        return self.previewData?.isComplete ?? false
    }
    
    func showExerciseHeader() {
        let view = (self.theController.view as? LogPreviewView)
        let activityId = self.previewData?.trainingActivity?.id?.stringValue
        if  activityId == "1" {
            view?.viewRPM.isHidden = true
            view?.viewPercentage.isHidden = false
//            view?.leftViewPercentage.constant = 0
//            view?.rightViewPercentage.constant = 0
        }
        else if activityId == "2" {
            view?.viewRPM.isHidden = false
            view?.viewPercentage.isHidden = false
//            view?.leftViewPercentage.constant = 0
//            view?.rightViewPercentage.constant = 0
        }
        else if activityId == "3" {
            view?.viewPercentage.isHidden = true
            
            let width = (view?.viewPercentage.bounds.width)! / 2
//            view?.leftViewPercentage.constant = -width
//            view?.rightViewPercentage.constant = -width
        }
        else {
            view?.viewRPM.isHidden = true
            view?.viewPercentage.isHidden = false
//            view?.leftViewPercentage.constant = 0
//            view?.rightViewPercentage.constant = 0
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
    
    func apiCallGetDetails() {
        let param = ["":""]
        
        ApiManager.shared.MakeGetAPI(name: GET_TRAINING_LOG + "/" + self.trainingLogId, params: param, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let data = json.getDictionary(key: .data)
                print(data)
                let model = TrainingLogModelClass(JSON: data.dictionaryObject!)
                self.previewData = model
                
                self.getCurrenIndexOfCurrentLap()
                
                let activityName = self.previewData?.trainingActivity?.name?.lowercased() ?? ""
                if activityName == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){
                    
                    self.theController.checkLocationPermissionAvailableOrNot()
                    
                    guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
                        return
                    }
                    
                    let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data?.user?.id?.stringValue && $0.activityId == self.trainingLogId}
                    
                    if routeObjects.count > 0 {
                        
                        //We cannot Righ last index endTo because user also walk some km afrer complete lap so we have to take start of that repeat and recent value of Index passes
                        //                        let lastIndex = routeObjects[0].lapArray.count - 1
                        //                        routeObjects[0].lapArray[lastIndex].endTo
                        
                        self.totalDistanceWithPedometer = routeObjects[0].totalCoveredDistance
                        self.theController.totalDistancConverted = routeObjects[0].totalCoveredDistance
                        
                        self.theController?.lapCoveredDistance = routeObjects[0].lapArray[self.currentWorkedIndex].lapCoverDistance
                        self.coverdDistanceOfLapWithPedometer  = CGFloat(self.theController?.lapCoveredDistance ?? 0.0)
                        
                        //When user come to screen and no movement detected that time 10 seconds timer start
                        
                        
                        if self.previewData?.exercise?[0].startTime == ""{
                            
                        }else{
                            
                            if self.previewData?.exercise?.count ?? 0 > 0{
                                
                                if self.previewData?.exercise?[(self.previewData?.exercise?.count ?? 0) - 1].isCompleted == true && self.previewData?.exercise?[(self.previewData?.exercise?.count ?? 0) - 1].isCompletedRest == true{
                                    
                                    if routeObjects[0].isPauseAfterAllLapCompleted == false{
                                        if self.theController.timerForMotion == nil{
                                            self.theController.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self.theController, selector: #selector(self.theController.check10secondOrNot), userInfo: nil, repeats: true)
                                        }
                                    }
                                    
                                }else{
                                    //TODO:- Add Comment here because If it's pause then Total Duration already continue
                                    
                                    //                                    if self.previewData?.exercise?[self.currentWorkedIndex].isPause == false{
                                    
                                    if self.previewData?.exercise?[self.currentWorkedIndex].isCompleted == false || self.previewData?.exercise?[self.currentWorkedIndex].isCompleted == nil && (self.previewData?.exercise?[0].startTime != ""){
                                        
                                        if self.theController.timerForMotion == nil{
                                            self.theController.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self.theController, selector: #selector(self.theController.check10secondOrNot), userInfo: nil, repeats: true)
                                        }
                                    }
                                    //                                    }
                                }
                            }
                        }
                        
                    }
                } else {
                    
                    if self.previewData?.exercise?[self.currentWorkedIndex].isPause == true{
                        //Not need to add condition of Completed and Duration/Distnace because it's only add in Distnace condition added in StartWorkoutCardioVc
                        
                        if let valueForIndoor = Defaults.value(forKey: "trainingLog Indoor \(self.previewData?.id ?? "")") as? Double{
                            self.coverdDistanceOfLapWithPedometer = CGFloat(valueForIndoor)
                        }
                    }
                    
                    let count = self.previewData?.exercise?.count ?? 0
                    self.totalDistanceWithPedometer = self.previewData?.exercise?[count-1].totalDistance ?? 0.0
                    
                    print("Total Distance with pedometer :\(self.totalDistanceWithPedometer)")
                    
                }

                self.setupUI()
                
                if self.afterClickRepeatButtonVisible == 1{
                    self.afterClickRepeatButtonVisible = 0
                    if let view = (self.theController.view as? LogPreviewView){
                        view.isSetAlphaOrNOt(isSet: true)
                    }
                    
                    //Write return beause after that below method not execute
                    return
                }
                
            }
        })
    }
    
    func apiCallForUpdate(isSavedWorkout: Bool) {
        let param = ["": ""] as [String : Any]
        
        ApiManager.shared.MakeGetAPI(name: SAVE_TEMPLETE_TO_WORKOUT + "/" + (self.previewData?.id ?? ""), params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let message = json.getString(key: .message)
                makeToast(strMessage: message)
            }
        }
    }
    
    func apiCallSaveDetails(programId: String, isEndWorkout:Bool = false, progress:Bool = true) {
        
        var exercise: NSMutableArray = []
        var param : [String:Any] = [:]
     
        let activityName = self.previewData?.trainingActivity?.name?.lowercased()
        
        if isRepeatExercise{
            exercise = arrayForRepeatExercise()
            
            param = [
                "exercise": exercise,
                "is_complete": false
                ] as [String : Any]
            
        }else{
            exercise = arrayForExerciseAccordingToActivity()
            
            param = [
                "exercise": exercise,
                "is_complete": false
//                "is_complete": self.previewData?.isComplete ?? false
                ] as [String : Any]
            
        }
        
        if activityName == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){
            
            guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
                return
            }

            let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.activityId == programId}

            if routeObjects.count > 0 {
                param["outdoor_route_data"] = String(routeObjects[0].allTrackRoute)
            }
        }
        
//        for data in self.previewData?.exercise ?? [] {
//            let dict: NSDictionary = ["laps" : data.laps ?? "", "is_completed" : data.isCompleted ?? "", "is_completed_rest" : data.isCompletedRest ?? "", "speed": data.speed ?? "", "pace": data.pace ?? "", "rest": data.rest ?? "", "rpm": data.rpm ?? "", "percentage": data.percentage ?? "", "duration": data.duration ?? "", "distance": data.distance ?? ""]
//            exercise.add(dict)
//        }
        
        //MARK: - Anil old code comment
//        if isEndWorkout {
//            param.removeValue(forKey: "exercise")
//        }
        print(JSON(param))
        if isEndWorkout {
            self.previewData?.isComplete = true
        }
        if programId == "" {
            return
        }
        ApiManager.shared.MakePutAPI(name: COMPLETE_TRAINING_LOG + "/" + programId, params: param as [String : Any], progress: progress, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
//                print(json)
                let success = json.getBool(key: .success)
                if success {
                    
                    if self.isClickOnCompleteButton == true{
                        AppDelegate.shared?.locationManager.allowsBackgroundLocationUpdates = false

                        self.theController.redirectionForOutdoor()
                        return
                    }
                    
                    if self.previewData?.isComplete ?? false{
//                        self.theController.redirectToCardioSummary()
                        AppDelegate.shared?.locationManager.allowsBackgroundLocationUpdates = false
                        self.theController.redirectToRPESelection()
                    }
                    
//
                    let activityName = self.previewData?.trainingActivity?.name?.lowercased() ?? ""
                    
                    if activityName.lowercased() == "Cycling (Outdoor)".lowercased() || activityName.lowercased() == "Run (Outdoor)".lowercased(){
                        
                        //MARK: set 0 othewise it's not working in logPReview screen
                        self.coverdDistanceOfLapWithPedometer = 0
                        self.getCurrenIndexOfCurrentLap()
                    }else{
                        
                        
                        if self.previewData?.exercise?[self.currentWorkedIndex].isPause == false{
                            self.coverdDistanceOfLapWithPedometer = 0
                        }
                        
                        if self.isLogPreviewScreenOpen{
                            self.getCurrenIndexOfCurrentLap()
                        }
//                        self.theController.reCallMainCountingStep()
                    }
                    
                    if self.isRepeatExercise{
                        self.currentWorkedIndex = 0
                        self.isRepeatExercise = false
                        self.apiCallGetDetails()
                        print("Repepat method tappedddd call this method")
                        self.afterClickRepeatButtonVisible = 1
                    }
                    
                    //previous added
                    //                    self.theController.btnEdit.isHidden = self.checkIsExerciseStarted()
                    //New added
                    
                    if self.checkIsExerciseStarted(){
                        self.theController.btnEdit.setTitle(str: "Switch View")
                        self.theController.btnEdit.setTitleColor(UIColor.appthemeRedColor, for: .normal)
                        self.theController.btnEdit.setImage(nil, for: .normal)
                        self.theController.btnEdit.contentHorizontalAlignment = .center
                        self.theController.btnRightBarButton.width = 200
                        
                        if let view = (self.theController.view as? LogPreviewView){
                            
                            view.ConstratintBottomViewHeigh.constant = 102
                            
                            view.isBottomDeleteShareShow(isShow: false)
                            view.vwBottomHiddenShow(isHidden: true)
                            
                            if (view.scrollView.contentOffset.y + view.safeAreaHeight - 102) >= view.scrollView.contentSize.height{
                                view.isSetAlphaOrNOt(isSet: true)
                            }else{
                                view.isSetAlphaOrNOt(isSet: false)
                            }
                            
                            view.tableView.reloadData()
                        }
                        
                    }else{
                        self.theController.btnEdit.setTitle(str: "")
                        self.theController.btnEdit.setImage(UIImage(named: "ic_edit_red"), for: .normal)
                        self.theController.btnEdit.contentHorizontalAlignment = .right
                        self.theController.btnRightBarButton.width = 50
                        
                        if let view = (self.theController.view as? LogPreviewView){
                            
                            view.vwBottomHiddenShow(isHidden: false)
                            
//                            if view.scrollView.contentSize.height+177 <= view.safeAreaHeight{
                                view.isSetAlphaOrNOt(isSet: true)
                                view.isBottomDeleteShareShow(isShow: true)
//                            }else{
//                                view.isSetAlphaOrNOt(isSet: false)
//                                view.isBottomDeleteShareShow(isShow: false)
//                            }

                            view.tableView.reloadData()
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
    
    func apiCallDeleteLog() {
        let param = ["":""]
        
        ApiManager.shared.MakeGetAPI(name: TRAINING_LOG_DELETE + "/" + (self.previewData?.id)!, params: param, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                self.theController.dismiss(animated: false, completion: {
                    makeToast(strMessage: json.getString(key: .message))
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
                })
            }
        })
    }
    
    @objc func updatedTraining(notification: Notification) {
        if let model = notification.userInfo?["data"] as? TrainingLogModelClass {
            self.previewData = model
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)

            self.setupUI()
        }
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
    
    func checkRepeatClickableOrNot(){
        if let array = self.previewData?.exercise{
            
            if array.count == 0{
                return
            }
            
            if self.currentWorkedIndex == array.count-1{
                
                if let vw = self.theController.view as? LogPreviewView{
                    if array[self.currentWorkedIndex].isCompleted ?? false == true && array[self.currentWorkedIndex].isCompletedRest ?? false == true{
                        
                        vw.vwRepeatWorkout.borderColors = .appthemeOffRedColor
                        vw.vwRepeatWorkout.setShadowToView()
                        vw.btnRepeatWorkout.setColor(color: .appthemeRedColor)
                        vw.btnRepeatWorkout.isUserInteractionEnabled = true
                    }else{
                        vw.vwRepeatWorkout.borderColors = .black
                        vw.vwRepeatWorkout.shadowColors = .clear
                        vw.btnRepeatWorkout.setColor(color: .black)
                        vw.btnRepeatWorkout.isUserInteractionEnabled = false
                    }
                }
            }else{
                
                if let vw = self.theController.view as? LogPreviewView{
                    
                    if array[array.count-1].isCompleted == true || array[array.count-1].isCompletedRest == true{
                        vw.vwRepeatWorkout.borderColors = .appthemeOffRedColor
                        vw.vwRepeatWorkout.setShadowToView()
                        vw.btnRepeatWorkout.setColor(color: .appthemeRedColor)
                        vw.btnRepeatWorkout.isUserInteractionEnabled = true
                    }else{
                        vw.vwRepeatWorkout.borderColors = .black
                        vw.vwRepeatWorkout.shadowColors = .clear
                        
                        vw.btnRepeatWorkout.setColor(color: .black)
                        vw.btnRepeatWorkout.isUserInteractionEnabled = false
                    }
                }
            }
        }
    }
    
    func arrayForExerciseAccordingToActivity() -> NSMutableArray {
        
        let exerciseArray: NSMutableArray = NSMutableArray()

        if let array = self.previewData?.exercise{
            print("array :L \(array)")
            for i in 0..<array.count{
                
                let model = array[i]
                
                let valueLaps = model.laps
                let valueDistance = model.distance
                let valueDuration = model.duration
                let valueSpeed = model.speed
                let valuePace = model.pace
                let valuePercentage = model.percentage
                let valueRest = model.rest
                let valueRPM = model.rpm
                let valueWatt = model.watt
                let ValueLvl = model.lvl
                
                var dict = NSMutableDictionary()
                
                switch self.previewData?.trainingActivity?.name?.lowercased(){
                    
                case "Run (Outdoor)".lowercased():
                   dict = ["laps": valueLaps, "speed": valueSpeed , "pace": valuePace, "percentage": valuePercentage, "duration": valueDuration, "distance": valueDistance, "rest": valueRest]
                  // exerciseArray.add(dict)
                    
                case "Run (Indoor)".lowercased():
                     dict = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "percentage": valuePercentage, "duration": valueDuration, "distance": valueDistance, "rest": valueRest]
                //    exerciseArray.add(dict)
                    
                case "Cycling (Indoor)".lowercased():
                    dict = ["laps": valueLaps, "speed": valueSpeed, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm": valueRPM, "watt": valueWatt, "lvl" : ValueLvl]
               //     exerciseArray.add(dict)
                    
                case "Cycling (Outdoor)".lowercased():
                    dict = ["laps": valueLaps, "speed": valueSpeed, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt, "percentage": valuePercentage]
               //     exerciseArray.add(dict)
                    
                case "Swimming".lowercased():
                   dict = ["laps": valueLaps, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest]
           //         exerciseArray.add(dict)
                    
                case "Others".lowercased():
                    
                    dict = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt, "lvl" : ValueLvl,"is_speed" : model.isSpeed]
         //           exerciseArray.add(dict)
                default:
                   dict = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt, "lvl" : ValueLvl]
        //            exerciseArray.add(dict)
                }
                
                dict.setValue(model.isCompleted ?? false, forKey: "is_completed")
                dict.setValue(model.isCompletedRest ?? "", forKey: "is_completed_rest")
                dict.setValue(model.startTime, forKey: "start_time")
                dict.setValue(model.addedStartTime, forKey: "added_start_time")
                dict.setValue(model.addedRestTime, forKey: "added_rest_time")
                dict.setValue(model.pauseTime, forKey: "pause_time")
                dict.setValue(model.isPause, forKey: "is_pause")
                dict.setValue(model.isCheckMarkAlreadyDone, forKey: "is_checkmark_done")
                dict.setValue(model.elapsedTime, forKey: "elapsedTime")
                dict.setValue(model.isClickOnPause, forKey: "isClickOnPause")
                dict.setValue(model.lineDraw, forKey: "lineDraw")
                dict.setValue(model.lastPauseTime, forKey: "lastPauseTime")
                
                if i == 0{
                    dict.setValue(model.repeatTime, forKey: "repeat_time")
                    dict.setValue(model.startTime, forKey: "start_time")
                    dict.setValue(model.startLat, forKey: "start_lat")
                    dict.setValue(model.startLong, forKey: "start_long")
                    
                    if let value = Defaults.value(forKey: self.trainingLogId) as? Int{
                        dict.setValue(value, forKey: "deactive_duration")
                    }
                }
                
                if i == array.count - 1{
                    dict.setValue(model.endTime, forKey: "end_time")
                    dict.setValue(model.endLat, forKey: "end_lat")
                    dict.setValue(model.endLong, forKey: "end_long")
                    dict.setValue(self.totalDistanceWithPedometer, forKey: "total_distance")
                    dict.setValue(self.totalAverageActivePacePedometer, forKey: "avg_total_pace")
                    dict.setValue(self.netElevationGain, forKey: "elevation_gain")
                }
                
                exerciseArray.add(dict)
                
            }
            
            return exerciseArray
        }
        
        return exerciseArray
    }
    
    
    func arrayForRepeatExercise() -> NSMutableArray {
        
        let exerciseArray: NSMutableArray = NSMutableArray()

        if let array = self.previewData?.exercise{
            print("array :L \(array)")
            for i in 0..<array.count{
                
                let model = array[i]
                
                let valueLaps = model.laps
                let valueDistance = model.distance
                let valueDuration = model.duration
                let valueSpeed = model.speed
                let valuePace = model.pace
                let valuePercentage = model.percentage
                let valueRest = model.rest
                let valueRPM = model.rpm
                let valueWatt = model.watt
                let ValueLvl = model.lvl
                
                var dict = NSMutableDictionary()
                
                switch self.previewData?.trainingActivity?.name?.lowercased(){
                    
                case "Run (Outdoor)".lowercased():
                   dict = ["laps": valueLaps, "speed": valueSpeed , "pace": valuePace, "percentage": valuePercentage, "duration": valueDuration, "distance": valueDistance, "rest": valueRest]
                  // exerciseArray.add(dict)
                    
                case "Run (Indoor)".lowercased():
                     dict = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "percentage": valuePercentage, "duration": valueDuration, "distance": valueDistance, "rest": valueRest]
                //    exerciseArray.add(dict)
                    
                case "Cycling (Indoor)".lowercased():
                    dict = ["laps": valueLaps, "speed": valueSpeed, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm": valueRPM, "watt": valueWatt, "lvl" : ValueLvl]
               //     exerciseArray.add(dict)
                    
                case "Cycling (Outdoor)".lowercased():
                    dict = ["laps": valueLaps, "speed": valueSpeed, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt, "percentage": valuePercentage]
               //     exerciseArray.add(dict)
                    
                case "Swimming".lowercased():
                   dict = ["laps": valueLaps, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest]
           //         exerciseArray.add(dict)
                    
                case "Others".lowercased():
                    
                    dict = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt, "lvl" : ValueLvl,"is_speed" : model.isSpeed]
         //           exerciseArray.add(dict)
                default:
                   dict = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt, "lvl" : ValueLvl]
        //            exerciseArray.add(dict)
                }
                
                let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                
                 let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: model.rest)))
                
                 let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                 print("convertToStringForRest : \(convertToStringForRest)")


                if i == 0{
                    dict.setValue(date, forKey: "repeat_time")
                    dict.setValue(model.startTime, forKey: "start_time")
                    dict.setValue(model.startLat, forKey: "start_lat")
                    dict.setValue(model.startLong, forKey: "start_long")
                    dict.setValue(convertToStringForRest, forKey: "added_rest_time")

                }
                
                if i == array.count - 1{
                    dict.setValue(model.endTime, forKey: "end_time")
                    dict.setValue(model.endLat, forKey: "end_lat")
                    dict.setValue(model.endLong, forKey: "end_long")
                }
                
                exerciseArray.add(dict)
                
            }
            
            return exerciseArray
        }
        
        return exerciseArray
    }
    
    func getSeconds(data: String?) -> Float {
        let dataArray = data?.split(separator: ":")
        if dataArray?.count == 3 {
            let sHr = (Double(dataArray?[0] ?? "0") ?? 0) * 60 * 60
            let sMin = (Double(dataArray?[1] ?? "0") ?? 0) * 60
            let sSec = (Double(dataArray?[2] ?? "0") ?? 0)
            
            let secondCount = sHr + sMin + sSec
            return Float(secondCount)
        }
        else if dataArray?.count == 2 {
            let sMin = (Double(dataArray?[0] ?? "0") ?? 0) * 60
            let sSec = (Double(dataArray?[1] ?? "0") ?? 0)
            
            let secondCount = sMin + sSec
            return Float(secondCount)
        }
        return Float(0)
    }
}

//MARK: - Local Data base
extension LogPreviewViewModel{
    
    func ActivityIncrementId() -> Int{
        return (realm?.objects(CardioActivityRoute.self).max(ofProperty: CardioActivityRoute.primaryKey()) as Int? ?? 0) + 1
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
        
        let objActivityRouteData = CardioActivityRoute()
        
        let activityIncrementId = ActivityIncrementId()
        
        objActivityRouteData.id = activityIncrementId
        objActivityRouteData.userId = getUserDetail()?.data!.user!.id!.stringValue ?? ""
        objActivityRouteData.activityId = (previewData.id) ?? ""
        
        let arrayLap = self.previewData!.exercise ?? []
        
        if arrayLap.count != 0{
            
            for i in 0..<arrayLap.count{
                let lapData = arrayLap[i]
                let objLapDetails = LapDetails()
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
        
        guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
            return
        }

        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.activityId == previewData.id}
        
        try! realm?.write{
            
            if routeObjects.count > 0{
                print("reoutObjects:\(routeObjects)")

            }else{
                print("No Data Found in local database")
                setupDataToLocalDatabase()
            }
        }
    }
}
