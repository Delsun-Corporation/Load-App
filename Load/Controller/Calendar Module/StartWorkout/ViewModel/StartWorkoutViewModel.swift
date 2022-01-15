//
//  StartWorkoutViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 03/10/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

protocol StartWorkoutDelegate: class {
    func StartWorkoutFinish(isDone:Bool, exerciseArray:[WeekWiseWorkoutLapsDetails])
    func currentWorkedLapIndex(index:Int)
    func repeatWokout()
    func reloadTblData()
    func closeViewDismissSelectLocationProgram()
}

class StartWorkoutViewModel: SRCountdownTimerDelegate {

    fileprivate weak var theController:StartWorkoutVC!
//    private var circleSlider: CircleSlider!
    var timer: Timer?
    private var minValue: Float = 0
    private var maxValue: Float = 60
    var exerciseArray:[WeekWiseWorkoutLapsDetails] = []
    var isDistance:Bool = false
    var isRest:Bool = false
    var isDuration:Bool = false
    var timeCount:Int = 0
    var index:Int = 0
    weak var delegate:StartWorkoutDelegate?
    var time = 0.5
    
    var timerUpdate : Timer?
    var isRepeatExercise = false

    var isPaused: Bool = false
    var totalDurationInSecond = 0
    var pauseTimeCount = 0
    var isDismissView = true

    var trainingProgramId: String = ""
    var activityName = ""
    var isRunAutoPause = false
    var trailingGradientColor:UIColor!
    var lapTotalDurationManualCalculation = 0
    var isWellDoneAnimationDone = false
    var isCompletedDistanceOnce = false

    
    var handlerStopActivityUpdate : () -> Void = {}
    var handlerPauseOrNot : (Bool) -> Void = {_ in}
    var handlerFinishWorkoutOnEndClick : (UIImage?) -> Void = {_ in}
    var handlerClickOnCloseView : () -> Void = {}

    
    init(theController:StartWorkoutVC) {
        self.theController = theController
    }
    
    //MARK: - SetupUI
    
    func setupUI() {
        let view = (self.theController?.view as? StartWorkoutView)
        
        if activityName.lowercased() == "Outdoor".lowercased() {
            view?.btnMap.isHidden = false
        }else{
            view?.btnMap.isHidden = true
        }
        
        let indexFromMethod = getCurrenIndexOfCurrentLap()
        print("indexFromMethod : \(indexFromMethod)")
        
        trailingGradientColor = drawGradientColor(in: (view?.countdownTimer.bounds)!, colors: [
            UIColor(red:0.45, green:0.19, blue:0.6, alpha:1).cgColor,
            UIColor(red:0.78, green:0.2, blue:0.2, alpha:0.88).cgColor
        ])!
        
        //Both comment because starting it's show value as per we set here after value update to original value
        if !self.isRest {
//            view?.lblCount.text = "00:00:00"
        }
        else {
//            view?.lblCount.text = "\(Int(self.maxValue))"
        }
        
        if let view = (self.theController?.view as? StartWorkoutView){
            view.countdownTimer.trailLineColor = .clear
            view.countdownTimer.delegate = self
            view.imgActivity.image = UIImage(named: "ic_run_red")

        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.checkAndStart()
            
            if self.exerciseArray[self.exerciseArray.count-1].isCompleted == true && self.exerciseArray[self.exerciseArray.count-1].isCompletedRest == true{
                
                if self.activityName.lowercased() == "Outdoor".lowercased() {

                    let routeObjects = Array(realm.objects(CardioActivityRouteTrainingProgram.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.trainingProgramId)}

                    if routeObjects.count > 0{
                        
                        self.theController?.getRouteWhilePause(strPolyline: routeObjects[0].allTrackRoute)
                        
                        self.theController?.isCheckForAutoPause = routeObjects[0].isAutomaticallyPause
                      
                        //TODO: - Outdoor related data change
                        /*
                        if routeObjects[0].isPauseAfterAllLapCompleted == true{
                            
                            if self.timerUpdate != nil{
                                self.timerUpdate?.invalidate()
                                self.timerUpdate = nil
                            }
                            
//                            self.theController?.getTrackDistance()
                            
                            if self.timerUpdate == nil{
                                self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)
                            }

                            self.isPaused = true
                            view?.countdownTimer.pause()
                            view?.btnPlayPause.isSelected = true
                            //For disappering circle border while complete
//                            view?.countdownTimer.clearing = true
                            
                            view?.countdownTimer.isSolidLine = true
                            view?.countdownTimer.setNeedsDisplay()
                            
                        }else{
                            
                            self.isPaused = false
                            view?.countdownTimer.resume()
                            view?.btnPlayPause.isSelected = false
                            
                            self.theController?.getTrackDistance()
                        }*/
                        
                        if self.timerUpdate != nil{
                            self.timerUpdate?.invalidate()
                            self.timerUpdate = nil
                        }
                        
                        if self.timerUpdate == nil{
                            self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)
                        }
                        
                        view?.countdownTimer.isSolidLine = true
                        view?.countdownTimer.setNeedsDisplay()

                        self.theController?.getTrackDistance()
                        self.isPaused = false
                        view?.btnPlayPause.isSelected = false

                    }
                    
                }else{
                    //Indoor
                }
                
            }else{
                
                
                if self.exerciseArray[self.getCurrenIndexOfCurrentLap()].isPause == true{
                    
                    //                self.isPaused = true
                    
                    if self.timerUpdate != nil{
                        self.timerUpdate?.invalidate()
                        self.timerUpdate = nil
                    }
                    
                    //                if self.timerUpdate == nil{
                    //                    self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)
                    //                }
                    
                    if self.activityName.lowercased() == "Outdoor".lowercased() {
                        
                        
                        let routeObjects = Array(realm.objects(CardioActivityRouteTrainingProgram.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.trainingProgramId)}

                        self.theController?.getRouteWhilePause(strPolyline: routeObjects[0].allTrackRoute)
                        
//                        self.theController?.getTrackDistance()
                        
                        if self.timerUpdate == nil{
                            self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)
                        }
                    }else{
                        self.getTotalDurationForIndoorWhenPause()
                        
                        if let valueForIndoor = Defaults.value(forKey: "trainingProgram Indoor \(self.trainingProgramId)") as? Double{
                            self.theController?.distanceOfLapForIndoor = CGFloat(valueForIndoor)
                            
                            if self.isRest == false && self.isDuration == false{
                                view?.lblCount.text = self.theController?.setOneDigitWithFloor(value: (CGFloat((self.theController?.distanceOfLapForIndoor ?? 0)/1000)))
                            }

                        }

                        let count = self.exerciseArray.count
                        self.theController?.totalDistancConverted = self.exerciseArray[count-1].totalDistance
                        
                        view?.lblTotalDistance.text = self.theController?.setOneDigitWithFloor(value: (CGFloat((self.theController?.totalDistancConverted ?? 0)/1000)))

                    }
                    
                    //                self.getTotalDurationForIndoorWhenPause()
                    
                }else{
                    
                    if self.activityName.lowercased() == "Outdoor".lowercased() {
                        self.theController?.getTrackDistance()
                        
                        let routeObjects = Array(realm.objects(CardioActivityRouteTrainingProgram.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.trainingProgramId)}

                        if routeObjects.count > 0 {
                            self.theController?.getRouteWhilePause(strPolyline: routeObjects[0].allTrackRoute)
                        }
                        
                    }else{
                        //starting duration not show
                        self.getTotalDuration()
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                self.theController?.isPauseShow(isShow: view?.btnPlayPause.isSelected ?? false)
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        print("ACTIVE")
        
        if self.activityName.lowercased() == "Outdoor".lowercased() {
            self.theController.checkLocationPermissionAvailableOrNot()
        }
        
        if self.isPaused{

        }else{
            self.getTotalDuration()
            self.checkAndStart()
        }
        
    }

    
    @objc func getTotalDuration(){
        
        if let view = (self.theController?.view as? StartWorkoutView){
            if self.exerciseArray[0].startTime == ""{
                return
            }
            
            let secondDifference = self.exerciseArray[0].startTime.convertDateFormater().secondDifference(to: Date())
            self.totalDurationInSecond = secondDifference
//            if activityName.lowercased() == "Outdoor".lowercased() || activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
                self.theController?.getAvgSpeed()
//            }
            let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: secondDifference)
            view.lblTotalDuration.text = self.makeTimeString(h: h1, m: m1, s: s1)
        }
    }
    
    func getTotalDurationForIndoorWhenPause(){
        
        if let view = (self.theController?.view as? StartWorkoutView){
           
            if self.exerciseArray[0].startTime == ""{
                return
            }
            
            print("******PAUSE START TIME ***** \(self.exerciseArray[0].startTime)")
            
            let secondDifference = self.exerciseArray[0].startTime.convertDateFormater().secondDifference(to: self.exerciseArray[self.index].pauseTime.convertDateFormater())
            
            self.totalDurationInSecond = secondDifference

            let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: secondDifference)
            view.lblTotalDuration.text = self.makeTimeString(h: h1, m: m1, s: s1)
        }
    }

    
    //MARK: - Main method
    func checkAndStart() {
        
        print(self.exerciseArray.toJSON())
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        let view = (self.theController.view as? StartWorkoutView)
        var isFinish:Bool = true
        for (index, data) in self.exerciseArray.enumerated() {
            print(index)
            
            if index == 0 && (data.isCompleted == false || data.isCompleted == nil) {
                
                if data.updatedDuration != nil && data.updatedDuration != "" && (data.repeatTime == nil || data.repeatTime == ""){
                    //Add Duration time in current time and get difference
                    //                    let valueaddingForDuration = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: data.updatedDuration)))
                    //                    let convertToStringForDuration = valueaddingForDuration.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    //                    print("convertToStringForDuration : \(convertToStringForDuration)")
                    //                    data.addedStartTime = convertToStringForDuration
                    
                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: data.updatedRest)))
                    
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    print("convertToStringForRest : \(convertToStringForRest)")
                    data.addedRestTime = convertToStringForRest
                }
                
