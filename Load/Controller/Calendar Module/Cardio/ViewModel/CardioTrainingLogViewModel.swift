//
//  CardioTrainingLogViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift

class CardioTrainingLogViewModel: DismissPreviewDelegate {
    
    fileprivate weak var theController:CardioTrainingLogVC!
    
    let activityPickerView = UIPickerView()
    let intensityPickerView = UIPickerView()
    let trainingGoalPickerView = UIPickerView()
    let targatHRPickerView = UIPickerView()
    var stylePickerView = UIPickerView()
    
    var activityId:String = ""
    var intensityId:String = ""
    var trainingGoalId:String = ""
    var selectedTargatHRId:String = ""
    var targatHRId:String = ""
    var selectedDate:String = ""
    var trainingId:String = ""
    var isEdit:Bool = false
    var isGoalCustom:Bool = false
    var targatHR:String = ""
    var HRMaxValue : CGFloat = 0.0
    var selectedDateFromCalendar: String = ""
    
    
    var exercisesArray:[CardioExerciseModelClass] = [CardioExerciseModelClass]()
    var previewData: TrainingLogModelClass?
    var selectedCardioLogValidation: CardioValidationListData?
    var cardioLogValidationList: [CardioValidationListData] = []
    
    var isShowDistance:Bool = true
    var isShowSpeed:Bool = false
    var isShowRPM:Bool = true
    
    var isTrainigGoalSelectAsCustomize:Bool = false
    var selectedTrainingGoalName = ""
    
    var selectedSwimmingStyle = ""
    
    init(theController:CardioTrainingLogVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.DOBSetup()
        self.showCurrentDate()
        let view = (self.theController.view as? CardioTrainingLogView)
        view?.lblLapsTitle.text = self.getTotalLaps(total: self.exercisesArray.count)
        
        activityPickerView.delegate = theController
        activityPickerView.backgroundColor = UIColor.white
        view?.txtActivity.inputView = activityPickerView
        
        stylePickerView.delegate = theController
        stylePickerView.backgroundColor = UIColor.white
        view?.txtStyle.inputView = stylePickerView

        intensityPickerView.delegate = theController
        intensityPickerView.backgroundColor = UIColor.white
        view?.txtIntensity.inputView = intensityPickerView
        
        self.showDistance(isShow: self.isShowDistance)
        self.showSpeed(isShow: self.isShowSpeed)
        self.showRPM(isShow: self.isShowRPM)
        
        self.apiCallGetValidationForCardio()
        self.setTrainingGoal()
        targatHRPickerView.delegate = theController
        targatHRPickerView.backgroundColor = UIColor.white
        view?.txtTargetHR.inputView = targatHRPickerView
        
        if self.isEdit {
            self.setupEditData()
        }
    }
    
    func setTrainingGoal(isSet:Bool = true) {
        let view = (self.theController.view as? CardioTrainingLogView)
        view?.txtTrainingGoal.delegate = theController
        if isSet {
            trainingGoalPickerView.delegate = theController
            trainingGoalPickerView.backgroundColor = UIColor.white
            view?.txtTrainingGoal.inputView = trainingGoalPickerView
            view?.txtTrainingGoal.placeholder = getCommonString(key: "Fill_in_your_training_goal_key")
        }
        else {
            view?.txtTrainingGoal.inputView = nil
            view?.txtTrainingGoal.placeholder = ""
            view?.txtTrainingGoal.becomeFirstResponder()
        }
    }
    
