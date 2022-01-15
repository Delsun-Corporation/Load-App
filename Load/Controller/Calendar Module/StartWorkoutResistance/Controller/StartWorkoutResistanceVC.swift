//
//  StartWorkoutResistanceVC.swift
//  Load
//
//  Created by Haresh Bhai on 29/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import AVKit
import XCDYouTubeKit

class StartWorkoutResistanceVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: StartWorkoutResistanceView = { [unowned self] in
        return self.view as! StartWorkoutResistanceView
    }()
    
    lazy var mainModelView: StartWorkoutResistanceViewModel = { [weak self] in
        return StartWorkoutResistanceViewModel(theController: self)
    }()
    
    var isLongGestureForNext = false
    var isLongGestureForEnd = false
    
//    var isClickOnPause = false // add variable because while user click on End that time not start Timer
    var dateClickonEndButton = Date()
    
    //MARK:- view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        
        print("Common library id:\(self.mainModelView.strCommonLibraryId)")
        print("library id:\(self.mainModelView.strLibraryId)")
        
        self.mainView.webViewVimeo.scrollView.delegate = self
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapBtnNext))
        self.mainView.btnNext.addGestureRecognizer(longGesture)

        let longGestureEnd = UILongPressGestureRecognizer(target: self, action: #selector(longTapBtnEnd))
        self.mainView.btnEndWorkout.addGestureRecognizer(longGestureEnd)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateVoume(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_RESISTANCE_UPDATED_VOLUME.rawValue), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_RESISTANCE_UPDATED_VOLUME.rawValue), object: nil)
    }
    
    deinit {
        print("Deallocate :\(self)")
    }

    
    //Gesture
    @objc func longTapBtnEnd(_ sender: UIGestureRecognizer){
        if sender.state == .ended {
            self.mainView.btnEndWorkout.backgroundColor = .white
            self.mainView.btnEndWorkout.setTitleColor(.appthemeOffRedColor, for: .normal)
            self.btnEndWorkoutTapped(self.mainView.btnEndWorkout)
        }
        else if sender.state == .began {
            self.isLongGestureForEnd = true
            self.mainView.btnEndWorkout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
            self.mainView.btnEndWorkout.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func longTapBtnNext(_ sender: UIGestureRecognizer){
        if sender.state == .ended {
            self.mainView.btnNext.setTitleColor(.appthemeOffRedColor, for: .normal)
            self.mainView.btnNext.backgroundColor = .white
            self.btnNextClicked(self.mainView.btnNext)
        }
        else if sender.state == .began {
            print("Began")
            isLongGestureForNext = true
            self.mainView.btnNext.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
            self.mainView.btnNext.setTitleColor(.white, for: .normal)
            self.mainView.btnNext.setImage(UIImage(named: "ic_next_white_play"), for: .normal)
        }
    }
    
    //MARK: - IBAction method
    
    @IBAction func btnCloseClicked(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        self.mainModelView.closeView()
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.perform(#selector(changeAnimation), with: nil, afterDelay: 0.02)
        
        
        if self.mainModelView.isPaused == true{
            let secondDifference = self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].pauseTime.convertDateFormater().secondDifference(to: Date())
            
            print("secondDifference:\(secondDifference)")
            
            let valueAddigForStartTime = self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0))
             
             if  let convertToStringForAddStartTime = valueAddigForStartTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"){
                 self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime = convertToStringForAddStartTime
             }
        }
        
        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isClickOnPause = false

        
        if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == false || self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == nil{
            //Yash Comment
            
//            if self.mainModelView.timeCount != 0 {
//                self.mainModelView.exerciseArray[self.mainModelView.index].completeTime = NSNumber(integerLiteral: self.mainModelView.timeCount)
//            }
            self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted = true
            
            if self.mainModelView.isPaused == true{
                
                self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isPause = false
                self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].pauseTime = ""
            }
            
            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            
            let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.mainModelView.getSeconds(data: self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].rest)))
            
            let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].addedRestTime = convertToStringForRest
            
            //add start time in reps set
            self.checkForRepeatSetNextButton()
            
            self.nextClickableOrNot()
        }
        else {
            self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompletedRest = true
            
            self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isRepeatSet = false
            //Yash new implements
            //set all lap to false and current lapto set as last
            
            self.mainView.lblLapsCompleted.text = "\(self.mainModelView.checkCompletedLapsCount())/\(self.mainModelView.totalLapCount)"

            self.completeLapsAndNextButtonCickableOrNot()

            return
//            self.setLastLapInCurrentExercise(lastLapIndex: self.mainModelView.arrayRowIndex, isSetNextLapWorking: true)
            
        }
        
        self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)
        self.mainModelView.checkAndStart()
    }
    
    @IBAction func btnEndWorkoutTapped(_ sender: UIButton) {
        
        let imageOfScreen = takeScreenshot()
        self.mainModelView.handlerFinishWorkoutOnEndClick(imageOfScreen)
        
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
        
        
        if self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime == ""{
            return
        }
        
        setVibration()
        
        self.dateClickonEndButton = Date()
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        print("date:\(date)")
        
        let allExerciseArrayCount = self.mainModelView.exerciseAllResistanceArray.count
        let lastInnerExerciseArrayCount = self.mainModelView.exerciseAllResistanceArray[allExerciseArrayCount - 1].data?.count ?? 0
        
        self.mainModelView.exerciseAllResistanceArray[allExerciseArrayCount - 1].data?[lastInnerExerciseArrayCount - 1].endTime = date
        
        if !self.mainModelView.isPaused{
            
            if (self.mainModelView.checkCompletedLapsCount() != self.mainModelView.totalLapCount) {
                self.mainModelView.isPaused = true
                self.mainView.countdownTimer.pause()
                self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isPause = true
                self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].pauseTime = date
                
                self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)

            }
        }
        
        if self.mainModelView.timerUpdate != nil{
            mainModelView.timerUpdate?.invalidate()
            mainModelView.timerUpdate = nil
        }


        endWorkoutAlert()
    }
    
    @IBAction func btnMapClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
