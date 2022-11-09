//
//  ResistanceTrainingLogViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import IQKeyboardManagerSwift

class ResistanceTrainingLogViewModel: DismissPreviewDelegate {
    
    fileprivate weak var theController:ResistanceTrainingLogVC!
    let intensityPickerView = UIPickerView()
    let trainingGoalPickerView = UIPickerView()
    var exercisesMainArray:[LibraryLogList] = [LibraryLogList]()
    var previewData: TrainingLogResistanceModelClass?

    var intensityId:String = ""
    var trainingGoalId:String = ""
    var selectedDate:String = ""
    var trainingId:String = ""
    var isEdit:Bool = false
    var isEditRow:Int?
    var isGoalCustom:Bool = false
    var resistanceValidationList: [ResistanceValidationListData] = []
    var selectedResistanceValidationList: ResistanceValidationListData?
    var isSelectedDuration:[Bool] = []
    var isShowDropdown:Bool = true
    var selectedDateFromCalendar = ""

    init(theController:ResistanceTrainingLogVC) {
        self.theController = theController
    }

    func setupUI() {
        self.DOBSetup()
        self.showCurrentDate()  
        intensityPickerView.delegate = theController
        intensityPickerView.backgroundColor = UIColor.white
        let view = (self.theController.view as? ResistanceTrainingLogView)
        view?.txtIntensity.inputView = intensityPickerView
        self.apiCallGetValidation()
        self.setTrainingGoal()
        
        if self.isEdit {
            self.setupEditData()
        }
    }
    
    func resetSelectedDuration() {
        let view = (self.theController.view as? ResistanceTrainingLogView)
        for i in 0..<self.isSelectedDuration.count {
            if view?.txtTrainingGoal.text?.lowercased() == "Muscular Endurance (Long)".lowercased() {
                self.isSelectedDuration[i] = true
            }
            else {
                self.isSelectedDuration[i] = false
            }
        }
    }
    
    func setTrainingGoal(isSet:Bool = true) {
        let view = (self.theController.view as? ResistanceTrainingLogView)
        view?.txtTrainingGoal.delegate = theController
        if isSet {
            trainingGoalPickerView.delegate = theController
            trainingGoalPickerView.backgroundColor = UIColor.white
            view?.txtTrainingGoal.inputView = trainingGoalPickerView
            view?.txtTrainingGoal.placeholder = getCommonString(key: "Select_your_goal_key")
        }
        else {
            view?.txtTrainingGoal.placeholder = ""
            view?.txtTrainingGoal.inputView = nil
            view?.txtTrainingGoal.becomeFirstResponder()
        }
    }
    
    func getValicationFromId() {
        let filter = self.resistanceValidationList.filter { (model) -> Bool in
            
            return model.trainingIntensityId?.stringValue == self.intensityId && model.trainingGoalId?.stringValue == self.trainingGoalId
        }
        self.selectedResistanceValidationList = filter.first
        
        if let view = (self.theController.view as? ResistanceTrainingLogView){
            view.tableView.reloadData()
        }
    }
    
