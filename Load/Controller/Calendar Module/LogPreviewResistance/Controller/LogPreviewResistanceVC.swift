//
//  LogPreviewResistanceVC.swift
//  Load
//
//  Created by Haresh Bhai on 08/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LogPreviewResistanceVC: UIViewController {
    
    //MARK:- Variables
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnRightBarButton: UIBarButtonItem!
    
    lazy var mainView: LogPreviewResistanceView = { [unowned self] in
        return self.view as! LogPreviewResistanceView
    }()
    
    lazy var mainModelView: LogPreviewResistanceViewModel = { [weak self] in
        return LogPreviewResistanceViewModel(theController: self)
    }()
    
    
    var isLongGestureForEnd = false
    var isLongGestureForComplete = false
    
    var sectionIndex = 0
    var rowIndex = 0
    
    //Click on End that time set date
    var dateClickonEndButton = Date()

    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.mainModelView.setupUI()
        self.mainView.setupUI()
        
        self.findSpecificIndextoShow()
        
        //add gesture
        addLongGestureInButton()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("deallocate Controller:\(self)")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if let cell = self.mainView.tableView.cellForRow(at: IndexPath(row: self.rowIndex, section: self.sectionIndex)) as? ExerciseResistancePreviewCell{
            print("cell enter")
            if cell.timerofUpdateProgressbar != nil{
                cell.timerofUpdateProgressbar?.invalidate()
                cell.timerofUpdateProgressbar = nil
            }
        }
    }

    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.mainModelView.delegate?.DismissPreviewDidFinish()
    }
    
    @IBAction func btnEditClicked(_ sender: Any) {
        
        if self.mainModelView.checkIsExerciseStarted(){
            //Tag 0 pass only for passing value not used in function
            self.CountDownViewFinish(tag: 0)
            
        }else{
            let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateTrainingLogVC") as! CreateTrainingLogVC
            obj.mainModelView.previewDataResistance = self.mainModelView.previewData
            obj.mainModelView.isEditCardio = false
            obj.mainModelView.isEditResistance = true
            obj.mainModelView.tabIndex = 1
            obj.mainModelView.pastSelectedIndex = 1
            let nav = UINavigationController(rootViewController: obj)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
       self.mainModelView.deleteLog()
    }
    
    @IBAction func btnSaveAsTempleteClicked(_ sender: Any) {
//        self.mainModelView.apiCallForUpdate(isSavedWorkout: true)
    }
    
    @IBAction func btnShareClicked(_ sender: Any) {

//        self.redirectToConfirmationScreen()
        
//        let obj: NewMessageSelectVC
//            = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "NewMessageSelectVC") as! NewMessageSelectVC
//        obj.mainModelView.delegate = self
//        self.navigationController?.pushViewController(obj, animated: true)
    }

    @IBAction func btnCompleteWorkoutClicked(_ sender: Any) {
        
        if isLongGestureForComplete == false{
            UIView.animate(withDuration: 0.05, animations: {
                self.mainView.btnCompleteWorkout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
                self.mainView.btnCompleteWorkout.setTitleColor(.white, for: .normal)
            }) { (status) in
                self.mainView.btnCompleteWorkout.backgroundColor = .white
                self.mainView.btnCompleteWorkout.setTitleColor(.appthemeOffRedColor, for: .normal)
            }
        }else{
            isLongGestureForComplete = false
        }
        
        setVibration()

        let selectedDate = self.mainModelView.expandedDate
        let currentDate = Date().toString(dateFormat: "yyyy-MM-dd")
//        if currentDate == selectedDate {
            let alertController = UIAlertController(title: getCommonString(key: "Complete_Workout_key"), message: getCommonString(key: "Do_you_want_to_complete_this_workout_key"), preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
                
                //Comment for dismiss
//                let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""
//
//                if activityName.lowercased() == "Cycling (Outdoor)".lowercased() || activityName.lowercased() == "Run (Outdoor)".lowercased(){
//                    self.mainModelView.isClickOnCompleteButton = true
//                }
                self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: true)
            }
            
            let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
                print("Cancel")
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
//        }
//        else {
//            makeToast(strMessage: getCommonString(key: "You_can't_end_future_workout"))
//        }
    }
    @IBAction func btnEndWorkoutClicked(_ sender: Any) {
        
        if isLongGestureForEnd == false{
            UIView.animate(withDuration: 0.05, animations: {
                self.mainView.btnEndWorkout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
                self.mainView.btnEndWorkout.setTitleColor(.white, for: .normal)
            }) { (status) in
                self.mainView.btnEndWorkout.backgroundColor = .white
                self.mainView.btnEndWorkout.setTitleColor(.appthemeOffRedColor, for: .normal)
            }
        }else{
            isLongGestureForEnd = false
        }

        setVibration()
        
        let allExerciseArrayCount = self.mainModelView.previewData?.exercise?.count ?? 0
        let lastInnerExerciseArrayCount = self.mainModelView.previewData?.exercise?[allExerciseArrayCount - 1].data?.count ?? 0
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        print("date:\(date)")
        
        self.dateClickonEndButton = Date()
        
        self.mainModelView.previewData?.exercise?[allExerciseArrayCount - 1].data?[lastInnerExerciseArrayCount - 1].endTime = date
        
        
        if self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].isPause == false{
            
            if self.mainModelView.totalLapCount != self.checkCompletedLapsCount(){
                
                self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].isPause = true
                self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].pauseTime = date

            }
        }
        
        