//            self.mainView.mapView.isHidden = false
            self.mainView.viewText.isHidden = true
            self.mainView.countdownTimer.isHidden = true
        }
        else {
//            self.mainView.mapView.isHidden = true
            self.mainView.viewText.isHidden = false
            self.mainView.countdownTimer.isHidden = false
        }
    }
    
    @IBAction func btnAddVideoUrlTapped(_ sender: UIButton) {
        
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "PasteLinkVC") as! PasteLinkVC
        obj.modalPresentationStyle = .overFullScreen
        obj.modalTransitionStyle = .crossDissolve
        obj.strCommonLibraryId = self.mainModelView.strCommonLibraryId
        obj.strLibraryId = self.mainModelView.strLibraryId
        obj.handlerAddedLink = {[weak self] strLink in
            self?.mainModelView.exerciseAllResistanceArray[self?.mainModelView.arrayIndex ?? 0].exerciseLink = strLink
            self?.mainModelView.checkLinkAvailableOrNot()
            
            self?.mainModelView.delegate?.afterAddExerciseLink(tag: self?.mainModelView.arrayIndex ?? 0, exerciseLink: strLink)
        }
        self.present(obj, animated: true, completion: nil)
        
    }
    
    @IBAction func btnRelaodClicked(_ sender: Any) {
        self.mainModelView.checkAndStart()
    }

    @IBAction func btnPauseClicked(_ sender: UIButton) {
        
        if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == true && self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompletedRest == true{
            
            return
        }
        
        sender.isSelected = !sender.isSelected
        self.mainModelView.isPaused = !self.mainModelView.isPaused
        
        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isPause = self.mainModelView.isPaused
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")

        if !self.mainModelView.isPaused {
            
            //check for repeat particular set and click on play
            self.checkForRepeatSetPlayButton()
            
            //Play
            
            self.mainView.countdownTimer.resume()
            
            self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isClickOnPause = false
//            self.isClickOnPause = false
            
            let secondDifference = self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].pauseTime.convertDateFormater().secondDifference(to: Date())
            
            print("secondDifference:\(secondDifference)")
            
            let valueAddigForStartTime = self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0))
             
             if  let convertToStringForAddStartTime = valueAddigForStartTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"){
                 self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime = convertToStringForAddStartTime
             }
            
            
            if self.mainModelView.arrayRowIndex == 0 && self.mainModelView.arrayIndex == 0{
                
                let valueAddigForAddRestTime = self.mainModelView.exerciseAllResistanceArray[0].data?[0].repeatTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0))

                if  let convertToStringForAddRestTime = valueAddigForAddRestTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"){
                    self.mainModelView.exerciseAllResistanceArray[0].data?[0].repeatTime = convertToStringForAddRestTime
                }
                
            }else{
                
                let valueAddigForAddRestTime = self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0))

                if  let convertToStringForAddRestTime = valueAddigForAddRestTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"){
                    self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime = convertToStringForAddRestTime
                }

            }
            
            let valueAddigForRest = self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].addedRestTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0))

            if let convertToStringForRest = valueAddigForRest?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"){
                print("convertToStringForRest : \(convertToStringForRest)")
                self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].addedRestTime = convertToStringForRest
            }
            
            self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].pauseTime = ""
                
            if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].reps != nil && self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].reps != ""{
                
                if self.mainModelView.timerUpdate != nil{
                    self.mainModelView.timerUpdate?.invalidate()
                    self.mainModelView.timerUpdate = nil
                }
                
                self.mainModelView.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.durationTimerChange), userInfo: nil, repeats: true)
            }
            
            if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isRepeatSet == true{
                
                if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].duration != nil && self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].duration != ""{
                    
                    nextClickableOrNot()
                }

            }
            
        }else{
            //Pause
            
            print("self.lblDurationRepsWorkout:\(self.mainView.lblDurationtRepsWorkout.text)")
            
            self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].lastPauseTime = self.mainView.lblDurationtRepsWorkout.text ?? ""

            
            if self.mainModelView.timerUpdate != nil{
                self.mainModelView.timerUpdate?.invalidate()
                self.mainModelView.timerUpdate = nil
            }

            self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isClickOnPause = true
