//
//  CalendarViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 29/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class CalendarViewModel: SwitchAccountDelegate, SwitchAccountPickedDelegate, dismissCreateTrainingDelegate {
    
    fileprivate weak var theController:CalendarVC!
    var calendarArray: CalendarModelClass?
    var currentShowMonth = Date()
    var isExpanded:Bool = false
    var expandedSection:Int = -1
    var expandedRow:Int = -1
    var expandedIndex:Int = 0
    var expandedDate:String = ""
    var arrayCount:Int = 0
    var isOpenSwitch: Bool = false
    var viewSwitchAccount: SwitchAccountButtonView?
    var logList: TrainingLogListModelClass?
    var selectedDate: String = ""
    var isReloaded: [Bool] = [false, false, false, false, false, false]

    var lastSelectedSection = 0
    
    init(theController:CalendarVC) {
        self.theController = theController
    }
    
    func setupData(isExpanded:Bool = false,expandedDate:String = "") {
        
        self.isExpanded = isExpanded
        self.expandedSection = -1
        self.expandedRow = -1
        self.expandedIndex = 0
        self.expandedDate = expandedDate
        
        let view = (self.theController.view as? CalendarView)
        view?.lblMonthName.text = self.currentShowMonth.toString(dateFormat: "MMMM yyyy").uppercased()
        
        let data = self.makeDateArray(date: currentShowMonth, position: currentShowMonth.startOfMonth().position(), PreviousCount: currentShowMonth.getPreviousMonth()!.count(), currentCount: currentShowMonth.startOfMonth().count())
        calendarArray = CalendarModelClass(JSON: JSON(data).dictionaryObject!)
        let sDate = convertStringToISO8601((calendarArray?.date?.first)!, dateFormat: "yyyy-MM-dd")
        let eDate = convertStringToISO8601((calendarArray?.date?.last)!, dateFormat: "yyyy-MM-dd")
        self.apiCallForTrainingLogList(userId: (getUserDetail().data?.user?.id?.stringValue)!, startDate: sDate, endDate: eDate)
        
        viewSwitchAccount = SwitchAccountButtonView.instanceFromNib() as? SwitchAccountButtonView
        viewSwitchAccount?.setupUI()
        viewSwitchAccount?.showAccountType()
        viewSwitchAccount?.delegate = self
        self.theController.navigationItem.titleView = viewSwitchAccount
        
        //TODO: - yash comment for overlooping
        // From here
        NotificationCenter.default.addObserver(self, selector: #selector(updatedTraining(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
        //To here
         //
//        NotificationCenter.default.addObserver(self, selector: #selector(openWorkout(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.OPEN_SAVEDWORKOUT_NOTIFICATION.rawValue), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(hideNavWorkout(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.HIDE_NAV_SAVEDWORKOUT_NOTIFICATION.rawValue), object: nil)
    }
    
    @objc func updatedTraining(notification: Notification) {
        
        let sDate = convertStringToISO8601((calendarArray?.date?.first)!, dateFormat: "yyyy-MM-dd")
        let eDate = convertStringToISO8601((calendarArray?.date?.last)!, dateFormat: "yyyy-MM-dd")

        self.apiCallForTrainingLogList(userId: (getUserDetail().data?.user?.id?.stringValue)!, startDate: sDate, endDate: eDate)

    }
    
    @objc func openWorkout(notification: Notification) {
//        self.openCreateTraining(isAutoOpen: true)
        self.theController.dismiss(animated: false, completion: nil)
        let view = self.theController.view as? CalendarView
        view?.isHidden = true
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateTrainingLogVC") as! CreateTrainingLogVC
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.theController.present(nav, animated: false, completion: {
            view?.isHidden = false
            self.theController.tabBarController?.tabBar.isHidden = false
            self.theController.navigationController?.navigationBar.isHidden = false
        })
    }
    
    @objc func hideNavWorkout(notification: Notification) {
        self.theController.navigationController?.navigationBar.isHidden = true
        self.theController.tabBarController?.tabBar.isHidden = true
        let view = self.theController.view as? CalendarView
        view?.isHidden = true
    }
    
    func apiCallForTrainingLogList(userId: String, startDate: String, endDate: String) {
        
        let relation = ["training_intensity", "training_goal", "training_activity", "user_detail"]
        let trainingIntensityList =  [ "id", "name", "code", "is_active" ]
        let trainingGoalList = [ "id", "name", "code", "is_active" ]
        let trainingActivityList = [ "id", "name", "code", "is_active", "icon_path" ]
        let userDetailList = [ "id", "name", "email", "mobile", "date_of_birth", "gender", "height", "weight", "photo", "is_active" ]
        
        let param = ["user_id":userId, "start_date": startDate, "end_date": endDate, "relation" : relation, "training_intensity_list": trainingIntensityList, "training_goal_list": trainingGoalList, "training_activity_list": trainingActivityList, "user_detail_list" : userDetailList] as [String : Any]
        
        ApiManager.shared.MakePostAPI(name: TRAINING_LOG_LIST, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let data = json.getDictionary(key: .data)
                
                let success = json.getBool(key: .success)
                
                if success {
                    self.logList = TrainingLogListModelClass(JSON: data.dictionaryObject!)
                    self.theController.tableReload()
                }else{
                    self.logList = nil
                    self.theController.tableReload()
                }
                
//                if self.expandedDate != "" {
//                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) {
//                        view?.tableView.reloadData()
//                    }
//                }
            }
            else {
                self.theController.tableReload()
            }
        }
    }
    
    func apiCallGetSettingDetails(trainingId:String, weekday:Int, weekNumber:Int, weekdayWiseMainIDForProgram: String, isCompleted: Bool?) {
        
        let param = ["":""] as [String : Any]
//        print(JSON(param))
        
        ApiManager.shared.MakeGetAPI(name: GET_SETTING_TRAINING_DETAILS, params: param as [String : Any], progress: false, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let raceDistanceId = data.getInt(key: .race_distance_id)
                    let raceTime = data.getString(key: .race_time)
                    
                    if isCompleted == true {
                        
                        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CalendarTrainingLogSummaryVc") as! CalendarTrainingLogSummaryVc
                        obj.mainModelView.controllerMoveFrom = .trainingProgram
                        obj.mainModelView.date = self.expandedDate
                        obj.mainModelView.isComeFromCalendar = true
                        obj.mainModelView.trainingLogId = weekdayWiseMainIDForProgram
                        let nav = UINavigationController(rootViewController: obj)
                        nav.modalPresentationStyle = .overFullScreen
                        self.theController.present(nav, animated: true, completion: nil)

                    }else{
                        
                        if raceDistanceId != 0 && raceTime != "" {
                            let obj: TrainingPreviewVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "TrainingPreviewVC") as! TrainingPreviewVC
                            
                            let timeArray = raceTime.components(separatedBy: ":")
                            let totalHrs = timeArray[0]
                            let totalMins = timeArray[1]
                            let totalSec = timeArray[2] == "00" ? 0 : 1
                            let hr = ((Int(totalHrs) ?? 0) * 60)
                            let min = (Int(totalMins) ?? 0)
                            let totalTime = hr + min + totalSec
                            obj.mainModelView.weekday = weekday
                            obj.mainModelView.weekNumber = weekNumber
                            obj.mainModelView.programId = trainingId
                            obj.mainModelView.weekdayWiseMainID = weekdayWiseMainIDForProgram
                            obj.mainModelView.raceDistanceId = Double(getRaceDistanceName(id: raceDistanceId).replace(target: " km", withString: ""))
                            obj.mainModelView.raceTime = Double(totalTime)
                            obj.mainModelView.expandedDate = self.expandedDate
                            let nav = UINavigationController(rootViewController: obj)
                            nav.modalPresentationStyle = .overFullScreen
                            self.theController.present(nav, animated: true, completion: nil)
                        }
                        else {
                            let refreshAlert = UIAlertController(title: "Load", message: "Distance and time not filled. press Yes to move settings.", preferredStyle: UIAlertController.Style.alert)
                            
                            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                                IS_OPEN_RACETIME = true
                                self.theController.tabBarController?.selectedIndex = 4
                            }))
                            
                            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                            }))
                            
                            self.theController.present(refreshAlert, animated: true, completion: nil)
                        }
                    }
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        })
    }
    
    func apiCallDailyPrograms(programId: String, weekNumber:Int, workoutNumber:Int, progress:Bool = true, completionHandler: @escaping (TrainingProgramModel?, String?)-> Void) {
//        print(self.expandedDate)
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
                    let model = TrainingProgramModel(JSON: data.dictionaryObject!)
                    completionHandler(model, nil)
                }
                else {
                    completionHandler(nil, "Something went wrong")
                    //                    let message = json.getString(key: .message)
                    //                    makeToast(strMessage: message)
                }
            }else{
                completionHandler(nil, "Something went wrong")
            }
        })
    }
    
    func openCreateTraining(isAutoOpen:Bool = false) {
        self.theController.dismiss(animated: false, completion: nil)
        let view = self.theController.view as? CalendarView
        if isAutoOpen {
            view?.isHidden = true
        }
        let obj: CreateTrainingVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateTrainingVC") as! CreateTrainingVC
        obj.mainModelView.isAutoOpen = isAutoOpen
        obj.mainModelView.selectedDateFromCalendar = self.selectedDate
        obj.mainModelView.delegateCreateTraining = self
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.theController.present(nav, animated: false, completion: {
            view?.isHidden = false
            self.theController.tabBarController?.tabBar.isHidden = false
            self.theController.navigationController?.navigationBar.isHidden = false
        })
    }
    
    func makeDateArray(date: Date, position:Int, PreviousCount: Int, currentCount:Int) -> NSDictionary {
    
        var arrayDate:[String] = []
        var arrayNo:[Int] = []
        var isEnable:[Bool] = []
        
        if position != 1 {
            for i in (PreviousCount - (position - 2))...PreviousCount {
                arrayNo.append(i)
                let day = i > 9 ? "\(i)" : "0\(i)"
                arrayDate.append((date.getPreviousMonth()?.year)! + "-" + (date.getPreviousMonth()?.month)! + "-" + day)
                isEnable.append(false)
            }
        }
        
        for i in 1...currentCount {
            arrayNo.append(i)
            let day = i > 9 ? "\(i)" : "0\(i)"
            arrayDate.append((date.year) + "-" + (date.month) + "-" + day)
            isEnable.append(true)
        }
        
        if arrayNo.count < 42 {
            for i in 1...(42 - arrayNo.count) {
                arrayNo.append(i)
                let day = i > 9 ? "\(i)" : "0\(i)"
                arrayDate.append((date.getNextMonth()?.year)! + "-" + (date.getNextMonth()?.month)! + "-" + day)
                isEnable.append(false)
            }
        }
        return ["no":arrayNo,"date":arrayDate, "is_enable": isEnable]
    }
    
    func SwitchAccountClicked(isOpen: Bool) {
        self.isOpenSwitch = isOpen
        if isOpen {
            self.showImageRightButton(isSwitch: true)
            let controller = SwitchAccountVC(nibName: "SwitchAccountVC", bundle: nil)
            controller.delegate = self
            controller.view.frame = CGRect(x: 0, y: 0, width: self.theController.view.bounds.width, height: self.theController.view.bounds.height)
            self.theController.addChild(controller)
            self.theController.view.addSubview(controller.view)
            controller.didMove(toParent: self.theController)
        }
        else {
            self.showImageRightButton(isSwitch: false)
            if self.theController.children.count > 0{
                let viewControllers:[UIViewController] = self.theController.children
                for viewContoller in viewControllers{
                    viewContoller.willMove(toParent: nil)
                    viewContoller.view.removeFromSuperview()
                    viewContoller.removeFromParent()
                }
            }
            let view = (self.theController.view as? CalendarView)
            view?.tableView.reloadData()
        }
    }
    
    func SwitchAccountPickedClicked(index: Int) {
        self.isOpenSwitch = false
        self.viewSwitchAccount?.isOpen = false
        self.showImageRightButton(isSwitch: false)
        self.viewSwitchAccount?.lblFree.text = showAccountType(index: index)
        SELECTED_ACCOUNT_TYPE = showAccountType(index: index)
        if self.theController.children.count > 0{
            let viewControllers:[UIViewController] = self.theController.children
            for viewContoller in viewControllers{
                viewContoller.willMove(toParent: nil)
                viewContoller.view.removeFromSuperview()
                viewContoller.removeFromParent()
            }
        }
        let view = (self.theController.view as? CalendarView)
        view?.tableView.reloadData()
    }    
    
    func showImageRightButton(isSwitch:Bool) {
        let image = isSwitch ? UIImage(named: "ic_close_switch_screen") : UIImage(named: "ic_add")
        self.theController.btnAdd.setImage(image, for: .normal)
    }
    
    //Dismiss create training screen
    func dismissCreateTraining() {
        self.theController.dismiss(animated: false, completion: nil)
    }

}