    func showCustomTrainingGoal(isShow:Bool = true) {
        let view = (self.theController.view as? CardioTrainingLogView)
        if isShow {
            view?.heightCustomTrainingGoal.constant = 58
            view?.viewCustomTrainingGoal.isHidden = false
            //TODO: - Yash changes
            
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                    view?.mainScrollView.contentOffset.y = self.theController.scrollCurrentOffset-216
                    view?.layoutIfNeeded()
                    view?.layoutSubviews()
                }, completion: nil)
            }
            
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        else {
            view?.heightCustomTrainingGoal.constant = 0
            view?.viewCustomTrainingGoal.isHidden = true
            //TODO: - Yash changes 
            IQKeyboardManager.shared.enableAutoToolbar = true
        }
    }
    
    func setupEditData() {
        let view = (self.theController.view as? CardioTrainingLogView)!
        view.txtActivity.text = self.previewData?.trainingActivity?.name
        
        view.txtWhen.text =  convertDateFormater(self.previewData?.date ?? "", dateFormat: "EEEE, dd MMM yyyy 'at' hh:mm a")
//            (self.previewData?.date)!.UTCToLocal(returnFormat: "EEEE, dd MMM yyyy 'at' hh:mm a")
//
        view.txtIntensity.text = self.previewData?.trainingIntensity?.name
        view.txtName.text = self.previewData?.workoutName
        let trainigGoalCustom = self.previewData?.trainingGoalCustom
        view.txtTrainingGoal.text = self.previewData?.trainingGoal?.name ?? trainigGoalCustom
        view.txtTargetHR.text = (self.previewData?.targetedHr ?? "") + " bpm"
        self.targatHR = (self.previewData?.targetedHr ?? "") + " bpm"
        
        view.txtNotes.text = self.previewData?.notes
        
//        if trainigGoalCustom == "" || trainigGoalCustom == nil {
//            view.txtTargetHR.isUserInteractionEnabled = true
//
//            self.isGoalCustom = false
//        }
//        else {
//            self.isGoalCustom = true
//        }

        if self.previewData?.trainingGoalId?.stringValue == "" || self.previewData?.trainingGoalId?.stringValue == nil || self.previewData?.trainingGoalId?.stringValue == "0"{
            
            self.trainingGoalId = String(self.previewData?.trainingGoalCustomId ?? 0)
            self.isGoalCustom = true

        }else{
            view.txtTargetHR.isUserInteractionEnabled = true
            self.trainingGoalId = self.previewData?.trainingGoalId?.stringValue ?? ""
            self.isGoalCustom = false
        }
        
        self.activityId = self.previewData?.trainingActivity?.id?.stringValue ?? ""
        self.intensityId = self.previewData?.trainingIntensityId?.stringValue ?? ""
        self.trainingId = self.previewData?.id?.stringValue ?? ""
        self.targatHRId = self.previewData?.targetedHr ?? ""
        self.selectedDate = self.previewData?.date ?? ""
        theController.hideShowHeaderAccordingToActivity(name : view.txtActivity.text ?? "")
        
        view.btnLogIt.backgroundColor = UIColor.appthemeRedColor
        view.btnLogIt.isUserInteractionEnabled = true
        
        if view.txtActivity.text?.toTrim().lowercased() ?? "" == "Swimming".lowercased(){
            self.selectedSwimmingStyle = String(self.previewData?.trainingStyle?.id ?? 0)
            view.txtStyle.text = self.previewData?.trainingStyle?.name
        }
        
        print("Style id: \(self.selectedSwimmingStyle)")
        
        setDataEditTimeAccordingToActivity()
        
        //TODO: - Yash Changes
        
//        for exerciseData in (self.previewData?.exercise)! {
//            let dict: NSDictionary = ["Laps":exerciseData.laps!, "Speed": exerciseData.speed!,"Percentage": self.activityId != "3" ? exerciseData.percentage ?? "0" : exerciseData.rpm ?? "0", "Duration":exerciseData.duration!, "Rest":exerciseData.rest!]
//            let exercises = CardioExerciseModelClass(JSON: JSON(dict).dictionaryObject!)
//            self.exercisesArray.append(exercises!)
//        }
        
        print(self.exercisesArray.count)
        
        if self.exercisesArray.first?.distance == "" || self.exercisesArray.first?.distance == nil{
            view.lblDuration.text = "Duration"
            view.imgDurationArrow.image = UIImage(named: "ic_up_black")
            self.isShowDistance = false
        }else{
            view.lblDuration.text = "Distance"
            view.imgDurationArrow.image = UIImage(named: "ic_dropdown_black")
            self.isShowDistance = true
        }

        if self.exercisesArray.first?.speed == "" || self.exercisesArray.first?.speed == nil{
            view.lblSpeed.text = "Pace"
            view.imgSpeedArrow.image = UIImage(named: "ic_dropdown_black")
            self.isShowSpeed = false
        }else{
            view.lblSpeed.text = "Speed"
            view.imgSpeedArrow.image = UIImage(named: "ic_up_black")
            self.isShowSpeed = true
        }

        if self.exercisesArray.first?.rpm == "" || self.exercisesArray.first?.rpm == nil{
            view.lblRPM.text = "Watt"
            view.imgRPMArrow.image = UIImage(named: "ic_up_black")
            self.isShowRPM = false
        }else{
            view.lblRPM.text = "RPM"
            view.imgRPMArrow.image = UIImage(named: "ic_dropdown_black")
            self.isShowRPM = true
        }
        
        view.lblLapsTitle.text = self.getTotalLaps(total: self.exercisesArray.count)
        
        view.tableViewHeight.constant = CGFloat(self.exercisesArray.count * 70)        
        print(self.exercisesArray.count)
        
        print("ActivityId : \(self.activityId)")
        print("TrainingId : \(self.trainingGoalId)")
        
        getValidationFromId()

      //  self.showExerciseHeader()
        view.tableView.reloadData()
    }
    
    func DOBSetup() {
        let view = (theController.view as? CardioTrainingLogView)
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
            //datePickerView.setValue(UIColor.clear, forKey: "magnifierLineColor")
            datePickerView.setValue(false, forKey: "highlightsToday")
        }
        datePickerView.backgroundColor = UIColor.white

        if self.selectedDateFromCalendar == ""{
            datePickerView.setDate(Date(), animated: false)
        }else{
            
            let convertToTime = DateToString(Formatter: "hh:mm a", date: Date())
            print("convertToTime: \(convertToTime)")
            
            let stringFullDate = self.selectedDateFromCalendar + " " + convertToTime
            print("stringFullDate: \(stringFullDate)")
            
            let convertToDate = convertDate(stringFullDate, dateFormat:  "yyyy-MM-dd hh:mm a")
            print("convertToDate:\(convertToDate)")
            
            datePickerView.setDate(convertToDate, animated: false)
        }
        
        datePickerView.setValue(UIColor.appthemeOffRedColor, forKeyPath: "textColor")
        view?.txtWhen.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    func showCurrentDate() {
        let view = (self.theController.view as? CardioTrainingLogView)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat = "EEEE, dd MMM yyyy 'at' hh:mm a"
        
        if self.selectedDateFromCalendar == ""{
            view?.txtWhen.text = dateFormatter.string(from: Date())
            self.selectedDate = DateToString(Formatter: "yyyy-MM-dd HH:mm:ss", date: Date())
            
        }else{
//            let convertToDate = convertDate(self.selectedDateFromCalendar, dateFormat:  "yyyy-MM-dd")
            
            let convertToTime = DateToString(Formatter: "hh:mm a", date: Date())
            print("convertToTime: \(convertToTime)")
            
            let stringFullDate = self.selectedDateFromCalendar + " " + convertToTime
            print("stringFullDate: \(stringFullDate)")
            
            let convertToDate = convertDate(stringFullDate, dateFormat:  "yyyy-MM-dd hh:mm a")
            print("convertToDate:\(convertToDate)")

            view?.txtWhen.text = dateFormatter.string(from: convertToDate)
            self.selectedDate = DateToString(Formatter: "yyyy-MM-dd HH:mm:ss", date: convertToDate)
        }
        
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let view = (theController.view as? CardioTrainingLogView)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "EEEE, dd MMM yyyy 'at' hh:mm a"
        view?.txtWhen.text = dateFormatter.string(from: sender.date)
        self.selectedDate = DateToString(Formatter: "yyyy-MM-dd HH:mm:ss", date: sender.date)
    }
    
    func getTrainingGoal() -> [TrainingGoalLogCardio] {
        
        let findDataAccordingActivityID = GetAllData?.data?.trainingGoalLogCardio?.filter({ (logModel) -> Bool in
            return logModel.trainingActivityIds?.contains(self.activityId) ?? false
        })
        
        let filter = findDataAccordingActivityID?.filter({ (model) -> Bool in
            return model.trainingIntensityIds?.contains(self.intensityId) ?? false
        })
        
//        let json = JSON([ "target_hr" : "0", "is_active" : true, "training_intensity_ids" : [], "code" : "CUSTOMIZE", "updated_at" : "2019-09-28 01:16:45", "display_at" : [ "LOG_CARDIO", "LOG_RESISTANCE", "PROGRAM_CARDIO", "PROGRAM_RESISTANCE" ], "id" : 0, "created_at" : "2019-05-29 13:00:00", "sequence" : 0, "name" : "Customize"])
//        filter?.append(TrainingGoalLogCardio(JSON: json.dictionaryObject!)!)
        return filter ?? []
    }
    
    func ValidateDetailsForShare() -> Bool {
        let view = (self.theController.view as? CardioTrainingLogView)
        if view?.txtActivity.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_activity_key"))
        }
        else if view?.txtWhen.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_date_key"))
        }
        else if view?.txtIntensity.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_intensity_key"))
        }
        else if view?.txtName.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_name_key"))
        }
        else if view?.txtTrainingGoal.text?.toTrim() == "" {
            
            makeToast(strMessage: getCommonString(key: "Please_fill_in_your_training_goal_key"))
        }
        else if view?.viewCustomTrainingGoal.isHidden == false {
            makeToast(strMessage: getCommonString(key: "Please_enter_custom_training_goal_key"))
        }
            //        else if view?.txtTargetHR.text == "" {
            //            makeToast(strMessage: getCommonString(key: "Please_select_target_hr_key"))
            //        }
            //        else if view?.txtNotes.text == "" {
            //            makeToast(strMessage: getCommonString(key: "Please_enter_notes_key"))
            //        }
        else if exercisesArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_add_some_exercise_key"))
        }
        else {
            return true
        }
        return false
    }
    
    func shareFriend(toId:String) {
        let view = (self.theController.view as? CardioTrainingLogView)
        if self.exercisesArray.count != 0 {
            var isAllFieled:Bool = true
            for model in self.exercisesArray {
                if model.laps == "" {
                    isAllFieled = false
                }
                /*
                if view?.txtActivity.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() !=  "Run (Indoor)".lowercased() && view?.txtActivity.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != "Run (Outdoor)".lowercased(){
                    
                    if model.percentage == "" {
                        isAllFieled = false
                    }
                    
                   if model.rest == "" || model.rest == nil {
                        isAllFieled = false
                    }
                    
                }*/
                
                let trainingGoalValue = view?.txtTrainingGoal.text?.toTrim().lowercased()
                
                let speedIntervals = "Speed Intervals".lowercased()
                let lacateToleranceIntervals = "Lactate Tolerance (Intervals)".lowercased()
                let aerobicIntervals = "Aerobic Intervals".lowercased()
                let aerobicCapacity = "Aerobic Capacity".lowercased()
                let sprint = "Sprint".lowercased()
                let speed = "Speed".lowercased()

                switch view?.txtActivity.text?.toTrim().lowercased(){
                    
                case "Run (Outdoor)".lowercased():
                    
                    if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil) && self.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if (model.pace == "" || model.pace == nil) && !self.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == speedIntervals || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicIntervals{
                       if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                    }
                    
                case "Run (Indoor)".lowercased():
                    if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil) && self.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if (model.pace == "" || model.pace == nil) && !self.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == speedIntervals || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicIntervals{
                       if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                    }
                    
                case "Cycling (Indoor)".lowercased():
                    
                    if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil) && self.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == sprint || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicCapacity{
                       if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                    }
                    
                    //Lvl is comment becaus static value pass(CardioTrainingViewModel)(CardioTrainingLogVc)
//                    if model.lvl == "" || model.lvl == nil {
//                        isAllFieled = false
//                    }
                    
                    if (model.rpm == "" || model.rpm == nil) && self.isShowRPM {
                        isAllFieled = false
                    }
                    
                    if (model.watt == "" || model.watt == nil) && !self.isShowRPM {
                        isAllFieled = false
                    }
                    
                case "Cycling (Outdoor)".lowercased():
                   
                    if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil) && self.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if (model.rpm == "" || model.rpm == nil) && self.isShowRPM {
                        isAllFieled = false
                    }
                    
                    if (model.watt == "" || model.watt == nil) && !self.isShowRPM {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == sprint || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicCapacity{
                       if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                    }
                    
                case "Swimming".lowercased():
                  
                    if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.pace == "" || model.pace == nil) && !self.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == speed{
                       if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                    }

                case "Others".lowercased():
                    
                    if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                        isAllFieled = false
                    }
                    