//            self.isClickOnPause = true
            self.mainView.countdownTimer.pause()
            
            self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].pauseTime = date
        }
        
        self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)

    }
    
    @IBAction func btnChangeableParamter(_ sender: UIButton) {
        
        self.mainView.btnChangeableParameter.isSelected = !self.mainView.btnChangeableParameter.isSelected
        
        if self.mainView.btnChangeableParameter.isSelected{
            self.mainView.lblChangeableParameter.text = "Targeted Volume (kg)"
            self.mainView.lblChangeableParameterValue.text = "\(self.mainModelView.targetedVolume)"
        }else{
            self.mainView.lblChangeableParameter.text = "Completed Volume (kg)"
            self.mainView.lblChangeableParameterValue.text = "\(self.mainModelView.completedVolume)"
        }
        
    }
    
    
    //MARK: - Other Functions
    
    
    func endWorkoutAlert(){
        
        let alertController = UIAlertController(title: getCommonString(key: "End_Workout_key"), message: getCommonString(key: "Are_you_sure_you_want_to_stop_the_workout_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            
            self.dismiss(animated: false) {
                
                self.mainModelView.delegate?.finishWorkout(isDone: true, tag: self.mainModelView.arrayIndex, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)
                
            }
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
            
            self.mainModelView.handlerFinishWorkoutOnEndClick(nil)
            
//            let secondDifference = self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].pauseTime.convertDateFormater().secondDifference(to: Date())
            
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
                
                if self.mainModelView.timerUpdate != nil{
                    self.mainModelView.timerUpdate?.invalidate()
                    self.mainModelView.timerUpdate = nil
                }
                
                self.mainModelView.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.durationTimerChange), userInfo: nil, repeats: true)
                
                self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)

                return
            }
            
            //All completed that time call
            if (self.mainModelView.checkCompletedLapsCount() == self.mainModelView.totalLapCount) {
                print("Return call")
                
                let valueAddigForStartTimeForOutdoor = self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifferenceForEndButton))
                
                let convertToStringForStartTimeForOutDoor = valueAddigForStartTimeForOutdoor?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                
                self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime = convertToStringForStartTimeForOutDoor ?? ""
                
                if self.mainModelView.timerUpdate != nil{
                    self.mainModelView.timerUpdate?.invalidate()
                    self.mainModelView.timerUpdate = nil
                }
                
                self.mainModelView.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.durationTimerChange), userInfo: nil, repeats: true)

                self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)

                return
            }
            
            if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isClickOnPause == false{
                if self.mainModelView.isPaused{
                    self.mainModelView.isPaused = false
                    self.userClickOnCancelForEndAlert()
                    
                    if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == true && self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompletedRest == true{
                     
                        if self.mainModelView.timerUpdate != nil{
                            self.mainModelView.timerUpdate?.invalidate()
                            self.mainModelView.timerUpdate = nil
                        }
                        
                        self.mainModelView.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.durationTimerChange), userInfo: nil, repeats: true)
                        
                    }
                }
            }

            self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)

        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func repeatSetManageWhileClickOnEndCancle(secondDifferenceForEndButton:Int) -> Bool{
        
        if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isRepeatSet == true && self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCurrentLapWorking == true{
            
            if self.mainModelView.arrayIndex == 0 && self.mainModelView.arrayRowIndex == 0{
                
                if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].repeatTime == ""{
                    
                    if let valueAddigForStartTime = self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifferenceForEndButton)){
                        
                        let convertToStringForStartTime = valueAddigForStartTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                        self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime = convertToStringForStartTime
                    }
                    return true
                }
            }else{
                if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime == ""{
                    
                    if let valueAddigForStartTime = self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifferenceForEndButton)){
                        
                        let convertToStringForStartTime = valueAddigForStartTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                        self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime = convertToStringForStartTime
                    }
                    return true
                }
            }
        }
        
        return false
    }
    
    func userClickOnCancelForEndAlert(){
        
        let secondDifference = self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].pauseTime.convertDateFormater().secondDifference(to: Date())

        if let valueAddigForStartTime = self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0)){
            
            let convertToStringForStartTime = valueAddigForStartTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime = convertToStringForStartTime
        }

        if self.mainModelView.arrayRowIndex == 0 && self.mainModelView.arrayIndex == 0{
            
            let valueAddigForAddRestTime = self.mainModelView.exerciseAllResistanceArray[0].data?[0].repeatTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0 ))

            if  let convertToStringForAddRestTime = valueAddigForAddRestTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"){
                self.mainModelView.exerciseAllResistanceArray[0].data?[0].repeatTime = convertToStringForAddRestTime
            }
            
        }else{
            
            let valueAddigForAddRestTime = self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0 ))

            if  let convertToStringForAddRestTime = valueAddigForAddRestTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"){
                self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime = convertToStringForAddRestTime
            }
        }
        
        if let valueAddigForAddRestTime = self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].addedRestTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference ?? 0)){
            
            let convertToStringForAddRestTime = valueAddigForAddRestTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].addedRestTime = convertToStringForAddRestTime
        }

        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isPause = false
        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].pauseTime = ""
        self.mainView.btnPlayPause.isSelected = false
        self.mainView.countdownTimer.resume()

    }
    
    func completeLapsAndNextButtonCickableOrNot(){
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        if (self.mainModelView.arrayRowIndex + 1) != self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?.count {

                print("Duration")
                //check next lap is completed or not
                
                if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex+1].isCompleted == true && self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex+1].isCompletedRest == true{
                    //Next lap is Completed
                    //No need to assign next lap currentlap working
                    
                    self.setLastLapInCurrentExercise(lastLapIndex: self.mainModelView.arrayRowIndex, isSetNextLapWorking: false)
                    
                    if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == false || self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == nil{
                        self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: true)
                    }else{
                        self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: false)
                    }
                    
                }else{
                    
                    //all set currentLapWorkinglap false including current index that's why write currentIndex as currentworkinglap after all done
                    
                    self.setLastLapInCurrentExercise(lastLapIndex: self.mainModelView.arrayRowIndex, isSetNextLapWorking: true)
                    
                    //Next array add time
                    self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime = date
                    
                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.mainModelView.getSeconds(data: self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].rest)))
                    
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].addedRestTime = convertToStringForRest

                }
                
                //set true because we need last currentworking lap
                self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCurrentLapWorking = true

                //makeToast(strMessage: "ArrayIndex:\(self.mainModelView.arrayIndex) RowIndex:\(self.mainModelView.arrayRowIndex)")
                
                self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)
                
                self.mainModelView.checkAndStart()
        }
        else {
            
            print("Last section:\(self.mainModelView.checkNextSectionIsAvailableOrNot())")
            
            if self.mainModelView.checkNextSectionIsAvailableOrNot(){
                
                if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex+1].data?[0].reps == "" || self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex+1].data?[0].reps == nil{
                    //Duration in next section
                    
                    //check next section is completed or not
                    if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex + 1].data?[0].isCompleted == true && self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex+1].data?[0].isCompletedRest == true{
                        
                        self.setLastLapInCurrentExercise(lastLapIndex: self.mainModelView.arrayRowIndex, isSetNextLapWorking: false)
                        
                        //Color change of next buttion
                        if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == false || self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == nil{
                            self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: true)
                        }else{
                            self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: false)
                        }
                        
                        //set true because we need last currentworking lap
                        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCurrentLapWorking = true
                        
                        //makeToast(strMessage: "ArrayIndex:\(self.mainModelView.arrayIndex) RowIndex:\(self.mainModelView.arrayRowIndex)")
                        
                        //    self.theController?.dismiss(animated: true, completion: nil)
                        self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)
                        
                    }else{
                        
                        print("Before arrayIndex:\(self.mainModelView.arrayIndex)")
                        
                        self.setLastLapInCurrentExercise(lastLapIndex: self.mainModelView.arrayRowIndex, isSetNextLapWorking: true)
                        
                        print("After arrayIndex:\(self.mainModelView.arrayIndex)")
                        
                        //Next array add time
                        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime = date
                        
                        let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.mainModelView.getSeconds(data: self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].rest)))
                        
                        let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].addedRestTime = convertToStringForRest
                        
                        //set true because we need last currentworking lap
                        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCurrentLapWorking = true
                        
                        //makeToast(strMessage: "ArrayIndex:\(self.mainModelView.arrayIndex) RowIndex:\(self.mainModelView.arrayRowIndex)")
                        
                        //    self.theController?.dismiss(animated: true, completion: nil)
                        self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex - 1, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)
                        
                        self.mainModelView.checkAndStart()
                        
                    }
                    
                    self.mainModelView.checkLinkAvailableOrNot()
                    
                    return
                    
                }else{
                    
                    mainView.countdownTimer.trailLineColor = .clear
                    mainView.countdownTimer.setNeedsDisplay()
                    
                    if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex + 1].data?[0].isCompleted == true && self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex+1].data?[0].isCompletedRest == true{
                        
                        self.setLastLapInCurrentExercise(lastLapIndex: self.mainModelView.arrayRowIndex, isSetNextLapWorking: false)
                        
                        //Color change of next buttion
                        self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: false)
                        
                        
                        //set true because we need last currentworking lap
                        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCurrentLapWorking = true
                        
                        //makeToast(strMessage: "ArrayIndex:\(self.mainModelView.arrayIndex) RowIndex:\(self.mainModelView.arrayRowIndex)")
                        
                        //    self.theController?.dismiss(animated: true, completion: nil)
                        self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)
                        
                    }else{
                        self.setLastLapInCurrentExercise(lastLapIndex: self.mainModelView.arrayRowIndex, isSetNextLapWorking: true)
                        
                        //set true because we need last currentworking lap
                        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCurrentLapWorking = true
                        
                        //Next array add time
                        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime = date
                        
                        let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.mainModelView.getSeconds(data: self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].rest)))
                        
                        let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].addedRestTime = convertToStringForRest
                        
                        
                        //makeToast(strMessage: "ArrayIndex:\(self.mainModelView.arrayIndex) RowIndex:\(self.mainModelView.arrayRowIndex)")
                        
                        //    self.theController?.dismiss(animated: true, completion: nil)
                        self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex - 1, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)
                        
                        self.mainModelView.checkAndStart()
                        
                    }
                    
                    self.mainModelView.checkLinkAvailableOrNot()
                    
                }
                
            }else{
                
                mainView.countdownTimer.trailLineColor = .clear
                mainView.countdownTimer.setNeedsDisplay()
                
                if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == false || self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == nil{
                    self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: true)
                }else{
                    self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: false)
                }
                
                //color change, no set further
                //                    self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: false)
                
                //                    self.setLastLapInCurrentExercise(lastLapIndex: self.mainModelView.arrayRowIndex, isSetNextLapWorking: false)
            }
            
            //set true because we need last currentworking lap
            self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCurrentLapWorking = true
            
            //makeToast(strMessage: "ArrayIndex:\(self.mainModelView.arrayIndex) RowIndex:\(self.mainModelView.arrayRowIndex)")
            
            //    self.theController?.dismiss(animated: true, completion: nil)
            self.mainModelView.delegate?.StartWorkoutFinish(tag: self.mainModelView.arrayIndex, exerciseAllArray: self.mainModelView.exerciseAllResistanceArray)
        }

        mainView.lblLapsCompleted.text = "\(self.mainModelView.checkCompletedLapsCount())/\(self.mainModelView.totalLapCount)"

    }
    
    func nextClickableOrNot(){
        
        //        if self.mainModelView.isDuration
        //        {
        
        if (self.mainModelView.arrayRowIndex + 1) != self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?.count {
            
            //check Next button clickable or not
            if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex+1].isCompleted == true && self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex+1].isCompletedRest == true{
                
                if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == false || self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == nil{
                    self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: true)
                }else{
                    self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: false)
                }
                
            }else{
                self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: true)
            }
            
        }
        else {
            
            //Check next button clickable or not
            if self.mainModelView.checkNextSectionIsAvailableOrNot(){
                
                if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex+1].data?[0].isCompleted == true && self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex+1].data?[0].isCompletedRest == true{
                    
                    if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == false || self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == nil{
                        self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: true)
                    }else{
                        self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: false)
                    }
                    
                }else{
                    self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: true)
                }
            }else{
                
                if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == false || self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCompleted == nil{
                    self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: true)
                }else{
                    self.mainModelView.ChangeNextWorkOutColorChange(isRedColor: false)
                }
                
            }
        }
    }
    
    func setLastLapInCurrentExercise(lastLapIndex:Int,isSetNextLapWorking:Bool){

        for i in 0..<self.mainModelView.exerciseAllResistanceArray.count{
            
            for j in 0..<(self.mainModelView.exerciseAllResistanceArray[i].data?.count ?? 0){
                
                guard let dict = self.mainModelView.exerciseAllResistanceArray[i].data?[j] else { return}
                
//                var dict = self.mainModelView.exerciseAllResistanceArray[i].data?[j]
                dict.isCurrentLapWorking = false
                self.mainModelView.exerciseAllResistanceArray[i].data?[j] = dict
            }
        }

        if isSetNextLapWorking{
            
            let dataDict = self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex]
            
            if let count = dataDict.data?.count{
                
                if count - 1 == lastLapIndex{
                    //Last lap
                    
                    if self.mainModelView.exerciseAllResistanceArray.count - 1 == self.mainModelView.arrayIndex{
                        //Last section
                        
                    }else{
                        self.mainModelView.arrayIndex += 1
                        self.mainModelView.arrayRowIndex = 0
                        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCurrentLapWorking = true
                    }
                    
                }else{
                    
                    self.mainModelView.arrayRowIndex += 1
                    
//                    print("arrayRowIndex:\(self.mainModelView.arrayRowIndex)")
//                    print("LastLapIndex:\(lastLapIndex+1)")
                    
                    self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isCurrentLapWorking = true
                }
            }
        }
    }
    
    func checkForRepeatSetPlayButton(){
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isRepeatSet == true{
            
            if self.mainModelView.arrayIndex == 0 && self.mainModelView.arrayRowIndex == 0{
                
                if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].repeatTime == ""{
                    
                    self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].repeatTime = date
                    
                    self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].pauseTime = date
                    self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].addedRestTime = date
                    
                    if self.mainModelView.isDuration{
                        self.mainModelView.timeCount = -1
                    }
                    
                    self.mainModelView.playNext()
                }
            }else{
                
                if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime == ""{
                    
                    self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime = date
                    
                    self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].pauseTime = date
                    self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].addedRestTime = date
                    
                    if self.mainModelView.isDuration{
                        self.mainModelView.timeCount = -1
                    }
                    
                    self.mainModelView.playNext()

                }
            }
        }
    }
    
    func checkForRepeatSetNextButton(){
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].isRepeatSet == true{
            
            if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].reps != "" && self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].reps != nil{
                
                if self.mainModelView.arrayIndex == 0 && self.mainModelView.arrayRowIndex == 0{
                    
                    if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].repeatTime == ""{
                        
                        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].repeatTime = date
                        
                    }
                }else{
                    
                    if self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime == ""{
                        
                        self.mainModelView.exerciseAllResistanceArray[self.mainModelView.arrayIndex].data?[self.mainModelView.arrayRowIndex].startTime = date
                        
                    }
                }
                
            }
        }
    }
    

    @objc func changeAnimation(){
        
        if isLongGestureForNext == false{
            UIView.animate(withDuration: 0.03, animations: {

                print("STart")
                
                self.mainView.btnNext.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
                self.mainView.btnNext.setTitleColor(.white, for: .normal)
                self.mainView.btnNext.setImage(UIImage(named: "ic_next_white_play"), for: .normal)

            }) { (status) in
                
                print("End")
                
                self.mainView.btnNext.backgroundColor = .white
                /*
                if self.mainModelView.index + 1  == self.mainModelView.exerciseArray.count{
                    if self.mainModelView.exerciseArray[self.mainModelView.index].rest == nil {
                        self.mainView.btnNext.setTitleColor(.black, for: .normal)
                        self.mainView.btnNext.setImage(UIImage(named: "ic_next_black"), for: .normal)

                    }else{
                        if self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == true && (self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == false || self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == nil) {
                            self.mainView.btnNext.setTitleColor(.black, for: .normal)
                            self.mainView.btnNext.setImage(UIImage(named: "ic_next_black"), for: .normal)
                        }else{
                            self.mainView.btnNext.setTitleColor(.appthemeOffRedColor, for: .normal)
                            self.mainView.btnNext.setImage(UIImage(named: "ic_next-1"), for: .normal)
                        }
                    }
                }else{*/
                    self.mainView.btnNext.setTitleColor(.appthemeOffRedColor, for: .normal)
                    self.mainView.btnNext.setImage(UIImage(named: "ic_next-1"), for: .normal)
//                }
            }
        }else{
            isLongGestureForNext = false
        }

    }
    
    @objc func durationTimerChange(){
        
        if self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime == ""{
            return
        }
        
        let secondDifference = self.mainModelView.exerciseAllResistanceArray[0].data?[0].startTime.convertDateFormater().secondDifference(to: Date())
        //        print("Total Duration secondDifference:\(secondDifference)")
//        self.mainModelView.totalDurationInSecond = secondDifference
//        if self.mainModelView.activityName.lowercased() == "Run (Outdoor)".lowercased() || self.mainModelView.activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
//        }

        let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: secondDifference ?? 0)
        
        mainView.lblTotalDuration.text = self.mainModelView.makeTimeString(h: h1, m: m1, s: s1)
    }

    @objc func updateVoume(notification: Notification){
        
        if let dataDict = notification.userInfo as? [String:Any] {
            print("dataDict:\(dataDict)")
            
            self.mainModelView.targetedVolume = dataDict["targetdVolume"] as? Int ?? 0
            self.mainModelView.completedVolume = dataDict["completedVolume"] as? Int ?? 0
            
            if self.mainView.btnChangeableParameter.isSelected{
                self.mainView.lblChangeableParameterValue.text = "\(self.mainModelView.targetedVolume)"
            }else{
                self.mainView.lblChangeableParameterValue.text = "\(self.mainModelView.completedVolume)"
            }

        }
    }

    //MARK: - For screen shots
    open func takeScreenshot() -> UIImage? {
        
        return UIGraphicsImageRenderer(size: self.view.bounds.size).image { _ in
            self.view.drawHierarchy(in: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), afterScreenUpdates: true)
        }
    }

}

