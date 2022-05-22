//
//  StartWorkoutVC.swift
//  Load
//
//  Created by Haresh Bhai on 03/10/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreMotion
import SwiftyJSON
import GoogleMaps
import Polyline


class StartWorkoutVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: StartWorkoutView = { [unowned self] in
        return self.view as! StartWorkoutView
        }()
    
    lazy var mainModelView: StartWorkoutViewModel = {
        return StartWorkoutViewModel(theController: self)
    }()
    
    //MARK: - Variable
    
    private let activityManager = CMMotionActivityManager()
    private let pedometer = CMPedometer()
    
    var handlerForPassPedometerDistancePace : (Double,Double?) -> Void = { _,_ in}
    var handlerForPassPedometerDate : (Date) -> Void = { _ in}
    var handlerForPassDataOfParticularLapWithPolyline : (String, Double) -> Void = { _ , _ in}
    var handlerNetElevationGain : (Double) -> Void = { _ in}
    var handlerForIndoorParticularLapForReset: (Double) -> Void = {_ in}

    var nextVariableCount = 1
    var isAvgSpeedOrPace = true
    var isSpeed = true
    var timerForMotion : Timer?
    var countForMotion = 0
    
    var countForTotalStationaryTime = 0
    
    var isAutoPauseCheckForAlert = false
    var isEndAlertShowing = false
    var dateClickonEndButton = Date()
    var dateClickOnPauseButton = Date()
    
    var distanceOfLapForIndoor = CGFloat()
    
    var isLongGestureForEnd = false
    var isLongGestureForRepeat = false
    var isLongGestureForNext = false
    
    //For outdoors
    var lattitude  = Double()
    var longitude = Double()
    var arrWayPoint: [CLLocationCoordinate2D] = []
    
    var totalAltitude = 0.0
    //main Distance and Index
    var lastIndex = 0
    var totalDistancConverted = 0.0
    //--------------------
    
    //Inner lap index
    var lastLapIndex = 0
    var lapCoveredDistance = 0.0
    
    var netElevationGain = 0.0
    
    //check user click on manual pause/play or autopause/play
    var isCheckForAutoPause = false
    
    //pass calculated speed value in this variable so user change paramter that time show value instead of 0.0 or 00:00
    var calculatedSpeed :CGFloat = 0.0
    
    //timer for pause
    
    var timerForPauseView : Timer?

    //MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        self.mainView.mapView.isMyLocationEnabled = true
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapBtnEnd))
        self.mainView.btnEndWokrout.addGestureRecognizer(longGesture)

        let longGestureRepeat = UILongPressGestureRecognizer(target: self, action: #selector(longTapBtnRepeat))
        self.mainView.btnRepeat.addGestureRecognizer(longGestureRepeat)
        
        let longGestureNext = UILongPressGestureRecognizer(target: self, action: #selector(longTapBtnNext))
        self.mainView.btnNext.addGestureRecognizer(longGestureNext)
        
        let activityName = self.mainModelView.activityName.lowercased()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            let dateStart = self.mainModelView.exerciseArray[0].startTime == "" ? Date() : self.mainModelView.exerciseArray[0].startTime.convertDateFormater()
            
            self.handlerForPassPedometerDate(dateStart)
            
            //Pass only for indoor activities outdoor depend on GPS location
            
            if activityName == "Outdoor".lowercased() {
                self.checkLocationPermissionAvailableOrNot()
                AppDelegate.shared.locationManager.allowsBackgroundLocationUpdates = true
            }else{
                self.startUpdating(fromDate: dateStart)
            }
            //            self.updateStepsCountLabelUsing(startDate: dateStart)
        }
        
        //For Right/left animation set translation in map
        self.mainView.mapView.transform = CGAffineTransform(translationX: self.mainView.mapView.frame.size.width, y: 0)
        
        //get last value ane assign value of that
        if let value = Defaults.value(forKey: self.mainModelView.trainingProgramId + " " + "Program") as? Int{
            print("Program value:\(value)")
            countForTotalStationaryTime = Int(value)
        }
        
        //MARK: - COMMENT CHECK
        //Get data from database
        
        /*
        let routeObjects = Array(realm.objects(CardioActivityRouteTrainingProgram.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}
        
        if routeObjects.count > 0{
            
            try! realm.write{
                self.drawTotalPath(strPolyLine: routeObjects[0].allTrackRoute)
            }
        }
        */
        guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
            return
        }
        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}

        if routeObjects.count > 0{
            self.totalDistancConverted = routeObjects[0].totalCoveredDistance
            self.mainView.lblTotalDistance.text = self.setOneDigitWithFloor(value: (CGFloat((totalDistancConverted)/1000)))

            self.lapCoveredDistance = routeObjects[0].lapArray[self.mainModelView.getCurrenIndexOfCurrentLap()].lapCoverDistance
            self.isCheckForAutoPause = routeObjects[0].isAutomaticallyPause

            if self.mainModelView.exerciseArray[self.mainModelView.getCurrenIndexOfCurrentLap()].isCompleted == false || self.mainModelView.exerciseArray[self.mainModelView.getCurrenIndexOfCurrentLap()].isCompleted == nil{
                
                if !(self.mainModelView.exerciseArray[self.mainModelView.getCurrenIndexOfCurrentLap()].updatedDuration != nil && self.mainModelView.exerciseArray[self.mainModelView.getCurrenIndexOfCurrentLap()].updatedDuration != "") {
                    self.mainView.lblCount.text = self.setOneDigitWithFloor(value: (CGFloat(lapCoveredDistance)/1000))
                }
            }
            
            //Finding avg speed when user enter the screen otherwise wait for 3 seconds
            
            let saveAvgSpeed = routeObjects[0].averageSpeed
            self.calculatedSpeed = CGFloat(saveAvgSpeed)

            let speedinOneDigit = self.setOneDigitWithFloor(value: CGFloat(saveAvgSpeed))
            
            if self.isAvgSpeedOrPace {
                if self.isSpeed == true{ // speed
                    if calculatedSpeed < 0.0{
                        self.mainView.lblChangeableParameterValue.text = "0.0"
                    }else{
                        self.mainView.lblChangeableParameterValue.text = speedinOneDigit
                        //                            oneDigitAfterDecimal(value: Float(speed), digit: 1)
                    }
                }else if self.isSpeed == false{ // pace
                    
                    let twoDigitForPace = "\((floor(60 / self.calculatedSpeed * 100) / 100))"
                    self.mainView.lblChangeableParameterValue.text = self.calculatePaceInTimeFormate(value: twoDigitForPace.toFloat())
                }
            }

            
            self.netElevationGain = routeObjects[0].elevationGain
/*
            let totalActiveDurationSecond = self.mainModelView.totalDurationInSecond - self.countForTotalStationaryTime
            
            let speed = (CGFloat(self.totalDistancConverted)/CGFloat(totalActiveDurationSecond)) * 3.6
            
            let speedinOneDigit = self.setOneDigitWithFloor(value: speed)

            
            */
            /*
            if self.isAvgSpeedOrPace {
                if self.isSpeed == true{ // speed
                    if speed < 0.0{
                        self.mainView.lblChangeableParameterValue.text = "0.0"
                    }else{
                        self.mainView.lblChangeableParameterValue.text = speedinOneDigit
                        //                            oneDigitAfterDecimal(value: Float(speed), digit: 1)
                    }
                }else if self.isSpeed == false{ // pace
                    
                    let twoDigitForPace = "\((floor(60 / self.calculatedSpeed * 100) / 100))"
                    self.mainView.lblChangeableParameterValue.text = self.calculatePaceInTimeFormate(value: twoDigitForPace.toFloat())
                }
            }*/

//            self.lapCoveredDistance = routeObjects[0].lapArray[self.mainModelView.index].lapCoverDistance
//            self.mainView.lblCount.text = self.setOneDigitWithFloor(value: (CGFloat(lapCoveredDistance)/1000))
        }
        
        //delegate for finding user lat/long
        // get and show google route data in viewModel bcz while opening screen user get latest data otherwise show 0.0
        //TOtal Distance set 0 automatically that's why first assign value and after call method
        
        if activityName == "Outdoor".lowercased() {
            AppDelegate.shared.delegateUpadateLatLong = self
            AppDelegate.shared.locationManager.startUpdatingLocation()
        }

        self.mainView.mapView.camera = GMSCameraPosition(target: CLLocationCoordinate2D(latitude: userCurrentLocation?.coordinate.latitude ?? 0, longitude: userCurrentLocation?.coordinate.longitude ?? 0), zoom: 6)
        
        // Do any additional setup after loading the view.
    }
    
    
    deinit {
        print("Deallocate :\(self)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(updateTotalDistance(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_TRAINING_PROGRAM_CARDIO_TOTAL_DISTANCE.rawValue), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if self.mainModelView.timerUpdate != nil{
            mainModelView.timerUpdate?.invalidate()
            mainModelView.timerUpdate = nil
        }
        
        if self.timerForMotion != nil{
            self.timerForMotion?.invalidate()
            self.timerForMotion = nil
        }
        
        self.activityManager.stopActivityUpdates()
        self.pedometer.stopUpdates()
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_TRAINING_PROGRAM_CARDIO_TOTAL_DISTANCE.rawValue), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    //MARK: - IBAction methods
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.mainModelView.closeView()
    }
    
    
    @objc func longTapBtnNext(_ sender: UIGestureRecognizer){
        print("Long tap Next")
        if sender.state == .ended {
            self.mainView.btnNext.setTitleColor(.appthemeOffRedColor, for: .normal)
            self.mainView.btnNext.backgroundColor = .white
            
            //            self.mainView.btnRepeat.backgroundColor = .white
            //            self.mainView.btnRepeat.setTitleColor(.appthemeRedColor, for: .normal)
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
    
    
    @objc func changeAnimation(){
        
        if isLongGestureForNext == false{
            UIView.animate(withDuration: 0.03, animations: {

                self.mainView.btnNext.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
                self.mainView.btnNext.setTitleColor(.white, for: .normal)
                self.mainView.btnNext.setImage(UIImage(named: "ic_next_white_play"), for: .normal)

            }) { (status) in
                self.mainView.btnNext.backgroundColor = .white
                if self.mainModelView.index + 1  == self.mainModelView.exerciseArray.count{
                    if self.mainModelView.exerciseArray[self.mainModelView.index].updatedRest == nil {
                        self.mainView.btnNext.setTitleColor(.black, for: .normal)
                        self.mainView.btnNext.setImage(UIImage(named: ""), for: .normal)

                    }else{
                        if self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == true && (self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == false || self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == nil) {
                            self.mainView.btnNext.setTitleColor(.black, for: .normal)
                            self.mainView.btnNext.setImage(UIImage(named: ""), for: .normal)
                        }else{
                            self.mainView.btnNext.setTitleColor(.appthemeOffRedColor, for: .normal)
                            self.mainView.btnNext.setImage(UIImage(named: "ic_next-1"), for: .normal)
                        }
                    }
                }else{
                    self.mainView.btnNext.setTitleColor(.appthemeOffRedColor, for: .normal)
                    self.mainView.btnNext.setImage(UIImage(named: "ic_next-1"), for: .normal)
                }
            }
        }else{
            isLongGestureForNext = false
        }

    }
    @IBAction func btnNextClicked(_ sender: Any) {
        //        self.mainModelView.timer?.invalidate()
        //        self.mainModelView.timer = nil
        
        self.perform(#selector(changeAnimation), with: nil, afterDelay: 0.02)
        
        if self.mainModelView.exerciseArray.count > 0{
            if self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompletedRest == true{
                return
            }
        }
        
        let activityName = self.mainModelView.activityName.lowercased()

        if self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == false || self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == nil{
            if self.mainModelView.timeCount != 0 {
                //                self.mainModelView.exerciseArray[self.mainModelView.index].completeTime = NSNumber(integerLiteral: self.mainModelView.timeCount)
            }
            self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted = true
            self.mainModelView.exerciseArray[self.mainModelView.index].isClickOnPause = false

//            self.lapCoveredDistance = 0
            
            removeTimerOfMotion()
            if self.mainModelView.isPaused == true{
                
                if !(activityName == "Outdoor".lowercased()){

                    let secondDifference = self.mainModelView.exerciseArray[self.mainModelView.index].pauseTime.convertDateFormater().secondDifference(to: Date())
                    //For Main TotalDuration
                    let valueAddigForAddRestTime = self.mainModelView.exerciseArray[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
                    
                    let convertToStringForAddRestTime = valueAddigForAddRestTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    self.mainModelView.exerciseArray[0].startTime = convertToStringForAddRestTime
                    //

                }
                
                self.mainModelView.exerciseArray[self.mainModelView.index].isPause = false
                self.mainModelView.exerciseArray[self.mainModelView.index].pauseTime = ""
                self.isPauseShow(isShow: false)
                
            }else{
                
            }
            
            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            
            print("Before addedResttime :\(self.mainModelView.exerciseArray[self.mainModelView.index].addedRestTime)")
            
            let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.mainModelView.getSeconds(data: self.mainModelView.exerciseArray[self.mainModelView.index].updatedRest)))
            
            let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            print("convertToStringForRest : \(convertToStringForRest)")
            self.mainModelView.exerciseArray[self.mainModelView.index].addedRestTime = convertToStringForRest
            
            print("After added Rest time :\(self.mainModelView.exerciseArray[self.mainModelView.index].addedRestTime)")
            
            //Set next lap completed or not directly by checking next laps value
            
            if self.mainModelView.index == self.mainModelView.exerciseArray.count - 1{
                
            }
            else{
                
                if self.mainModelView.exerciseArray[self.mainModelView.index].updatedRest == nil || self.mainModelView.exerciseArray[self.mainModelView.index].updatedRest == ""{
                    
                    self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest = true

                    if (self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedDuration == nil || self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedDuration == "") && (self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedDistance == nil || self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedDistance == 0.0){
                        
                        self.mainModelView.exerciseArray[self.mainModelView.index+1].isCompleted = true
     //                   self.mainModelView.exerciseArray[self.mainModelView.index+1].startTime = date

                        if self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedRest == "" || self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedRest == nil{
                            
                            self.mainModelView.exerciseArray[self.mainModelView.index+1].isCompletedRest = true

                            if self.mainModelView.index+2 == self.mainModelView.exerciseArray.count{
                                
                            }else{
//                                self.mainModelView.exerciseArray[self.mainModelView.index+1].isCompletedRest = true
                            }
                        }else{
                           //next completed rest not blank so it's not true
                        }
                        
                    }else{
                        //current completedRest true
                    }
                    
                }else{
                    
                }
                
            }
            
            print("Exercise Array:\(self.mainModelView.exerciseArray.toJSON())")
            
            self.mainModelView.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.mainModelView.exerciseArray)
            
        }
        else {
            self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest = true
            self.nextVariableCount = 0
            
            if self.mainModelView.isPaused == true{
                
                let activityName = self.mainModelView.activityName.lowercased()
                if !(activityName == "Outdoor".lowercased()){
                    let secondDifference = self.mainModelView.exerciseArray[self.mainModelView.index].pauseTime.convertDateFormater().secondDifference(to: Date())
                    //For Main TotalDuration
                    let valueAddigForAddRestTime = self.mainModelView.exerciseArray[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
                    
                    let convertToStringForAddRestTime = valueAddigForAddRestTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    self.mainModelView.exerciseArray[0].startTime = convertToStringForAddRestTime

                }

            }
            
            self.mainModelView.exerciseArray[self.mainModelView.index].isClickOnPause = false

            self.mainModelView.exerciseArray[self.mainModelView.index].isPause = false
            self.mainModelView.exerciseArray[self.mainModelView.index].pauseTime = ""

            self.isPauseShow(isShow: false)
        }
        
        //Click on next button after rest get update data in Rest
        self.clickOnNextAndForRest()
        
        //        self.mainModelView.delegate?.StartWorkoutFinish(isDone: false, tag: self.mainModelView.arrayIndex, exerciseArray: self.mainModelView.exerciseArray)
        //        self.mainView.btnNext.isUserInteractionEnabled = false
        
        if (activityName == "Outdoor".lowercased()){
            guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                return
            }
            
            let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}

            if routeObjects.count > 0{
                
                lapCoveredDistance = 0.0
                
                let strPolyLine = routeObjects[0].allTrackRoute
                handlerForPassDataOfParticularLapWithPolyline(strPolyLine, 0)
            }
            
        } else {
            handlerForIndoorParticularLapForReset(0)
            self.distanceOfLapForIndoor = 0
            self.reCallMainCountingStep()

        }

        self.mainModelView.checkAndStart()
        
    }
    
    @IBAction func btnMapClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            
            self.mainView.vwCounterAndText.transform = CGAffineTransform(translationX: 0, y: 0)
            self.mainView.mapView.transform = CGAffineTransform(translationX: self.mainView.mapView.frame.size.width, y: 0)
            
            DispatchQueue.main.async {
                self.mainModelView.setUpPinOnMap(lat: userCurrentLocation?.coordinate.latitude ?? 0, long: userCurrentLocation?.coordinate.longitude ?? 0)
            }
            
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseInOut,
                           animations: {
                            self.mainView.vwCounterAndText.transform = CGAffineTransform(translationX: -self.mainView.vwCounterAndText.frame.size.width, y: 0)
                            
                            self.mainView.mapView.transform = CGAffineTransform(translationX: 0, y: 0)
            },completion: { finished in
            })
        }
        else {
            
            self.mainView.vwCounterAndText.transform = CGAffineTransform(translationX: -self.mainView.vwCounterAndText.frame.size.width , y: 0)
            self.mainView.mapView.transform = CGAffineTransform(translationX: 0, y: 0)
            
            
            UIView.animate(withDuration: 0.5,
                           delay: 0.0,
                           options: UIView.AnimationOptions.curveEaseInOut,
                           animations: {
                            self.mainView.vwCounterAndText.transform = CGAffineTransform(translationX: 0, y: 0)
                            self.mainView.mapView.transform = CGAffineTransform(translationX: self.mainView.mapView.frame.size.width, y: 0)
            },completion: { finished in
            })
            
        }
        
    }
    
    
    @objc func longTapBtnEnd(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            self.mainView.btnEndWokrout.backgroundColor = .white
            self.mainView.btnEndWokrout.setTitleColor(.appthemeOffRedColor, for: .normal)
            self.btnEndWorkoutClicked(self.mainView.btnEndWokrout)
        }
        else if sender.state == .began {
            print("Began")
            self.isLongGestureForEnd = true
            self.mainView.btnEndWokrout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
            self.mainView.btnEndWokrout.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func btnEndWorkoutClicked(_ sender: Any) {
        
        let imageOfScreen = takeScreenshot()
        self.mainModelView.handlerFinishWorkoutOnEndClick(imageOfScreen)
        
        if isLongGestureForEnd == false{
            UIView.animate(withDuration: 0.05, animations: {
                self.mainView.btnEndWokrout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
                self.mainView.btnEndWokrout.setTitleColor(.white, for: .normal)
            }) { (status) in
                self.mainView.btnEndWokrout.backgroundColor = .white
                self.mainView.btnEndWokrout.setTitleColor(.appthemeOffRedColor, for: .normal)
            }
        }else{
            isLongGestureForEnd = false
        }
        
        if self.mainModelView.exerciseArray[0].startTime == ""{
            return
        }
        
        setVibration()
        
        let secondDifference = self.mainModelView.exerciseArray[0].startTime.convertDateFormater().secondDifference(to: Date())
        print("secondDifference:\(secondDifference)")
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        print("date:\(date)")
        
        self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].endTime = date
        
        dateClickonEndButton = Date()
        self.removeTimerOfMotion()
        
        if !self.mainModelView.isPaused{
            if !(self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompletedRest == true){
                self.mainModelView.isPaused = true
                self.mainView.countdownTimer.pause()
                self.mainModelView.exerciseArray[self.mainModelView.index].isPause = true
                self.mainModelView.exerciseArray[self.mainModelView.index].pauseTime = date
            }
        }
        
        if self.mainModelView.timerUpdate != nil{
            mainModelView.timerUpdate?.invalidate()
            mainModelView.timerUpdate = nil
        }
        
        self.mainModelView.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.mainModelView.exerciseArray)
        
        self.isEndAlertShowing = true

        //30 second old flow commented because anna said it's outdated flow in skype.
        