    func setupEditData() {
        let view = (self.theController.view as? ResistanceTrainingLogView)!
        view.txtWhen.text = convertDateFormater((self.previewData?.date)!, dateFormat: "EEEE, dd MMM yyyy 'at' HH:mm a")
        
        let trainigGoalCustom = self.previewData?.trainingGoalCustom
        view.txtTrainingGoal.text = self.previewData?.trainingGoal?.name ?? trainigGoalCustom
        view.txtIntensity.text = self.previewData?.trainingIntensity?.name
        view.txtName.text = self.previewData?.workoutName
        view.txtNotes.text = self.previewData?.notes ?? ""
        
        if self.previewData?.trainingGoalId?.stringValue == "" || self.previewData?.trainingGoalId?.stringValue == nil || self.previewData?.trainingGoalId?.stringValue == "0"{
            
            self.trainingGoalId = String(self.previewData!.trainingGoalCustomId)
            self.isGoalCustom = true
            self.isShowDropdown = true

        }else{
            self.trainingGoalId = self.previewData?.trainingGoalId?.stringValue ?? ""
            self.isGoalCustom = false
            if self.previewData?.trainingGoal?.name?.lowercased() == "Muscular Endurance (Medium)".lowercased() || self.previewData?.trainingGoal?.name?.lowercased() == "Muscular Endurance (Short)".lowercased() || self.previewData?.trainingGoal?.name?.lowercased() == "customize".lowercased() {
                self.isShowDropdown = true
            }else{
                self.isShowDropdown = false
            }
        }

        self.intensityId = "\(self.previewData?.trainingIntensityId ?? 0)"
        self.trainingId = self.previewData?.id?.stringValue ?? ""
        self.selectedDate = self.previewData?.date ?? ""
        
        print(self.intensityId)
        print(self.trainingGoalId)
        for exerciseData in self.previewData?.exercise ?? [] {
            
            print("ExerciseData:\(exerciseData.toJSON())")
            
            let dict: NSDictionary = ["exercise_name":exerciseData.name!, "Mechanics": "","selected": true,"is_edit" : true,"library_id": exerciseData.libraryId,"common_library_id": exerciseData.commonLibraryId, "exercise_link": exerciseData.exerciseLink]
            self.isSelectedDuration.append(exerciseData.data?.first?.reps != nil &&  exerciseData.data?.first?.reps != "" ? false : true)

            let exercises = LibraryLogList(JSON: JSON(dict).dictionaryObject!)
            var exercisesArray:[ResistanceExerciseModelClass] = [ResistanceExerciseModelClass]()
            
            for exerciseDataSub in exerciseData.data ?? [] {
                let dictSub: NSDictionary = ["Weight":exerciseDataSub.weight ?? "", "Reps": exerciseDataSub.reps ?? "","duration": exerciseDataSub.duration ?? "", "Rest": exerciseDataSub.rest ?? "", "is_completed": exerciseDataSub.isCompleted ?? ""]
                
                let exercisesSub = ResistanceExerciseModelClass(JSON: JSON(dictSub).dictionaryObject!)
                exercisesArray.append(exercisesSub!)
            }
            exercises?.exercisesArray = exercisesArray
            exercises?.repetitionMax = exerciseData.repetitionMax
            self.exercisesMainArray.append(exercises!)
        }
        print(self.isSelectedDuration)
        var count:Int = 0
        for (index, _) in self.exercisesMainArray.enumerated() {
            count += self.exercisesMainArray[index].exercisesArray.count
        }
        
        self.theController.changeColorAccordingToClickable()
        
//        view.btnLogIt.backgroundColor = UIColor.appthemeRedColor
//        view.btnLogIt.isUserInteractionEnabled = true

        self.getValicationFromId()
        view.tableViewHeight.constant = CGFloat((self.exercisesMainArray.count * 127) + (count * 73))
        view.tableView.reloadData()
    }
    
    func showCustomTrainingGoal(isShow:Bool = true) {
        let view = (self.theController.view as? ResistanceTrainingLogView)
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
    
    func DOBSetup() {
        let view = (self.theController.view as? ResistanceTrainingLogView)

        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
            //datePickerView.setValue(UIColor.clear, forKey: "magnifierLineColor")
            datePickerView.setValue(false, forKey: "highlightsToday")
        }
        datePickerView.backgroundColor = UIColor.white
        
        datePickerView.setValue(UIColor.appthemeOffRedColor, forKeyPath: "textColor")
       
        if self.selectedDateFromCalendar == ""{
            datePickerView.setDate(Date(), animated: false)
        }else{
//            let convertToDate = convertDate(self.selectedDateFromCalendar, dateFormat:  "yyyy-MM-dd")
//            print("convertToDate:\(convertToDate)")
            
            let convertToTime = DateToString(Formatter: "hh:mm a", date: Date())
            print("convertToTime: \(convertToTime)")
            
            let stringFullDate = self.selectedDateFromCalendar + " " + convertToTime
            print("stringFullDate: \(stringFullDate)")
            
            let convertToDate = convertDate(stringFullDate, dateFormat:  "yyyy-MM-dd hh:mm a")
            print("convertToDate:\(convertToDate)")

            datePickerView.setDate(convertToDate, animated: false)
        }
        
        view?.txtWhen.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let view = (self.theController.view as? ResistanceTrainingLogView)

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateFormatter.dateFormat = "EEEE, dd MMM yyyy 'at' hh:mm a"
        view?.txtWhen.text = dateFormatter.string(from: sender.date)
        self.selectedDate = DateToString(Formatter: "yyyy-MM-dd HH:mm:ss", date: sender.date)
    }
    