//MARK: - ScrollView delegate

extension StartWorkoutResistanceVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(self.mainView.scrollHorizontal.contentOffset.x/view.frame.width)
        self.mainView.pageControl.currentPage = Int(pageIndex)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
       scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func playVideoInView(strVideoURL:String)
    {
        let playerViewController = AVPlayerViewController()
        //        present(playerViewController, animated: true)
        playerViewController.view.frame = CGRect(x: 0, y: 0, width: self.mainView.vwYoutubeVideo.frame.width, height:self.mainView.vwYoutubeVideo.frame.height)
        self.mainView.vwYoutubeVideo.addSubview(playerViewController.view)
        self.addChild(playerViewController)
        weak var weakPlayerViewController: AVPlayerViewController? = playerViewController
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
        } catch(let error) {
            print(error.localizedDescription)
        }

        XCDYouTubeClient.default().getVideoWithIdentifier(strVideoURL) { [weak self] (video, error) in
            /*if let obj = self {
             obj.theCurrentView.statusActivityIndicator(isLoading: false, activityIndicator: obj.theCurrentView.activityIndicator)
             }*/
            
            print("Error:\(error?.localizedDescription)")
            print("strVideoURL:\(strVideoURL)")
            
            if video != nil {
                var streamURLs = video?.streamURLs
                let streamURL = streamURLs?[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs?[NSNumber(value: XCDYouTubeVideoQuality.HD720.rawValue)] ?? streamURLs?[NSNumber(value: XCDYouTubeVideoQuality.medium360.rawValue)] ?? streamURLs?[NSNumber(value: XCDYouTubeVideoQuality.small240.rawValue)]
                if let streamURL = streamURL {
                    weakPlayerViewController?.player = AVPlayer(url: streamURL)
                }
//                weakPlayerViewController?.player?.play()
                weakPlayerViewController?.entersFullScreenWhenPlaybackBegins = true
                
            } else {
                //                self?.dismiss(animated: true)
            }
        }
        
    }

}