//        if secondDifference <= 30{
//            self.mainModelView.showResumeAlert()
//        }else{
        
            endWorkoutAlert()
//        }
    }
        
    @IBAction func btnPauseClicked(_ sender: UIButton) {
        
        if self.mainModelView.exerciseArray.count > 0{
            if self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompletedRest == true{
                
                if self.mainModelView.activityName.lowercased() == "Outdoor".lowercased() {
                    
                    //After client stop work
                    /*
                    if !self.mainModelView.isPaused {
                        
                        self.removeTimerOfMotion()

                        if self.timerForMotion == nil{
                            self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
                        }
                    }*/
                    guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                        return
                    }
                    let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}

                    if routeObjects.count > 0 {
                        
                        try? realm?.write{
                            routeObjects[0].isPauseAfterAllLapCompleted = false

                        }
                    }
                }
                
                return
            }
        }
        
        sender.isSelected = !sender.isSelected
        self.mainModelView.isPaused = !self.mainModelView.isPaused

        self.mainModelView.handlerPauseOrNot(self.mainModelView.isPaused)
        self.mainModelView.exerciseArray[self.mainModelView.index].isPause = self.mainModelView.isPaused
        
        self.isPauseShow(isShow: self.mainModelView.isPaused)
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        if self.mainModelView.timerUpdate != nil{
            mainModelView.timerUpdate?.invalidate()
            mainModelView.timerUpdate = nil
        }
        
        if self.mainModelView.isPaused{
            //Add currently show last pause time on screen
            self.mainModelView.exerciseArray[self.mainModelView.index].lastPauseTime = self.mainView.lblCount.text ?? ""
            
            if self.mainModelView.activityName.lowercased() == "Outdoor".lowercased(){
                
//                if  self.isCheckForAutoPause == true{
                    self.mainModelView.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.durationTimerChange), userInfo: nil, repeats: true)