//                    if (model.speed == "" || model.speed == nil) && self.isShowSpeed {
//                        isAllFieled = false
//                    }
//
//                    if (model.pace == "" || model.pace == nil) && !self.isShowSpeed {
//                        isAllFieled = false
//                    }
//
//                    if (model.rpm == "" || model.rpm == nil) && self.isShowRPM {
//                        isAllFieled = false
//                    }
//
//                    if (model.watt == "" || model.watt == nil) && !self.isShowRPM {
//                        isAllFieled = false
//                    }
//
//                    if model.lvl == "" || model.lvl == nil {
//                        isAllFieled = false
//                    }
//
//                   if model.rest == "" || model.rest == nil {
//                        isAllFieled = false
//                    }
                    
                default:
                    
                   if model.rest == "" || model.rest == nil {
                        isAllFieled = false
                    }
                    
                }
                
                if !isAllFieled {
                    makeToast(strMessage: getCommonString(key: "Please_fill_all_details_key"))
                    return
                }
            }
        }
        print("Done")
        
        let exerciseArray: NSMutableArray = arrayForExerciseAccordingToActivity()
        
        let txtName = view?.txtName.text ?? ""
        let txtNotes = view?.txtNotes.text ?? ""
        
        self.apiCallShareFriend(status: TRAINING_LOG_STATUS.CARDIO.rawValue, userId: (getUserDetail()?.data?.user?.id?.stringValue) ?? "", date: self.selectedDate, workoutName: txtName, trainingGoalId: trainingGoalId, trainingIntensityId: intensityId, trainingActivityId: activityId, targetedHr: targatHRId, notes: txtNotes, isSavedWorkout: true, exercise: exerciseArray, toId: toId)
    }
    
    func apiCallShareFriend(status: String, userId: String, date: String, workoutName: String, trainingGoalId: String, trainingIntensityId: String, trainingActivityId: String, targetedHr: String, notes: String, isSavedWorkout: Bool, exercise: NSMutableArray, toId:String) {
        let view = (self.theController.view as? CardioTrainingLogView)
        var param = ["status":TRAINING_LOG_STATUS.CARDIO.rawValue, "user_id": userId, "date": date, "workout_name" : workoutName, "training_goal_id" : trainingGoalId, "training_intensity_id" : trainingIntensityId, "training_activity_id": trainingActivityId, "targeted_hr": targetedHr, "notes": notes, "is_saved_workout": isSavedWorkout, "exercise":exercise, "training_goal_custom": view?.txtTrainingGoal.text?.toTrim() ?? "","training_goal_custom_id": trainingGoalId] as [String : Any]
        
        if self.isGoalCustom {
            param.removeValue(forKey: "training_goal_id")
        }
        else {
            param.removeValue(forKey: "training_goal_custom")
        }
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CREATE_TRAINING_LOG, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                //                let data = json.getDictionary(key: .data)
                //                let model = TrainingLogModelClass(JSON: data.dictionaryObject!)
                self.trainingId = "\(json.getDictionary(key: .data).getInt(key: .id))"
                SocketIOHandler.shared.shareFriendTrainingLog(toIds: [Int(toId)!], trainingLogId: Int(self.trainingId)!)
            }
        }
    }
    
    func apiCallGetValidationForCardio() {
        ApiManager.shared.MakeGetAPI(name: LOG_CARDIO_VALIDATION_LIST, params: [:], progress: false, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let model = CardioValidationList(JSON: json.dictionaryObject!)
                self.cardioLogValidationList = model?.data ?? []
                
                if self.cardioLogValidationList.count > 0{
                    self.HRMaxValue = self.cardioLogValidationList[0].HRMax
                }
                
                self.getValidationFromId()
                let view = (self.theController.view as? CardioTrainingLogView)
                view?.tableView.reloadData()
            }
        }
    }
    
    func getValidationFromId() {
        
        let view = (self.theController.view as? CardioTrainingLogView)
        
        let filter = self.cardioLogValidationList.filter { (model) -> Bool in
            
            if view?.txtActivity.text?.lowercased() == "Others".lowercased(){
                
                self.trainingGoalId = String(0)
                return model.trainingActivityId == Int(self.activityId) && model.trainingGoalId == Int(0)
            }
            return model.trainingActivityId == Int(self.activityId) && model.trainingGoalId == Int(self.trainingGoalId)
        }
        self.selectedCardioLogValidation = filter.first
    }
    
    
    func ValidateDetails(isSavedWorkout:Bool = false) {
        let view = (self.theController.view as? CardioTrainingLogView)
        if view?.txtActivity.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_activity_key"))
        }
        else if view?.txtWhen.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_date_key"))
        }
        else if view?.txtIntensity.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_intensity_key"))
        }
        else if view?.txtName.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_name_key"))
        }
        else if view?.txtTrainingGoal.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_fill_in_your_training_goal_key"))
        }
        else if view?.txtActivity.text?.toTrim().lowercased() ?? "" == "Swimming".lowercased() && view?.txtStyle.text == ""{
            makeToast(strMessage: getCommonString(key: "Please_select_style_key"))
        }
        else if view?.viewCustomTrainingGoal.isHidden == false {
            makeToast(strMessage: getCommonString(key: "Please_enter_custom_training_goal_key"))
        }
            //        else if view?.txtTargetHR.text == "" {
            //            makeToast(strMessage: getCommonString(key: "Please_select_target_hr_key"))
            //        }
            //        else if view?.txtNotes.text == "" {
            //            makeToast(strMessage: getCommonString(key: "Please_enter_notes_key"))
            //        }
        else if exercisesArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_add_some_exercise_key"))
        }
        else {
            if self.exercisesArray.count != 0 {
                var isAllFieled:Bool = true
                for model in self.exercisesArray {
                    if model.laps == "" || model.laps == nil{
                        isAllFieled = false
                    }
                    
                    /*
                    if view?.txtActivity.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() !=  "Run (Indoor)".lowercased() && view?.txtActivity.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != "Run (Outdoor)".lowercased(){
                        
                        if model.percentage == "" {
                            isAllFieled = false
                        }
                        
                       if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                        
                    }*/
                    
                    
                    let trainingGoalValue = view?.txtTrainingGoal.text?.toTrim().lowercased()
                    
                    let speedIntervals = "Speed Intervals".lowercased()
                    let lacateToleranceIntervals = "Lactate Tolerance (Intervals)".lowercased()
                    let aerobicIntervals = "Aerobic Intervals".lowercased()
                    let aerobicCapacity = "Aerobic Capacity".lowercased()
                    let sprint = "Sprint".lowercased()
                    let speed = "Speed".lowercased()

                    switch view?.txtActivity.text?.toTrim().lowercased(){
                        
                    case "Run (Outdoor)".lowercased():
                        
                        if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                            isAllFieled = false
                        }
                        
                        if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                            isAllFieled = false
                        }
                        
                        if (model.speed == "" || model.speed == nil) && self.isShowSpeed {
                            isAllFieled = false
                        }
                        
                        if (model.pace == "" || model.pace == nil) && !self.isShowSpeed {
                            isAllFieled = false
                        }
                        
                        if trainingGoalValue == speedIntervals || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicIntervals{
                           if model.rest == "" || model.rest == nil || model.rest == nil{
                                isAllFieled = false
                            }
                        }
                        
                    case "Run (Indoor)".lowercased():
                        if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                            isAllFieled = false
                        }
                        
                        if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                            isAllFieled = false
                        }
                        
                        if (model.speed == "" || model.speed == nil) && self.isShowSpeed {
                            isAllFieled = false
                        }
                        
                        if (model.pace == "" || model.pace == nil) && !self.isShowSpeed {
                            isAllFieled = false
                        }
                        
                        if trainingGoalValue == speedIntervals || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicIntervals{
                           if model.rest == "" || model.rest == nil {
                                isAllFieled = false
                            }
                        }
                        
                    case "Cycling (Indoor)".lowercased():
                        
                        if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                            isAllFieled = false
                        }
                        
                        if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                            isAllFieled = false
                        }
                        
                        if (model.speed == "" || model.speed == nil) && self.isShowSpeed {
                            isAllFieled = false
                        }
                        
                        if trainingGoalValue == sprint || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicCapacity{
                           if model.rest == "" || model.rest == nil {
                                isAllFieled = false
                            }
                        }
                        
                        //Lvl is comment because array create that time static value as per client requirment(CardioTrainingViewModel)(CardioTrainingLogVc)
