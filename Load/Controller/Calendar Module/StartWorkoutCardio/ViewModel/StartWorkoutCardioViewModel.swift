//
//  StartWorkoutCardioViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 30/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON

protocol StartWorkoutCardioDelegate: class {
    func StartWorkoutFinish(isDone:Bool, exerciseArray:[Exercise])
    func currentWorkedLapIndex(index:Int)
    func repeatWokout()
    func reloadTblData()
}

class StartWorkoutCardioViewModel: SRCountdownTimerDelegate {
    
    fileprivate weak var theController:StartWorkoutCardioVC?
//    private var circleSlider: CircleSlider!
//    var timer: Timer?
    private var minValue: Float = 0
    private var maxValue: Float = 60
    var exerciseArray:[Exercise] = []
    var isRest:Bool = false
    var isDuration:Bool = false
    var timeCount:Int = 0
    var index:Int = 0
    var trainingLogId: String = ""
    var isRunAutoPause = false
    var isCycleAutoPause = false
    
    var trailingGradientColor:UIColor!
    var timeCountTotalDuration = 0
    
    var isPaused: Bool = false
    var isPausedTotalDuration: Bool = false
    
    var timerUpdate : Timer?
    
    var isDismissView = true
    var handlerUserClickOnYesOrNoInAlert : () -> Void = {}
    var handlerClickOnCloseView : () -> Void = {}
    var activityName = ""
    var activityImage = ""
    
    var lapTotalDurationManualCalculation = 0
    var handlerStopActivityUpdate : () -> Void = {}
    var handlerPauseOrNot : (Bool) -> Void = {_ in}
    var handlerFinishWorkoutOnEndClick : (UIImage?) -> Void = {_ in}
    
    weak var delegate:StartWorkoutCardioDelegate?
    
    var totalDurationInSecond = 0
    
    var isRepeatExercise = false
    var isWellDoneAnimationDone = false
    
    var isCompletedDistanceOnce = false
    
    var pauseTimeCount = 0
    
    init(theController:StartWorkoutCardioVC?) {
        self.theController = theController
    }
    
    func setupUI() {
        let view = (self.theController?.view as? StartWorkoutCardioView)
        
        if activityName.lowercased() == "Run (Outdoor)".lowercased() || activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
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
        
        view?.imgActivity.sd_setImage(with: URL(string: SERVER_URL + activityImage), completed: nil)
        
        if let view = (self.theController?.view as? StartWorkoutCardioView){
            view.countdownTimer.trailLineColor = .clear
            view.countdownTimer.delegate = self
        }

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.checkAndStart()
            
            if self.exerciseArray[self.exerciseArray.count-1].isCompleted == true && self.exerciseArray[self.exerciseArray.count-1].isCompletedRest == true{
                
                if self.activityName.lowercased() == "Run (Outdoor)".lowercased() || self.activityName.lowercased() == "Cycling (Outdoor)".lowercased(){

                    let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.trainingLogId)}

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
                        }
                        */
                        
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
                    
                    if self.activityName.lowercased() == "Run (Outdoor)".lowercased() || self.activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
                        
                        
                        let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.trainingLogId)}

                        if routeObjects.count > 0{
                            self.theController?.getRouteWhilePause(strPolyline: routeObjects[0].allTrackRoute)
                        }
                        