//                }
            }
        }
        
        guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
            return
        }
        
        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}

        try? realm?.write{
            
            if routeObjects.count > 0{
                routeObjects[0].isAutomaticallyPause = false
                self.isCheckForAutoPause = false
            }
        }
        
        if !self.mainModelView.isPaused {
            //While auto pause that time after 1-2 second it's pause so timer set to nil
            self.removeTimerOfMotion()
            
            self.mainView.countdownTimer.resume()
            
            self.mainModelView.exerciseArray[self.mainModelView.index].isClickOnPause = false
//            self.isClickOnPause = false
            //uncomment for if play/pause time changes in particular lap
            
//            if self.mainModelView.exerciseArray[0].updatedDuration == "" || self.mainModelView.exerciseArray[0].updatedDuration == nil{
//                print("Disance not need to change anything")
//            }else{
            
            let secondDifference = self.mainModelView.exerciseArray[self.mainModelView.index].pauseTime.convertDateFormater().secondDifference(to: Date())
            
            print("secondDifference:\(secondDifference)")
            
            //added uper side of condition
            
            if self.mainModelView.activityName.lowercased() == "Outdoor".lowercased() {
                
                if self.timerForMotion == nil{
                    self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
                }
                isCheckForAutoPause = false
                
            }else{
                
                print("Before Start Time:\(self.mainModelView.exerciseArray[0].startTime)")

                let valueAddigForAddRestTime = self.mainModelView.exerciseArray[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
                
                let convertToStringForAddRestTime = valueAddigForAddRestTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                self.mainModelView.exerciseArray[0].startTime = convertToStringForAddRestTime
                
                print("After Start Time:\(self.mainModelView.exerciseArray[0].startTime)")

            }
            
            //for indoor start time change so total duration set as same

            if self.mainModelView.index == 0 {
                
                let valueAddigForAddRestTime = self.mainModelView.exerciseArray[self.mainModelView.index].repeatTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
                
                let convertToStringForAddRestTime = valueAddigForAddRestTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                self.mainModelView.exerciseArray[self.mainModelView.index].repeatTime = convertToStringForAddRestTime
                
            }else{
                
                let valueAddigForAddRestTime = self.mainModelView.exerciseArray[self.mainModelView.index].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
                
                let convertToStringForAddRestTime = valueAddigForAddRestTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                self.mainModelView.exerciseArray[self.mainModelView.index].startTime = convertToStringForAddRestTime
                
            }
                
                self.mainModelView.exerciseArray[self.mainModelView.index].pauseTime = ""

                print("Add Rest time \(self.mainModelView.exerciseArray[self.mainModelView.index].addedRestTime)")
                
                let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")

                let valueAddigForRest = self.mainModelView.exerciseArray[self.mainModelView.index].addedRestTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))

                let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                self.mainModelView.exerciseArray[self.mainModelView.index].addedRestTime = convertToStringForRest
                
                print("After Added Rest time \(self.mainModelView.exerciseArray[self.mainModelView.index].addedRestTime)")
                
                //Currently set here it's work but for pause this line added below
//                self.mainModelView.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.mainModelView.exerciseArray)
                