//                        if model.lvl == "" || model.lvl == nil{
//                            isAllFieled = false
//                        }
                        
                        if (model.rpm == "" || model.rpm == nil) && self.isShowRPM {
                            isAllFieled = false
                        }
                        
                        if (model.watt == "" || model.watt == nil) && !self.isShowRPM {
                            isAllFieled = false
                        }
                        
                    case "Cycling (Outdoor)".lowercased():
                       
                        if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                            isAllFieled = false
                        }
                        
                        if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                            isAllFieled = false
                        }
                        
                        if (model.speed == "" || model.speed == nil) && self.isShowSpeed {
                            isAllFieled = false
                        }
                        
                        if (model.rpm == "" || model.rpm == nil) && self.isShowRPM {
                            isAllFieled = false
                        }
                        
                        if (model.watt == "" || model.watt == nil) && !self.isShowRPM {
                            isAllFieled = false
                        }
                        
                        if trainingGoalValue == sprint || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicCapacity{
                           if model.rest == "" || model.rest == nil {
                                isAllFieled = false
                            }
                        }
                        
                    case "Swimming".lowercased():
                      
                        if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                            isAllFieled = false
                        }
                        
                        if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                            isAllFieled = false
                        }
                        
                        if (model.pace == "" || model.pace == nil) && !self.isShowSpeed {
                            isAllFieled = false
                        }
                        
                        if trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == speed{
                           if model.rest == "" || model.rest == nil {
                                isAllFieled = false
                            }
                        }

                    case "Others".lowercased():
                        
                        if (model.distance == "" || model.distance == nil) && self.isShowDistance {
                            isAllFieled = false
                        }
                        
                        if (model.duration == "" || model.duration == nil) && !self.isShowDistance {
                            isAllFieled = false
                        }
                        