//                        self.theController?.getTrackDistance()
                        
                        if self.timerUpdate == nil{
                            self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)
                        }
                    }else{
                        self.getTotalDurationForIndoorWhenPause()
                        
                        if let valueForIndoor = Defaults.value(forKey: "trainingLog Indoor \(self.trainingLogId)") as? Double{
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
                    
                    if self.activityName.lowercased() == "Run (Outdoor)".lowercased() || self.activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
                        self.theController?.getTrackDistance()
                        
                        let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.trainingLogId)}
                        if routeObjects.count > 0{
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
        
        if self.activityName.lowercased() == "Run (Outdoor)".lowercased() || self.activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
            
            self.theController?.checkLocationPermissionAvailableOrNot()
            
        }
        
        if self.isPaused{

        }else{
            self.getTotalDuration()
            self.checkAndStart()
        }
        
    }

    func setUpPinOnMap(lat:Double,long:Double) {
        let view = (self.theController?.view as? StartWorkoutCardioView)
        view?.mapView.layoutIfNeeded()
        let cameraCoord = CLLocationCoordinate2D(latitude: lat, longitude: long)
        view?.mapView.camera = GMSCameraPosition.camera(withTarget: cameraCoord, zoom: 15)
        let updateCamera = GMSCameraUpdate.setTarget(cameraCoord, zoom: 15)
        view?.mapView.animate(with: updateCamera)
        view?.mapView.layoutIfNeeded()
    }
    
    @objc func getTotalDuration(){
        
        if let view = (self.theController?.view as? StartWorkoutCardioView){
            if self.exerciseArray[0].startTime == ""{
                return
            }
            
            let secondDifference = self.exerciseArray[0].startTime.convertDateFormater().secondDifference(to: Date())
            self.totalDurationInSecond = secondDifference
//            if activityName.lowercased() == "Run (Outdoor)".lowercased() || activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
                self.theController?.getAvgSpeed()
//            }
            let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: secondDifference)
            view.lblTotalDuration.text = self.makeTimeString(h: h1, m: m1, s: s1)
        }
    }
    
    
    func getTotalDurationForIndoorWhenPause(){
        
        if let view = (self.theController?.view as? StartWorkoutCardioView){
           
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
    
/*
    func getTotalDurationAfterCompletion(){
        let view = (self.theController?.view as? StartWorkoutCardioView)
        
        if self.exerciseArray[0].startTime == ""{
            return
        }
        
        let secondDifference = self.exerciseArray[0].startTime.convertDateFormater().secondDifference(to: self.exerciseArray[self.exerciseArray.count-1].endTime.convertDateFormater())
        //        print("Total Duration secondDifference:\(secondDifference)")
        let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: secondDifference)
        view?.lblTotalDuration.text = self.makeTimeString(h: h1, m: m1, s: s1)
    }
*/
    
    deinit {
        print("Deallocate :\(self)")
    }

    func checkAndStart() {
        print(self.exerciseArray.count)
        var isFinish:Bool = true
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        print("date:\(date)")

        for (index, data) in self.exerciseArray.enumerated() {
//            && (data.startTime == nil || data.startTime == "")
            
            if index == 0 && (data.isCompleted == false || data.isCompleted == nil) {
                
                if data.duration != nil && data.duration != "" && (data.repeatTime == nil || data.repeatTime == ""){
                    //Add Duration time in current time and get difference
//                    let valueaddingForDuration = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: data.duration)))
//                    let convertToStringForDuration = valueaddingForDuration.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
//                    print("convertToStringForDuration : \(convertToStringForDuration)")
//                    data.addedStartTime = convertToStringForDuration
                    
                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: data.rest)))
                   
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    print("convertToStringForRest : \(convertToStringForRest)")
                    data.addedRestTime = convertToStringForRest
                }
                
                if data.startTime != "" && (data.repeatTime == nil || data.repeatTime == ""){
                    
                    data.repeatTime = date
                     let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: data.rest)))
                    
                     let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                     print("convertToStringForRest : \(convertToStringForRest)")
                     data.addedRestTime = convertToStringForRest

                    self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
                }else if (data.startTime == ""){
                    
                    let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.trainingLogId)}

                    if routeObjects.count > 0{
                        try! realm.write{
                            routeObjects[0].startTimeForIndoor = date
                        }
                    }
                    
                    data.startTime = date
                    data.repeatTime = date
                    data.startLat = userCurrentLocation?.coordinate.latitude
                    data.startLong = userCurrentLocation?.coordinate.longitude
                    
                     let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: data.rest)))
                    
                     let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                     print("convertToStringForRest : \(convertToStringForRest)")
                     data.addedRestTime = convertToStringForRest
                    
                    self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
                }
            }
            
            if data.isCompleted == false || data.isCompleted == nil || data.isCompletedRest == false || data.isCompletedRest == nil {
                isFinish = false
                
                let view = (self.theController?.view as? StartWorkoutCardioView)
                view?.countdownTimer.isSolidLine = true
                
                view?.btnNext.isUserInteractionEnabled = true
                view?.lblCount.textAlignment = .left
                self.index = index
                
                self.delegate?.currentWorkedLapIndex(index: self.index)
                
                if data.isCompleted == false || data.isCompleted == nil {

                    view?.widthOfLblCount.constant = 169
                    
                    view?.btnPlayPause.setImage(UIImage(named: "ic_pause"), for: .normal)
                    view?.btnPlayPause.setImage(UIImage(named: "ic_play_long"), for: .selected)
                    
                    if data.duration != nil && data.duration != "" {
//                        view?.btnNext.isUserInteractionEnabled = false
                        self.isDuration = true
                        self.isRest = false
                        self.maxValue = 0
                        
                        view?.lblLapsCompleted.text = "\(data.laps ?? 0)/\(self.exerciseArray.count)"
                        view?.lblTotalTimeAndDistance.text = "\(data.duration ?? "")"
                        view?.lblWorkout.text = "Laps \(data.laps ?? 0)"
                        
                        view?.countdownTimer.trailLineColor = trailingGradientColor
                        
                        self.lapTotalDurationManualCalculation = Int(self.getSeconds(data: data.duration))
                        
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
                        
                        if activityName.lowercased() == "Run (Outdoor)".lowercased() || activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
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
                        
                        view?.lblTotalTimeAndDistance.text = "\(data.distance ?? 0.0) km"
                        
                        view?.lblLapsCompleted.text = "\(data.laps ?? 0)/\(self.exerciseArray.count)"
//                        view?.lblTotalTimeAndDistance.text = "\(data.distance ?? 0.0)"
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
                    
                    let rest = calculateDuration(data: data.rest)
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: rest)
                    
//                    self.theController?.checkChangeAbleParameter()
                    
                    if index+1 == self.exerciseArray.count{
                        
                        if data.rest == nil {
                           
                            view?.btnNext.isUserInteractionEnabled = false
//                            view?.lblNextWorkout.text = "Workout completed"
                       
                            self.btnCompleted(strTitle: "Completed")
//                            view?.btnNext.setImage(view?.btnNext.imageView?.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
//                            view?.btnNext.tintColor = UIColor.gray
                            
                        }else{
                            view?.btnNext.isUserInteractionEnabled = true
                       
//                            view?.lblNextWorkout.text = self.makeTimeString(h: h, m: m, s: s) + " rest"
                            
                            self.btnNextRestOrLap(strTitle: "Rest")
//                            view?.lblNextWorkout.text = "Rest"
                        }
                        
                    }else{
                        
                        if self.exerciseArray[index].rest == nil || self.exerciseArray[self.index].rest == ""{
                            self.btnNextRestOrLap(strTitle: "Laps \((data.laps ?? 0) + 1)")
                        }else{
                            self.btnNextRestOrLap(strTitle: "Rest")
                        }
                        
                        view?.btnNext.isUserInteractionEnabled = true
                        
//                        view?.lblNextWorkout.text = self.makeTimeString(h: h, m: m, s: s) + " rest"
//                        view?.lblNextWorkout.text = "Rest"
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
                    
//                    let rest = calculateDuration(data: data.rest)

                    view?.lblWorkout.text = "Laps \(data.laps ?? 0)"
                    
                    let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: Int(calculateDuration(data: data.rest)))
                    
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
            }else{
                
                let isDone = (index < (self.exerciseArray.count)) ? true : false
                print("isDone : \(isDone)")
                
                if isDone{
                    
                    if (index+1) != self.exerciseArray.count{
                        if (exerciseArray[index+1].isCompleted == false || exerciseArray[index+1].isCompleted == nil) && (exerciseArray[index+1].startTime == "" || exerciseArray[index+1].startTime == nil){
                            print("Enter in loop")
                            /*
                            if data.duration != nil && data.duration != "" {
                                //Add Duration time in current time and get difference
//                               let valueaddingForDuration = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[self.index+1].duration)))
//
//                                let convertToStringForDuration = valueaddingForDuration.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
//                                self.exerciseArray[self.index+1].addedStartTime = convertToStringForDuration
                                
                                 let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[self.index+1].rest)))
                                
                                 let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                                 print("convertToStringForRest : \(convertToStringForRest)")
                                 self.exerciseArray[self.index+1].addedRestTime = convertToStringForRest
                                
                            }else{
                                //Add direct time for Distance selection
//                                self.exerciseArray[self.index+1].startTime = date
                                
                                 let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[self.index+1].rest)))
                                
                                 let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                                 print("convertToStringForRest : \(convertToStringForRest)")
                                
                                //Comment below line because distance we cannot find exact finish time
                                 self.exerciseArray[self.index+1].addedRestTime = convertToStringForRest
                            }*/

                            let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[self.index+1].rest)))
                           
                            let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                            print("convertToStringForRest : \(convertToStringForRest)")
                            self.exerciseArray[self.index+1].addedRestTime = convertToStringForRest

                            print("Index Start TIme add:\(self.index)")
                            
                            self.exerciseArray[self.index+1].startTime = date
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
                self.handlerUserClickOnYesOrNoInAlert()
                
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

                if let vw = self.theController?.view as? StartWorkoutCardioView{
                    
                    vw.btnRepeat.setColor(color: .appthemeOffRedColor)
                    vw.vwRepeat.borderColors = UIColor.appthemeOffRedColor
                    vw.vwRepeat.setShadowToView()
                    vw.btnRepeat.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
                    vw.btnRepeat.isUserInteractionEnabled = true
                    vw.lblLapsCompleted.text = "\(self.exerciseArray.count)/\(self.exerciseArray.count)"
                    
                    vw.btnNext.isUserInteractionEnabled = false
//                    vw.lblNextWorkout.text = "Workout completed"
                    
                    //Prevent animation of button title
                    UIView.setAnimationsEnabled(false)
                    self.btnCompleted(strTitle: "Completed")
                    UIView.setAnimationsEnabled(true)
                    vw.btnNext.layoutIfNeeded()
                    
                    //For appering circle border while complete
                    vw.countdownTimer.clearing = false
                    vw.countdownTimer.isSolidLine = false
                    vw.countdownTimer.trailLineColor = UIColor.black
                    vw.countdownTimer.setNeedsDisplay()
                    
                    vw.btnPlayPause.isUserInteractionEnabled = false
                    vw.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                    vw.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)

                    if self.exerciseArray.last?.rest == "" || self.exerciseArray.last?.rest == nil {
                        
                        if self.exerciseArray.last?.duration != nil && self.exerciseArray.last?.duration != ""{
                            vw.lblCount.text = self.exerciseArray.last?.duration
                        }else{
                            vw.lblCount.text = "\(self.exerciseArray.last?.distance ?? 0.0) km"
                        }
                        
                    }else{
                        vw.lblCount.text = "00:00"
                    }
                    
                }

            }else{
                if let vw = self.theController?.view as? StartWorkoutCardioView{
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
    
    func getCurrenIndexOfCurrentLap() -> Int{
        for i in 0..<exerciseArray.count{
            let model = exerciseArray[i]
            if model.startTime != "" && ((model.isCompleted == false || model.isCompleted == nil) || (model.isCompleted == true && (model.isCompletedRest == false || model.isCompletedRest == nil))){
                return i
            }
        }
        
        return 0
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
    
    func wellDoneAnimation(){
        
        if let view = self.theController?.view as? StartWorkoutCardioView{
            
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
    
    func btnNextRestOrLap(strTitle:String){
        
        if let view = self.theController?.view as? StartWorkoutCardioView{
            
            view.btnNext.setTitle(strTitle, for: .normal)
            view.btnNext.setTitleColor(UIColor.appthemeOffRedColor, for: .normal)
            view.btnNext.setImage(UIImage(named: "ic_next-1"), for: .normal)
            view.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
            view.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            view.vwNextWorkout.borderColors = UIColor.appthemeOffRedColor
            view.vwNextWorkout.setShadowToView()
            view.vwNextWorkout.borderWidth = 0.9
        }
        
    }
    
    func btnCompleted(strTitle:String){
            
        if let view = self.theController?.view as? StartWorkoutCardioView{
            
            view.btnNext.setTitle(strTitle, for: .normal)
            view.btnNext.setTitleColor(UIColor.black, for: .normal)
            view.btnNext.setImage(nil, for: .normal)
//            view.btnNext.setImage(UIImage(named: "ic_next_black"), for: .normal)
//            view.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
//            view.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
            
            view.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            view.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
            view.vwNextWorkout.borderColors = .black
            view.vwNextWorkout.shadowColors = .clear
            view.vwNextWorkout.borderWidth = 0.9
        }
    }

    func finishWorkout() {
//        self.timer?.invalidate()
//        self.timer = nil
        
        self.theController?.dismiss(animated: false) {
            self.delegate?.StartWorkoutFinish(isDone: true, exerciseArray: self.exerciseArray)
        }
        
//        self.isRepeatExercise = false
//        self.apiCallRepeatWorkout(programId: self.trainingLogId, isEndWorkout: false, progress: true)
        
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
    
    func checkNext() {
        let view = (self.theController?.view as? StartWorkoutCardioView)
        if self.exerciseArray.count == (self.index + 1) {
            view?.btnNext.isUserInteractionEnabled = false
//            view?.lblNextWorkout.text = "Workout completed"
            self.btnCompleted(strTitle: "Completed")

        }
        else {
            
            view?.btnNext.isUserInteractionEnabled = true

            for (index, data) in self.exerciseArray.enumerated() {
                if index == (self.index + 1) {
                    if data.isCompleted == false || data.isCompleted == nil {
//                        view?.lblNextWorkout.text = "Laps \(data.laps ?? 0)"
                        self.btnNextRestOrLap(strTitle: "Laps \(data.laps ?? 0)")
                    }
                    else if data.isCompletedRest == false || data.isCompletedRest == nil {
                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(data.rest ?? "0") ?? 0)
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
    
    func startCountDownTimer(text:String) {
        let view = (self.theController?.view as? StartWorkoutCardioView)

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
            
            if self.exerciseArray[self.index].rest == nil{
                
                if self.isDuration == true{
                    
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
                }else{
                    /*
                    if self.index == self.exerciseArray.count - 1{
                        let lapDistance = (self.exerciseArray[self.index].distance ?? 0.0)*1000
                        
                        let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.trainingLogId)}
                        
                        if routeObjects.count > 0{
                            if (routeObjects[0].lapArray[self.index].lapCoverDistance) >= Double(lapDistance){
                                
                                view?.countdownTimer.trailLineColor = UIColor.black
                                view?.countdownTimer.isSolidLine = false
                                self.isWellDoneAnimationDone = true
                                self.wellDoneAnimation()
                                view?.btnPlayPause.isUserInteractionEnabled = false
                                view?.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                                view?.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)

                            }
                        }
                    }*/
                }
            }
            
            if (Int(timeCount) ) % 2 == 0 {
                
                view?.countdownTimer.lineDraw = false
//                view?.countdownTimer.lineColor = trailingGradientColor
//                view?.countdownTimer.trailLineColor = UIColor.clear
            }else{
                view?.countdownTimer.lineDraw = true
//                view?.countdownTimer.lineColor = UIColor.clear
//                view?.countdownTimer.trailLineColor = trailingGradientColor
            }
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
                    if let view = (self.theController?.view as? StartWorkoutCardioView){
                        view.countdownTimer.setNeedsDisplay()
                    }
                    return
                }
            }
            else{
                if self.isDuration == true {
                    if self.index+1 == self.exerciseArray.count{
                        if self.exerciseArray[self.index].rest == nil{
                            if self.lapTotalDurationManualCalculation < self.timeCount{
                                if self.lapTotalDurationManualCalculation % 2 != 0{
                                    return
                                }
                            }
                        }
                    }
                }else{
                    if self.index == self.exerciseArray.count - 1{
                        if self.exerciseArray[self.index].rest == nil{
                            
                            let lapDistance = (self.exerciseArray[self.index].distance ?? 0.0)*1000
                            
                            if activityName.lowercased() == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){
                                
                                let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.trainingLogId)}
                                
                                if routeObjects.count > 0{
                                    if (routeObjects[0].lapArray[self.index].lapCoverDistance) >= Double(lapDistance){
                                        if let view = (self.theController?.view as? StartWorkoutCardioView){
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
                                    if let view = (self.theController?.view as? StartWorkoutCardioView){
                                        if self.isCompletedDistanceOnce{
                                            view.countdownTimer.setNeedsDisplay()
                                            self.isCompletedDistanceOnce = false
                                            return
                                        }
                                    }
                                }
                            }
                        }
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

    func playNext(){
        
        if let view = (self.theController?.view as? StartWorkoutCardioView){
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
//                    if self.isDuration == true {
//                        self.exerciseArray[index].isCompleted = true
//                    }
//                    else {
                        self.exerciseArray[index].isCompletedRest = true
//                    }
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
                        
                        if self.exerciseArray[self.index].rest == nil{
                            
                            if self.lapTotalDurationManualCalculation < self.timeCount{
                                self.exerciseArray[self.index].isCompletedRest = true
                                self.exerciseArray[self.index].isCompleted = true
                                
                                // set for odd duration
                                if self.lapTotalDurationManualCalculation % 2 != 0{
                                    self.startCountDownTimer(text: self.exerciseArray[self.index].duration ?? "")
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
                                
                                //                            self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
                                //                            self.delegate?.currentWorkedLapIndex(index: self.index)
                                //                            self.isPaused = true
                                //
                                //                            view.btnRepeat.setColor(color: .appthemeRedColor)
                                //                            view.btnRepeat.borderColor = UIColor.appthemeRedColor
                                //                            view.btnRepeat.titleLabel?.font = themeFont(size: 14, fontname: .Helvetica)
                                //                            view.btnRepeat.isUserInteractionEnabled = true
                                return
                            }
                        }
                    }
                    
                    view.countdownTimer.isSolidLine = true
                    
                    //                let view = (self.theController?.view as? StartWorkoutCardioView)
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: self.timeCount)
                    view.lblCount.text = self.makeTimeString(h: h, m: m, s: s)
                    self.startCountDownTimer(text: view.lblCount.text?.toTrim() ?? "")
                    
                    if self.lapTotalDurationManualCalculation < self.timeCount{
                        print("Timer finish")
                        self.exerciseArray[self.index].isCompleted = true
                        
                        if self.exerciseArray[self.index].rest == nil ||  self.exerciseArray[self.index].rest == ""{
                            self.exerciseArray[self.index].isCompletedRest = true
                        }
                        
                        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                        
                        let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[self.index].rest)))
                        
                        let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                        self.exerciseArray[self.index].addedRestTime = convertToStringForRest
                        
                        checkAndStart()
                    }
                    
                }else{
                    
                    let lapDistance = (self.exerciseArray[self.index].distance ?? 0.0)*1000

                    if self.index+1 == self.exerciseArray.count{
                        
                        if self.exerciseArray[self.index].rest == nil{
                            
                            if activityName.lowercased() == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){
                                
                                let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.trainingLogId)}
                                
                                if routeObjects.count > 0{
                                    if (routeObjects[0].lapArray[self.index].lapCoverDistance) >= Double(lapDistance){
                                        
                                        self.index = self.exerciseArray.count - 1
                                        
                                        if let view = (self.theController?.view as? StartWorkoutCardioView){
                                            
                                            if (Int(timeCount) ) % 2 == 0 {
                                                
                                                self.exerciseArray[self.index].isCompletedRest = true
                                                self.exerciseArray[self.index].isCompleted = true

                                                self.isCompletedDistanceOnce = true
                                                
                                                self.startCountDownTimer(text: "")
                                                view.lblCount.text = "\(self.exerciseArray[self.index].distance ?? 0.0)"
                                                view.countdownTimer.trailLineColor = UIColor.black
//                                                view.countdownTimer.setNeedsDisplay()
                                                view.countdownTimer.isSolidLine = false
                                                self.isWellDoneAnimationDone = true
                                                self.wellDoneAnimation()
                                                
                                                view.btnPlayPause.isUserInteractionEnabled = false
                                                view.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                                                view.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)
                                                checkAndStart()

                                            }else{
                                                self.startCountDownTimer(text: "")
                                            }
                                            
                                        }
                                        return
                                    }else{
                                        //MARK: - For distance round circle purpose only
                                        self.startCountDownTimer(text: "")
                                    }
                                }
                                
                            }else{
                                
                                if (self.theController?.distanceOfLapForIndoor ?? 0.0) >= lapDistance{

                                    self.index = self.exerciseArray.count - 1

                                    if let view = (self.theController?.view as? StartWorkoutCardioView){
                                        
                                        if (Int(timeCount) ) % 2 == 0 {
                                            
                                            self.exerciseArray[self.index].isCompletedRest = true
                                            self.exerciseArray[self.index].isCompleted = true

                                            self.isCompletedDistanceOnce = true
                                            
                                            self.startCountDownTimer(text: "")
                                            view.lblCount.text = "\(self.exerciseArray[self.index].distance ?? 0.0)"
                                            view.countdownTimer.trailLineColor = UIColor.black
//                                            view.countdownTimer.setNeedsDisplay()
                                            view.countdownTimer.isSolidLine = false
                                            self.isWellDoneAnimationDone = true
                                            self.wellDoneAnimation()
                                            
                                            view.btnPlayPause.isUserInteractionEnabled = false
                                            view.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                                            view.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)
                                            
                                            checkAndStart()

                                        }else{
                                            self.startCountDownTimer(text: "")
                                        }
                                    }
                                    return
                                }else{
                                    //MARK: - For distance round circle purpose only
                                    self.startCountDownTimer(text: "")
                                }
                                
                            }
                            
                        }else{
                            //MARK: - For distance round circle purpose only
                            self.startCountDownTimer(text: "")
                        }
                    }else{
                        
                        //MARK: - For distance round circle purpose only
                        let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.trainingLogId)}

                        var lapCoveredDistance : CGFloat = 0.0
                        
                        if activityName.lowercased() == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){

                            if routeObjects.count > 0 {
                                lapCoveredDistance = CGFloat(routeObjects[0].lapArray[self.index].lapCoverDistance)
                            }
                            
                        }else{
                            lapCoveredDistance = self.theController?.distanceOfLapForIndoor ?? 0.0
                        }
                        
                        if lapCoveredDistance >= lapDistance{
                            
                            if let view = (self.theController?.view as? StartWorkoutCardioView){
                                view.lblCount.text = "\(self.exerciseArray[self.index].distance ?? 0.0)"
                            }
                            
                            if (Int(timeCount) ) % 2 == 0 {
                                
                                print("self.Index:\(self.index)")
                                self.exerciseArray[self.index].isCompleted = true
                                if self.exerciseArray[self.index].rest == nil{
                                    self.exerciseArray[self.index].isCompletedRest = true
                                }
                                
                                //ADD TODAY
                                if activityName.lowercased() == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){

                                    if routeObjects.count > 0{
                                        
                                        self.theController?.lapCoveredDistance = 0.0
                                        
                                        let strPolyLine = routeObjects[0].allTrackRoute
                                        self.theController?.handlerForPassDataOfParticularLapWithPolyline(strPolyLine, 0)
                                    }
                                    
                                } else {
                                    self.theController?.reCallMainCountingStep()
                                    self.theController?.handlerForIndoorParticularLapForReset(0)
                                    self.theController?.distanceOfLapForIndoor = 0
                                }

                                checkAndStart()
                            }else{
                                self.startCountDownTimer(text: "")
                            }
                            
                        } else {
                            self.startCountDownTimer(text: "")
                        }
                    }
                }
            }
        }
        
        //        self.timeCountTotalDuration += 1
        //        let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: self.timeCountTotalDuration)
        //        view?.lblTotalDuration.text = self.makeTimeString(h: h1, m: m1, s: s1)
        
        //TODO: - Last Commnet YAsh
        getTotalDuration()
    }
    