//            }
            
            if self.mainModelView.activityName.lowercased() == "Outdoor".lowercased() {

            } else {
                self.reCallMainCountingStep()
                if let valueForIndoor = Defaults.value(forKey: "trainingProgram Indoor \(self.mainModelView.trainingProgramId)") as? Double{
                    
                    print("ValueForIndoor:\(valueForIndoor)")
                    
                    Defaults.removeObject(forKey: "trainingProgram Indoor \(self.mainModelView.trainingProgramId)")
                    Defaults.synchronize()
                }
            }
            
        }else{
            self.mainView.countdownTimer.pause()
            
            self.mainModelView.exerciseArray[self.mainModelView.index].isClickOnPause = true
//            self.isClickOnPause = true
            //uncomment for if play/pause time changes in particular lap
            
            if self.mainModelView.exerciseArray[0].updatedDuration == "" || self.mainModelView.exerciseArray[0].updatedDuration == nil{
                print("This is for Distance so no need to add time while pause")
            }else{
                print("This is for duration so we need to add second difference while pause/play")
//                self.dateClickOnPauseButton = Date()
            }
            
            self.mainModelView.exerciseArray[self.mainModelView.index].pauseTime = date

            if self.mainModelView.activityName.lowercased() == "Outdoor".lowercased() {

            } else {
                if self.mainModelView.isRest == false && self.mainModelView.isDuration == false{
                    Defaults.set(self.distanceOfLapForIndoor, forKey: "trainingProgram Indoor \(self.mainModelView.trainingProgramId)")
                    Defaults.synchronize()
                }
            }

        }
        
        self.mainModelView.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.mainModelView.exerciseArray)
    }
    
    @IBAction func btnChangeDetailTapped(_ sender: UIButton) {
        self.checkChangeAbleParameter()
    }

    @objc func longTapBtnRepeat(_ sender: UIGestureRecognizer){
        print("Long tap Repeat")
        if sender.state == .ended {
            self.mainView.btnRepeat.setColor(color: .black)
            self.mainView.vwRepeat.borderColors = UIColor.black
            self.mainView.vwRepeat.shadowColors = .clear
            self.mainView.btnRepeat.backgroundColor = .white

//            self.mainView.btnRepeat.backgroundColor = .white
//            self.mainView.btnRepeat.setTitleColor(.appthemeRedColor, for: .normal)
            self.btnRepeatWorkoutTapped(self.mainView.btnRepeat)
        }
        else if sender.state == .began {
            print("Began")
            self.isLongGestureForRepeat = true
            self.mainView.btnRepeat.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
            self.mainView.btnRepeat.setTitleColor(.white, for: .normal)
        }
    }

    
    @IBAction func btnRepeatWorkoutTapped(_ sender: UIButton) {
        //        self.mainModelView.delegate?.repeatWokout()
        //        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
        
        if isLongGestureForRepeat == false{
            UIView.animate(withDuration: 0.05, animations: {
                self.mainView.btnRepeat.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
                self.mainView.btnRepeat.setTitleColor(.white, for: .normal)
            }) { (status) in
                self.mainView.btnRepeat.backgroundColor = .white
                self.mainView.btnRepeat.setTitleColor(.appthemeOffRedColor, for: .normal)
            }
        }else{
            isLongGestureForRepeat = false
        }
        
        mainView.lblTotalTimeAndDistance.textColor = .black
        
        if self.mainModelView.timerUpdate != nil{
            mainModelView.timerUpdate?.invalidate()
            mainModelView.timerUpdate = nil
        }
        
        //For repeat that time first time solderline appear
//        self.mainView.countdownTimer.isSolidLine = true

        self.mainView.btnPlayPause.isUserInteractionEnabled = true
        self.mainView.btnPlayPause.setImage(UIImage(named: "ic_pause"), for: .normal)
        self.mainView.btnPlayPause.setImage(UIImage(named: "ic_play_long"), for: .selected)
        
        self.mainModelView.isRepeatExercise = true
        mainView.btnNext.isUserInteractionEnabled = true
        mainView.btnNext.setImage(mainView.btnNext.imageView?.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        mainView.btnNext.tintColor = UIColor.appthemeRedColor
        
        self.setExerciseArrayForRepeat()
        print("After Exercise Array:\(self.mainModelView.exerciseArray.toJSON())")
        
        self.mainModelView.delegate?.currentWorkedLapIndex(index: 0)
        
        let activityName = self.mainModelView.activityName.lowercased()
        if activityName == "Outdoor".lowercased() {
            
            self.removeTimerOfMotion()
            
            if self.timerForMotion == nil{
                self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
            }
            
            if self.mainModelView.exerciseArray[self.mainModelView.index].updatedDuration == nil || self.mainModelView.exerciseArray[self.mainModelView.index].updatedDuration == ""{
                
                try? realm?.write{
                    guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                        return
                    }
                    
                    let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}

                    if routeObjects.count > 0 {
                        
                        //We cannot Righ last index endTo because user also walk some km afrer complete lap so we have to take start of that repeat and recent value of Index passes
//                        let lastIndex = routeObjects[0].lapArray.count - 1
//                        routeObjects[0].lapArray[lastIndex].endTo
                        let startingIndex = self.lastIndex
                        
                        for i in 0..<routeObjects[0].lapArray.count{
                            routeObjects[0].lapArray[i].lapCoverDistance = 0
                        }
                        
                        routeObjects[0].isAutomaticallyPause = false
                        routeObjects[0].isPauseAfterAllLapCompleted = false
                        lapCoveredDistance = 0.0
                        
                        let strPolyLine = routeObjects[0].allTrackRoute
                        handlerForPassDataOfParticularLapWithPolyline(strPolyLine, 0)
                        
                    }
                }
            }
            
        }else{
            
            handlerForIndoorParticularLapForReset(0)
            self.distanceOfLapForIndoor = 0
            self.reCallMainCountingStep()

        }
        
        self.mainModelView.isPaused = false
        self.mainModelView.index = 0
        self.mainModelView.checkAndStart()

     //   self.mainModelView.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.mainModelView.exerciseArray)

    }
    
    func endWorkoutAlert(){
        
        let alertController = UIAlertController(title: getCommonString(key: "End_Workout_key"), message: getCommonString(key: "Do_you_want_to_stop_the_workout_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            self.mainModelView.finishWorkout()
            self.mainModelView.delegate?.closeViewDismissSelectLocationProgram()
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.cancel) { [self] (result : UIAlertAction) -> Void in
            print("Cancel")
            
            self.mainModelView.handlerFinishWorkoutOnEndClick(nil)
            
            self.isEndAlertShowing = false
            
            let miliseconds = String(Date().timeIntervalSince(self.dateClickonEndButton))
            print("Milisecond \(miliseconds)")

            //Set for Outdoor only
            var secondDifferenceForOutdoor = 0
            if miliseconds.contains("."){
                let array = miliseconds.split(separator: ".")
                
                let firstIndex = array[0]
                let secondIndex = array[1]
                
                if ("0.\(secondIndex)").toFloat() > 0.5{
                    secondDifferenceForOutdoor = (Int(String(firstIndex)) ?? 1) + 1
                }else{
                    secondDifferenceForOutdoor = Int(String(firstIndex)) ?? 0
                }
            }
            
            
            //Before in below condition set as AUR Codition Now set And Condition for futher issue check with AUR
            if self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompletedRest == true{
                print("Return call")
                self.mainModelView.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.durationTimerChange), userInfo: nil, repeats: true)
                
                //This is applies for both otherwise Total Duration value jump
                let valueAddigForStartTimeForOutdoor = self.mainModelView.exerciseArray[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifferenceForOutdoor))
                let convertToStringForStartTimeForOutDoor = valueAddigForStartTimeForOutdoor.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                self.mainModelView.exerciseArray[0].startTime = convertToStringForStartTimeForOutDoor

                self.mainModelView.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.mainModelView.exerciseArray)
                
                return
            }
            
            //For indoor n all
            let secondDifference = self.mainModelView.exerciseArray[self.mainModelView.index].pauseTime.convertDateFormater().secondDifference(to: Date())

            print("After Start Time:\(self.mainModelView.exerciseArray[0].startTime)")
            
            let valueAddigForStartTime = self.mainModelView.exerciseArray[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
            let convertToStringForStartTime = valueAddigForStartTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            //TODO: - Comments this line because  check for Out door scenario
//            self.mainModelView.exerciseArray[0].startTime = convertToStringForStartTime
            
            print("Start Time:\(self.mainModelView.exerciseArray[0].startTime)")
            
            if self.mainModelView.exerciseArray[self.mainModelView.index].isClickOnPause == false{
                if self.mainModelView.isPaused{
                    self.mainModelView.isPaused = false
                    self.mainModelView.exerciseArray[0].startTime = convertToStringForStartTime
                    self.userClickOnCancelForEndAlert()
                }
            }else{
                
                //Only for Outdoor because in outdoor Total Duration constantly increase even if pause
                if self.mainModelView.timerUpdate != nil{
                    mainModelView.timerUpdate?.invalidate()
                    mainModelView.timerUpdate = nil
                }
                
                if self.mainModelView.isPaused{
                    if self.mainModelView.activityName.lowercased() == "Outdoor".lowercased(){
                        
        //                if  self.isCheckForAutoPause == true{
                        
                        let valueAddigForStartTimeForOutdoor = self.mainModelView.exerciseArray[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifferenceForOutdoor))
                        let convertToStringForStartTimeForOutDoor = valueAddigForStartTimeForOutdoor.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                        self.mainModelView.exerciseArray[0].startTime = convertToStringForStartTimeForOutDoor
                        
                        
                        self.mainModelView.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.durationTimerChange), userInfo: nil, repeats: true)
        //                }
                    }
                }

            }
            
            self.mainModelView.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.mainModelView.exerciseArray)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func userClickOnCancelForEndAlert(){
        
        let secondDifference = self.mainModelView.exerciseArray[self.mainModelView.index].pauseTime.convertDateFormater().secondDifference(to: Date())
        
//        let valueAddigForAddRestTime = self.mainModelView.exerciseArray[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
//
//        let convertToStringForAddRestTime = valueAddigForAddRestTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
//        self.mainModelView.exerciseArray[0].startTime = convertToStringForAddRestTime
        
        //for indoor start time change so total duration set as same
        
        if self.mainModelView.index == 0 {
            
            let valueAddigForAddRestTime = self.mainModelView.exerciseArray[self.mainModelView.index].repeatTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
            
            let convertToStringForAddRestTime = valueAddigForAddRestTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.mainModelView.exerciseArray[self.mainModelView.index].repeatTime = convertToStringForAddRestTime
            
        }else{
            
            let valueAddigForAddRestTime = self.mainModelView.exerciseArray[self.mainModelView.index].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
            
            let convertToStringForAddRestTime = valueAddigForAddRestTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.mainModelView.exerciseArray[self.mainModelView.index].startTime = convertToStringForAddRestTime
            
        }
        
        let valueAddigForAddRestTime = self.mainModelView.exerciseArray[self.mainModelView.index].addedRestTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
        let convertToStringForAddRestTime = valueAddigForAddRestTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        self.mainModelView.exerciseArray[self.mainModelView.index].addedRestTime = convertToStringForAddRestTime
        
        self.mainModelView.exerciseArray[self.mainModelView.index].isPause = false
        self.mainModelView.exerciseArray[self.mainModelView.index].pauseTime = ""
        self.mainView.btnPlayPause.isSelected = false
        self.mainView.countdownTimer.resume()

    }
    
    func setExerciseArrayForRepeat(){
        
        for i in 0..<self.mainModelView.exerciseArray.count{
            
            var dict = self.mainModelView.exerciseArray[i]
            
            dict.isCompleted = false
            dict.isCompletedRest = false
            dict.addedStartTime = ""
            dict.addedRestTime = ""
            dict.repeatTime = ""
            dict.elapsedTime = 0
            dict.isPause = false
            dict.pauseTime = ""
            dict.isCheckMarkAlreadyDone = false
            dict.isClickOnPause = false
            dict.lineDraw = false
            dict.lastPauseTime = ""
            dict.repeatTime = ""
            
            
            if i == 0{
                
//                dict.setValue(model.startTime, forKey: "start_time")
//                dict.setValue(model.startLat, forKey: "start_lat")
//                dict.setValue(model.startLong, forKey: "start_long")
            }else{
                dict.startTime = ""
            }
            
            if i == self.mainModelView.exerciseArray.count - 1{
//                dict.setValue(model.endTime, forKey: "end_time")
//                dict.setValue(model.endLat, forKey: "end_lat")
//                dict.setValue(model.endLong, forKey: "end_long")
            }else{
                dict.endTime = ""
            }
            
            self.mainModelView.exerciseArray[i] = dict
        }
        
    }
    
    
}


//MARK: - Pedometer data
extension StartWorkoutVC{
    