//        let selectedDate = self.mainModelView.expandedDate
//        let currentDate = Date().toString(dateFormat: "yyyy-MM-dd")
//        if currentDate == selectedDate {
            let alertController = UIAlertController(title: getCommonString(key: "Load_key"), message: getCommonString(key: "Are_you_sure_you_want_to_stop_the_workout_key"), preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
                
                self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: true)
            }
            
            let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
                print("Cancel")
                
//                self.checkForRepeatSetPlayButton()
                
                if self.endAlertCancelMainTapped(){
                    return
                }
                
                self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: false,progress: false)

            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
//        }
//        else {
//            makeToast(strMessage: getCommonString(key: "You_can't_end_future_workout"))
//        }
    }
    
    @IBAction func btnStartWorkoutTapped(_ sender: UIButton) {
        
        let obj: CountDownVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CountDownVC") as! CountDownVC
        obj.mainModelView.delegate = self
        obj.mainModelView.tag = 0
        obj.modalPresentationStyle = .overFullScreen
        self.present(obj, animated: true, completion: nil)
    }
    
    //MARK:-  other method
    
    func checkCompletedLapsCount() -> Int{
        
        var count = 0
         
        for i in 0..<(self.mainModelView.previewData?.exercise?.count ?? 0){
             
             for j in 0..<(self.mainModelView.previewData?.exercise?[i].data?.count ?? 0){
                 
                 let dict = self.mainModelView.previewData?.exercise?[i].data?[j]
                 
                if dict?.isCompleted == true && dict?.isCompletedRest == true{
                    count += 1
                }
             }
         }

        return count
        
    }
    
    func endAlertCancelMainTapped() -> Bool{
        
        let miliseconds = String(Date().timeIntervalSince(self.dateClickonEndButton))
        print("Milisecond \(miliseconds)")
        
        // add second differnce of click on End and Click on No added in StartTime of 0 index

        //Set for End button
        var secondDifferenceForEndButton = 0
        if miliseconds.contains("."){
            let array = miliseconds.split(separator: ".")
            
            let firstIndex = array[0]
            let secondIndex = array[1]
            
            if ("0.\(secondIndex)").toFloat() > 0.5{
                secondDifferenceForEndButton = (Int(String(firstIndex)) ?? 1) + 1
            }else{
                secondDifferenceForEndButton = Int(String(firstIndex)) ?? 0
            }
        }
        
        // last completed set untick and open timer screen
        // implement because if we use checkForRepeatSetPlayButton then automatically start without clicking
        if self.repeatSetManageWhileClickOnEndCancle(secondDifferenceForEndButton: secondDifferenceForEndButton){
            
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: false)

            return true
        }
        
        //All completed that time call
        
        if (self.checkCompletedLapsCount() == self.mainModelView.totalLapCount) {
            print("Return call")
            
            let valueAddigForStartTimeForOutdoor = self.mainModelView.previewData?.exercise?[0].data?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifferenceForEndButton))
            
            let convertToStringForStartTimeForOutDoor = valueAddigForStartTimeForOutdoor?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            
            self.mainModelView.previewData?.exercise?[0].data?[0].startTime = convertToStringForStartTimeForOutDoor ?? ""
            
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: false)

            return true
        }
        
        if self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].isClickOnPause == false{
            
            if self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].isPause == true{
                
                self.userClickOnCancelForEndAlert()
            }
        }
        
        return false

    }
    
    
    func repeatSetManageWhileClickOnEndCancle(secondDifferenceForEndButton:Int) -> Bool{
        
        if self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].isRepeatSet == true && self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].isCurrentLapWorking == true{
            
            if self.findSpecificIndextoShow().section == 0 && self.findSpecificIndextoShow().row == 0{
                
                if self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].repeatTime == ""{
                    
                    if let valueAddigForStartTime = self.mainModelView.previewData?.exercise?[0].data?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifferenceForEndButton)){
                        
                        let convertToStringForStartTime = valueAddigForStartTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                        self.mainModelView.previewData?.exercise?[0].data?[0].startTime = convertToStringForStartTime
                    }
                    return true
                }
            }else{
                if self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].startTime == ""{
                    
                    if let valueAddigForStartTime = self.mainModelView.previewData?.exercise?[0].data?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifferenceForEndButton)){
                        
                        let convertToStringForStartTime = valueAddigForStartTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                        self.mainModelView.previewData?.exercise?[0].data?[0].startTime = convertToStringForStartTime
                    }
                    return true
                }
            }
        }
        
        return false
    }
    
    func userClickOnCancelForEndAlert(){
        
        let secondDifference = self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].pauseTime.convertDateFormater().secondDifference(to: Date())

        if let valueAddigForStartTime = self.mainModelView.previewData?.exercise?[0].data?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0)){
            
            let convertToStringForStartTime = valueAddigForStartTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.mainModelView.previewData?.exercise?[0].data?[0].startTime = convertToStringForStartTime
        }

        if self.findSpecificIndextoShow().row == 0 && self.findSpecificIndextoShow().section == 0{
            
            let valueAddigForAddRestTime = self.mainModelView.previewData?.exercise?[0].data?[0].repeatTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0 ))

            if  let convertToStringForAddRestTime = valueAddigForAddRestTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"){
                self.mainModelView.previewData?.exercise?[0].data?[0].repeatTime = convertToStringForAddRestTime
            }
            
        }else{
            
            let valueAddigForAddRestTime = self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0 ))
            
            if  let convertToStringForAddRestTime = valueAddigForAddRestTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"){
                self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].startTime = convertToStringForAddRestTime
            }
        }
        
        if let valueAddigForAddRestTime = self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].addedRestTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0)){
            
            let convertToStringForAddRestTime = valueAddigForAddRestTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].addedRestTime = convertToStringForAddRestTime
        }

        self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].isPause = false
        self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].pauseTime = ""

    }


    
    func redirectToResistanceSummary(){
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CalendarTrainingLogResistanceSummaryVc") as! CalendarTrainingLogResistanceSummaryVc
        obj.mainModelView.date = self.mainModelView.expandedDate
        obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
        obj.mainModelView.delegateDismissTrainingLogSummary = self
        
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil )
    }
    /*
    func redirectToRPESelection(){
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "RPESelectionVc") as! RPESelectionVc
        obj.mainModelView.delegateDismissRPESelection = self
        obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)
    }*/
    
    func redirectToConfirmationScreen(){
        
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "ResistanceConfirmationPageVc") as! ResistanceConfirmationPageVc
        obj.mainModelView.delegateConfirmation = self
        obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)

    }

    
    func setCompleteButtonColor(){
        
        if self.mainModelView.checkIsExerciseStarted(){
            self.btnEdit.setTitle(str: "Switch View")
            self.btnEdit.setTitleColor(UIColor.appthemeRedColor, for: .normal)
            self.btnEdit.setImage(nil, for: .normal)
            self.btnEdit.contentHorizontalAlignment = .center
            self.btnRightBarButton.width = 200
            self.btnEdit.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            
            self.mainView.vwEndWorkout.isHidden = false
            self.mainView.vwCompleteWorkout.isHidden = true
            self.mainView.vwStartWorkout.isHidden = true
            
            mainView.ConstratintBottomViewHeigh.constant = 102
            
            mainView.isBottomDeleteShareShow(isShow: false)
            mainView.vwBottomHiddenShow(isHidden: true)
            
            if (mainView.scrollView.contentOffset.y + mainView.safeAreaHeight - 102) >= mainView.scrollView.contentSize.height{
                mainView.isSetAlphaOrNOt(isSet: true)
            }else{
                mainView.isSetAlphaOrNOt(isSet: false)
            }

        }else{
            
            self.btnEdit.setTitle(str: "")
            self.btnEdit.setImage(UIImage(named: "ic_edit_red"), for: .normal)
            self.btnEdit.contentHorizontalAlignment = .right
            self.btnRightBarButton.width = 50
            
            self.mainView.vwCompleteWorkout.isHidden = false
            self.mainView.vwStartWorkout.isHidden = false
            self.mainView.vwEndWorkout.isHidden = true
            
//            mainView.vwBottomHiddenShow(isHidden: false)
//
//            print("contentsizeHeight:\(mainView.scrollView.contentSize.height)")
//            print("safeAreaHeigh:\(view.safeAreaHeight)")
//
//            if (mainView.scrollView.contentOffset.y + mainView.safeAreaHeight - 177) >= mainView.scrollView.contentSize.height{
//                mainView.isSetAlphaOrNOt(isSet: true)
//                mainView.isBottomDeleteShareShow(isShow: true)
//            }else{
//                mainView.isSetAlphaOrNOt(isSet: false)
//                mainView.isBottomDeleteShareShow(isShow: false)
//            }
        }
    }
    
    func addLongGestureInButton(){
        
        let longGestureComplete = UILongPressGestureRecognizer(target: self, action: #selector(longTapBtnComplete))
        self.mainView.btnCompleteWorkout.addGestureRecognizer(longGestureComplete)
        
        let longGestureEnd = UILongPressGestureRecognizer(target: self, action: #selector(longTapBtnEnd))
        self.mainView.btnEndWorkout.addGestureRecognizer(longGestureEnd)
        
    }
    
    
    //add Gesture methods
    
    @objc func longTapBtnComplete(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            self.mainView.btnCompleteWorkout.backgroundColor = .white
            self.mainView.btnCompleteWorkout.setTitleColor(.appthemeOffRedColor, for: .normal)
            self.btnCompleteWorkoutClicked(self.mainView.btnCompleteWorkout)
        }
        else if sender.state == .began {
            print("Began")
            self.isLongGestureForComplete = true
            self.mainView.btnCompleteWorkout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
            self.mainView.btnCompleteWorkout.setTitleColor(.white, for: .normal)
        }
    }

    
    @objc func longTapBtnEnd(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            self.mainView.btnEndWorkout.backgroundColor = .white
            self.mainView.btnEndWorkout.setTitleColor(.appthemeOffRedColor, for: .normal)
            self.btnEndWorkoutClicked(self.mainView.btnEndWorkout)
        }
        else if sender.state == .began {
            print("Began")
            self.isLongGestureForEnd = true
            self.mainView.btnEndWorkout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
            self.mainView.btnEndWorkout.setTitleColor(.white, for: .normal)
        }
    }
    
    //find index of current working set and last done set
    
    func findSpecificIndextoShow() -> (section:Int,row:Int){
        
        for i in 0..<(self.mainModelView.previewData?.exercise?.count ?? 0){
            
            for j in 0..<(self.mainModelView.previewData?.exercise?[i].data?.count ?? 0){
                
                let dict = self.mainModelView.previewData?.exercise?[i].data?[j]
                
                if dict?.isCurrentLapWorking ?? false {
                    return (i,j)
                }
            }
        }
        return (0,0)
    }

}