//    @objc func valueChange(sender: CircleSlider) {
//        if self.isRest || self.isDuration {
//            let view = (self.theController?.view as? StartWorkoutCardioView)
//            //            view?.lblCount.text = "\(Int((self.maxValue + 1) - sender.value))"
//            let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int((self.maxValue + 1) - sender.value))
//            //            print(self.makeTimeString(h: h, m: m, s: s))
//            view?.lblCount.text = self.makeTimeString(h: h, m: m, s: s)
//            if timer != nil {
//                changeButtonImage(circleSlider.status)
//            }
//        }
//    }
    
//    @objc func fire(timer _: Timer) {
//        if self.isRest || self.isDuration {
//            circleSlider.value += 1
//            if timer != nil {
//                changeButtonImage(circleSlider.status)
//            }
//        }
//        else  {
//            self.timeCount += 1
//            let view = (self.theController?.view as? StartWorkoutCardioView)
//            //            view?.lblCount.text = "\(self.timeCount )"
//            let (h, m, s) = secondsToHoursMinutesSeconds(seconds: self.timeCount)
//            //            print(self.makeTimeString(h: h, m: m, s: s))
//            view?.lblCount.text = self.makeTimeString(h: h, m: m, s: s)
//        }
//    }
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
    
//    private func changeButtonImage(_ status: CircleSliderStatus) {
//        switch status {
//        case CircleSliderStatus.noChangeMinValue:
//            break
//
//        case CircleSliderStatus.inProgressChangeValue:
//            break
//
//        case CircleSliderStatus.reachedMaxValue:
//            timer?.invalidate()
//            timer = nil
//            if self.isDuration == true {
//                self.exerciseArray[index].isCompleted = true
//            }
//            else {
//                self.exerciseArray[index].isCompletedRest = true
//            }
//            self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
//            self.checkAndStart()
//        }
//    }
    
    func closeView()
    {

        self.handlerFinishWorkoutOnEndClick(nil)
//        self.handlerPauseOrNot(false)

        if isDismissView{
            self.isDismissView = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1){
                self.isPaused = true
                self.delegate?.currentWorkedLapIndex(index: self.index)
                self.handlerUserClickOnYesOrNoInAlert()
                self.handlerClickOnCloseView()
                
                self.theController?.dismiss(animated: true) {
                    if self.timerUpdate != nil{
                        self.timerUpdate?.invalidate()
                        self.timerUpdate = nil
                    }
                    
                    if self.theController?.timerForMotion != nil{
                        self.theController?.timerForMotion?.invalidate()
                        self.theController?.timerForMotion = nil
                    }
                }
                
                self.isDismissView = true
            }
        }
    }
    
    //MARK: - Duration
    
    func findingDurationFromDistance(model:Exercise) -> String{
        
        print("model:\(model)")
        
        if model.speed != nil {
            
            guard let distance = model.distance else { return "" }
            guard let speed = model.speed else { return ""}
            
            let duration = (distance/speed) * 60
            print("Duration ::\(duration)")
            
            print("Time:\(getSecondsFromFloatValue(value: duration))")
            
            return getSecondsFromFloatValue(value: duration)
        }
        else if model.pace != nil || model.pace != ""{
            
            guard let distance = model.distance else { return "" }
            guard let pace = model.pace else { return ""}

            let seconds = CGFloat(getSeconds(data: pace))
            
            let speed = (60*60) / seconds
            
            let durationInMin = (distance/speed)*60
            print("Duration ::\(durationInMin)")
            
            print("Time:\(getSecondsFromFloatValue(value: durationInMin))")
            
            return getSecondsFromFloatValue(value: durationInMin)
        }
        
        return ""
    }
    
    func getSecondsFromFloatValue(value:CGFloat) -> String{
        
        let stringValue = "\(value)"
        print("stringValue : \(stringValue)")
        
        let dataArray = stringValue.split(separator: ".")

        let sHr = (Double(dataArray[0] ?? "0") ?? 0) * 60
        let sMin = (Double("0.\(dataArray[1] ?? "0")") ?? 0) * 60
        
        let TotalNumber = Int(sHr) + Int(sMin)
        print("TotalNumber : \(TotalNumber)")
        
        self.lapTotalDurationManualCalculation = TotalNumber
        
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: TotalNumber)
        return self.makeTimeString(h: h, m: m, s: s)

    }
    
    //MARK: - Alert Showing
    
    func yesNoCancelAlert(){
        let alertController = UIAlertController(title: getCommonString(key: "Load_key"), message: getCommonString(key: "Are_you_sure_you_want_to_finish_workout_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            //            self.timer?.invalidate()
            //            self.timer = nil
            self.theController?.dismiss(animated: true, completion: nil)
            let isDone =  (self.index + 1) == self.exerciseArray.count ? true : false
            self.exerciseArray[self.index].isCompleted = true
            //            self.exerciseArray[self.index].completeTime = NSNumber(integerLiteral: self.timeCount)
            if self.isRest {
                self.exerciseArray[self.index].isCompletedRest = true
            }
            else {
                //                isDone = false
                self.exerciseArray[self.index].isCompleted = true
                //                self.exerciseArray[self.index].completeTime = NSNumber(integerLiteral: self.timeCount)
            }
            self.delegate?.StartWorkoutFinish(isDone: isDone, exerciseArray: self.exerciseArray)
        }
        
        let noAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            print("No")
            //            self.timer?.invalidate()
            //            self.timer = nil
            self.theController?.dismiss(animated: true, completion: nil)
            if self.isRest {
                self.exerciseArray[self.index].isCompletedRest = false
                let isDone =  (self.index + 1) == self.exerciseArray.count ? true : false
                self.delegate?.StartWorkoutFinish(isDone: isDone, exerciseArray: self.exerciseArray)
            }
            else {
                self.exerciseArray[self.index].isCompleted = false
                self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
            }
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "Cancel_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        alertController.addAction(cancelAction)
        self.theController?.present(alertController, animated: true, completion: nil)
        
    }
    
    func showResumeAlert(){
        
        var msg = ""
        
        if self.activityName.lowercased().contains("Indoor".lowercased()){
            msg = getCommonString(key: "Are_you_sure_you_want_to_stop_the_workout_key")
        }else{
            msg = getCommonString(key: "Are_you_sure_you_want_to_end_the_workout_key")
        }
        
        let alertController = UIAlertController(title: getCommonString(key: "End_Workout_key"), message: msg, preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            //            self.timer?.invalidate()
            //            self.timer = nil
            self.theController?.dismiss(animated: true, completion: nil)
            
            self.handlerUserClickOnYesOrNoInAlert()
            
            /*
            let isDone =  (self.index + 1) == self.exerciseArray.count ? true : false
            self.exerciseArray[self.index].isCompleted = true
            //            self.exerciseArray[self.index].completeTime = NSNumber(integerLiteral: self.timeCount)
            if self.isRest {
                self.exerciseArray[self.index].isCompletedRest = true
            }
            else {
                //                isDone = false
                self.exerciseArray[self.index].isCompleted = true
                //                self.exerciseArray[self.index].completeTime = NSNumber(integerLiteral: self.timeCount)
            }
            self.delegate?.StartWorkoutFinish(isDone: isDone, exerciseArray: self.exerciseArray)
             */
        }
        
        let noAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            print("No")
            //            self.timer?.invalidate()
            //            self.timer = nil
            self.theController?.dismiss(animated: true, completion: nil)
            
            //Yash Added
            self.exerciseArray[self.index].startTime = ""
            self.exerciseArray[self.index].addedRestTime = ""
            self.exerciseArray[self.index].addedStartTime = ""
            self.handlerUserClickOnYesOrNoInAlert()

            self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
            //Yash Changes
//            if self.isRest {
//                self.exerciseArray[self.index].isCompletedRest = false
//                let isDone =  (self.index + 1) == self.exerciseArray.count ? true : false
//                self.delegate?.StartWorkoutFinish(isDone: isDone, exerciseArray: self.exerciseArray)
//            }
//            else {
//                self.exerciseArray[self.index].isCompleted = false
//                self.delegate?.StartWorkoutFinish(isDone: false, exerciseArray: self.exerciseArray)
//            }
        }
        
        alertController.addAction(okAction)
        alertController.addAction(noAction)
        self.theController?.present(alertController, animated: true, completion: nil)
        
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
}