    func updateStepsCountLabelUsing(startDate: Date) {
        
        pedometer.queryPedometerData(from: startDate, to: Date()) {
            [weak self] pedometerData, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                
            } else if let pedometerData = pedometerData {
                DispatchQueue.main.async {
                    print("UPDATE NEW METHOD FOR STARTING PACE:\(pedometerData.currentPace?.doubleValue ?? 0.0)")
                }
            }
        }
    }
    
    func startUpdating(fromDate:Date) {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        } else {
            
//            makeToast(strMessage: "Phone is not in motion")
            print("Phone is not in motion")
           // activityTypeLabel.text = "Not available"
        }

        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps(fromDate: fromDate)
        } else {
          //  stepsCountLabel.text = "Not available"
        }
    }
    
    func startTrackingActivityType() {
        
        self.mainModelView.handlerStopActivityUpdate()

        activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            
            //            guard let activity = activity else {
            //                return
            //            }
            
            if self?.isEndAlertShowing == true{
                return
            }
            
            if let activity = activity{
                
                DispatchQueue.main.async {
                    if activity.walking {
                        print("startworkout walking")
                        self?.commonMethodForActivity()
                        
                    } else if activity.stationary {
                        print("startworkout stationary")
                        
                        let activityName = self?.mainModelView.activityName.lowercased()
                        
                        if activityName == "Outdoor".lowercased() {
                            
                            //Old condition wrong in second lap always return false bcz icCompleted always false
                            //                        if (self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompleted == true) && (self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == false || self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == nil){
                            
                            if (self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompleted == false || self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompleted == nil){
                                if self?.timerForMotion == nil{
                                    print("ENTER IN TIME ENTER IN TIMER ===================== ENTER IN TIMER ENTER IN TIMER")
//                                    self?.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self?.check10secondOrNot), userInfo: nil, repeats: true)
                                }
                            }else{
                                self?.removeTimerOfMotion()
                            }
                        }
                        
                    } else if activity.running {
                        print("startworkout running")
                        self?.commonMethodForActivity()
                    } else if activity.automotive {
                        print("startworkout automotive")
                        self?.commonMethodForActivity()
                    }else if activity.cycling{
                        print("startworkout cycling")
                        self?.commonMethodForActivity()
                    }
                }
            }
        }
        
        print("NO ACTIVITY DETECT")
        
        let activityName = self.mainModelView.activityName.lowercased()
        if activityName == "Outdoor".lowercased(){
            if (self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == false || self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == nil){
                if self.timerForMotion == nil{
                    print("NO ACTIVITY IN TIMER ======== ENTER IN TIMER")
                    self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
                }
            }else{
                self.removeTimerOfMotion()
            }
        }
    }

    private func startCountingSteps(fromDate:Date) {
         pedometer.startUpdates(from: fromDate) {
             [weak self] pedometerData, error in
            
             guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async {
                
                if self?.mainModelView.exerciseArray[self?.mainModelView.getCurrenIndexOfCurrentLap() ?? 0].isPause == true {
                    print("Inside STARTWORKOUT return")
                    return
                }
                
                self?.mainView.lblTotalDistance.text = self?.setOneDigitWithFloor(value: (CGFloat((pedometerData.distance?.floatValue ?? 0.0)/1000)))
                
                let distance = pedometerData.distance?.doubleValue ?? 0.0
                
                self?.totalDistancConverted = distance
                
                self?.handlerForPassPedometerDistancePace(distance,nil)
                
                if self?.mainModelView.exerciseArray[0].updatedDuration == nil || self?.mainModelView.exerciseArray[0].updatedDuration == ""{
                    
                    if self?.mainModelView.isDuration == false
                    {
                            
                        var dateRepeat : Date?
                        
                        if self?.mainModelView.index == 0{
                            dateRepeat = self?.mainModelView.exerciseArray[0].repeatTime == "" ? Date() : self?.mainModelView.exerciseArray[0].repeatTime.convertDateFormater()
                        }else{
                            dateRepeat = self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].startTime == "" ? Date() : self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].startTime.convertDateFormater()
                            
                            print("DateRepeat:\(dateRepeat)")
                            
                        }
                            
                        if self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompleted == true && self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == true{
                            print("Both Complted")
                            
                            //Write here because when user complete all laps that time data not updated in Repeat section
                            
                            //s/m convert to mins

                            let paceConvertTokmhr = (pedometerData.currentPace?.doubleValue ?? 0.0) * 16.67
                            print("CurrentPace:\(pedometerData.currentPace?.doubleValue ?? 0.0)")
                            print("CurrentPace without value :\(pedometerData.currentPace?.floatValue)")
                            
//                            if self?.isAvgSpeedOrPace ?? true{
//
//                                if self?.isSpeed == true{ // speed
//                                    if pedometerData.currentPace?.floatValue ?? 0.0 == 0.0{
//                                        self?.mainView.lblChangeableParameterValue.text = "0.0"
//                                    }else{
//                                        self?.mainView.lblChangeableParameterValue.text = self?.oneDigitAfterDecimal(value: Float(60.0/paceConvertTokmhr))
//                                    }
//                                }else if self?.isSpeed == false{ // pace
//                                    self?.mainView.lblChangeableParameterValue.text = self?.calculatePaceInTimeFormate(value: self?.oneDigitAfterDecimal(value: Float(paceConvertTokmhr),digit: 2).toFloat() ?? 0.0)
//                                }
//                            }
                            
                        }else{
                            self?.startUpdatingForRepeat(fromDate: dateRepeat ?? Date())
                        }
                    }
                    
                }else{
                    
                    //                s/m convert to mins
                    let paceConvertTokmhr = (pedometerData.currentPace?.doubleValue ?? 0.0) * 16.67
                    print("CurrentPace:\(pedometerData.currentPace?.doubleValue ?? 0.0)")
                    print("CurrentPace without value :\(pedometerData.currentPace?.floatValue)")
                    
//                    self?.findingAvgSpeed()
//                    if self?.isAvgSpeedOrPace ?? true{
//
//                        if self?.isSpeed == true{ // speed
//                            if pedometerData.currentPace?.floatValue ?? 0.0 == 0.0{
//                                self?.mainView.lblChangeableParameterValue.text = "0.0"
//                            }else{
//                                self?.mainView.lblChangeableParameterValue.text = self?.oneDigitAfterDecimal(value: Float(60.0/paceConvertTokmhr))
//                            }
//                        }else if self?.isSpeed == false{ // pace
//                            self?.mainView.lblChangeableParameterValue.text = self?.calculatePaceInTimeFormate(value: self?.oneDigitAfterDecimal(value: Float(paceConvertTokmhr),digit: 2).toFloat() ?? 0.0)
//                        }
//                    }
                }
                
            }
         }
     }
    
    func commonMethodForActivity(){
        let activityName = self.mainModelView.activityName.lowercased()
        if activityName == "Outdoor".lowercased(){
            
            self.removeTimerOfMotion()
            
            if self.mainModelView.isPaused {
                
                if self.isCheckForAutoPause == true{
                    if self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompletedRest == true{
                        
                        self.mainView.btnPlayPause.isSelected = !(self.mainView.btnPlayPause.isSelected)
                        self.mainModelView.isPaused = !(self.mainModelView.isPaused)
                        guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                            return
                        }
                        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}

                        try? realm?.write{
                            
                            if routeObjects.count > 0{
                                
                                routeObjects[0].isPauseAfterAllLapCompleted = self.mainModelView.isPaused
                                routeObjects[0].isAutomaticallyPause = false
                                self.isCheckForAutoPause = false
                            }
                        }

                        
                    }else{
                        
                        if (self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted != true){
                            self.mainView.btnPlayPause.isSelected = !(self.mainView.btnPlayPause.isSelected)
                            self.mainModelView.isPaused = !(self.mainModelView.isPaused)
                            guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                                return
                            }
                            let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}

                            try? realm?.write{
                                
                                if routeObjects.count > 0{
                                    routeObjects[0].isAutomaticallyPause = false
                                    self.isCheckForAutoPause = false
                                }
                            }

                            self.mainView.countdownTimer.resume()
                            self.mainModelView.exerciseArray[self.mainModelView.index].isPause = false
                            self.isPauseShow(isShow: false)
                            self.mainModelView.handlerPauseOrNot(false)
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    @objc func check10secondOrNot(){
        
        self.mainModelView.handlerStopActivityUpdate()
        
        
        if self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompletedRest == true{
        
        }else{
            if self.mainModelView.isRest == true{
                return
            }
        }
        
        
        
        if self.isEndAlertShowing == true{
            return
        }

        countForMotion += 1
        
//        makeToast(strMessage: "CountForMotion:\(countForMotion)")
        
//        makeToast(strMessage: "Seconds:\(countForMotion)")
        print("countForMotion:\(countForMotion)")
        
        if countForMotion > 5{
            
            countForTotalStationaryTime += 1
            print("countForTotalStationaryTime:\(countForTotalStationaryTime)")
            
            Defaults.set(countForTotalStationaryTime, forKey: self.mainModelView.trainingProgramId + " " + "Program")
            Defaults.synchronize()
            
        }
        
        var isAutoPauseCheck = false
        
        if countForMotion >= 11{
            
            print("value defaults:\(Defaults.value(forKey: self.mainModelView.trainingProgramId + " " + "Program"))")
            
//            makeToast(strMessage: "PHONE IS NOT IN MOTION")
            
            let activityName = self.mainModelView.activityName.lowercased()
            
            if activityName == "Outdoor".lowercased(){
                isAutoPauseCheck = self.mainModelView.isRunAutoPause
            }
            
//            if activityName == "Cycling (Outdoor)".lowercased() {
//                isAutoPauseCheck = self.mainModelView.isCycleAutoPause
//            }
            
            if isAutoPauseCheck{
                if !self.mainModelView.isPaused {
                    self.btnPauseClicked(self.mainView.btnPlayPause)
                    guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                        return
                    }
                    let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}

                    try? realm?.write{
                        
                        if routeObjects.count > 0{
                            routeObjects[0].isAutomaticallyPause = true
                            self.isCheckForAutoPause = true
                        }
                    }
                }
            }else{
                if self.isAutoPauseCheckForAlert == false{
                    self.isAutoPauseCheckForAlert = true
                    
                    let imageOfScreen = takeScreenshot()
                    self.mainModelView.handlerFinishWorkoutOnEndClick(imageOfScreen)

                    autoPauseAlert()
                }
            }
        }
    }
    
    func autoPauseAlert(){
        
        let alertController = UIAlertController(title: "", message: getCommonString(key: "Do_you_want_to_continue_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            
            self.isAutoPauseCheckForAlert = false
            self.removeTimerOfMotion()
            
            self.mainModelView.handlerFinishWorkoutOnEndClick(nil)
            
            if self.timerForMotion == nil{
                self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
            }
            
//            print("isActivity available : \(CMMotionActivityManager.isActivityAvailable())")
//            if CMMotionActivityManager.isActivityAvailable() {
//                self.startTrackingActivityType()
//            }
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            print("Cancel")
            
            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            print("date:\(date)")
            
            self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].endTime = date
            self.mainModelView.finishWorkout()
            self.mainModelView.delegate?.closeViewDismissSelectLocationProgram()

        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //find avg speed
    func getAvgSpeed(){
        
//        if isCheckForAutoPause == true{
//            return
//        }
        
        if self.mainModelView.isPaused == true{
            if isCheckForAutoPause == false{
                return
            }
        }
        
        let totalDistance = self.totalDistancConverted
        
        let totalActiveDurationSecond = self.mainModelView.totalDurationInSecond - self.countForTotalStationaryTime
        
        let speed = (CGFloat(totalDistance)/CGFloat(totalActiveDurationSecond)) * 3.6
        
        if totalDistance <= 50{
            return
        }
        
        if (self.mainModelView.totalDurationInSecond) % 3 == 0 {
            
            let speedinOneDigit = self.setOneDigitWithFloor(value: speed)
            self.calculatedSpeed = speedinOneDigit.toFloat()
            guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                return
            }
            let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}
            
            if routeObjects.count > 0 {
                
                if ((realm?.isInWriteTransaction) != nil){
                    routeObjects[0].averageSpeed = Double(self.calculatedSpeed)
                } else {
                    try? realm?.write{
                        routeObjects[0].averageSpeed = Double(self.calculatedSpeed)
                    }
                }
                
            }

            if self.isAvgSpeedOrPace {
                if self.isSpeed == true{ // speed
                    if speed < 0.0{
                        self.mainView.lblChangeableParameterValue.text = "0.0"
                    }else{
                        self.mainView.lblChangeableParameterValue.text = speedinOneDigit
//                            oneDigitAfterDecimal(value: Float(speed), digit: 1)
                    }
                }else if self.isSpeed == false{ // pace
                    
                    let twoDigitForPace = "\((floor(60 / self.calculatedSpeed * 100) / 100))"
                    self.mainView.lblChangeableParameterValue.text = self.calculatePaceInTimeFormate(value: twoDigitForPace.toFloat())
                }
            }
        }
    }

    @objc func durationTimerChange(){
        
        if self.mainModelView.exerciseArray[0].startTime == ""{
            return
        }
        
        let secondDifference = self.mainModelView.exerciseArray[0].startTime.convertDateFormater().secondDifference(to: Date())
        //        print("Total Duration secondDifference:\(secondDifference)")
        self.mainModelView.totalDurationInSecond = secondDifference
//        if self.mainModelView.activityName.lowercased() == "Run (Outdoor)".lowercased() || self.mainModelView.activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
            self.getAvgSpeed()
//        }

        let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: secondDifference)
        
        mainView.lblTotalDuration.text = self.mainModelView.makeTimeString(h: h1, m: m1, s: s1)
    }

}

//MARK: - Other function