    func showCurrentDate() {
        let view = (self.theController.view as? ResistanceTrainingLogView)
        
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
    
    func ValidateDetailsForShare() -> Bool {
        let view = (self.theController.view as? ResistanceTrainingLogView)
        if view?.txtWhen.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_date_key"))
        }
        else if view?.txtTrainingGoal.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_training_goal_key"))
        }
        else if view?.txtIntensity.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_intensity_key"))
        }
        else if view?.txtName.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_name_key"))
        }
        else if exercisesMainArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_add_some_exercise_key"))
        }
        else {
            return true
        }
        return false
    }
    
    func shareFriend(toId:String) {
        let view = (self.theController.view as? ResistanceTrainingLogView)
        for (index, model) in exercisesMainArray.enumerated() {
            for modelValue in model.exercisesArray {
                if modelValue.weight == "" || modelValue.weight == nil {
                    makeToast(strMessage: getCommonString(key: "Select_weight_key"))
                    return
                }
                else if (modelValue.reps == "" || modelValue.reps == nil) && (modelValue.duration == "" || modelValue.duration == nil){
                    if self.isSelectedDuration[index] {
                        makeToast(strMessage: getCommonString(key: "Select_duration_key"))
                    }
                    else {
                        makeToast(strMessage: getCommonString(key: "Select_reps_key"))
                    }
                    return
                }
                else if modelValue.rest == "" || modelValue.rest == nil {
                    makeToast(strMessage: getCommonString(key: "Select_rest_key"))
                    return
                }
            }
        }
        
        let exerciseArray: NSMutableArray = NSMutableArray()
        for model in exercisesMainArray {
            let exerciseSubArray: NSMutableArray = NSMutableArray()
            
            for modelValue in model.exercisesArray {
                
                let dict: NSDictionary = ["weight" : modelValue.weight!, "reps" : modelValue.reps!, "duration" : modelValue.duration!, "rest" : modelValue.rest!, "is_completed": false]
                exerciseSubArray.add(dict)
            }
            let dict: NSDictionary = ["name": model.exerciseName!, "data": exerciseSubArray, "is_completed": false, "library_id": model.userId == nil ? 0 : model.id ?? 0, "common_library_id": model.userId == nil ? model.id ?? 0 : 0]
            exerciseArray.add(dict)
        }
        
        let txtName = view?.txtName.text ?? ""
        let txtNotes = view?.txtNotes.text ?? ""

        self.apiCallShareFriend(status: TRAINING_LOG_STATUS.RESISTANCE.rawValue, userId: (getUserDetail()?.data?.user?.id?.stringValue) ?? "", date:  self.selectedDate, workoutName: txtName, trainingGoalId: trainingGoalId, trainingIntensityId: intensityId, isSavedWorkout: true, exercise: exerciseArray, toId: toId, notes: txtNotes)
    }
    
    func apiCallShareFriend(status: String, userId: String, date: String, workoutName: String, trainingGoalId: String, trainingIntensityId: String, isSavedWorkout: Bool, exercise: NSMutableArray, toId:String, notes: String) {
        let view = (self.theController.view as? ResistanceTrainingLogView)

        var param = ["status":status, "user_id": userId, "date": date, "workout_name" : workoutName, "training_goal_id" : trainingGoalId, "training_intensity_id" : trainingIntensityId, "is_saved_workout": isSavedWorkout, "exercise":exercise, "training_goal_custom_id" : trainingGoalId, "training_goal_custom": view?.txtTrainingGoal.text?.toTrim() ?? "", "notes": notes] as [String : Any]
        
        if self.isGoalCustom {
            param.removeValue(forKey: "training_goal_id")
        }
        else {
            param.removeValue(forKey: "training_goal_custom_id")
            param.removeValue(forKey: "training_goal_custom")
        }
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CREATE_TRAINING_LOG, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                self.trainingId = "\(json.getDictionary(key: .data).getInt(key: .id))"
                SocketIOHandler.shared.shareFriendTrainingLog(toIds: [Int(toId)!], trainingLogId: Int(self.trainingId)!)
            }
        }
    }
    
    func ValidateDetails(isSavedWorkout:Bool = false) {
        let view = (self.theController.view as? ResistanceTrainingLogView)
        
         if view?.txtWhen.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_date_key"))
        }
        else if view?.txtName.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_name_key"))
        }
        else if view?.txtIntensity.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_intensity_key"))
        }
        else if view?.txtTrainingGoal.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_training_goal_key"))
        }