extension LogPreviewResistanceVC : dismissConfirmationPageDelegate{
    func dismissConfirmationPage() {
        self.dismiss(animated: true) {
            self.redirectToResistanceSummary()
        }
    }
}

extension LogPreviewResistanceVC: delegateDismissCalendarTrainingLogSummary{
    
    func dismissCalendarTrainingLogSummary() {
        
        self.dismiss(animated: true) {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
            
            self.mainModelView.delegate?.DismissPreviewDidFinish()
//            }
        }
    }
}

//MARK: - ScrollView Delegate

extension LogPreviewResistanceVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height+177 <= mainView.safeAreaHeight{
            return
        }
        
        if self.mainView.scrollView.panGestureRecognizer.translation(in: scrollView).y > 0{
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                [self.mainView.vwEndWorkout,self.mainView.vwCompleteWorkout,self.mainView.vwStartWorkout].forEach { (vw) in
                    vw?.alpha = 0.0
                }
                
                self.mainView.vwMainBottom.isUserInteractionEnabled = false
                
                if self.mainModelView.checkIsExerciseStarted(){
                    
                }else{
                    self.mainView.heightOfVwBottom.constant = 0
                    self.mainView.isBottomDeleteShareShow(isShow: false)
                }
//                self.mainView.constraintBottomofStackView.constant = 0
//                self.mainView.ConstratintBottomView.constant = 0
                self.mainView.layoutIfNeeded()

            }, completion: nil)
            
        }
        else{
            
            if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            }else{
                
                if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                    scrollEndMethod()
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        scrollEndMethod()
    }
    
    func scrollEndMethod(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            [self.mainView,self.mainView.vwEndWorkout,self.mainView.vwCompleteWorkout,self.mainView.vwStartWorkout,self.mainView.vwBottom].forEach { (vw) in
                vw?.alpha = 1.0
            }
            
            self.mainView.vwMainBottom.isUserInteractionEnabled = true
            
            if self.mainModelView.checkIsExerciseStarted(){
                
            }else{
                self.mainView.heightOfVwBottom.constant = 75
                self.mainView.isBottomDeleteShareShow(isShow: true)
            }
            
//            self.mainView.constraintBottomofStackView.constant = 30.5
//            self.mainView.heightOfVwBottom.constant = 75
//            self.mainView.ConstratintBottomView.constant = 15
            self.mainView.layoutIfNeeded()
        }, completion: nil)

    }
    
}