//MARK: - API calling

extension StartWorkoutCardioViewModel{
    
    func apiCallRepeatWorkout(programId: String, isEndWorkout:Bool = false, progress:Bool = true) {
        
        var param : [String : Any] = [:]

        if self.isRepeatExercise{
            
            var exercise: NSMutableArray = arrayForRepeatExercise()
            param = [
                "exercise": exercise,
                "is_complete": false
                ] as [String : Any]
        }else{
            let exercise = arrayForExerciseAccordingToActivity()
            param = [
                "exercise": exercise,
                "is_complete": false
                ] as [String : Any]
        }
        
        if activityName.lowercased() == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){

            let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(programId)}

            if routeObjects.count > 0 {
                param["outdoor_route_data"] = String(routeObjects[0].allTrackRoute)
            }
        }

        
        //MARK: - Anil old code comment
        //        if isEndWorkout {
        //            param.removeValue(forKey: "exercise")
        //        }
        print(JSON(param))

        if programId == "" {
            return
        }
        
        ApiManager.shared.MakePutAPI(name: COMPLETE_TRAINING_LOG + "/" + programId, params: param as [String : Any], progress: progress, vc: self.theController!, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    
                    let data = json.getDictionary(key: .data)
                    print(data)
                    let model = TrainingLogModelClass(JSON: data.dictionaryObject!)
                    
                    if self.isRepeatExercise{
                        print("array : \(model?.exercise)")
                        
                        self.index = 0
                        self.exerciseArray = []
                        self.exerciseArray = model?.exercise ?? []
                        self.isPaused = false
                        self.checkAndStart()
                        
                    }else{
                        //                        self.theController?.redirectToCardioSummary()
//                        AppDelegate.shared.locationManager.allowsBackgroundLocationUpdates = false
//                        self.theController?.redirectToRPESelection()
                    }
                    
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    
    func arrayForRepeatExercise() -> NSMutableArray {
        
        let exerciseMutableArrayArray: NSMutableArray = NSMutableArray()

        for i in 0..<self.exerciseArray.count{
                
                let model = self.exerciseArray[i]
                
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
                
                switch self.activityName.lowercased(){
                    
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
                
                if i == 0{
                    dict.setValue(model.startTime, forKey: "start_time")
                    dict.setValue(model.startLat, forKey: "start_lat")
                    dict.setValue(model.startLong, forKey: "start_long")
                }
                
                if i == exerciseArray.count - 1{
                    dict.setValue(model.endTime, forKey: "end_time")
                    dict.setValue(model.endLat, forKey: "end_lat")
                    dict.setValue(model.endLong, forKey: "end_long")
                }
                
                exerciseMutableArrayArray.add(dict)
                
            }
            return exerciseMutableArrayArray
        
    }
    
    func arrayForExerciseAccordingToActivity() -> NSMutableArray {
        
        let exerciseArray: NSMutableArray = NSMutableArray()
        
        for i in 0..<self.exerciseArray.count{
            
            let model = self.exerciseArray[i]

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
            
            switch self.activityName.lowercased(){
                
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
            
            if i == 0{
                dict.setValue(model.repeatTime, forKey: "repeat_time")
                dict.setValue(model.startTime, forKey: "start_time")
                dict.setValue(model.startLat, forKey: "start_lat")
                dict.setValue(model.startLong, forKey: "start_long")
                
                if let value = Defaults.value(forKey: self.trainingLogId) as? Int{
                    dict.setValue(value, forKey: "deactive_duration")
                }
            }
            
            if i == exerciseArray.count - 1{
                
                //                    let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                
                //                    if model.endTime == ""{
                //                        dict.setValue(date, forKey: "end_time")
                //                    }else{
                //                        dict.setValue(model.endTime, forKey: "end_time")
                //                    }
                
                dict.setValue(model.endTime, forKey: "end_time")
                dict.setValue(model.endLat, forKey: "end_lat")
                dict.setValue(model.endLong, forKey: "end_long")
                dict.setValue(self.theController?.totalDistancConverted, forKey: "total_distance")
            }
            
            exerciseArray.add(dict)
            
        }
        
        return exerciseArray
    }

}