extension StartWorkoutVC {
    
    
    func checkChangeAbleParameter(){
        
        let lastSpeed = self.setOneDigitWithFloor(value: self.calculatedSpeed)
        
        let twoDigitForPace = "\((floor((60 / calculatedSpeed * 100)) / 100))"

        let lastPace = self.calculatePaceInTimeFormate(value: twoDigitForPace.toFloat())
        
        switch self.mainModelView.activityName.lowercased(){
            
        case "Outdoor".lowercased():
            
            if self.nextVariableCount == 0{
                self.isSpeed = true
                self.mainView.lblChangableParameter.text = "Avg. Speed (km/hr)"
                self.mainView.lblChangeableParameterValue.text = lastSpeed
                self.nextVariableCount += 1
            }else if self.nextVariableCount == 1{
                self.isSpeed = false
                self.mainView.lblChangableParameter.text = "Avg. Pace (min/km)"
                self.mainView.lblChangeableParameterValue.text = lastPace
                self.nextVariableCount = 0
            }
            
        case "Indoor".lowercased():
            
            if self.nextVariableCount == 0{
                self.isSpeed = true
                self.mainView.lblChangableParameter.text = "Avg. Speed (km/hr)"
                self.mainView.lblChangeableParameterValue.text = lastSpeed
                self.nextVariableCount += 1
            }else if self.nextVariableCount == 1{
                self.isSpeed = false
                self.mainView.lblChangableParameter.text = "Avg. Pace (min/km)"
                self.mainView.lblChangeableParameterValue.text = lastPace
                self.nextVariableCount = 0
            }
            
        default:
            
            if self.nextVariableCount == 0{
                
            }
        }
        
    }

    
    func calculatePaceInTimeFormate(value:CGFloat) -> String{
        
        let stringValue = "\(value)"
        let dataArray = stringValue.split(separator: ".")

        let sMin = (Double(dataArray[0] ?? "0") ?? 0) * 60
        let sSec = (Double("0.\(dataArray[1] ?? "0")") ?? 0) * 60
        
//        let TotalNumber = Int(sMin) + Int(sSec)
//
//        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: TotalNumber)
        
//        print("h : \(h)")
//        print("m : \(m)")
//        print("s : \(s)")
        
        let getTimeformate = "\(Int(String(dataArray[0])) ?? 0 > 9 ? "\(dataArray[0])" : "0\(dataArray[0])"):\(Int(sSec) > 9 ? "\(Int(sSec))" : "0\(Int(sSec))")"
        
        print("GET TIME FORMATE GET TIME FORMATE GET TIME FORMATE : \(getTimeformate)")
        
        return getTimeformate
//        return self.mainModelView.makeTimeStringForRest(h: h, m: m, s: s)

    }
    
    @objc func updateTotalDistance(notification: Notification) {
        if let distance = notification.userInfo?["distance"] as? Double {
            //Uncomment only for check
            //            self.totalDistancConverted = distance
            self.mainView.lblTotalDistance.text = self.setOneDigitWithFloor(value: (CGFloat((distance)/1000)))
        }
    }

}

//MARK: - Lat/long delegate

extension StartWorkoutVC: updateLatLongDelegate{
    
    func updatedLatLong(lat: Double,long: Double) {
        print("lat:\(lat)\t long:\(long)")
        
//        makeToast(strMessage: "STRTWORKOUT LATLONG")
        
        let activityName = self.mainModelView.activityName.lowercased()
        if activityName == "Outdoor".lowercased(){
            
            getPreviousTrackPolyline()
            
//
//            let speed = Double(AppDelegate.shared.locationManager.location!.speed * 3.6)
//
//            if self.isAvgSpeedOrPace {
//
//                if self.isSpeed == true{ // speed
//                    if speed < 0.0{
//                        self.mainView.lblChangeableParameterValue.text = "0.0"
//                    }else{
//                        self.mainView.lblChangeableParameterValue.text = oneDigitAfterDecimal(value: Float(speed), digit: 1)
//                    }
//                }else if self.isSpeed == false{ // pace
//
//                    self.mainView.lblChangeableParameterValue.text = self.calculatePaceInTimeFormate(value: self.oneDigitAfterDecimal(value: Float(speed),digit: 2).toFloat())
//                }
//            }

            if self.mainModelView.exerciseArray[0].startTime == ""{
                return
            }
            
            //When user enter that time Timer set nil
            self.removeTimerOfMotion()
            
            if lattitude != lat && longitude != long {
                guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                    return
                }
                let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}

                //When user click on End button that time user goes to 10 second timer so that time isPaused call and Loader continue
                if self.isEndAlertShowing == true{
                    
                }else{
                    //Timer set here Reason we know like how many second before it call this method
                    
                    self.commonMethodForActivity()
                    
                    if self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompletedRest == true{
                        
                        if routeObjects.count > 0 {
                            if routeObjects[0].isPauseAfterAllLapCompleted == false{
                                if self.timerForMotion == nil{
                                    self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
                                }
                            }
                        }
                        
//                        if routeObjects[0].isAutomaticallyPause == true{
//                            if self.timerForMotion == nil{
//                                self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
//                            }
//                        }

                        
                    }else{
                        
                        //TODO:- Add Comment here because If it's pause then Total Duration already continue
                        
//                        if self.mainModelView.exerciseArray[self.mainModelView.getCurrenIndexOfCurrentLap()].isPause == false {
                            
                            if self.mainModelView.exerciseArray[self.mainModelView.getCurrenIndexOfCurrentLap()].isCompleted == false || self.mainModelView.exerciseArray[self.mainModelView.getCurrenIndexOfCurrentLap()].isCompleted == nil{
                                
                                if self.timerForMotion == nil{
                                    self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
                                }
                            }
//                        }
                    }
                    
                }
                
                lattitude = lat
                longitude = long
                
                
                var wayPoint : [String:String] = [:]
                wayPoint = ["way_lat" : String(lattitude),
                            "way_lng" : String(longitude)]
                
                let destination = CLLocationCoordinate2DMake(lattitude, longitude)
                arrWayPoint.append(destination)
                
                let polyline = Polyline(coordinates: arrWayPoint)
                let encodedPolyline: String = polyline.encodedPolyline
                
                print("enocodedPolyline : \(encodedPolyline)")
                
                print("TraininngGaolId : \(Int(self.mainModelView.trainingProgramId))")

                try? realm?.write{
                    if routeObjects.count > 0{
                        routeObjects[0].allTrackRoute = encodedPolyline
                        
                        if arrWayPoint.count > 1{
                            routeObjects[0].secondLastIndex = arrWayPoint.count - 2
                            routeObjects[0].lastIndex = arrWayPoint.count - 1
                        }
                        
                        if self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompletedRest == true{

                            if routeObjects[0].isPauseAfterAllLapCompleted == false{
                                self.drawTotalPath(strPolyLine: routeObjects[0].allTrackRoute)
                            }else{
                                self.getRouteWhilePause(strPolyline: routeObjects[0].allTrackRoute)
                            }
                            
                        }else{
                            if self.mainModelView.exerciseArray[self.mainModelView.getCurrenIndexOfCurrentLap()].isPause == false {
                                self.drawTotalPath(strPolyLine: routeObjects[0].allTrackRoute)
                            }else{
                                self.getRouteWhilePause(strPolyline: routeObjects[0].allTrackRoute)
                            }
                        }

                        
//                        if self.mainModelView.isPaused == false {
//                            self.drawTotalPath(strPolyLine: routeObjects[0].allTrackRoute)
//                        }
                    }
                }
            }
            else{
                print("timer call")
                //            let activityName = self.mainModelView.activityName.lowercased()
                //
                //            if activityName == "Outdoor".lowercased() || activityName == "Cycling (Outdoor)".lowercased() {
                //
                //                //Old condition wrong in second lap always return false bcz icCompleted always false
                //                //                        if (self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompleted == true) && (self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == false || self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == nil){
                //
                //                if (self.mainModelView.exerciseArray[self.mainModelView.index ?? 0].isCompleted == false || self.mainModelView.exerciseArray[self.mainModelView.index ?? 0].isCompleted == nil){
                //                    if self.timerForMotion == nil{
                //                        print("ENTER IN TIME ENTER IN TIMER ===================== ENTER IN TIMER ENTER IN TIMER")
                //                        self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
                //                    }
                //                }else{
                //                    self.removeTimerOfMotion()
                //                }
                //            }
            }
        }
        
    }
    
    func getRouteWhilePause(strPolyline:String) {
        
        self.mainView.mapView.clear()
        let path1 = GMSPath(fromEncodedPath: strPolyline)
        let polylineForPath = GMSPolyline(path: path1)
        polylineForPath.strokeWidth = 5.0
        polylineForPath.strokeColor = .appthemeOffRedColor
        polylineForPath.map = self.mainView.mapView // Google MapView
        
    }
    
    func removeTimerOfMotion(){
        if self.timerForMotion != nil{
            countForMotion = 0
            self.timerForMotion?.invalidate()
            self.timerForMotion = nil
        }
    }

    
}


//MARK: - For distance and repeat functionality

extension StartWorkoutVC{
    
    func startUpdatingForRepeat(fromDate:Date) {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        } else {
            
            //            makeToast(strMessage: "Phone is not in motion")
            print("Phone is not in motion")
            // activityTypeLabel.text = "Not available"
        }
        