                if data.startTime != "" && (data.repeatTime == nil || data.repeatTime == ""){
                    
                    data.repeatTime = date
                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: data.updatedRest)))
                    
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    print("convertToStringForRest : \(convertToStringForRest)")
                    data.addedRestTime = convertToStringForRest
                    
                    self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
                }else if (data.startTime == ""){
                    
                    let routeObjects = Array(realm.objects(CardioActivityRouteTrainingProgram.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.trainingProgramId)}
                    
                    if routeObjects.count > 0{
                        try! realm.write{
                            routeObjects[0].startTimeForIndoor = date
                        }
                    }
                    
                    data.startTime = date
                    data.repeatTime = date
                    data.startLat = userCurrentLocation?.coordinate.latitude
                    data.startLong = userCurrentLocation?.coordinate.longitude
                    
                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: data.updatedRest)))
                    
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    print("convertToStringForRest : \(convertToStringForRest)")
                    data.addedRestTime = convertToStringForRest
                    
                    self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
                }
            }
            
            print("isCompleted :\(data.isCompleted)")
            print("isCompletedRest:\(data.isCompletedRest)")
            
            if data.isCompleted == false || data.isCompleted == nil || data.isCompletedRest == false || data.isCompletedRest == nil {
                isFinish = false
                
                let view = (self.theController?.view as? StartWorkoutView)
                view?.countdownTimer.isSolidLine = true
                
                view?.lblCount.textAlignment = .left
                self.index = index
                
                self.delegate?.currentWorkedLapIndex(index: self.index)
                
                if data.isCompleted == false || data.isCompleted == nil {
                    
                    view?.widthOfLblCount.constant = 169
                    
                    view?.btnPlayPause.setImage(UIImage(named: "ic_pause"), for: .normal)
                    view?.btnPlayPause.setImage(UIImage(named: "ic_play_long"), for: .selected)
                    
                    
                    if data.updatedDuration != nil && data.updatedDuration != "" {
                        //                        view?.btnNext.isUserInteractionEnabled = false
                        self.isDuration = true
                        self.isRest = false
                        self.maxValue = 0
                        
                        view?.lblLapsCompleted.text = "\(data.laps ?? 0)/\(self.exerciseArray.count)"
                        view?.lblTotalTimeAndDistance.text = "\(data.updatedDuration ?? "")"
                        view?.lblWorkout.text = "Laps \(data.laps ?? 0)"
                        
                        view?.countdownTimer.trailLineColor = trailingGradientColor
                        
                        self.lapTotalDurationManualCalculation = Int(self.getSeconds(data: data.updatedDuration))
                        
                        if index == 0{
                            
                            if self.exerciseArray[index].isPause == true{
                                self.timeCount = self.exerciseArray[index].repeatTime.convertDateFormater().secondDifference(to: self.exerciseArray[index].pauseTime.convertDateFormater())
                            }else{
                                self.timeCount = self.exerciseArray[index].repeatTime.convertDateFormater().secondDifference(to: Date())
                            }
                            
                        }else{
                            
                            if self.exerciseArray[index].isPause == true{
                                self.timeCount = self.exerciseArray[index].startTime.convertDateFormater().secondDifference(to: self.exerciseArray[index].pauseTime.convertDateFormater())
                            }else{
                                self.timeCount = self.exerciseArray[index].startTime.convertDateFormater().secondDifference(to: Date())
                            }
                        }
                        
                        if self.exerciseArray[index].isPause == true{
                            self.isPaused = true
                            view?.btnPlayPause.isSelected = true
                            view?.countdownTimer.elapsedTime = self.exerciseArray[index].elapsedTime
                            view?.countdownTimer.lineDraw = self.exerciseArray[index].lineDraw
                            
                            self.pauseTimeCount = self.stringTimeConvertIntoInt(strDate: self.exerciseArray[index].lastPauseTime)
                            
                            if (self.timeCount - self.pauseTimeCount) != 0 {
                                self.updatePauseTimeWithMilliseconds(secondsDifference: self.pauseTimeCount - self.timeCount)
                            }
                            
                            self.timeCount = self.pauseTimeCount
                            
                            let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: Int(self.timeCount))
                            view?.lblCount.text = self.makeTimeString(h: h1, m: m1, s: s1)
                            
                            //For disappering circle border while complete
                            //                            view?.countdownTimer.clearing = true
                            view?.countdownTimer.setNeedsDisplay()
                            
                        }else{
                            self.isPaused = false
                            //                            view?.countdownTimer.resume()
                            view?.btnPlayPause.isSelected = false
                            
                            let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: Int(self.timeCount))
                            self.startCountDownTimer(text: self.makeTimeString(h: h1, m: m1, s: s1))
                        }
                        
                    }
                    else {
                        //                        view?.btnNext.isUserInteractionEnabled = true
                        self.isDuration = false
                        self.isRest = false
                        view?.lblCount.textAlignment = .center
                        view?.countdownTimer.trailLineColor = trailingGradientColor
                        
                        if activityName.lowercased() == "Outdoor".lowercased(){
                            view?.lblCount.text = self.theController?.setOneDigitWithFloor(value: (CGFloat(self.theController?.lapCoveredDistance ?? 0)/1000))
                        }else{
                            view?.lblCount.text = "0.0"
                        }
                        
                        //TODO:- Yash Changes
                        //                        self.timeCount = 0
                        //
                        //                        if index == 0{
                        //                            self.timeCount = self.exerciseArray[index].repeatTime.convertDateFormater().secondDifference(to: Date())
                        //                        }else{
                        //                            self.timeCount = self.exerciseArray[index].startTime.convertDateFormater().secondDifference(to: Date())
                        //                        }
                        
                        if index == 0{
                            self.timeCount = self.exerciseArray[index].repeatTime.convertDateFormater().secondDifference(to: Date())
                            
                            //Time count starting 2 because it's directly show well done animation
                            self.timeCount = self.timeCount == 0 ? 2 : self.timeCount
                        }else{
                            self.timeCount = self.exerciseArray[index].startTime.convertDateFormater().secondDifference(to: Date())
                            //Time count starting 2 because it's directly show well done animation
                            self.timeCount = self.timeCount == 0 ? 2 : self.timeCount
                        }
                        
                        //TODO: - Last comment for Indoor/Outdoor
                        //                        if self.activityName.lowercased().contains("Indoor".lowercased()){
                        //                            view?.lblTotalTimeAndDistance.text = findingDurationFromDistance(model: data)
                        //                        }else{
                        //                            view?.lblTotalTimeAndDistance.text = "\(data.distance ?? 0.0)"
                        //                        }
                        
                        view?.lblTotalTimeAndDistance.text = "\(data.updatedDistance ?? 0.0) km"
                        
                        view?.lblLapsCompleted.text = "\(data.laps ?? 0)/\(self.exerciseArray.count)"
                        view?.lblWorkout.text = "Laps \(data.laps ?? 0)"
                        
                        //MARK: - Only for circle round
                        
                        if self.exerciseArray[index].isPause == true{
                            self.isPaused = true
                            //                            view?.countdownTimer.pause()
                            view?.btnPlayPause.isSelected = true
                            view?.countdownTimer.elapsedTime = self.exerciseArray[index].elapsedTime
                            view?.countdownTimer.lineDraw = self.exerciseArray[index].lineDraw
                            
                            if self.exerciseArray[index].lineDraw == false{
                                self.timeCount = 0
                            }else{
                                self.timeCount = 1
                            }
                            
                            //For disappering circle border while complete
                            //                            view?.countdownTimer.clearing = true
                            view?.countdownTimer.setNeedsDisplay()
                            
                        }else{
                            self.isPaused = false
                            view?.btnPlayPause.isSelected = false
                            self.startCountDownTimer(text: "")
                        }
                        
                        //                        self.startCountDownTimer(text: "00:00:00")
                    }
                    
                    let rest = calculateDuration(data: data.updatedRest)
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: rest)
                    
                    //                    self.theController?.checkChangeAbleParameter()
                    
                    if index+1 == self.exerciseArray.count{
                        
                        if data.updatedRest == nil {
                            self.btnCompleted(strTitle: "Completed")
                        }else{
                            self.btnNextRestOrLap(strTitle: "Rest")
                        }
                        
                    }else{
                        
                        if self.exerciseArray[index].updatedRest == nil || self.exerciseArray[self.index].updatedRest == ""{
                            
                            if (self.exerciseArray[index+1].updatedDuration == nil || self.exerciseArray[index+1].updatedDuration == "") && (self.exerciseArray[index+1].updatedDistance == nil || self.exerciseArray[index+1].updatedDistance == 0.0){
                                
                                if self.exerciseArray[index+1].updatedRest == "" || self.exerciseArray[index+1].updatedRest == nil{
                                    if index+2 == self.exerciseArray.count{
                                        self.btnCompleted(strTitle: "Completed")
                                    }else{
                                        self.btnNextRestOrLap(strTitle: "Laps \((data.laps ?? 0) + 2)")
                                    }
                                }else{
                                    self.btnNextRestOrLap(strTitle: "Rest")
                                }
                                
                            }else{
                                self.btnNextRestOrLap(strTitle: "Laps \((data.laps ?? 0) + 1)")
                            }
                            
                        }else{
                            self.btnNextRestOrLap(strTitle: "Rest")
                        }
                        
                    }
                    
                }
                else if data.isCompletedRest == false || data.isCompletedRest == nil {
                    
                    view?.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                    view?.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)
                    
                    view?.countdownTimer.trailLineColor = .black
                    //                    view?.btnNext.isUserInteractionEnabled = false
                    self.isDuration = false
                    self.isRest = true
                    view?.lblLapsCompleted.text = "\(data.laps ?? 0)/\(self.exerciseArray.count)"
                    view?.lblCount.textAlignment = .left
                    self.timeCount = 0
                    
                    var secondDifference = 0
                    
                    if self.exerciseArray[index].isPause == true{
                        secondDifference = self.exerciseArray[index].pauseTime.convertDateFormater().secondDifference(to: self.exerciseArray[index].addedRestTime.convertDateFormater())
                        self.maxValue = Float(secondDifference)

                    }else{
                        secondDifference = Date().secondDifference(to: self.exerciseArray[index].addedRestTime.convertDateFormater())
                        self.maxValue = Float(secondDifference)

                    }
                    
                    //                    let rest = calculateDuration(data: data.updatedRest)
                    
                    view?.lblWorkout.text = "Laps \(data.laps ?? 0)"
                    
                    let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: Int(calculateDuration(data: data.updatedRest)))
                    
                    view?.lblWorkout.text = "Rest"
                    view?.lblTotalTimeAndDistance.text = self.makeTimeStringForRest(h: h1, m: m1, s: s1)
                    
                    if self.exerciseArray[index].isPause == true{
                        self.isPaused = true
//                        view?.countdownTimer.pause()
                        view?.btnPlayPause.isSelected = true
                        view?.countdownTimer.elapsedTime = self.exerciseArray[index].elapsedTime
                        view?.countdownTimer.lineDraw = self.exerciseArray[index].lineDraw

                        //MARK: - Remaining to setlike Duration
                        self.pauseTimeCount = self.stringTimeConvertIntoInt(strDate: self.exerciseArray[index].lastPauseTime)

                        if (self.pauseTimeCount - Int(self.maxValue)) != 0 {
                            self.updatePauseTimeWithMilliseconds(secondsDifference: self.pauseTimeCount - Int(self.maxValue))
                        }

                        self.maxValue = Float(self.pauseTimeCount)
                        
                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(self.maxValue))
                        view?.lblCount.text = self.makeTimeStringForRest(h: h, m: m, s: s)

                        //For disappering circle border while complete
