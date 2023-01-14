//
//  LogPreviewResistanceViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 08/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

protocol DismissPreviewDelegate:class {
    func DismissPreviewDidFinish()
}

class LogPreviewResistanceViewModel {
    
    fileprivate weak var theController:LogPreviewResistanceVC!
    var previewData: TrainingLogResistanceModelClass?
    weak var delegate:DismissPreviewDelegate?
    var trainingLogId: String = ""
    var expandedDate:String = ""
    var totalLapCount = 0
    
    var targetedVolume = 0
    var completedVolume = 0


    init(theController:LogPreviewResistanceVC?) {
        self.theController = theController
    }
    
    deinit {
        print("deallocate videmodel:\(self)")
    }

    func setupUI() {
        if previewData == nil {
            self.apiCallGetDetails()
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatedTraining(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.RESISTANCE_NOTIFICATION.rawValue), object: nil)
        
        let view = (self.theController.view as? LogPreviewResistanceView)
        
        var count:Int = 0
        if let exercises = previewData?.exercise {
            for (index, _) in exercises.enumerated() {
                count += previewData?.exercise?[index].data?.count ?? 0
            }
        }
        
        self.totalLapCount = count
        
        view?.heightTableView.constant = CGFloat((((self.previewData?.exercise?.count) ?? 0) * 95) + (count * 77))
        
        let section = self.theController.findSpecificIndextoShow().section
        let row = self.theController.findSpecificIndextoShow().row
        
        print("Section:\(section) Row:\(row)")
        
        view?.lblCompletedVolumeValue.text = "\(self.previewData?.completedVolume ?? 0) \(self.previewData?.completedVolumeUnit ?? "")"
        view?.lblTargetedVolumeValue.text = "\(self.previewData?.targetedVolume ?? 0) \(self.previewData?.targetedVolumeUnit ?? "")"
        
        let image = self.previewData?.userDetail?.photo
        view?.imgProfile.sd_setImage(with: URL(string: image ?? ""), completed: nil)
        
        view?.imgActivity.image = view?.imgActivity.image?.withRenderingMode(.alwaysTemplate)
        view?.imgActivity.tintColor = UIColor.appthemeOffRedColor
        view?.lblDate.text = convertDateFormater((self.previewData?.date)!, dateFormat: "EEEE, dd MMM yyyy 'at' HH:mm a")
        view?.lblWhen.text = self.previewData?.workoutName
        view?.lblSubTitle.text = self.previewData?.notes == "" ? "-" : self.previewData?.notes
//        view?.lblName.text = self.previewData?.workoutName
        
        let trainigGoalCustom = self.previewData?.trainingGoalCustom
        view?.lblTrainingGoal.text = (self.previewData?.trainingGoal?.name ?? "") == "" ? trainigGoalCustom : self.previewData?.trainingGoal?.name        
        view?.lblIntensity.text = self.previewData?.trainingIntensity?.name
        
        view?.tableView.delegate = self.theController
        view?.tableView.dataSource = self.theController
        view?.tableView.reloadData()
//        self.theController.btnEdit.isHidden = self.checkIsExerciseStarted()
        
        self.theController.setCompleteButtonColor()
        view?.layoutIfNeeded()
        
        if self.checkIsExerciseStarted(){
            self.theController.btnEdit.setTitle(str: "Switch View")
            self.theController.btnEdit.setTitleColor(UIColor.appthemeRedColor, for: .normal)
            self.theController.btnEdit.setImage(nil, for: .normal)
            self.theController.btnEdit.contentHorizontalAlignment = .center
            self.theController.btnRightBarButton.width = 200
            self.theController.btnEdit.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            
            if let view = (self.theController.view as? LogPreviewResistanceView){

                view.ConstratintBottomViewHeigh.constant = 102

                view.isBottomDeleteShareShow(isShow: false)
                view.vwBottomHiddenShow(isHidden: true)

                if (view.scrollView.contentOffset.y + view.safeAreaHeight - 102) >= view.scrollView.contentSize.height{
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
            
            if let view = (self.theController.view as? LogPreviewResistanceView){

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
    }
    
    func checkIsExerciseStarted() -> Bool {
        for data in self.previewData?.exercise ?? [] {
            if data.data?[0].startTime != ""{
                return true
            }
        }
        return false
    }
    
    func checkIsCompleted() -> Bool {
        return self.previewData?.isComplete ?? false
    }
    
    func deleteLog() {
        let alertController = UIAlertController(title: getCommonString(key: "Load_key"), message: getCommonString(key: "Do_you_want_to_delete_this_workout?_key"), preferredStyle: UIAlertController.Style.alert)
        
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
        
        ApiManager.shared.MakeGetAPI(name: TRAINING_LOG_DELETE + "/" + (self.previewData?.id?.stringValue)!, params: param, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
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
    
    func apiCallGetDetails() {
        let param = ["":""]
        
        ApiManager.shared.MakeGetAPI(name: GET_TRAINING_LOG + "/" + self.trainingLogId, params: param, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let data = json.getDictionary(key: .data)
                print(data)
                let model = TrainingLogResistanceModelClass(JSON: data.dictionaryObject!)
                self.previewData = model
                
                self.targetedVolume = self.previewData?.targetedVolume ?? 0
                self.completedVolume = self.previewData?.completedVolume ?? 0

                self.setupUI()
            }
        })
    }
    
    func apiCallSaveDetails(programId: String, isEndWorkout:Bool = false, progress:Bool = true) {
        let exercise: NSMutableArray = NSMutableArray()
        var isComplete:Bool = true
        for (index,data) in (self.previewData?.exercise ?? []).enumerated() {
            let exerciseData: NSMutableArray = NSMutableArray()

            for i in (0..<(data.data ?? []).count) {
                
                var dict = NSMutableDictionary()
                
                let dataValue = data.data?[i]
                
                dict = ["reps" : dataValue?.reps ?? "", "is_completed" : dataValue?.isCompleted ?? "", "is_completed_rest" : dataValue?.isCompletedRest ?? "", "weight": dataValue?.weight ?? "", "rest": dataValue?.rest ?? "", "completeTime": dataValue?.completeTime ?? 0, "duration": dataValue?.duration ?? ""]
                
                dict.setValue(dataValue?.isCheckMarkAlreadyDone, forKey: "is_checkmark_done")
                dict.setValue(dataValue?.isCurrentLapWorking, forKey: "is_CurrentLapWorking")
                dict.setValue(dataValue?.isLastWorkedLap, forKey: "is_LastWorkedLap")
                dict.setValue(dataValue?.pauseTime, forKey: "pause_time")
                dict.setValue(dataValue?.isPause, forKey: "is_pause")
                dict.setValue(dataValue?.addedRestTime, forKey: "added_rest_time")
                dict.setValue(dataValue?.isRepeatSet, forKey: "is_repeat_set")
                dict.setValue(dataValue?.isClickOnPause, forKey: "isClickOnPause")
                dict.setValue(dataValue?.lineDraw, forKey: "lineDraw")
                dict.setValue(dataValue?.lastPauseTime, forKey: "lastPauseTime")
                dict.setValue(dataValue?.elapsedTime, forKey: "elapsedTime")
                
                if index == 0 && i == 0{
                    dict.setValue(dataValue?.startTime, forKey: "start_time")
                    dict.setValue(dataValue?.repeatTime, forKey: "repeat_time")
                }else{
                    dict.setValue(dataValue?.startTime, forKey: "start_time")
                }
                
                if index == (self.previewData?.exercise?.count ?? 0) - 1{
                    if i == (data.data?.count ?? 0) - 1{
                        dict.setValue(dataValue?.endTime, forKey: "end_time")
                    }
                }
                
                exerciseData.add(dict)
            }
            if data.isCompleted == false {
                isComplete = false
            }
            let dict: NSDictionary = ["name" : data.name ?? "", "is_completed" : data.isCompleted ?? false, "data":exerciseData, "library_id": data.libraryId, "common_library_id": data.commonLibraryId, "exercise_link": data.exerciseLink ]
            exercise.add(dict)
        }
        
        //TODO: - yash comments for test
        /*
        if isEndWorkout {
            isComplete = true
        }*/
        
        let param = [
            "exercise": exercise,
            "is_complete": false
            ] as [String : Any]
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
                print(json)
                let data = json.getDictionary(key: .data)
                let model = TrainingLogResistanceModelClass(JSON: data.dictionaryObject!)

                let success = json.getBool(key: .success)
                if success {
                    
                    //New addeed
                    if let view = (self.theController.view as? LogPreviewResistanceView){
                        view.lblCompletedVolumeValue.text = "\(model?.completedVolume ?? 0) \(model?.completedVolumeUnit ?? "")"
                        view.lblTargetedVolumeValue.text = "\(model?.targetedVolume ?? 0) \(model?.targetedVolumeUnit ?? "")"
                    }
                    
                    let dataDict:[String: Any] = ["completedVolume": model?.completedVolume ?? 0,
                                                  "targetdVolume": model?.targetedVolume ?? 0]
                    
                    self.targetedVolume = model?.targetedVolume ?? 0
                    self.completedVolume = model?.completedVolume ?? 0
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_RESISTANCE_UPDATED_VOLUME.rawValue), object: nil, userInfo: dataDict)
                    
                    if self.previewData?.isComplete ?? false{
//                        self.theController.dismiss(animated: true, completion: nil)
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
                        //Yash comments
//                        self.theController.redirectToRPMSelection()
                        self.theController.redirectToConfirmationScreen()
                        return
                    }
                    
                    if self.checkIsExerciseStarted(){
                        self.theController.btnEdit.setTitle(str: "Switch View")
                        self.theController.btnEdit.setTitleColor(UIColor.appthemeRedColor, for: .normal)
                        self.theController.btnEdit.setImage(nil, for: .normal)
                        self.theController.btnEdit.contentHorizontalAlignment = .center
                        self.theController.btnRightBarButton.width = 200
                        self.theController.btnEdit.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

                        if let view = (self.theController.view as? LogPreviewResistanceView){
                            
                            view.ConstratintBottomViewHeigh.constant = 102
                            view.vwEndWorkout.isHidden = false
                            view.vwCompleteWorkout.isHidden = true
                            view.vwStartWorkout.isHidden = true
                            
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
                        
                        if let view = (self.theController.view as? LogPreviewResistanceView){
                            
                            view.vwCompleteWorkout.isHidden = false
                            view.vwStartWorkout.isHidden = false
                            view.vwEndWorkout.isHidden = true
                            
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
    
    @objc func updatedTraining(notification: Notification) {
        if let model = notification.userInfo?["data"] as? TrainingLogResistanceModelClass {
            self.previewData = model
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)

            self.setupUI()
        }
    }
}