        if CMPedometer.isStepCountingAvailable() {
            startCountingStepsForRepeat(fromDate:fromDate)
        } else {
            //  stepsCountLabel.text = "Not available"
        }
    }
    
    func updateStepsCountLabelForRepeatWorkout(startDate: Date) {
//           pedometer.queryPedometerData(from: startDate, to: Date()) {
//               [weak self] pedometerData, error in
//               if let error = error {
//                print("Error : \(error.localizedDescription)")
//
//               } else if let pedometerData = pedometerData {
//                   DispatchQueue.main.async {
//
//                    let distance = pedometerData.distance?.doubleValue ?? 0.0
//                    print("Repeat Distance: \(distance)")
//                   }
//               }
//           }
       }
    
    private func startCountingStepsForRepeat(fromDate:Date) {
        pedometer.startUpdates(from: fromDate) {
            [weak self] pedometerData, error in
            
            guard let pedometerData = pedometerData, error == nil else { return }

            DispatchQueue.main.async {
                
                if self?.mainModelView.isDuration == false
                {
                   
                    if self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompleted == true && self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == true{
                        return
                    }

                    if self?.mainModelView.exerciseArray[self?.mainModelView.getCurrenIndexOfCurrentLap() ?? 0].isPause == true {
                        return
                    }
                    
                    let distance = pedometerData.distance?.floatValue ?? 0.0
                    
                    print("distanceOfLapForIndoor:\(self?.distanceOfLapForIndoor)")
//                    self?.findingAvgSpeed()

                    if !(self?.mainModelView.isRest ?? false){
                        self?.distanceOfLapForIndoor = CGFloat(distance)
                        self?.mainView.lblCount.text = self?.setOneDigitWithFloor(value: (CGFloat((pedometerData.distance?.floatValue ?? 0.0)/1000)))
                    }
                    
                    //                s/m convert to mins
//                    let paceConvertTokmhr = (pedometerData.currentPace?.doubleValue ?? 0.0) * 16.67
//
//                    if self?.isAvgSpeedOrPace ?? true{
//
//                        if self?.isSpeed == true{ // speed
//                            if pedometerData.currentPace?.floatValue ?? 0.0 == 0.0{
//                                self?.mainView.lblChangeableParameterValue.text = "0.0"
//                            }else{
//                                self?.mainView.lblChangeableParameterValue.text = self?.oneDigitAfterDecimal(value: Float(60.0/paceConvertTokmhr))
//                            }
//                        }else if self?.isSpeed == false{ // pace
//                            self?.mainView.lblChangeableParameterValue.text = self?.calculatePaceInTimeFormate(value: self?.oneDigitAfterDecimal(value: Float(paceConvertTokmhr),digit: 2).toFloat() ?? 0.0)
//                        }
//                    }

                    let totalDistanceValue = (self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].updatedDistance ?? 0.0) * 1000.0
                    
                    print("START workout Repeat Distance: :\(distance)")
                    
                    if CGFloat(distance) >= totalDistanceValue{
                        
                        if self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompleted == true && self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == true{
                            
                            print("Lap number: \(self?.mainModelView.index) Completed both")
                            
                        }else{
                            self?.setCompleteDistance()
                            
                            if self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompleted == true && self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == true{

                            }else{
                                self?.perform(#selector(self?.reCallMainCountingStep), with: nil, afterDelay: 3.0)
                            }

                        }
                    }
//                    else{
//                        self?.perform(#selector(self?.reCallMainCountingStep), with: nil, afterDelay: 60.0)
//                    }
                    
                }
                
            }
        }
    }
    
    @objc func reCallMainCountingStep(){
        
        let dateStart = self.mainModelView.exerciseArray[0].startTime == "" ? Date() : self.mainModelView.exerciseArray[0].startTime.convertDateFormater()
        
        self.startUpdating(fromDate: dateStart)
        
    }
    
    //MARK: - Set commplete distance functionality
    
    func setCompleteDistance(){
        
        if self.mainModelView.exerciseArray.count > 0{
            if self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompletedRest == true{
                return
            }
        }
        
        if self.mainModelView.isDuration == false && self.mainModelView.isRest == false{
            
            if self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == false || self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == nil{
                
                //TODO:- LAST COMMENT FOR CHECK
                /*
//                self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted = true
//
//                let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
//
//                let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.mainModelView.getSeconds(data: self.mainModelView.exerciseArray[self.mainModelView.index].updatedRest)))
//
//                let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
//                print("convertToStringForRest : \(convertToStringForRest)")
//                self.mainModelView.exerciseArray[self.mainModelView.index].addedRestTime = convertToStringForRest
                */
                
                
                /*
                if self.mainModelView.index == self.mainModelView.exerciseArray.count - 1{
                    
                    if self.mainModelView.exerciseArray[self.mainModelView.index].updatedRest == nil || self.mainModelView.exerciseArray[self.mainModelView.index].updatedRest == ""{
                       
                        self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest = true
                    }
                }
                else{
                    
                    if self.mainModelView.exerciseArray[self.mainModelView.index].updatedRest == nil || self.mainModelView.exerciseArray[self.mainModelView.index].updatedRest == ""{
                        
                        self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest = true

                        if (self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedDuration == nil || self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedDuration == "") && (self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedDistance == nil || self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedDistance == 0.0){
                            
                            self.mainModelView.exerciseArray[self.mainModelView.index+1].isCompleted = true

                            if self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedRest == "" || self.mainModelView.exerciseArray[self.mainModelView.index+1].updatedRest == nil{
                                
                                self.mainModelView.exerciseArray[self.mainModelView.index+1].isCompletedRest = true

                                if self.mainModelView.index+2 == self.mainModelView.exerciseArray.count{
                                    
                                }else{
    //                                self.mainModelView.exerciseArray[self.mainModelView.index+1].isCompletedRest = true
                                }
                            }else{
                               //next completed rest not blank so it's not true
                            }
                            
                        }else{
                            //current completedRest true
                        }
                        
                    }else{
                        
                    }
                    
                }*/
                
                self.mainModelView.playNext()
                
//                self.mainModelView.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.mainModelView.exerciseArray)
                
            }else{
                //            self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest = true
                //            self.nextVariableCount = 0
            }
//            self.mainModelView.checkAndStart()
        }
        
    }
    
}

//MARK: - Location/database related changes
extension StartWorkoutVC{
    
    func getTrackDistance(){
        
        self.removeTimerOfMotion()
        
        if self.timerForMotion == nil{
            self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
        }
        /*
        let routeObjects = Array(realm.objects(CardioActivityRouteTrainingProgram.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}

        if routeObjects.count > 0{
            self.totalDistancConverted = routeObjects[0].totalCoveredDistance
            self.mainView.lblTotalDistance.text = self.setOneDigitWithFloor(value: (CGFloat((totalDistancConverted)/1000)))

            makeToast(strMessage: "Method related index:\(self.mainModelView.getCurrenIndexOfCurrentLap()) DIstance:\(routeObjects[0].lapArray[self.mainModelView.getCurrenIndexOfCurrentLap()].lapCoverDistance)\n Index :\(self.mainModelView.index) Distance:\(routeObjects[0].lapArray[self.mainModelView.index].lapCoverDistance)")
            
            self.lapCoveredDistance = routeObjects[0].lapArray[self.mainModelView.index].lapCoverDistance
            
            if self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == false || self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == nil{
                self.mainView.lblCount.text = self.setOneDigitWithFloor(value: (CGFloat(lapCoveredDistance)/1000))
            }
            
            self.getAvgSpeed()
        }
        */
    }
    