//                        view?.countdownTimer.clearing = true
                        view?.countdownTimer.setNeedsDisplay()
                    }else{
                        self.isPaused = false
//                        view?.countdownTimer.resume()
                        view?.btnPlayPause.isSelected = false
                        
                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(self.maxValue))
                        self.startCountDownTimer(text:  self.makeTimeStringForRest(h: h, m: m, s: s))
                    }
                    
                    view?.widthOfLblCount.constant = 110
                    
                    self.checkNext()
                }
                
                break
            } else {
                
                let isDone = (index < (self.exerciseArray.count)) ? true : false
                print("isDone : \(isDone)")
                
                if isDone{
                    
                    if (index+1) != self.exerciseArray.count{
//                        if (exerciseArray[index+1].isCompleted == false || exerciseArray[index+1].isCompleted == nil) && (exerciseArray[index+1].startTime == "" || exerciseArray[index+1].startTime == nil){
                        if (exerciseArray[index+1].startTime == "" || exerciseArray[index+1].startTime == nil){

                            let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[index+1].updatedRest)))
                        
                            let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                            print("convertToStringForRest : \(convertToStringForRest)")
                        
                            //Comment below line because distance we cannot find exact finish time
                            self.exerciseArray[index+1].addedRestTime = convertToStringForRest

                            print("self.Indexxxxx : \(index+1)")
                            self.exerciseArray[index+1].startTime = date
                            self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
                        }
                    }
                }
            }
            
        }
        
        if let data = self.exerciseArray.last {
            data.endTime = date
            data.endLat = userCurrentLocation?.coordinate.latitude
            data.endLong = userCurrentLocation?.coordinate.longitude
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            if isFinish {
                //                self.timer?.invalidate()
                //                self.timer = nil
                
                //                self.theController?.dismiss(animated: true, completion: nil)
                //                self.delegate?.StartWorkoutFinish(isDone: true, exerciseArray: self.exerciseArray)
                
                if self.isWellDoneAnimationDone == false{
                    self.wellDoneAnimation()
                }else{
                    self.isWellDoneAnimationDone = false
                }
                
                self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
                //                self.index = self.exerciseArray.count - 1
                //                self.delegate?.currentWorkedLapIndex(index: self.index)
                
                //                self.getTotalDurationAfterCompletion()
                
                if self.timerUpdate != nil{
                    self.timerUpdate?.invalidate()
                    self.timerUpdate = nil
                }
                
                self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)
                
                //MARK: - COMMENT CHECK
                //                self.isPaused = true
                
                self.theController?.removeTimerOfMotion()
                self.theController?.isCheckForAutoPause = false
                
                //for disapper last part of timer while complete rest
                
                if let vw = self.theController?.view as? StartWorkoutView{
                    
                    vw.btnRepeat.setColor(color: .appthemeOffRedColor)
                    vw.vwRepeat.borderColors = UIColor.appthemeOffRedColor
                    vw.vwRepeat.setShadowToView()
                    vw.btnRepeat.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
                    vw.btnRepeat.isUserInteractionEnabled = true
                    vw.lblLapsCompleted.text = "\(self.exerciseArray.count)/\(self.exerciseArray.count)"
                    
                    //                    vw.lblNextWorkout.text = "Workout completed"
                    
                    //Prevent animation of button title
                    UIView.setAnimationsEnabled(false)
                    self.btnCompleted(strTitle: "Completed")
                    UIView.setAnimationsEnabled(true)
                    vw.btnNext.layoutIfNeeded()
                    
                    //For disappering circle border while complete
                    vw.countdownTimer.clearing = false
                    vw.countdownTimer.isSolidLine = false
                    vw.countdownTimer.trailLineColor = UIColor.black
                    vw.countdownTimer.setNeedsDisplay()
                    
                    vw.btnPlayPause.isUserInteractionEnabled = false
                    vw.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                    vw.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)
                                        
                    self.index = self.exerciseArray.count - 1
                    
                    if self.exerciseArray[self.index].updatedRest == nil || self.exerciseArray[self.index].updatedRest == ""{
                        
                        if (self.exerciseArray[self.index].updatedDuration == nil || self.exerciseArray[self.index].updatedDuration == "") && (self.exerciseArray[self.index].updatedDistance == nil || self.exerciseArray[self.index].updatedDistance == 0.0){
                            
                            if self.exerciseArray[self.index-1].updatedRest == "" || self.exerciseArray[self.index-1].updatedRest == nil{
                                
                                if self.exerciseArray[self.index-1].updatedDuration != nil && self.exerciseArray[self.index-1].updatedDuration != ""{
                                    vw.lblCount.text = (self.exerciseArray[self.index-1].updatedDuration ?? "")
                                }else{
                                    vw.lblCount.text = "\(self.exerciseArray[self.index-1].updatedDistance ?? 0.0) km"
                                }
                                
                            }else{
                                //next completed rest not blank so it's not true
                                vw.lblCount.text = "00:00"
                            }
                            
                        }else{
                            //current completedRest true
                            if self.exerciseArray[self.index].updatedDuration != nil && self.exerciseArray[self.index].updatedDuration != ""{
                                vw.lblCount.text = (self.exerciseArray[self.index].updatedDuration ?? "")
                            }else{
                                vw.lblCount.text = "\(self.exerciseArray[self.index].updatedDistance ?? 0.0) km"
                            }

                        }
                        
                    }else{
                        vw.lblCount.text = "00:00"
                    }
                    
                    if self.timerUpdate != nil{
                        self.timerUpdate?.invalidate()
                        self.timerUpdate = nil
                    }
                    
                    self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)

                }
                
            }else{
                if let vw = self.theController?.view as? StartWorkoutView{
                    vw.btnRepeat.setColor(color: .black)
                    vw.vwRepeat.borderColors = UIColor.black
                    vw.vwRepeat.shadowColors = .clear
                    vw.btnRepeat.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
                    vw.btnRepeat.isUserInteractionEnabled = false
                    vw.btnRepeat.backgroundColor = .white
                    
                    //                    vw.btnNext.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func finishWorkout() {
        self.theController?.dismiss(animated: false) {
            self.delegate?.StartWorkoutFinish(isDone: true, exerciseArray: self.exerciseArray)
        }
    }
    
    func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState()
        }

        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
        context?.clear(rect)
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }
    
    
    func getSeconds(data: String?) -> Float {
        let dataArray = data?.split(separator: "-")
        if dataArray?.count == 2 {
            let secondArray = dataArray?[1].split(separator: ":")
            
            let sHr = (Double(secondArray?[0] ?? "0") ?? 0) * 60 * 60
            let sMin = (Double(secondArray?[1] ?? "0") ?? 0) * 60
            let sSec = (Double(secondArray?[2] ?? "0") ?? 0)
            
            let secondCount = sHr + sMin + sSec
            return Float(secondCount)
        }
        else {
            let firstArray = data?.split(separator: ":")
            if (firstArray?.count ?? 0) == 3 {
                let fHr = (Double(firstArray?[0] ?? "0") ?? 0) * 60 * 60
                let fMin = (Double(firstArray?[1] ?? "0") ?? 0) * 60
                let fSec = (Double(firstArray?[2] ?? "0") ?? 0)
                
                let firstCount = fHr + fMin + fSec
                return Float(firstCount)
            } else if (firstArray?.count ?? 0) == 2 {
                let fMin = (Double(firstArray?[0] ?? "0") ?? 0) * 60
                let fSec = (Double(firstArray?[1] ?? "0") ?? 0)
                
                let firstCount = fMin + fSec
                return Float(firstCount)
            }
            else {
                return Float(0)
            }
        }
    }
    
    func checkNext() {
        let view = (self.theController?.view as? StartWorkoutView)
        if self.exerciseArray.count == (self.index + 1) {
//            view?.lblNextWorkout.text = "Workout completed"
            self.btnCompleted(strTitle: "Completed")

        }
        else {
            

            for (index, data) in self.exerciseArray.enumerated() {
                if index == (self.index + 1) {
                    if data.isCompleted == false || data.isCompleted == nil {
//                        view?.lblNextWorkout.text = "Laps \(data.laps ?? 0)"
                        self.btnNextRestOrLap(strTitle: "Laps \(data.laps ?? 0)")
                    }
                    else if data.isCompletedRest == false || data.isCompletedRest == nil {
                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(data.updatedRest ?? "0") ?? 0)
//                        view?.lblNextWorkout.text = self.makeTimeString(h: h, m: m, s: s) + " rest"
                        self.btnNextRestOrLap(strTitle: self.makeTimeStringForRest(h: h, m: m, s: s) + " rest")
                        
                        //MARK: - Add here because After Rest complition check Start_time for next Lap
                            //If we added below line in Next click button that time Rest is also consider in Start_time
//                        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
//                        print("date:\(date)")
//                        self.exerciseArray[self.index + 1].startTime = date
//                        self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
                    }
                    break
                }
            }
        }
    }
    
    func setUpPinOnMap(lat:Double,long:Double) {
        let view = (self.theController.view as? StartWorkoutView)
        view?.mapView.layoutIfNeeded()
        let cameraCoord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        view?.mapView.camera = GMSCameraPosition.camera(withTarget: cameraCoord, zoom: 15)
        let updateCamera = GMSCameraUpdate.setTarget(cameraCoord, zoom: 15)
        view?.mapView.animate(with: updateCamera)
        view?.mapView.layoutIfNeeded()
    }
    
    //MARK: - Timer method
    
    func startCountDownTimer(text:String) {
        
        let view = (self.theController.view as? StartWorkoutView)
      
        if isRest == true || isDuration == true{
            view?.lblCount.text = text
        }
        
        view?.countdownTimer.start(beginingValue: 1, interval: 1)
        
        if self.isRest{
            
            view?.countdownTimer.trailLineColor = UIColor.black
            if Int(maxValue) == 0{
                
                if self.index == self.exerciseArray.count - 1{
                    print("=====================first=================")
                    view?.countdownTimer.isSolidLine = false
                }
            }

            if (Int(maxValue) ?? 0) % 2 == 0 {
                view?.countdownTimer.lineDraw = false

//                view?.countdownTimer.lineColor = UIColor.black
//                view?.countdownTimer.trailLineColor = UIColor.white
            }else{
                view?.countdownTimer.lineDraw = true

//                view?.countdownTimer.lineColor = UIColor.white
//                view?.countdownTimer.trailLineColor = UIColor.black
                //                view?.countdownTimer.isShowGradient = true
            }
            
        }else{
            
            view?.countdownTimer.trailLineColor = trailingGradientColor
            
            if self.exerciseArray[self.index].updatedRest == nil {
                
                //This is help ful only in duration
                if Int(timeCount) == lapTotalDurationManualCalculation{
                    
                    if self.index == self.exerciseArray.count - 1{
                        if self.lapTotalDurationManualCalculation % 2 == 0{
                            view?.countdownTimer.trailLineColor = UIColor.black
                            view?.countdownTimer.isSolidLine = false
                            self.isWellDoneAnimationDone = true
                            self.wellDoneAnimation()
                            view?.btnPlayPause.isUserInteractionEnabled = false
                            view?.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                            view?.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)

                        }
                    }
                }
            }
            
            if (Int(timeCount) ) % 2 == 0 {
                view?.countdownTimer.lineDraw = false
            }else{
                view?.countdownTimer.lineDraw = true
            }
        }
    }
    
    func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval) {
        
        if self.timerUpdate != nil{
            self.timerUpdate?.invalidate()
            self.timerUpdate = nil
        }

        if isPaused {
            return
        }
            
        if self.index == self.exerciseArray.count - 1{
            if self.isRest{
                if self.maxValue == 0{
                    if let view = (self.theController?.view as? StartWorkoutView){
                        view.countdownTimer.setNeedsDisplay()
                    }
                    return
                }
            }
            else{
                if self.isDuration == true {
                    if self.index+1 == self.exerciseArray.count{
                        if self.exerciseArray[self.index].updatedRest == nil{
                            if self.lapTotalDurationManualCalculation < self.timeCount{
                                if self.lapTotalDurationManualCalculation % 2 != 0{
                                    return
                                }
                            }
                        }
                    }
                }else {
                    
                    if self.index == self.exerciseArray.count - 1{
                        if self.exerciseArray[self.index].updatedRest == nil{
                            
                            let lapDistance = (self.exerciseArray[self.index].updatedDistance ?? 0.0)*1000
                            
                            if activityName.lowercased() == "Outdoor".lowercased() {
                                
                                let routeObjects = Array(realm.objects(CardioActivityRouteTrainingProgram.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.trainingProgramId)}
                                
                                if routeObjects.count > 0{
                                    if (routeObjects[0].lapArray[self.index].lapCoverDistance) >= Double(lapDistance){
                                        if let view = (self.theController?.view as? StartWorkoutView){
                                            if self.isCompletedDistanceOnce{
                                                view.countdownTimer.setNeedsDisplay()
                                                self.isCompletedDistanceOnce = false
                                                return
                                            }
                                        }
                                    }
                                }
                                
                            }else{
                                if (self.theController?.distanceOfLapForIndoor ?? 0.0) >= lapDistance{
                                    if let view = (self.theController?.view as? StartWorkoutView){
                                        if self.isCompletedDistanceOnce{
                                            view.countdownTimer.setNeedsDisplay()
                                            self.isCompletedDistanceOnce = false
                                            return
                                        }
                                    }
                                }
                            }
                        }
                    }else{
                        
                    }
                }
            }
            
        }

        playNext()
    }
    
    func timerDidPause(sender: SRCountdownTimer) {
        print("Pause")
        self.exerciseArray[self.index].elapsedTime = sender.elapsedTime
        if isRest == true{
            self.exerciseArray[self.index].lineDraw = Int(maxValue) % 2 == 0 ? false : true
        }else{
            self.exerciseArray[self.index].lineDraw = Int(timeCount) % 2 == 0 ? false : true
        }
        
    }
    
    func timerDidResume(sender: SRCountdownTimer) {
        print("Resume")
        
        sender.resumeTimer(elapsedTime: TimeInterval(self.exerciseArray[self.index].elapsedTime), beginingValue: 1 ,interval: 1)
        
//        self.exerciseArray[self.index].currentAngle = 0
//        self.exerciseArray[self.index].lineDraw = Int(timeCount) % 2 == 0 ? false : true
//        if let view = self.theController?.view as? StartWorkoutResistanceView{
//            view.countdownTimer.currentAngelCheckk = 0.0
//        }
    }
    
    func playNext() {
        
        if let view = (self.theController?.view as? StartWorkoutView){
            if self.isRest{
                
//                || self.isDuration {
//                if self.isRest{
                    self.maxValue -= 1
//                }else{
//                    self.maxValue += 1
//                }
                
                let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(self.maxValue))
                view.lblCount.text = self.makeTimeStringForRest(h: h, m: m, s: s)

                if self.maxValue > 0 {
                    self.startCountDownTimer(text: self.makeTimeStringForRest(h: h, m: m, s: s))
                }
                else {
                        self.exerciseArray[index].isCompletedRest = true

                    //Yash comment
                    //                self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)

                    //for disapper last part of timer while complete rest
//                    view.countdownTimer.clearing = true
//                    view.countdownTimer.setNeedsDisplay()
                    
                    if self.index == self.exerciseArray.count - 1{
                        self.startCountDownTimer(text: "00:00")
                        view.countdownTimer.setNeedsDisplay()
                        self.isWellDoneAnimationDone = true
                        self.wellDoneAnimation()
                        
                    }else{
                        view.countdownTimer.isSolidLine = true
                    }
                    
                    self.theController?.clickOnNextAndForRest()

                    self.checkAndStart()

                }
            }
            else{
                
                self.timeCount += 1
                
                //set condition only for apply in duration
                
                if self.isDuration == true {
                    
                    if self.index+1 == self.exerciseArray.count{
                        
                        if self.exerciseArray[self.index].updatedRest == nil{
                            
                            if self.lapTotalDurationManualCalculation < self.timeCount{
                                self.exerciseArray[self.index].isCompletedRest = true
                                self.exerciseArray[self.index].isCompleted = true
                                
                                // set for odd duration
                                if self.lapTotalDurationManualCalculation % 2 != 0{
                                    self.startCountDownTimer(text: self.exerciseArray[self.index].updatedDuration ?? "")
                                    view.countdownTimer.trailLineColor = UIColor.black
                                    view.countdownTimer.setNeedsDisplay()
                                    view.countdownTimer.isSolidLine = false
                                    self.isWellDoneAnimationDone = true
                                    self.wellDoneAnimation()
                                }else{
                                    view.countdownTimer.setNeedsDisplay()
                                }
                               
                                view.btnPlayPause.isUserInteractionEnabled = false
                                view.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                                view.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)
                                
                                checkAndStart()
                                
                                return
                            }
                        }
                    }
                    
                    view.countdownTimer.isSolidLine = true
                    
                    //                let view = (self.theController?.view as? StartWorkoutView)
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: self.timeCount)
                    view.lblCount.text = self.makeTimeString(h: h, m: m, s: s)
                    self.startCountDownTimer(text: view.lblCount.text?.toTrim() ?? "")
                    
                    if self.lapTotalDurationManualCalculation < self.timeCount{
                        print("Timer finish")
                        self.exerciseArray[self.index].isCompleted = true
                        
                        if self.exerciseArray[self.index].updatedRest == nil || self.exerciseArray[self.index].updatedRest == "" {
                            
                            self.exerciseArray[self.index].isCompletedRest = true

                            if (self.exerciseArray[self.index+1].updatedDuration == nil || self.exerciseArray[self.index+1].updatedDuration == "") && (self.exerciseArray[self.index+1].updatedDistance == nil || self.exerciseArray[self.index+1].updatedDistance == 0.0){
                                
                                self.exerciseArray[self.index+1].isCompleted = true

                                if self.exerciseArray[self.index+1].updatedRest == "" || self.exerciseArray[self.index+1].updatedRest == nil{
                                    
                                    self.exerciseArray[self.index+1].isCompletedRest = true

                                    if self.index+2 == self.exerciseArray.count{
                                        
                                        // set for odd duration
                                        if self.lapTotalDurationManualCalculation % 2 != 0{
                                            self.startCountDownTimer(text: self.exerciseArray[self.index+2].updatedDuration ?? "")
                                            view.countdownTimer.trailLineColor = UIColor.black
                                            view.countdownTimer.setNeedsDisplay()
                                            view.countdownTimer.isSolidLine = false
                                            self.isWellDoneAnimationDone = true
                                            self.wellDoneAnimation()
                                        }else{
                                            view.countdownTimer.setNeedsDisplay()
                                        }
                                       
                                        view.btnPlayPause.isUserInteractionEnabled = false
                                        view.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                                        view.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)

                                    }else{
        //                                self.exerciseArray[self.index+1].isCompletedRest = true
                                    }
                                }else{
                                   //next completed rest not blank so it's not true
                                    let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")

                                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[self.index+1].updatedRest)))
                                    
                                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                                    self.exerciseArray[self.index+1].addedRestTime = convertToStringForRest

                                }
                                
                            }else{
                                //current completedRest true
                            }
                            
                        } else {
                            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                            
                            let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[self.index].updatedRest)))
                            
                            let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                            self.exerciseArray[self.index].addedRestTime = convertToStringForRest

                        }
                        
                        checkAndStart()
                    }
                    
                }else{
                    
                    //MARK: - For distance round circle purpose only
//                    self.startCountDownTimer(text: "")
                    
                    self.forDistanceCheckWellDoneAnimationAndRestTime()
                }
            }
        }
        
        //        self.timeCountTotalDuration += 1
        //        let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: self.timeCountTotalDuration)
        //        view?.lblTotalDuration.text = self.makeTimeString(h: h1, m: m1, s: s1)
        
        //TODO: - Last Commnet YAsh
        getTotalDuration()
    }
    
    
    func forDistanceCheckWellDoneAnimationAndRestTime(){
        
        let routeObjects = Array(realm.objects(CardioActivityRouteTrainingProgram.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.weekWiseProgramId == Int(self.trainingProgramId)}
        
        let lapDistance = (self.exerciseArray[self.index].updatedDistance ?? 0.0)*1000
        
        if let view = (self.theController?.view as? StartWorkoutView){
            
            if self.index+1 == self.exerciseArray.count{
                
                if self.exerciseArray[self.index].updatedRest == nil{
                    
                    var trackedDistance : CGFloat = 0.0
                    
                    if self.activityName.lowercased() == "Outdoor".lowercased() {
                        if routeObjects.count > 0{
                            trackedDistance = CGFloat(routeObjects[0].lapArray[self.index].lapCoverDistance)
                        }
                    }else{
                        trackedDistance = self.theController.distanceOfLapForIndoor
                    }
                    
                    if trackedDistance >= lapDistance {
                        
                        self.exerciseArray[self.index].isCompletedRest = true
                        self.exerciseArray[self.index].isCompleted = true
                        
                        self.index = self.exerciseArray.count - 1
                        print("self.index:\(self.index)")

                        print("******************************Distance******************************")
                        
                        if self.timeCount % 2 == 0{
                            
                            self.isCompletedDistanceOnce = true
                            self.startCountDownTimer(text: "")
                            
                            view.countdownTimer.trailLineColor = UIColor.black
                            view.countdownTimer.setNeedsDisplay()
                            view.countdownTimer.isSolidLine = false
                            self.isWellDoneAnimationDone = true
                            self.wellDoneAnimation()
                            
                            view.btnPlayPause.isUserInteractionEnabled = false
                            view.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                            view.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)
                            checkAndStart()

                        }else{
                            self.startCountDownTimer(text: "")
                            view.countdownTimer.isSolidLine = true
                        }
                        view.lblCount.text = "\(self.exerciseArray[self.index].updatedDistance ?? 0.0)"

                        return
                    }else{
                        //MARK: - For distance round circle purpose only
                        self.startCountDownTimer(text: "")
                        return
                    }
                    
                }
            }
            
            view.countdownTimer.isSolidLine = true
            
            var trackedDistance : CGFloat = 0.0
            
            if self.activityName.lowercased() == "Outdoor".lowercased() {
                if routeObjects.count > 0{
                    trackedDistance = CGFloat(routeObjects[0].lapArray[self.index].lapCoverDistance)
                }
            }else{
                trackedDistance = self.theController.distanceOfLapForIndoor
            }
            
            print("STRTWORKOUT MODEL DISTANCE ****************** \(trackedDistance) ****************** INDEX ;\(self.index)")

            if trackedDistance >= lapDistance {
                
                self.exerciseArray[self.index].isCompleted = true
                
                if self.exerciseArray[self.index].updatedRest == nil || self.exerciseArray[self.index].updatedRest == "" {
                    
                    self.exerciseArray[self.index].isCompletedRest = true
                    
                    if (self.exerciseArray[self.index+1].updatedDuration == nil || self.exerciseArray[self.index+1].updatedDuration == "") && (self.exerciseArray[self.index+1].updatedDistance == nil || self.exerciseArray[self.index+1].updatedDistance == 0.0){
                        
                        self.exerciseArray[self.index+1].isCompleted = true
                        
                        if self.exerciseArray[self.index+1].updatedRest == "" || self.exerciseArray[self.index+1].updatedRest == nil{
                            
                            self.exerciseArray[self.index+1].isCompletedRest = true
                            
                            if self.index+2 == self.exerciseArray.count{
                                

                                if (Int(timeCount) ) % 2 == 0 {
                                    
                                    self.index = self.exerciseArray.count - 1
                                    
                                    self.isCompletedDistanceOnce = true
                                    self.startCountDownTimer(text: "")
                                    
                                    view.lblCount.text = "\(self.exerciseArray[self.index].updatedDistance ?? 0.0)"
                                    view.countdownTimer.trailLineColor = UIColor.black
                                    view.countdownTimer.setNeedsDisplay()
                                    view.countdownTimer.isSolidLine = false
                                    self.isWellDoneAnimationDone = true
                                    self.wellDoneAnimation()
                                    
                                    view.btnPlayPause.isUserInteractionEnabled = false
                                    view.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                                    view.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)

                                    checkAndStart()
                                    
                                    return
                                }else{
                                    //MARK: - For distance round circle purpose only
                                    view.countdownTimer.isSolidLine = true
                                    self.startCountDownTimer(text: "")
                                    view.lblCount.text = "\(self.exerciseArray[self.index].updatedDistance ?? 0.0)"

                                    return
                                }
                                
                            }else{
                                //                                self.exerciseArray[self.index+1].isCompletedRest = true
                            }
                        }else{
                            //next completed rest not blank so it's not true
                            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                            
                            let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[self.index+1].updatedRest)))
                            
                            let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                            self.exerciseArray[self.index+1].addedRestTime = convertToStringForRest
                            
                        }
                        
                    }else{
                        print("Here value")
                        //current completedRest true
                    }
                    
                } else {
                    let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    
                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[self.index].updatedRest)))
                    
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    self.exerciseArray[self.index].addedRestTime = convertToStringForRest
                    
                }
                
                if (Int(timeCount) ) % 2 == 0 {
                    
                    if (activityName.lowercased() == "Outdoor".lowercased()){
                        
                        if routeObjects.count > 0{
                            
                            self.theController.lapCoveredDistance = 0.0
                            
                            let strPolyLine = routeObjects[0].allTrackRoute
                            self.theController.handlerForPassDataOfParticularLapWithPolyline(strPolyLine, 0)
                        }
                        
                    } else {
                        self.theController.handlerForIndoorParticularLapForReset(0)
                        self.theController.distanceOfLapForIndoor = 0
                        self.theController.reCallMainCountingStep()
                    }
                    
                    checkAndStart()
                }else{
                    startCountDownTimer(text: "")
                }
                
            }else{
                self.startCountDownTimer(text: "")
            }
            
        }
    }
    
    
    /*
    func makeTimeString(h:Int, m:Int, s:Int) -> String {
        var str:String = ""
        if h != 0 {
            str += "\(h)".count == 1 ? "0\(h):" : "\(h):"
        }
        if m != 0 {
            str += "\(m)".count == 1 ? "0\(m):" : "\(m):"
        }
        else if h != 0 {
            str += "00:"
        }
        
        if s != 0 {
            str += "\(s)".count == 1 ? "0\(s)" : "\(s)"
        }
        else {
            str += "00"
        }
        
        if str.last == ":" {
            str.removeLast()
        }
        
        return str
    }*/
    
    
    func makeTimeString(h:Int, m:Int, s:Int) -> String {
       
        var hourStr = ""
        var minuteStr = ""
        var secondStr = ""
        
        //For Hour
        if (h) <= 9{
            hourStr = "0\(h)"
        }else{
            hourStr = "\(h)"
        }
        
        //ForMinutes
        if (m) <= 9{
            minuteStr = "0\(m)"
        }else{
            minuteStr = "\(m)"
        }
        
        //For Seconds
        
        if (s) <= 9{
            secondStr = "0\(s)"
        }else{
            secondStr = "\(s)"
        }
        
        return hourStr + ":" + minuteStr + ":" + secondStr
//        return "\(hourStr):\(minuteStr):\(secondStr)"
    }
    
    func makeTimeStringForRest(h:Int, m:Int, s:Int) -> String {
       
        var hourStr = ""
        var minuteStr = ""
        var secondStr = ""
        
        //For Hour
        if (h) <= 9{
            hourStr = "0\(h)"
        }else{
            hourStr = "\(h)"
        }
        
        //ForMinutes
        if (m) <= 9{
            minuteStr = "0\(m)"
        }else{
            minuteStr = "\(m)"
        }
        
        //For Seconds
        if (s) <= 9{
            secondStr = "0\(s)"
        }else{
            secondStr = "\(s)"
        }
        
        return "\(minuteStr):\(secondStr)"
    }

    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func closeView()
    {

        self.handlerFinishWorkoutOnEndClick(nil)
//        self.handlerPauseOrNot(false)

        if isDismissView{
            self.isDismissView = false

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()){
                self.isPaused = true
                self.delegate?.currentWorkedLapIndex(index: self.index)
                self.handlerClickOnCloseView()

                self.theController?.dismiss(animated: false) {
                    if self.timerUpdate != nil{
                        self.timerUpdate?.invalidate()
                        self.timerUpdate = nil
                    }
                    
                    if self.theController?.timerForMotion != nil{
                        self.theController?.timerForMotion?.invalidate()
                        self.theController?.timerForMotion = nil
                    }
                }
                
                self.delegate?.closeViewDismissSelectLocationProgram()

                self.isDismissView = true
            }
        }
    }
    
    func stringTimeConvertIntoInt(strDate:String) -> Int{
        
        let dataArray = strDate.split(separator: ":")
        
        if dataArray.count == 3{

            let hrData = Int(dataArray[0]) ?? 0
            let minuteData = Int(dataArray[1]) ?? 0
            let secondData = Int(dataArray[2]) ?? 0

            return (hrData * 3600) + (minuteData * 60) + secondData
        }
        else if dataArray.count == 2{
            let minuteData = Int(dataArray[0]) ?? 0
            let secondData = Int(dataArray[1]) ?? 0
            
            return (minuteData * 60) + secondData
        }
        
        return 0
        
    }
    
    func calculateDuration(data:String?) -> Int {
        if data?.contains(":") ?? false {
            let firstArray = data?.split(separator: ":")
            let fMin = (Double(firstArray?[0] ?? "0") ?? 0) * 60
            let fSec = (Double(firstArray?[1] ?? "0") ?? 0)
            let firstCount = fMin + fSec
            return Int(firstCount)
        }
        else {
            return Int(data ?? "0") ?? 0
        }
    }
    
    func wellDoneAnimation(){
        
        if let view = self.theController?.view as? StartWorkoutView{
            
            view.lblWorkout.text = ""
            
            view.lblTotalTimeAndDistance.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            view.lblTotalTimeAndDistance.text = getCommonString(key: "Well_done!_key")
            
            view.lblTotalTimeAndDistance.alpha = 0.5
            
            UIView.animate(withDuration: 0.6,
                                       delay:0.0,
                                       usingSpringWithDamping:0.6,
                                       initialSpringVelocity:0.3,
                                       options: .curveEaseOut,
                                       animations: {
                                        
                                        view.lblTotalTimeAndDistance.alpha = 1
                                        view.lblTotalTimeAndDistance.textColor = .appthemeOffRedColor
                                        view.lblTotalTimeAndDistance.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: {
                //Code to run after animating
                (value: Bool) in
                
            })
            
        }
    }
    
    func getCurrenIndexOfCurrentLap() -> Int{
        for i in 0..<exerciseArray.count{
            let model = exerciseArray[i]
            if model.startTime != "" && ((model.isCompleted == false || model.isCompleted == nil) || (model.isCompleted == true && (model.isCompletedRest == false || model.isCompletedRest == nil))){
                return i
            }
        }
        
        return 0
    }
    
    func btnNextRestOrLap(strTitle:String){
        
        if let view = self.theController?.view as? StartWorkoutView{
            
            view.btnNext.setTitle(strTitle, for: .normal)
            view.btnNext.setTitleColor(UIColor.appthemeOffRedColor, for: .normal)
            view.btnNext.setImage(UIImage(named: "ic_next-1"), for: .normal)
            view.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            view.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            view.vwNextWorkout.borderColors = UIColor.appthemeOffRedColor
            view.vwNextWorkout.setShadowToView()
            view.vwNextWorkout.borderWidth = 0.9
            view.btnNext.isUserInteractionEnabled = true
        }
        
    }
    
    func btnCompleted(strTitle:String){
            
        if let view = self.theController?.view as? StartWorkoutView{
            
            view.btnNext.setTitle(strTitle, for: .normal)
            view.btnNext.setTitleColor(UIColor.black, for: .normal)
            view.btnNext.setImage(nil, for: .normal)
//            view.btnNext.setImage(UIImage(named: "ic_next_black"), for: .normal)
//            view.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//            view.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            
            view.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            view.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            view.btnNext.isUserInteractionEnabled = false

            view.vwNextWorkout.borderColors = .black
            view.vwNextWorkout.shadowColors = .clear
            view.vwNextWorkout.borderWidth = 0.9
        }
    }

    func updatePauseTimeWithMilliseconds(secondsDifference:Int){
        
        if self.isRest == true{
            let valueAddigForPauseTime = self.exerciseArray[self.index].addedRestTime.convertDateFormater().addingTimeInterval(TimeInterval(secondsDifference))

            let convertToStringForPauseTime = valueAddigForPauseTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.exerciseArray[self.index].addedRestTime = convertToStringForPauseTime
        }else{
            let valueAddigForPauseTime = self.exerciseArray[self.index].pauseTime.convertDateFormater().addingTimeInterval(TimeInterval(secondsDifference))
            
            let convertToStringForPauseTime = valueAddigForPauseTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.exerciseArray[self.index].pauseTime = convertToStringForPauseTime
        }
        
    }
}