//        else if view?.viewCustomTrainingGoal.isHidden == false {
//            makeToast(strMessage: getCommonString(key: "Please_enter_custom_training_goal_key"))
//        }
        else if exercisesMainArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_add_some_exercise_key"))
        }
        else {
            for (index, model) in exercisesMainArray.enumerated() {
                for modelValue in model.exercisesArray {
                    if modelValue.weight == "" || modelValue.weight == nil {
                        makeToast(strMessage: getCommonString(key: "Select_weight_key"))
                        return
                    }
                    else if (modelValue.reps == "" || modelValue.reps == nil) && (modelValue.duration == "" || modelValue.duration == nil){
                        if self.isSelectedDuration[index] {
                            makeToast(strMessage: getCommonString(key: "Select_duration_key"))
                        }
                        else {
                            makeToast(strMessage: getCommonString(key: "Select_reps_key"))
                        }
                        return
                    }
                    else if modelValue.rest == "" || modelValue.rest == nil {
                        makeToast(strMessage: getCommonString(key: "Select_rest_key"))
                        return
                    }
                }
            }
        
            let exerciseArray: NSMutableArray = NSMutableArray()
            for model in exercisesMainArray {
                let exerciseSubArray: NSMutableArray = NSMutableArray()

                for modelValue in model.exercisesArray {
                    let dict: NSDictionary = ["weight" : modelValue.weight ?? "", "rest" : modelValue.rest ?? "", "reps" : modelValue.reps ?? "", "duration" : modelValue.duration ?? "", "is_completed": false]
                    exerciseSubArray.add(dict)
                }
                
                var dict: NSDictionary = NSDictionary()
                
                if isEdit{
                    
                    if model.isEdit{
                        dict = ["name": model.exerciseName ?? "", "data": exerciseSubArray, "is_completed": false, "library_id": model.libraryId == 0 ? 0 : model.libraryId , "common_library_id": model.commonLibraryId == 0 ? 0 : model.commonLibraryId, "exercise_link": model.exerciseLink ?? ""]
                    }else{
                        dict = ["name": model.exerciseName ?? "", "data": exerciseSubArray, "is_completed": false, "library_id": model.userId == nil ? 0 : model.id ?? 0, "common_library_id": model.userId == nil ? model.id ?? 0 : 0, "exercise_link": model.exerciseLink ?? ""]
                    }
                    
                }else{
                    dict = ["name": model.exerciseName ?? "", "data": exerciseSubArray, "is_completed": false, "library_id": model.userId == nil ? 0 : model.id ?? 0, "common_library_id": model.userId == nil ? model.id ?? 0 : 0, "exercise_link": model.exerciseLink ?? ""]
                }
                
                exerciseArray.add(dict)
                
            }
            print(exerciseArray)
            let txtName = view?.txtName.text ?? ""
            let txtNotes = view?.txtNotes.text ?? ""

            if self.isEdit {
                self.apiCallForUpdate(status: TRAINING_LOG_STATUS.RESISTANCE.rawValue, userId: (getUserDetail()?.data?.user?.id?.stringValue) ?? "", date:  self.selectedDate, workoutName: txtName, trainingGoalId: trainingGoalId, trainingIntensityId: intensityId, isSavedWorkout: isSavedWorkout, exercise: exerciseArray, notes: txtNotes)
            }
            else {
                self.apiCall(status: TRAINING_LOG_STATUS.RESISTANCE.rawValue, userId: (getUserDetail()?.data?.user?.id?.stringValue) ?? "", date:  self.selectedDate, workoutName: txtName, trainingGoalId: trainingGoalId, trainingIntensityId: intensityId, isSavedWorkout: isSavedWorkout, exercise: exerciseArray, notes: txtNotes)
            }
        }
    }
    
    func apiCallGetValidation() {
        let param = ["is_active": true,
                     "relation": [
                        "training_intensity_detail",
                        "training_goal_detail"
            ],
//                     "list": [
//                        "id",
//                        "training_intensity_id",
//                        "training_goal_id",
//                        "weight_range",
//                        "reps_range",
//                        "reps_time_range",
//                        "rest_range",
//                        "is_active"
//            ],
                     "training_intensity_detail_list": [
                        "id",
                        "name",
                        "is_active"
            ],
                     "training_goal_detail_list": [
                        "id",
                        "name",
                        "display_at",
                        "is_active"
            ]
        ] as [String : Any]
        
        print(JSON(param))
        ApiManager.shared.MakeGetAPI(name: LOG_RESISTANCE_VALIDATION_LIST, params: param as [String : Any], progress: false, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let model = ResistanceValidationList(JSON: json.dictionaryObject!)
                self.resistanceValidationList = model?.data ?? []
                self.getValicationFromId()
                let view = (self.theController.view as? ResistanceTrainingLogView)
                view?.tableView.reloadData()
            }
        }
    }
    
    func apiCall(status: String, userId: String, date: String, workoutName: String, trainingGoalId: String, trainingIntensityId: String, isSavedWorkout: Bool, exercise: NSMutableArray, notes :String) {
        let view = (self.theController.view as? ResistanceTrainingLogView)

        var param = ["status":status, "user_id": userId, "date": date, "workout_name" : workoutName, "training_goal_id" : trainingGoalId, "training_intensity_id" : trainingIntensityId, "is_saved_workout": isSavedWorkout, "exercise":exercise, "training_goal_custom_id" : trainingGoalId, "training_goal_custom": view?.txtTrainingGoal.text?.toTrim() ?? "", "notes": notes] as [String : Any]
        
        if self.isGoalCustom {
            param.removeValue(forKey: "training_goal_id")
        }
        else {
            param.removeValue(forKey: "training_goal_custom_id")
            param.removeValue(forKey: "training_goal_custom")
        }
                
        print(JSON(param))
        ApiManager.shared.MakePostAPI(name: CREATE_TRAINING_LOG, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let data = json.getDictionary(key: .data)
                _ = TrainingLogResistanceModelClass(JSON: data.dictionaryObject!)
                if isSavedWorkout {
                    self.trainingId = "\(json.getDictionary(key: .data).getInt(key: .id))"
                    makeToast(strMessage: json.getString(key: .message))
                }
                else {
                    
                    self.theController.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
                    
                    //Old flow
                    /*
                    let obj: LogPreviewResistanceVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "LogPreviewResistanceVC") as! LogPreviewResistanceVC
                    obj.mainModelView.previewData = model
                    obj.mainModelView.delegate = self
                    let nav = UINavigationController(rootViewController: obj)
                    nav.modalPresentationStyle = .overCurrentContext
                    self.theController.present(nav, animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)*/
                }
            }
        }
    }
    
    func apiCallForUpdate(status: String, userId: String, date: String, workoutName: String, trainingGoalId: String, trainingIntensityId: String, isSavedWorkout: Bool, exercise: NSMutableArray, notes: String) {
        let view = (self.theController.view as? ResistanceTrainingLogView)

        let trainingGoalCustomId: String = trainingGoalId
        var trainingGoalIdRemoved: String? = trainingGoalId
        var trainingGoalCustom: String = view?.txtTrainingGoal.text?.toTrim() ?? ""

        if self.isGoalCustom {
            trainingGoalIdRemoved = nil
        }
        else {
            trainingGoalCustom = ""
        }
        
        let param = ["status":status, "user_id": userId, "date": date, "workout_name" : workoutName, "training_goal_id" : trainingGoalIdRemoved, "training_intensity_id" : trainingIntensityId, "is_saved_workout": isSavedWorkout, "exercise":exercise, "training_goal_custom_id" : trainingGoalCustomId, "training_goal_custom": trainingGoalCustom, "notes": notes] as [String : Any]
        
//        if self.isGoalCustom {
//            param.removeValue(forKey: "training_goal_id")
//        }
//        else {
//            param.removeValue(forKey: "training_goal_custom_id")
//            param.removeValue(forKey: "training_goal_custom")
//        }
        print(JSON(param))

        ApiManager.shared.MakePutAPI(name: TRAINING_LOG_UPDATE + "/" + self.trainingId, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let data = json.getDictionary(key: .data)
                print(data)
                let model = TrainingLogResistanceModelClass(JSON: data.dictionaryObject!)
                
                self.theController.dismiss(animated: true, completion: nil)
                let dataDict:[String: TrainingLogResistanceModelClass] = ["data": model!]

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.RESISTANCE_NOTIFICATION.rawValue), object: nil, userInfo: dataDict)
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
                let model = TrainingLogResistanceModelClass(JSON: data.dictionaryObject!)

                let obj: LogPreviewResistanceVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "LogPreviewResistanceVC") as! LogPreviewResistanceVC
                obj.mainModelView.previewData = model
                obj.mainModelView.delegate = self
                let nav = UINavigationController(rootViewController: obj)
                nav.modalPresentationStyle = .overCurrentContext
                self.theController.present(nav, animated: true, completion: nil)
            }
        })
    }
    
    func DismissPreviewDidFinish() {
        self.theController.dismiss(animated: false, completion: nil)
    }
    
    func getTrainingGoal() -> [TrainingGoalLogResistance] {
        let filter = GetAllData?.data?.trainingGoalLogResistance?.filter({ (model) -> Bool in
            return model.trainingIntensityIds?.contains(self.intensityId) ?? false
        })
//        let json = JSON([ "target_hr" : "0", "is_active" : true, "training_intensity_ids" : [], "code" : "CUSTOMIZE", "updated_at" : "2019-09-28 01:16:45", "display_at" : [ "LOG_CARDIO", "LOG_RESISTANCE", "PROGRAM_CARDIO", "PROGRAM_RESISTANCE" ], "id" : 0, "created_at" : "2019-05-29 13:00:00", "sequence" : 0, "name" : "Customize"])
//        filter?.append(TrainingGoalLogResistance(JSON: json.dictionaryObject!)!)
        return filter ?? []
    }
    
    func apiCallUpdateLibraryAfterAlert(id:String, repetitionMax: NSMutableArray,isMsgShowAgain:Bool,userId:Int,atIndex : Int) {
        
        var param = [
            "repetition_max": repetitionMax,
            "is_show_again_message" : isMsgShowAgain
            ] as [String : Any]
        
        if userId == 0{
            param["common_libraries_id"] = Int(id)
        }else{
            param["libraries_id"] = Int(id)
        }
        
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CREATE_UPDATE_COMMON_LIBRARY_DETAILS, params: param as [String : Any],progress: false, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                let message = json.getString(key: .message)
                 let data = json.getDictionary(key: .data)
                
                let model = CommonRepetitionMax(JSON: data.dictionaryObject!)
                
                if success {
                    
                    print("index : \(atIndex)")
                    
                    self.exercisesMainArray[atIndex].isShowAlertOrNot = isMsgShowAgain
                    self.exercisesMainArray[atIndex].repetitionMax = model?.repetitionMax
                }
                else {
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    
    //MARK:- ActionSheet
    func showActionSheet(row:Int, section:Int) {
        let actionSheet = UIAlertController(title: "Set Number \(row + 1)", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Remove Set", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.exercisesMainArray[section].exercisesArray.remove(at: row)
            var count:Int = 0
            for (index, _) in self.exercisesMainArray.enumerated() {
                count += self.exercisesMainArray[index].exercisesArray.count
            }
            let view = (self.theController.view as? ResistanceTrainingLogView)
            view?.tableViewHeight.constant = CGFloat((self.exercisesMainArray.count * 127) + (count * 73))
            view?.tableView.reloadData()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Rearrange Set", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.isEditRow = section
            let view = (self.theController.view as? ResistanceTrainingLogView)
            view?.tableView.reloadData()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.theController.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func showActionSheetSection(section:Int) {
        
        let actionSheet = UIAlertController(title: self.exercisesMainArray[section].exerciseName, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Duplicate Exercise", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.exercisesMainArray.append(self.exercisesMainArray[section])
            self.isSelectedDuration.append(self.isSelectedDuration[section])
            
            var count:Int = 0
            for (index, _) in self.exercisesMainArray.enumerated() {
                count += self.exercisesMainArray[index].exercisesArray.count
            }
            let view = (self.theController.view as? ResistanceTrainingLogView)
            view?.tableViewHeight.constant = CGFloat((self.exercisesMainArray.count * 127) + (count * 73))
            view?.tableView.reloadData()
            self.theController.changeColorAccordingToClickable()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Rearrange Exercise", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            let view = (self.theController.view as? ResistanceTrainingLogView)
            view?.tableView.isEditing = true
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Remove Exercise", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.exercisesMainArray.remove(at: section)
            self.isSelectedDuration.remove(at: section)
            
            var count:Int = 0
            for (index, _) in self.exercisesMainArray.enumerated() {
                count += self.exercisesMainArray[index].exercisesArray.count
            }
            let view = (self.theController.view as? ResistanceTrainingLogView)
            view?.tableViewHeight.constant = CGFloat((self.exercisesMainArray.count * 127) + (count * 73))
            view?.tableView.reloadData()
            
            self.theController.changeColorAccordingToClickable()

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.theController.present(actionSheet, animated: true, completion: nil)
        
    }
}