    func getPreviousTrackPolyline(){
        guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
            return
        }
        
        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}
        
        if routeObjects.count > 0{
            let polyline = Polyline(encodedPolyline: routeObjects[0].allTrackRoute)
            
            let decodedCoordinates: [CLLocationCoordinate2D] = polyline.coordinates!
            //   print("decodedCoordinates \(String(describing: decodedCoordinates))")
            self.arrWayPoint = []
            self.arrWayPoint = decodedCoordinates
//            print("arrWayPoint \(self.arrWayPoint)")
            
        }
        
    }
    
    /*
     func findingAvgSpeed(){
     
     //        if self.mainModelView.exerciseArray[0].startTime == ""{
     //            return
     //        }
     //
     //        if self.mainModelView.exerciseArray[self.mainModelView.index].startTime == ""{
     //            return
     //        }
     //
     //        let startTime = self.mainModelView.exerciseArray[self.mainModelView.index].startTime
     //
     //        let time = Int(Date().timeIntervalSince(startTime.convertDateFormater()))
     //        print("time:\(time)")
     //        let avgSpeed = distanceOfLapForIndoor/CGFloat(time)
     //
     //        makeToast(strMessage: "avg speed : \(avgSpeed * 3.6)")
     
     }*/
    
    func drawTotalPath(strPolyLine:String)
    {
        //TODO: - Comment drawpath with Polyline
        self.mainView.mapView.clear()
        let polyline = Polyline(encodedPolyline:strPolyLine)
        let decodedCoordinates: [CLLocationCoordinate2D] = polyline.coordinates!
        
        let decodeForElevationGain : [CLLocation] = polyline.locations!
        
//        for i in 0..<decodedCoordinates.count{
//
//            //set for elevation gain
//
//            let oldAltitude = decodeForElevationGain[i-1].altitude
//            let newAltitude = decodeForElevationGain[i].altitude
//
//            let diff = oldAltitude - newAltitude
//
//            netElevationGain += max(0, diff)
//
//            self.handlerNetElevationGain(netElevationGain)
//        }

        if decodedCoordinates.count > 1{
            
            guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                return
            }
            
            let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}
            
            if routeObjects.count > 0{
                
                //We can calculate Total Distance while it's not pause
                //
                let secondLastIndex = decodedCoordinates[routeObjects[0].secondLastIndex]
                let lastIndex = decodedCoordinates[routeObjects[0].lastIndex]
                
                //finding elevation gain
                
                let oldAltitude = decodeForElevationGain[routeObjects[0].secondLastIndex].altitude
                let newAltitude = decodeForElevationGain[routeObjects[0].secondLastIndex].altitude

                let diff = oldAltitude - newAltitude
                
                netElevationGain += max(0, diff)
                
                routeObjects[0].elevationGain = netElevationGain
                
                self.handlerNetElevationGain(netElevationGain)
                
                //Main Distance
                
                totalDistancConverted = totalDistancConverted + self.distance(driver: lastIndex, from: secondLastIndex)
                
                self.handlerForPassPedometerDistancePace(totalDistancConverted,nil)
                
                routeObjects[0].totalCoveredDistance = totalDistancConverted
                print("Total Distance:\(self.totalDistancConverted)")
                
                self.mainView.lblTotalDistance.text = self.setOneDigitWithFloor(value: (CGFloat((totalDistancConverted)/1000)))
                
                //
                //For finding particular lap cover distance
                //
                
                print("Methoddddd : \(self.mainModelView.getCurrenIndexOfCurrentLap())")
                print("Index : \(self.mainModelView.index)")
                
                //When user come to this screen sometime call this method first , before calling index get method so get accurate index

                //Add this condition because after lap successfully completed index set 0 and WellDone animation not set properly
                
                if (self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompleted ?? false && self.mainModelView.exerciseArray[self.mainModelView.exerciseArray.count-1].isCompletedRest ?? false){
                    self.mainModelView.index = self.mainModelView.exerciseArray.count-1
                }else{
//                    self.mainModelView.index = self.mainModelView.getCurrenIndexOfCurrentLap()
                }
                
                if self.mainModelView.exerciseArray.count > 0{
                    if self.mainModelView.exerciseArray[0].updatedDuration == nil || self.mainModelView.exerciseArray[0].updatedDuration == ""{
                        if (self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == nil || self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == false) && (self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == nil || self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == false){
                            
                            let lapDistance = (self.mainModelView.exerciseArray[self.mainModelView.index].updatedDistance ?? 0.0)*1000
                            
                            lapCoveredDistance = lapCoveredDistance + self.distance(driver: lastIndex, from: secondLastIndex)
                            
                            handlerForPassDataOfParticularLapWithPolyline(strPolyLine, lapCoveredDistance)

                            routeObjects[0].lapArray[self.mainModelView.index].lapCoverDistance = lapCoveredDistance
                                
                            var isCompletedCoverDistance = false
                            
                            if lapCoveredDistance >= Double(lapDistance){
                                
                                isCompletedCoverDistance = true
                                lapCoveredDistance = 0.0
                                
                                if self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == true{
                                    
                                    print("Lap number: \(self.mainModelView.index) Completed both")
                                    
                                }else{
                                    self.setCompleteDistance()
                                    
                                    if self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == true{
                                        
                                    }else{
                                        
                                    }
                                }
                            }
                            
                            if !self.mainModelView.isRest{
                                
                                if self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == true{
                                   
//                                    self.mainView.lblCount.text = "\(self.mainModelView.exerciseArray[self.mainModelView.index].updatedDistance ?? 0.0)"

                                }else{
                                    //Any time lap completed so in label so 0.0 instead of its value
                                    if isCompletedCoverDistance == true{
                                        isCompletedCoverDistance = false
                                    }else{
                                        self.mainView.lblCount.text = self.setOneDigitWithFloor(value: (CGFloat(lapCoveredDistance)/1000))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
//        MARK: - COMMENT CHECK
        
//        for i in self.lastIndex..<decodedCoordinates.count
//        {
//            if i > 0
//            {
//                if lastIndex < i{
//                    let dictFirst = decodedCoordinates[i]
//                    let dictSecond = decodedCoordinates[i-1]
//                    totalDistancConverted = totalDistancConverted + self.distance(driver: dictFirst, from: dictSecond)
//
//                    self.mainView.lblTotalDistance.text = self.setOneDigitWithFloor(value: (CGFloat((totalDistancConverted)/1000)))
//
//                    lastIndex = i
//                    print("lastIndex:\(lastIndex)")
//                    print("TotalDistanceConveted = \(totalDistancConverted)")
//
//                    self.handlerForPassPedometerDistancePace(totalDistancConverted,nil)
//
//                    //                    makeToast(strMessage: "\(totalDistancConverted)")
//
//                    //set for elevation gain
//
//                    let oldAltitude = decodeForElevationGain[i-1].altitude
//                    let newAltitude = decodeForElevationGain[i].altitude
//
//                    let diff = oldAltitude - newAltitude
//
//                    netElevationGain += max(0, diff)
//
//                    self.handlerNetElevationGain(netElevationGain)
//
//                    print("Diff and netElevationGain \(diff)  :  \(netElevationGain)")
//
//                    if self.mainModelView.exerciseArray[0].updatedDuration == nil || self.mainModelView.exerciseArray[0].updatedDuration == ""{
//
//                        if self.mainModelView.exerciseArray.count > 0 {
//                            if (self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == nil || self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == false) && (self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == nil || self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == false){
//
//                                //                            if self.mainModelView.index == 0{
//                                //                                findDistanceOfParticularLap(polyline: strPolyLine, fromIndex: getStartFrom, currentIndex: lastIndex)
//                                //                            }else{
//
//                                let routeObjects = Array(realm.objects(CardioActivityRouteTrainingProgram.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}
//
//                                let getStartFrom = routeObjects[0].lapArray[self.mainModelView.index].startFrom
//
//                                if getStartFrom <= lastIndex{
//                                    if routeObjects.count > 0{
//
//                                        findDistanceOfParticularLap(strPolyline: strPolyLine, fromIndex: getStartFrom, currentIndex: lastIndex)
//                                    }
//                                }
//                                //                         }
//                            }
//
//                        }
//                    }
//                }
//            }
//        }
        
        let path1 = GMSPath(fromEncodedPath: strPolyLine)
        let polylineForPath = GMSPolyline(path: path1)
        polylineForPath.strokeWidth = 5.0
        polylineForPath.strokeColor = .appthemeOffRedColor
        polylineForPath.map = self.mainView.mapView // Google MapView
        
    }
    
    func distance(driver: CLLocationCoordinate2D, from: CLLocationCoordinate2D) -> CLLocationDistance {
        let driver = CLLocation(latitude: driver.latitude, longitude: driver.longitude)
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        return driver.distance(from: from)
    }
    
    func findDistanceOfParticularLap(strPolyline:String,fromIndex:Int,currentIndex: Int){
        /*
        let routeObjects = Array(realm.objects(CardioActivityRouteTrainingProgram.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}
        
        //        if self.mainModelView.exerciseArray[self.mainModelView.index].updatedDuration == nil || self.mainModelView.exerciseArray[self.mainModelView.index].updatedDuration == ""{
        
        let lapDistance = (self.mainModelView.exerciseArray[self.mainModelView.index].distance ?? 0.0)*1000
        
        let polyline = Polyline(encodedPolyline:strPolyline)
        let decodedCoordinates: [CLLocationCoordinate2D] = polyline.coordinates!
        print("decodedCoordinates \(decodedCoordinates)")
        
        print("FromIndex : \(fromIndex)")
        print("CurrentIndex : \(currentIndex)")
        
        //Every time update last so when user click on Next lap that time value consider from here
        
        if routeObjects.count > 0{
            routeObjects[0].lapArray[self.mainModelView.index].endTo = currentIndex
        }
        
        for i in fromIndex..<decodedCoordinates.count
        {
            if i > 0
            {
                if lastLapIndex < i{
                    let dictFirst = decodedCoordinates[i]
                    let dictSecond = decodedCoordinates[i-1]
                    lapCoveredDistance = lapCoveredDistance + self.distance(driver: dictFirst, from: dictSecond)
                    
                    handlerForPassDataOfParticularLapWithPolyline(strPolyline)
                    
//                    makeToast(strMessage: "Lap Distance:\(lapCoveredDistance)")
                    
                    self.lastLapIndex = i
                    
                    if lapCoveredDistance >= Double(lapDistance){
                        
                        //                            try! realm.write{
                        
                        //Save data to realm local database Write comment because already written in DrawPath method
                        
                        lapCoveredDistance = 0.0
                        
                        if routeObjects.count > 0{
                            
                            if self.mainModelView.index + 1 == self.mainModelView.exerciseArray.count{
                                routeObjects[0].lapArray[self.mainModelView.index].startFrom = fromIndex
                                routeObjects[0].lapArray[self.mainModelView.index].endTo = currentIndex
                            }else{
                                routeObjects[0].lapArray[self.mainModelView.index].startFrom = fromIndex
                                routeObjects[0].lapArray[self.mainModelView.index].endTo = currentIndex
                                
                                routeObjects[0].lapArray[self.mainModelView.index+1].startFrom = currentIndex
                            }
                        }
                        //                            }
                        
                        if self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == true{
                            
                            print("Lap number: \(self.mainModelView.index) Completed both")
                            
                        }else{
                            self.setCompleteDistance()
                            
                            if self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted == true && self.mainModelView.exerciseArray[self.mainModelView.index].isCompletedRest == true{
                                
                            }else{
                                
                            }
                        }
                    }
                    
                    if !self.mainModelView.isRest{
                        self.mainView.lblCount.text = self.setOneDigitWithFloor(value: (CGFloat(lapCoveredDistance)/1000))
                    }
                    
                }
            }
        }
        
        //        }
        */
    }
    
    func clickOnNextAndForRest(){
        
        //Click on next button after rest get update data in Rest
        let activityName = self.mainModelView.activityName.lowercased()
        if activityName == "Outdoor".lowercased(){
            
            //When user take a rest after not moving for 10 second that time check karava add 10 seconds
            self.removeTimerOfMotion()
            
            if self.timerForMotion == nil{
                self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
            }

            if self.mainModelView.exerciseArray[self.mainModelView.index].updatedDuration == nil || self.mainModelView.exerciseArray[self.mainModelView.index].updatedDuration == ""{
                
                try? realm?.write{
                    guard let routerArray = realm?.objects(CardioActivityRouteTrainingProgram.self) else {
                        return
                    }
                    let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.mainModelView.trainingProgramId)}
                    
                    if routeObjects.count > 0 {
                        
                        //We cannot Righ last index endTo because user also walk some km afrer complete lap so we have to take start of that repeat and recent value of Index passes
                        //                            let lastIndex = routeObjects[0].lapArray.count - 1
                        //                        routeObjects[0].lapArray[lastIndex].endTo
                        
                        if self.mainModelView.index == self.mainModelView.exerciseArray.count - 1{
                            //                                routeObjects[0].lapArray[self.mainModelView.index+1].startFrom = startingIndex
                            
                        }else{
                            
                            lapCoveredDistance = 0.0

                            routeObjects[0].lapArray[self.mainModelView.index+1].lapCoverDistance = 0.0
                        }
                    }
                }
            }
        }
    }
    
}

//MARK: - take screenshot for TrainingPreview screen

extension StartWorkoutVC{
    
    open func takeScreenshot() -> UIImage? {
        
        return UIGraphicsImageRenderer(size: self.view.bounds.size).image { _ in
            self.view.drawHierarchy(in: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), afterScreenUpdates: true)
        }
    }

}

//MARK: - Pause animation set
extension StartWorkoutVC{
    
    func isPauseShow(isShow:Bool){
        
        if isShow{
            //show
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.mainView.vwPause.isHidden = false
                self.mainView.constantVwPauseHeaderHeight.constant = (25/667) * self.mainView.safeAreaHeight
                self.mainView.layoutIfNeeded()
                
            }) { (completed) in
                
                self.pauseSetBlink()
            }
                        
        }else{
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                self.mainView.vwPause.isHidden = true
                self.mainView.constantVwPauseHeaderHeight.constant = 0.0001
                self.mainView.layoutIfNeeded()
                self.mainView.vwPause.layer.removeAllAnimations()
            })
        }
    }

    @objc func pauseSetBlink(){
        self.mainView.vwPause.alpha = 0.2
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveEaseOut, .repeat, .autoreverse], animations: {self.mainView.vwPause.alpha = 1.0}, completion: nil)
    }
    
}