//                        if (model.speed == "" || model.speed == nil) && self.isShowSpeed {
//                            isAllFieled = false
//                        }
//
//                        if (model.pace == "" || model.pace == nil) && !self.isShowSpeed {
//                            isAllFieled = false
//                        }
//
//                        if (model.rpm == "" || model.rpm == nil) && self.isShowRPM {
//                            isAllFieled = false
//                        }
//
//                        if (model.watt == "" || model.watt == nil) && !self.isShowRPM {
//                            isAllFieled = false
//                        }
//
//                        if model.lvl == "" || model.lvl == nil {
//                            isAllFieled = false
//                        }
//
//                       if model.rest == "" || model.rest == nil {
//                            isAllFieled = false
//                        }
                        
                    default:
                        
                       if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                        
                    }
                    
                    if !isAllFieled {
                        makeToast(strMessage: getCommonString(key: "Please_fill_all_details_key"))
                        return
                    }
                }
            }
            print("Done")
            
            let exerciseArray: NSMutableArray = arrayForExerciseAccordingToActivity()
            
              print("Exercise array : \(exerciseArray)")
            
            let txtName = view?.txtName.text ?? ""
            let txtNotes = view?.txtNotes.text ?? ""
            
            if targatHRId.contains("bpm"){
                self.targatHRId = self.targatHRId.replacingOccurrences(of: "bpm", with: "")
            }
            
            if self.isEdit {
                self.apiCallForUpdate(status: TRAINING_LOG_STATUS.CARDIO.rawValue, userId: (getUserDetail()?.data?.user?.id?.stringValue) ?? "", date: self.selectedDate, workoutName: txtName, trainingGoalId: trainingGoalId, trainingIntensityId: intensityId, trainingActivityId: activityId, targetedHr: targatHRId, notes: txtNotes, isSavedWorkout: isSavedWorkout, exercise: exerciseArray)
            }
            else {
                self.apiCall(status: TRAINING_LOG_STATUS.CARDIO.rawValue, userId: (getUserDetail()?.data?.user?.id?.stringValue) ?? "", date: self.selectedDate, workoutName: txtName, trainingGoalId: trainingGoalId, trainingIntensityId: intensityId, trainingActivityId: activityId, targetedHr: targatHRId, notes: txtNotes, isSavedWorkout: isSavedWorkout, exercise: exerciseArray)
            }
        }
    }
    
    func apiCall(status: String, userId: String, date: String, workoutName: String, trainingGoalId: String, trainingIntensityId: String, trainingActivityId: String, targetedHr: String, notes: String, isSavedWorkout: Bool, exercise: NSMutableArray) {
        let view = (self.theController.view as? CardioTrainingLogView)
        var param = ["status":TRAINING_LOG_STATUS.CARDIO.rawValue, "user_id": userId, "date": date, "workout_name" : workoutName, "training_goal_id" : trainingGoalId, "training_intensity_id" : trainingIntensityId, "training_activity_id": trainingActivityId, "targeted_hr": targetedHr, "notes": notes, "is_saved_workout": isSavedWorkout, "exercise":exercise, "training_goal_custom": view?.txtTrainingGoal.text?.toTrim() ?? "","training_goal_custom_id": trainingGoalId] as [String : Any]
        
        if self.isGoalCustom {
            param.removeValue(forKey: "training_goal_id")
        }
        else {
             param.removeValue(forKey: "training_goal_custom_id")
            
            if view?.txtActivity.text?.lowercased() != "Others".lowercased(){
                param.removeValue(forKey: "training_goal_custom")
            }
        }
        
        if view?.txtActivity.text?.lowercased() == "Swimming".lowercased(){
            param["training_log_style_id"] = selectedSwimmingStyle
        }
        
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CREATE_TRAINING_LOG, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let success = json.getBool(key: .success)
                if success {
                    if isSavedWorkout {
                        self.trainingId = "\(json.getDictionary(key: .data).getInt(key: .id))"
                        makeToast(strMessage: json.getString(key: .message))
                    }
                    else {
                        
                        self.theController.dismiss(animated: true, completion: nil)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
                    }
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    
    func arrayForExerciseAccordingToActivity() -> NSMutableArray {
        
         let view = (self.theController.view as? CardioTrainingLogView)
        
        let exerciseArray: NSMutableArray = NSMutableArray()

        for model in self.exercisesArray {
            
            let valueLaps = Int(model.laps!) ?? 0
            let valueDistance = model.distance?.toFloat() ?? 0
            let valueDuration = model.duration ?? ""
            let valueSpeed = model.speed?.toFloat() ?? 0
            let valuePace = model.pace ?? ""
            
            let valueRest = model.rest ?? ""
            let valueRPM = model.rpm == "" ? 0 : Int(model.rpm ?? "0") ?? 0
            let valueWatt = model.watt == "" ? 0 : Int(model.watt ?? "0") ?? 0
            
            //New
            var ValueLvl : Int = 0
            var valuePercentage : CGFloat = 0.0
            
            if model.percentage == ""{
                if view?.txtActivity.text?.toTrim().lowercased() == "Run (Outdoor)".lowercased(){
                    
                    if self.selectedTrainingGoalName.lowercased() == "Hill Run".lowercased() {
                        valuePercentage = 3.0
                    }else{
                        valuePercentage = 1.0
                    }
                    
                }else if view?.txtActivity.text?.toTrim().lowercased() == "Run (Indoor)".lowercased(){
                    
                    if self.selectedTrainingGoalName.lowercased() == "Hill Run".lowercased() {
                        valuePercentage = 3.0
                    }else{
                        valuePercentage = 0.0
                    }
                }
                else{
                    valuePercentage = 0.0
                }
            }else{
                valuePercentage = model.percentage?.toFloat() ?? 0.0
            }
            
            if model.lvl == ""{
                if view?.txtActivity.text?.toTrim().lowercased() == "Cycling (Indoor)".lowercased(){
                    ValueLvl = 1
                }else{
                    ValueLvl = 0
                }
            }else{
                ValueLvl = Int(model.lvl ?? "0") ?? 0
            }
            
            
            print("value Percentage:\(valuePercentage)")
            
            switch view?.txtActivity.text?.toTrim().lowercased(){
                
            case "Run (Outdoor)".lowercased():
                let dict: NSDictionary = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "percentage": valuePercentage, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "is_completed": false]
                exerciseArray.add(dict)
                
            case "Run (Indoor)".lowercased():
                let dict: NSDictionary = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "percentage": valuePercentage, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "is_completed": false]
                exerciseArray.add(dict)
                
            case "Cycling (Indoor)".lowercased():
                let dict: NSDictionary = ["laps": valueLaps, "speed": valueSpeed, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm": valueRPM, "watt": valueWatt, "lvl" : ValueLvl, "is_completed": false]
                exerciseArray.add(dict)
                
            case "Cycling (Outdoor)".lowercased():
                let dict: NSDictionary = ["laps": valueLaps, "speed": valueSpeed, "duration": valueDuration, "distance": valueDistance,"percentage": valuePercentage, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt, "is_completed": false]
                exerciseArray.add(dict)
                
            case "Swimming".lowercased():
               let dict: NSDictionary = ["laps": valueLaps, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "is_completed": false]
                exerciseArray.add(dict)
                
            case "Others".lowercased():
                
                let dict: NSDictionary = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt, "lvl" : ValueLvl, "is_completed": false,"is_speed":isShowSpeed]
                exerciseArray.add(dict)
            default:
               let dict: NSDictionary = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt, "lvl" : ValueLvl, "is_completed": false]
                exerciseArray.add(dict)
                
            }
            
        }
        
        return exerciseArray
    }
    
    func setDataEditTimeAccordingToActivity(){
        
         let view = (self.theController.view as? CardioTrainingLogView)
        
        for model in (self.previewData?.exercise)!{
            
            let valueLaps = "\(model.laps!)"
            let valueDistance = "\(model.distance ?? 0.0)"
            let valueDuration = model.duration ?? ""
            let valueSpeed = "\(model.speed ?? 0.0)"
            let valuePace = model.pace ?? ""
            let valuePercentage = "\(model.percentage ?? 0.0)"
            let valueRest = model.rest ?? ""
            let valueRPM = "\(model.rpm ?? 0)"
            let valueWatt = "\(model.watt ?? 0)"
            let ValueLvl = "\(model.lvl ?? 0)"
            
            switch view?.txtActivity.text?.toTrim().lowercased(){
                
            case "Run (Outdoor)".lowercased():
                let dict : NSDictionary = ["laps": valueLaps, "speed": valueSpeed , "pace": valuePace, "percentage": valuePercentage, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "is_completed": false]
                
                 let exercises = CardioExerciseModelClass(JSON: JSON(dict).dictionaryObject!)
                self.exercisesArray.append(exercises!)
                
            case "Run (Indoor)".lowercased():
                let dict : NSDictionary = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "percentage": valuePercentage, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "is_completed": false]
                 let exercises = CardioExerciseModelClass(JSON: JSON(dict).dictionaryObject!)
                self.exercisesArray.append(exercises!)
                
            case "Cycling (Indoor)".lowercased():
                let dict : NSDictionary = ["laps": valueLaps, "speed": valueSpeed, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm": valueRPM, "watt": valueWatt, "lvl" : ValueLvl, "is_completed": false]
                
                let exercises = CardioExerciseModelClass(JSON: JSON(dict).dictionaryObject!)
                self.exercisesArray.append(exercises!)
                
            case "Cycling (Outdoor)".lowercased():
                let dict : NSDictionary = ["laps": valueLaps, "speed": valueSpeed, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt,"percentage": valuePercentage,  "is_completed": false]
                 let exercises = CardioExerciseModelClass(JSON: JSON(dict).dictionaryObject!)
                self.exercisesArray.append(exercises!)
                
            case "Swimming".lowercased():
                let dict : NSDictionary = ["laps": valueLaps, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "is_completed": false]
                 let exercises = CardioExerciseModelClass(JSON: JSON(dict).dictionaryObject!)
                self.exercisesArray.append(exercises!)
                
            case "Others".lowercased():
                
                let dict : NSDictionary = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt, "lvl" : ValueLvl, "is_completed": false,"is_speed":isShowSpeed]
                 let exercises = CardioExerciseModelClass(JSON: JSON(dict).dictionaryObject!)
                self.exercisesArray.append(exercises!)
                
            default:
                let dict = ["laps": valueLaps, "speed": valueSpeed, "pace": valuePace, "duration": valueDuration, "distance": valueDistance, "rest": valueRest, "rpm":valueRPM, "watt": valueWatt, "lvl" : ValueLvl, "is_completed": false] as [String : Any]
                 let exercises = CardioExerciseModelClass(JSON: JSON(dict).dictionaryObject!)
               self.exercisesArray.append(exercises!)
                
            }
            
        }
        
    }
    
    
    func apiCallForUpdate(status: String, userId: String, date: String, workoutName: String, trainingGoalId: String, trainingIntensityId: String, trainingActivityId: String, targetedHr: String, notes: String, isSavedWorkout: Bool, exercise: NSMutableArray) {
        let view = (self.theController.view as? CardioTrainingLogView)
        var param = ["status":TRAINING_LOG_STATUS.CARDIO.rawValue, "user_id": userId, "date": date, "workout_name" : workoutName, "training_goal_id" : trainingGoalId, "training_intensity_id" : trainingIntensityId, "training_activity_id": trainingActivityId, "targeted_hr": targetedHr, "notes": notes, "is_saved_workout": isSavedWorkout, "exercise":exercise, "training_goal_custom": view?.txtTrainingGoal.text?.toTrim() ?? "","training_goal_custom_id": trainingGoalId] as [String : Any]
        
        //TODO: - yash comments old
        /*if self.isGoalCustom {
            param.removeValue(forKey: "training_goal_id")
        }
        else {
            param.removeValue(forKey: "training_goal_custom")
        }*/
        
        //New set
        if self.isGoalCustom {
           // param.removeValue(forKey: "training_goal_id")
            param["training_goal_id"] = 0
        }
        else {
          //  param.removeValue(forKey: "training_goal_custom_id")
            param["training_goal_custom_id"] = 0
            
            if view?.txtActivity.text?.lowercased() != "Others".lowercased(){
                param.removeValue(forKey: "training_goal_custom")
            }
        }
        
        if view?.txtActivity.text?.lowercased() == "Swimming".lowercased(){
            param["training_log_style_id"] = selectedSwimmingStyle
        }
        
        print(JSON(param))
        
        ApiManager.shared.MakePutAPI(name: TRAINING_LOG_UPDATE + "/" + self.trainingId, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let data = json.getDictionary(key: .data)
                print(data)
                let model = TrainingLogModelClass(JSON: data.dictionaryObject!)
                
                self.theController.dismiss(animated: true, completion: nil)
                let dataDict:[String: TrainingLogModelClass] = ["data": model!]
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CARDIO_NOTIFICATION.rawValue), object: nil, userInfo: dataDict)
            }
        }
    }
    
    func apiCallSaveIsLogFlag() {
        let param = ["":""]
        
        ApiManager.shared.MakeGetAPI(name: SAVE_IS_LOG_FLAG + "/" + self.trainingId, params: param, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let data = json.getDictionary(key: .data)
                let model = TrainingLogModelClass(JSON: data.dictionaryValue)
                
                let obj: LogPreviewVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "LogPreviewVC") as! LogPreviewVC
                obj.mainModelView.delegate = self
                obj.mainModelView.previewData = model
                let nav = UINavigationController(rootViewController: obj)
                nav.modalPresentationStyle = .overCurrentContext
                self.theController.present(nav, animated: true, completion: nil)
            }
        })
    }
    
    func showTargetHr(hr: String,activityID:String) -> String {
        print(hr)
        let dataArray = hr.split(separator: "-")
        if dataArray.count == 2 {
            
            print("HRMax :\(self.HRMaxValue)")
            
            let hrMax = self.HRMaxValue
                
//                (getUserDetail().data?.user?.dateOfBirth ?? "") == "" ? "0" : self.getHRMax(date: getUserDetail().data?.user?.dateOfBirth ?? "")
            
            var no1 : Double = 0.0
            var no2 : Double = 0.0
            
            if activityID == "1" || activityID == "12"{
                no1 = (Double(hrMax)) * (Double(dataArray[0]) ?? 0) / 100
                no2 = (Double(hrMax)) * (Double(dataArray[1]) ?? 0) / 100
            }else if activityID == "2" || activityID == "4" || activityID == "13"{
                
                let minusValue = ((Double(hrMax)) - ((Double(hrMax) ?? 0) * 0.05))
                no1 = minusValue * (Double(dataArray[0]) ?? 0) / 100
                no2 = minusValue * (Double(dataArray[1]) ?? 0) / 100
            }else if activityID == "3"{
                no1 = ((Double(hrMax)) - 12) * (Double(dataArray[0]) ?? 0) / 100
                no2 = ((Double(hrMax)) - 12) * (Double(dataArray[1]) ?? 0) / 100
            }
            
            print(no1)
            print(no2)
            let final1 = "\(no1.rounded(toPlaces:0))".replace(target: ".0", withString: "")
            let final2 = "\(no2.rounded(toPlaces: 0))".replace(target: ".0", withString: "")
            
            let final = "\(final1) - \(final2)"
            print(final)
            return final
        }
        else {
            let hrMax = self.HRMaxValue
//                (getUserDetail().data?.user?.dateOfBirth ?? "") == "" ? "0" : self.getHRMax(date: getUserDetail().data?.user?.dateOfBirth ?? "")
            let no1 = (Double(hrMax)) * (Double(hr == "" ? "0" : hr) ?? 0) / 100
            print(no1)
            let final1 = "\(no1.rounded(toPlaces: 1))".replace(target: ".0", withString: "")
            let final = "\(final1)"
            return final
        }
    }
    
    func getHRMax(date:String) -> String {
        let now = Date().toString(dateFormat: "yyyy")
        let birthday: String = convertDateFormater(date, format: "dd-MM-yyyy", dateFormat: "yyyy")
        let age = Int(now)! - Int(birthday)!
        let value = Int(206.9 - (0.67 * Double(age)))
        return "\(value)".replace(target: ".00", withString: "")
    }
    
    func getHRList() -> [String] {
        return [self.targatHR, "Customize"]
    }
    
    func showExerciseHeader() {
        let view = (self.theController.view as? CardioTrainingLogView)
//        if self.activityId == "1" {
//            view?.viewRPM.isHidden = true
//            view?.viewPercentage.isHidden = false
//        }
//        else if self.activityId == "2" || self.activityId == "13" {
//            view?.viewRPM.isHidden = false
//            view?.viewPercentage.isHidden = false
//        }
//        else if self.activityId == "3" {
//            view?.viewPercentage.isHidden = false //true
//            view?.viewRPM.isHidden = true
//        }
//        else {
//            view?.viewRPM.isHidden = true
//            view?.viewPercentage.isHidden = false           
//        }
        view?.tableViewHeight.constant = 0
    }
    
    func DismissPreviewDidFinish() {
        self.theController.dismiss(animated: false, completion: nil)
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
    
    func showDistance(isShow:Bool = true) {
        let view = (self.theController.view as? CardioTrainingLogView)
        if isShow {
            view?.lblDuration.text = "Distance"
            view?.imgDurationArrow.image = UIImage(named: "ic_dropdown_black")
        }
        else {
            view?.lblDuration.text = "Duration"
            view?.imgDurationArrow.image = UIImage(named: "ic_up_black")
        }
        
        for (index, _) in self.exercisesArray.enumerated() {
            self.exercisesArray[index].duration = ""
            self.exercisesArray[index].distance = ""
        }
        view?.tableView.reloadData()
    }
    
    func showSpeed(isShow:Bool = true) {
        let view = (self.theController.view as? CardioTrainingLogView)
        if isShow {
            view?.lblSpeed.text = "Speed"
            view?.imgSpeedArrow.image = UIImage(named: "ic_up_black")
        }
        else {
            view?.lblSpeed.text = "Pace"
            view?.imgSpeedArrow.image = UIImage(named: "ic_dropdown_black")
        }
        for (index, _) in self.exercisesArray.enumerated() {
            self.exercisesArray[index].speed = ""
            self.exercisesArray[index].pace = ""
        }
        view?.tableView.reloadData()
    }
    
    func showRPM(isShow:Bool = true) {
        let view = (self.theController.view as? CardioTrainingLogView)
        if isShow {
            view?.lblRPM.text = "RPM"
            view?.imgRPMArrow.image = UIImage(named: "ic_dropdown_black")
        }
        else {
            view?.lblRPM.text = "Watt"
            view?.imgRPMArrow.image = UIImage(named: "ic_up_black")
        }
        for (index, _) in self.exercisesArray.enumerated() {
            self.exercisesArray[index].rpm = ""
            self.exercisesArray[index].watt = ""
        }
        view?.tableView.reloadData()
    }
    
    //MARK:- ActionSheet
    func showActionSheet(row:Int) {
        let actionSheet = UIAlertController(title: "Set Number \(row + 1)", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Remove Set", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.exercisesArray.remove(at: row)
            let view = (self.theController.view as? CardioTrainingLogView)
            view?.tableViewHeight.constant = CGFloat((self.exercisesArray.count * 70) + 0) //70
            view?.tableView.reloadData()
            view?.lblLapsTitle.text = self.getTotalLaps(total: self.exercisesArray.count)
            
            //Check userinteraction set or not
            self.theController.changeColorAccordingToClickable()

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Rearrange Set", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            let view = (self.theController.view as? CardioTrainingLogView)
            view?.tableView.isEditing = true
            view?.tableView.reloadData()            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.theController.present(actionSheet, animated: true, completion: nil)
    }
}
