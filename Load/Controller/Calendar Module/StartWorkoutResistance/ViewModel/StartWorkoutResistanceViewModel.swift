//
//  StartWorkoutResistanceViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 29/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol StartWorkoutResistanceDelegate: class {
    func StartWorkoutFinish(tag:Int, exerciseAllArray:[ExerciseResistance])
    func afterAddExerciseLink(tag:Int,exerciseLink: String)
    func finishWorkout(isDone:Bool,tag:Int, exerciseAllArray:[ExerciseResistance])
//    func getSectionAndRow(section:Int, row:Int)
}

class StartWorkoutResistanceViewModel: SRCountdownTimerDelegate {

    fileprivate weak var theController:StartWorkoutResistanceVC?
//    var timer: Timer?
    private var minValue: Float = 0
    private var maxValue: Float = 60
 //   var exerciseArray:[DataExercise] = [] // particular section pass
    var exerciseAllResistanceArray: [ExerciseResistance] = [] // all array of particular id
    var isDuration:Bool = false
    var isReps:Bool = false
    var isRest:Bool = false
    var timeCount:Int = 0
    var index:Int = 0
    var arrayIndex:Int = 0
    var arrayRowIndex:Int = 0
    weak var delegate:StartWorkoutResistanceDelegate?
//    var time = 0.5
    var trailingGradientColor:UIColor!

    var timerUpdate : Timer?
    var totalLapCount = 0
    var pauseTimeCount = 0

    //for add exercise link
    var exerciseLink = ""
    var strCommonLibraryId = 0
    var strLibraryId = 0
    
    var isPaused: Bool = false
    var totalDurationInSecond = 0

    var lapTotalDurationManualCalculation = 0
    
    var targetedVolume = 0
    var completedVolume = 0
    
    var handlerFinishWorkoutOnEndClick : (UIImage?) -> Void = {_ in}
    
//    private var sliderOptions: [CircleSliderOption] {
//        return [
//            CircleSliderOption.barColor(UIColor.white),
//            CircleSliderOption.thumbColor(UIColor(red: 127 / 255, green: 185 / 255, blue: 204 / 255, alpha: 1)),
//            CircleSliderOption.trackingColor(UIColor.appthemeRedColor),
//            CircleSliderOption.barWidth(15),
//            CircleSliderOption.startAngle(0),
//            CircleSliderOption.maxValue(self.maxValue),
//            CircleSliderOption.minValue(self.minValue),
//        ]
//    }
//
//    private var progressOptions: [CircleSliderOption] {
//        return [
//            .barColor(UIColor(red: 255 / 255, green: 190 / 255, blue: 190 / 255, alpha: 1)),
//            .trackingColor(UIColor(red: 159 / 255, green: 0 / 255, blue: 0 / 255, alpha: 1)),
//            .barWidth(30),
//            .sliderEnabled(false)
//        ]
//    }
    
    init(theController:StartWorkoutResistanceVC?) {
        self.theController = theController
    }
    
    deinit {
        print("Deallocate :\(self)")
    }

    func setupUI() {
        let view = (self.theController?.view as? StartWorkoutResistanceView)
        if !self.isRest {
//            view?.lblCount.text = "0"
        }
        else {
//            view?.lblCount.text = "\(Int(self.maxValue))"
        }
        
        //Check from exerciseLink
        checkLinkAvailableOrNot()
        
        trailingGradientColor = drawGradientColor(in: (view?.countdownTimer.bounds)!, colors: [
            UIColor(red:0.45, green:0.19, blue:0.6, alpha:1).cgColor,
            UIColor(red:0.78, green:0.2, blue:0.2, alpha:0.88).cgColor
        ])!
        
        if let view = (self.theController?.view as? StartWorkoutResistanceView){
            view.countdownTimer.trailLineColor = .clear
            view.lblLapsCompleted.text = "\(self.checkCompletedLapsCount())/\(self.totalLapCount)"
            view.lblChangeableParameterValue.text = "\(self.completedVolume)"
            view.countdownTimer.delegate = self

        }
        
//        if self.timerUpdate != nil{
//            self.timerUpdate?.invalidate()
//            self.timerUpdate = nil
//        }
//
//        self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            
            //Change the order of below method because set color while repeat
            
            self.theController?.nextClickableOrNot()

            self.checkAndStart()

            if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isPause == true{
                self.getTotalDurationForPause()
            }else{
                self.getTotalDuration()
            }
            
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        
        if self.isPaused{

        }else{
            self.getTotalDuration()
            self.checkAndStart()
        }
    }
    
    @objc func getTotalDuration(){
        
        if let view = (self.theController?.view as? StartWorkoutResistanceView){
            if self.exerciseAllResistanceArray[0].data?[0].startTime == ""{
                return
            }
            
            let secondDifference = self.exerciseAllResistanceArray[0].data?[0].startTime.convertDateFormater().secondDifference(to: Date())
            self.totalDurationInSecond = secondDifference ?? 0
            let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: secondDifference ?? 0)
            view.lblTotalDuration.text = self.makeTimeString(h: h1, m: m1, s: s1)
        }
    }

    //MARK: - Main method for begining
    func checkAndStart() {
        var isFinish:Bool = true
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        print("date:\(date)")
        print("arrayIndex:\(self.arrayIndex)")
        print("arrayRowIndex:\(self.arrayRowIndex)")
        
        for index in self.arrayRowIndex ..< (self.exerciseAllResistanceArray[self.arrayIndex].data?.count ?? 0){
            
            guard let data = self.exerciseAllResistanceArray[self.arrayIndex].data?[index] else { return
            }
            
            if arrayRowIndex == 0 && self.arrayIndex == 0 && (data.isCompleted == false || data.isCompleted == nil) && (data.isRepeatSet == false || data.isRepeatSet == nil){
                
                if (data.startTime == ""){
                    
//                    let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.trainingLogId)}
//
//                    if routeObjects.count > 0{
//                        try! realm.write{
//                            routeObjects[0].startTimeForIndoor = date
//                        }
//                    }
                    
                    data.startTime = date
                    data.isCurrentLapWorking = true

//                    data.repeatTime = date
                    
                     let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: data.rest)))
                    
                     let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                     print("convertToStringForRest : \(convertToStringForRest)")
                     data.addedRestTime = convertToStringForRest
                    
                    self.delegate?.StartWorkoutFinish(tag: self.arrayIndex, exerciseAllArray: self.exerciseAllResistanceArray)
                }
                
                if data.startTime != "" && (data.repeatTime == nil || data.repeatTime == ""){
                    
                    data.repeatTime = date
                     let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: data.rest)))
                    
                     let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                     print("convertToStringForRest : \(convertToStringForRest)")
                     data.addedRestTime = convertToStringForRest

                    self.delegate?.StartWorkoutFinish(tag: self.arrayIndex, exerciseAllArray: self.exerciseAllResistanceArray)
                }
            }
            
            if data.isCompleted == false || data.isCompleted == nil ||  data.isCompletedRest == false || data.isCompletedRest == nil {
                
                data.isCurrentLapWorking = true
                
                isFinish = false
                let view = (self.theController?.view as? StartWorkoutResistanceView)
//                view?.btnNext.isUserInteractionEnabled = true
                self.index = index
                print("self.index:\(self.index)")
                
                print("data:\(data.toJSON())")
                view?.countdownTimer.isSolidLine = true
                
                view?.lblExerciseName.text = self.exerciseAllResistanceArray[self.arrayIndex].name ?? ""
                if data.isCompleted == false || data.isCompleted == nil{
                    
                    view?.lblX.isHidden = false
                    view?.btnPlayPause.setImage(UIImage(named: "ic_pause"), for: .normal)
                    view?.btnPlayPause.setImage(UIImage(named: "ic_play_long"), for: .selected)
                    view?.btnNext.setTitle("Rest", for: .normal)
                    view?.vwNextWorkout.setShadowToView()
                    view?.countdownTimer.trailLineColor = trailingGradientColor

                    view?.lblCount.attributedText = setColorWithOffRedName(mainString: "\(index+1) /\(self.exerciseAllResistanceArray[self.arrayIndex].data?.count ?? 0)", stringToColor: "\(index+1)")
                    

                    if data.reps != nil && data.reps != "" {
                        view?.lblOriginalDuration.isHidden = true
                        
                        view?.constantWidthDurationReps.constant = 54
                        view?.lblDurationtRepsWorkout.textAlignment = .center
                        self.isReps = true
                        self.isDuration = false
                        self.isRest = false
                        self.timeCount = 0
                        
//                        view?.countdownTimer.isSolidLine = true
//                        view?.countdownTimer.trailLineColor = trailingGradientColor
//                        view?.countdownTimer.setNeedsDisplay()
                        
                        view?.constantDurationRepearWorkoutCenterX.constant = -44
                        view?.lblDurationtRepsWorkout.text = data.reps ?? ""
                        view?.lblWeightWorkout.text = "\(data.weight ?? "")"
                            
//                            setFontOfKg(mainString: "\(data.weight ?? "")kg", stringToColor: "kg")
                        
//                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: self.timeCount)
//                        self.startCountDownTimer(text: self.makeTimeStringForMMSS(h: h, m: m, s: s))

                        if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isPause == true{
                            self.isPaused = true
                            
                            view?.countdownTimer.elapsedTime = data.elapsedTime
                            view?.countdownTimer.lineDraw = data.lineDraw

                            if data.lineDraw == false{
                                self.timeCount = 0
                            }else{
                                self.timeCount = 1
                            }

//                            view?.countdownTimer.pause()
                            view?.btnPlayPause.isSelected = true
                            //For disappering circle border while complete
//                            view?.countdownTimer.clearing = true
                            view?.countdownTimer.setNeedsDisplay()

                        }else{

//                            if self.timerUpdate != nil{
//                                self.timerUpdate?.invalidate()
//                                self.timerUpdate = nil
//                            }
//
//                            self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)

                            self.isPaused = false
//                            view?.countdownTimer.resume()
                            view?.btnPlayPause.isSelected = false
                            self.startCountDownTimer(text: "")
                        }

                    }
                    else {
                        
                        view?.constantWidthDurationReps.constant = 80
                        view?.lblOriginalDuration.isHidden = false
                        view?.lblOriginalDuration.text = data.duration ?? ""
//                        view?.btnNext.isUserInteractionEnabled = false
                        self.isDuration = true
                        self.isRest = false
                        self.isReps = false
//                        self.timeCount = 0
                        self.maxValue = 0
                        
                        self.lapTotalDurationManualCalculation = Int(self.getSeconds(data: data.duration))
                        
                        view?.lblWeightWorkout.text = "\(data.weight ?? "")"

                        if self.setConditionForRepeatParticularSet(){
                            return
                        }
                        
//                        else{
                            
                            if self.arrayIndex == 0 && self.arrayRowIndex == 0{
                                
                                if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isPause == true{
                                    
                                    self.timeCount = self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].repeatTime.convertDateFormater().secondDifference(to: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].pauseTime.convertDateFormater() ?? Date()) ?? 0
                                }else{
                                    
                                    self.timeCount = self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].repeatTime.convertDateFormater().secondDifference(to: Date()) ?? 0
                                }

                            }else{
                                
                                if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isPause == true{
                                    
                                    self.timeCount = self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].startTime.convertDateFormater().secondDifference(to: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].pauseTime.convertDateFormater() ?? Date()) ?? 0
                                }else{
                                    
                                    self.timeCount = self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].startTime.convertDateFormater().secondDifference(to: Date()) ?? 0
                                    
                                }
                                
                            }

//                        }
                        
                        view?.constantDurationRepearWorkoutCenterX.constant = -54
                        view?.lblDurationtRepsWorkout.textAlignment = .left

//                            setFontOfKg(mainString: "\(data.weight ?? "")kg", stringToColor: "kg")

//                        self.maxValue = self.getSeconds(data: data.duration)
                        
                        if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isPause == true{
                            
                            self.isPaused = true
                            
                            view?.countdownTimer.elapsedTime = data.elapsedTime
                            view?.countdownTimer.lineDraw = data.lineDraw

                            self.pauseTimeCount = Int(self.getSeconds(data: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].lastPauseTime))

                            if (self.timeCount - self.pauseTimeCount) != 0 {
                                self.updatePauseTimeWithMilliseconds(secondsDifference: self.pauseTimeCount - self.timeCount)
                            }
                            
                            self.timeCount = self.pauseTimeCount
                            
                            let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: Int(self.timeCount))
                            view?.lblDurationtRepsWorkout.text = self.makeTimeStringForMMSS(h: h1, m: m1, s: s1)
                            
                            view?.btnPlayPause.isSelected = true
                            //For disappering circle border while complete
//                            view?.countdownTimer.clearing = true
                            view?.countdownTimer.setNeedsDisplay()

                        }else{
                            self.isPaused = false
//                            view?.countdownTimer.resume()
                            view?.btnPlayPause.isSelected = false
                            let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: Int(self.timeCount))

                            self.startCountDownTimer(text: self.makeTimeStringForMMSS(h: h1, m: m1, s: s1))

                        }
                        
                    }
                }
                else if data.isCompletedRest == false || data.isCompletedRest == nil {
//                    view?.btnNext.isUserInteractionEnabled = false
                    
                    view?.btnNext.setTitle("Next", for: .normal)

                    view?.lblX.isHidden = true
                    view?.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                    view?.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)
                    view?.countdownTimer.trailLineColor = .black

                    self.isDuration = false
                    self.isReps = false
                    self.isRest = true
                    view?.constantWidthDurationReps.constant = 80
                    
                    view?.lblCount.attributedText = setColorWithOffRedName(mainString: "\(index+1) /\(self.exerciseAllResistanceArray[self.arrayIndex].data?.count ?? 0)", stringToColor: "\(index+1)")
 
                    view?.lblOriginalDuration.isHidden = true
                    view?.constantDurationRepearWorkoutCenterX.constant = 0
                    view?.lblWeightWorkout.text = ""
                    view?.lblDurationtRepsWorkout.textAlignment = .left
                    view?.lblExerciseName.text = "Rest"

                    self.timeCount = 0
                    let rest = calculateDuration(data: data.rest)
//                    self.maxValue = Float(rest)

                    var secondDifference = 0

                    if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isPause == true{
                        secondDifference = self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].pauseTime.convertDateFormater().secondDifference(to: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].addedRestTime.convertDateFormater() ?? Date()) ?? 0
                        self.maxValue = Float(secondDifference)

                    }else{
                        secondDifference = Date().secondDifference(to: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].addedRestTime.convertDateFormater() ?? Date())
                        self.maxValue = Float(secondDifference)
                    }
                    


                    if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isPause == true{
                        self.isPaused = true
//                        view?.countdownTimer.pause()
                        view?.btnPlayPause.isSelected = true
                        view?.countdownTimer.elapsedTime = data.elapsedTime
                        view?.countdownTimer.lineDraw = data.lineDraw

                        //MARK: - Remaining to setlike Duration
                        
                        self.pauseTimeCount = Int(self.getSeconds(data: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].lastPauseTime))

                        if (self.pauseTimeCount - Int(self.maxValue)) != 0 {
                            self.updatePauseTimeWithMilliseconds(secondsDifference: self.pauseTimeCount - Int(self.maxValue))
                        }

                        self.maxValue = Float(self.pauseTimeCount)
                        
                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(self.maxValue))
                        view?.lblDurationtRepsWorkout.text = self.makeTimeStringForMMSS(h: h, m: m, s: s)

                        //For disappering circle border while complete
//                        view?.countdownTimer.clearing = true
                        view?.countdownTimer.setNeedsDisplay()

                    }else{
                        self.isPaused = false
//                        view?.countdownTimer.resume()
                        view?.btnPlayPause.isSelected = false
                        
                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(self.maxValue))
                        view?.lblDurationtRepsWorkout.text = self.makeTimeStringForMMSS(h: h, m: m, s: s)

                        self.startCountDownTimer(text:  self.makeTimeStringForMMSS(h: h, m: m, s: s))
                        
                    }

                    self.checkNext()
                }
                          
                break
            }
            
            // set for reps
            if data.isCompleted == true && data.isCompletedRest == true && data.isCurrentLapWorking == true{
                //When user open last completed set that time show data here
                let view = (self.theController?.view as? StartWorkoutResistanceView)

                view?.lblX.isHidden = true
                view?.btnPlayPause.setImage(UIImage(named: "ic_pause_black"), for: .normal)
                view?.btnPlayPause.setImage(UIImage(named: "ic_play_long_black"), for: .selected)
                
                self.isDuration = false
                self.isReps = false
                self.isRest = true
                view?.constantWidthDurationReps.constant = 80
                
                view?.lblCount.attributedText = setColorWithOffRedName(mainString: "\(self.arrayRowIndex+1) /\(self.exerciseAllResistanceArray[self.arrayIndex].data?.count ?? 0)", stringToColor: "\(self.arrayRowIndex+1)")

                view?.lblOriginalDuration.isHidden = true
                view?.constantDurationRepearWorkoutCenterX.constant = 0
                view?.lblWeightWorkout.text = ""
                view?.lblDurationtRepsWorkout.textAlignment = .left
                
                view?.lblDurationtRepsWorkout.text = "00:00"
                
                if (self.checkCompletedLapsCount() == self.totalLapCount) {
                    //For disappering circle border while complete
                    view?.btnNext.setTitle("Completed", for: .normal)
                    view?.countdownTimer.clearing = false
                    view?.countdownTimer.isSolidLine = false
                    view?.countdownTimer.trailLineColor = UIColor.black
                    self.wellDoneAnimation()
                    view?.countdownTimer.setNeedsDisplay()
                }else{
                    view?.lblExerciseName.text = "Rest"
                    view?.btnNext.setTitle("Next", for: .normal)
                }

                if self.timerUpdate != nil{
                    self.timerUpdate?.invalidate()
                    self.timerUpdate = nil
                }

                self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)

                return
            }
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            if isFinish {
                
                print("Finish")
//                self.timer?.invalidate()
//                self.timer = nil
//                self.theController.dismiss(animated: true, completion: nil)
//                self.delegate?.StartWorkoutFinish(tag: self.arrayIndex, exerciseArray: self.exerciseArray)
            }
        }
    }
    
    func setConditionForRepeatParticularSet() -> Bool{
        
        if let view = self.theController?.view as? StartWorkoutResistanceView{
            
            if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isRepeatSet == true{
                
                if self.arrayIndex == 0 && self.arrayRowIndex == 0{
                    
                    if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].repeatTime == ""{
                        
                        if self.timerUpdate != nil{
                            self.timerUpdate?.invalidate()
                            self.timerUpdate = nil
                        }
                        
                        self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)
                        
                        view.lblDurationtRepsWorkout.text = "00:00"
                        self.isPaused = true
                        view.countdownTimer.pause()
                        view.btnPlayPause.isSelected = true
                        //For disappering circle border while complete
                        view.countdownTimer.clearing = true
                        view.countdownTimer.setNeedsDisplay()
                        self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isClickOnPause = true
                        self.ChangeNextWorkOutColorChange(isRedColor: false)
                        
                        return true
                    }
                }else{
                    
                    if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].startTime == ""{
                        
                        if self.timerUpdate != nil{
                            self.timerUpdate?.invalidate()
                            self.timerUpdate = nil
                        }
                        
                        self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)
                        
                        view.lblDurationtRepsWorkout.text = "00:00"
                        self.isPaused = true
                        view.countdownTimer.pause()
                        view.btnPlayPause.isSelected = true
                        //For disappering circle border while complete
                        view.countdownTimer.clearing = true
                        self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isClickOnPause = true
                        view.countdownTimer.setNeedsDisplay()
                        
                        self.ChangeNextWorkOutColorChange(isRedColor: false)
                        
                        return true
                    }
                }
            }
            
        }
        
        return false
        
    }
    
    func updatePauseTimeWithMilliseconds(secondsDifference:Int){
        
        if self.isRest == true{
            
            print("addedRestTime Time Before:\(self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].addedRestTime)")
            
            if let valueAddigForPauseTime = self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].addedRestTime.convertDateFormater().addingTimeInterval(TimeInterval(secondsDifference)){
                
                let convertToStringForPauseTime = valueAddigForPauseTime.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].addedRestTime = convertToStringForPauseTime
                
            }
            
            print("addedRestTime Time After:\(self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].addedRestTime)")
            
        }else{
            let valueAddigForPauseTime = self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].pauseTime.convertDateFormater().addingTimeInterval(TimeInterval(secondsDifference))
            
            if let convertToStringForPauseTime = valueAddigForPauseTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss"){
                self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].pauseTime = convertToStringForPauseTime
            }
        }
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
        let view = (self.theController?.view as? StartWorkoutResistanceView)
        if self.exerciseAllResistanceArray[self.arrayIndex].data?.count == (self.index + 1) {
//            view?.btnNext.isUserInteractionEnabled = true
//            view?.lblNextWorkout.text = "Workout completed"
        }
        else {
            for (index, data) in self.self.exerciseAllResistanceArray[self.arrayIndex].data!.enumerated() {
                if index == (self.index + 1) {
                    if data.isCompleted == false || data.isCompleted == nil {
//                        view?.lblNextWorkout.text = "Reps \(data.reps ?? "")"
                    }
                    else if data.isCompletedRest == false || data.isCompletedRest == nil {
//                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(data.rest ?? "0") ?? 0)
//                        view?.lblNextWorkout.text = (data.rest ?? "") + " rest" //self.makeTimeStringForMMSS(h: h, m: m, s: s) + " rest"
                    }
                    break
                }
            }
        }
    }
    
    //MARK: - CountDown Timer method
    
    func startCountDownTimer(text:String) {
        let view = (self.theController?.view as? StartWorkoutResistanceView)
        
        if isRest == true || isDuration == true{
            view?.lblDurationtRepsWorkout.text = text
        }
        
        view?.countdownTimer.start(beginingValue: 1, interval: 1)
        view?.countdownTimer.isSolidLine = true
        
        if self.isRest {
            view?.countdownTimer.trailLineColor = UIColor.black
            
            if Int(maxValue) == 0{
                if self.checkCompletedLapsCount() == self.totalLapCount {
                    view?.countdownTimer.isSolidLine = false
                }
            }

            if (Int(maxValue) ?? 0) % 2 == 0 {
                view?.countdownTimer.lineDraw = false
            }else{
                view?.countdownTimer.lineDraw = true
            }
        }else{
            
            view?.countdownTimer.trailLineColor = trailingGradientColor
            
//            if self.exerciseArray[self.index].rest == nil{
//
//                print("timeCount:\(Int(timeCount))")
//                print("lapTotalDurationManualCalculation:\(lapTotalDurationManualCalculation)")
//
//                if Int(timeCount) == lapTotalDurationManualCalculation{
//
//                    if self.index == self.exerciseArray.count - 1{
//                        view?.countdownTimer.isSolidLine = false
//                    }
//                }
//            }
            
            if (Int(timeCount) ?? 0) % 2 == 0 {
                
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
    
    func timerDidEnd(sender: SRCountdownTimer, elapsedTime: TimeInterval) {
        
        if isPaused {
            return
        }
        
        if self.checkCompletedLapsCount() == self.totalLapCount{
            if self.isRest{
                if self.maxValue == 0{
                    if let view = (self.theController?.view as? StartWorkoutResistanceView){
                        view.countdownTimer.setNeedsDisplay()
                    }
                    return
                }
            }
        }
        playNext()
        
    }
    
    func timerDidPause(sender: SRCountdownTimer) {
        print("Pause")
        self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].elapsedTime = sender.elapsedTime
        
        if self.isRest{
            self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].lineDraw = Int(maxValue) % 2 == 0 ? false : true
        }else{
            self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].lineDraw = Int(timeCount) % 2 == 0 ? false : true
        }
        
    }
    
    func timerDidResume(sender: SRCountdownTimer) {
        
        sender.resumeTimer(elapsedTime: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].elapsedTime ?? 0, beginingValue: 1 ,interval: 1)
        
    }
    
    func playNext(){
        
        if let view =  (self.theController?.view as? StartWorkoutResistanceView){
            
            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            
            if self.isRest{
                self.maxValue -= 1
                
                let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(self.maxValue))
                view.lblDurationtRepsWorkout.text = self.makeTimeStringForMMSS(h: h, m: m, s: s)
                
                if self.maxValue > 0 {
                    self.startCountDownTimer(text: self.makeTimeStringForMMSS(h: h, m: m, s: s))
                }else{
                    
                    if (self.arrayRowIndex + 1) != self.exerciseAllResistanceArray[self.arrayIndex].data?.count {
                            
                        self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCompletedRest = true
                        self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isRepeatSet = false
                        
                        if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].reps == "" || self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].reps == nil{
                            //Duration section

                            print("Duration")
                            //check next lap is completed or not
                            
                            if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex+1].isCompleted == true && self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex+1].isCompletedRest == true{
                                //Next lap is Completed
                                //No need to assign next lap currentlap working
                                
                                self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: false)
                                    
                                self.isWellDoneAnimationOccur(view: view)
                                self.disappearTimerCircle(view: view)
                                
                            }else{
                                
                                view.countdownTimer.isSolidLine = true
                                
                                //all set currentLapWorkinglap false including current index that's why write currentIndex as currentworkinglap after all done
                                
                                self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: true)
                                
                                let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].rest)))
                                
                                let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                                self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].addedRestTime = convertToStringForRest
                                
                                self.exerciseAllResistanceArray[self.arrayIndex].data?[arrayRowIndex].startTime = date
                            }
                            
                            //set true because we need last currentworking lap
                            self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCurrentLapWorking = true

                            self.delegate?.StartWorkoutFinish(tag: self.arrayIndex, exerciseAllArray: self.exerciseAllResistanceArray)
                            
                            self.checkAndStart()
                        }else{
                            //Reps section
                            print("Reps")
                            self.disappearTimerCircle(view: view)
                            
                            self.isWellDoneAnimationOccur(view: view)
                            
                            //TODO: - set here if last lap
                            
                            //all set currentLapWorkinglap false including current index that's why write currentIndex as currentworkinglap after all done
                            self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: false)
                            
                            //set true because we need last currentworking lap
                            self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCurrentLapWorking = true

                            self.delegate?.StartWorkoutFinish(tag: self.arrayIndex, exerciseAllArray: self.exerciseAllResistanceArray)
                        }
                        
                    }
                    else {
                        
                           
                        self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCompletedRest = true
                        self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isRepeatSet = false
                        
                        if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].reps == "" || self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].reps == nil{
                            //Duration section
                            
                            print("Next Section available : \(checkNextSectionIsAvailableOrNot())")
                            
                            if checkNextSectionIsAvailableOrNot(){
                                
                                if self.exerciseAllResistanceArray[self.arrayIndex+1].data?[0].reps == "" || self.exerciseAllResistanceArray[self.arrayIndex+1].data?[0].reps == nil{
                                    //Duration in next section
                                    
                                    //check next section is completed or not
                                    if self.exerciseAllResistanceArray[self.arrayIndex + 1].data?[0].isCompleted == true && self.exerciseAllResistanceArray[self.arrayIndex+1].data?[0].isCompletedRest == true{

                                        self.disappearTimerCircle(view: view)
                                          
                                        //set here animation
                                        self.isWellDoneAnimationOccur(view: view)
                                        //
                                        
                                        self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: false)
                                        
                                        //set true because we need last currentworking lap
                                        self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCurrentLapWorking = true
                                        
                                    //    self.theController?.dismiss(animated: true, completion: nil)
                                        self.delegate?.StartWorkoutFinish(tag: self.arrayIndex, exerciseAllArray: self.exerciseAllResistanceArray)

                                    }else{
                                        
                                        view.countdownTimer.isSolidLine = true
                                        
                                        self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: true)

                                        let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].rest)))
                                        
                                        let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                                        self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].addedRestTime = convertToStringForRest

                                        self.exerciseAllResistanceArray[self.arrayIndex].data?[arrayRowIndex].startTime = date

                                        //set true because we need last currentworking lap
                                        self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCurrentLapWorking = true
                                        
                                    //    self.theController?.dismiss(animated: true, completion: nil)
                                        self.delegate?.StartWorkoutFinish(tag: self.arrayIndex - 1, exerciseAllArray: self.exerciseAllResistanceArray)

                                        self.checkAndStart()

                                    }
                                    
                                    self.checkLinkAvailableOrNot()
                                    
                                    return

                                }else{
                                    
                                    self.disappearTimerCircle(view: view)
                                    self.isWellDoneAnimationOccur(view: view)
                                    
                                    //check
                                    
                                    self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: false)

                                }
                                
                            }else{
                                
                                self.disappearTimerCircle(view: view)
                                self.isWellDoneAnimationOccur(view: view)

                                self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: false)
                                    
                            }

                        }else{
                            
                            print("Reps")
                            self.disappearTimerCircle(view: view)
                            self.isWellDoneAnimationOccur(view: view)
                            //all set currentLapWorkinglap false including current index that's why write currentIndex as currentworkinglap after all done
                            self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: false)

                        }
                        
                        //set true because we need last currentworking lap
                        self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCurrentLapWorking = true
                                                
                    //    self.theController?.dismiss(animated: true, completion: nil)
                        self.delegate?.StartWorkoutFinish(tag: self.arrayIndex, exerciseAllArray: self.exerciseAllResistanceArray)
                    }

                    view.lblLapsCompleted.text = "\(self.checkCompletedLapsCount())/\(self.totalLapCount)"
                    
                    self.checkAndStart()

                }
            }else{
                
                self.timeCount += 1

                if self.isDuration
                {
                    
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(self.timeCount))
                    self.startCountDownTimer(text: self.makeTimeStringForMMSS(h: h, m: m, s: s))
                                             
                    view.lblDurationtRepsWorkout.text = self.makeTimeStringForMMSS(h: h, m: m, s: s)
                    view.lblWeightWorkout.text = "\(self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].weight ?? "")"
                        
//                        setFontOfKg(mainString: "\(self.exerciseArray[self.index].weight ?? "")kg", stringToColor: "kg")

                    if self.lapTotalDurationManualCalculation < self.timeCount{
                        if (self.arrayRowIndex + 1) != self.exerciseAllResistanceArray[self.arrayIndex].data?.count {
                            
                            self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCompleted = true
                            
                            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                            let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].rest)))
                            
                            let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                            self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].addedRestTime = convertToStringForRest
                            
                            //check Next button clickable or not
                            if self.exerciseAllResistanceArray[self.arrayIndex].data?[arrayRowIndex+1].isCompleted == true && self.exerciseAllResistanceArray[self.arrayIndex].data?[arrayRowIndex+1].isCompletedRest == true{
                                ChangeNextWorkOutColorChange(isRedColor: false)
                            }else{
                                ChangeNextWorkOutColorChange(isRedColor: true)
                            }
                            
                            
                            //all set currentLapWorkinglap false including current index that's why write currentIndex as currentworkinglap after all done
                            self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: false)

                            //set true because we need last currentworking lap
                            self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCurrentLapWorking = true

                            self.delegate?.StartWorkoutFinish(tag: self.arrayIndex, exerciseAllArray: self.exerciseAllResistanceArray)
                        }
                        else {
                            self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCompleted = true
                          
                            //Check next button clickable or not
                            if checkNextSectionIsAvailableOrNot(){
                                
                                if self.exerciseAllResistanceArray[self.arrayIndex+1].data?[0].isCompleted == true && self.exerciseAllResistanceArray[self.arrayIndex+1].data?[0].isCompletedRest == true{

                                    ChangeNextWorkOutColorChange(isRedColor: false)
                                    
                                }else{
                                    ChangeNextWorkOutColorChange(isRedColor: true)
                                }
                            }else{
                                ChangeNextWorkOutColorChange(isRedColor: false)
                            }
                            
                            //all set currentLapWorkinglap false including current index that's why write currentIndex as currentworkinglap after all done
                            self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: false)
                            
                            let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].rest)))
                            
                            let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                            self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].addedRestTime = convertToStringForRest

                            //set true because we need last currentworking lap
                            self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCurrentLapWorking = true

//                            self.theController?.dismiss(animated: true, completion: nil)
                            self.delegate?.StartWorkoutFinish(tag: self.arrayIndex, exerciseAllArray: self.exerciseAllResistanceArray)
                        }
                        
                        self.checkAndStart()
                    }

                }else{
                    
                    ChangeNextWorkOutColorChange(isRedColor: true)
                    self.startCountDownTimer(text: "")
                }
            }

        }
        
        getTotalDuration()
        
    }
    
    func wellDoneAnimation(){
        
        if let view = self.theController?.view as? StartWorkoutResistanceView{
            
            view.lblExerciseName.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            view.lblExerciseName.text = getCommonString(key: "Well_done!_key")
            
            view.lblExerciseName.alpha = 0.5
            
            UIView.animate(withDuration: 0.6,
                                       delay:0.0,
                                       usingSpringWithDamping:0.6,
                                       initialSpringVelocity:0.3,
                                       options: .curveEaseOut,
                                       animations: {
                                        
                                        view.lblExerciseName.alpha = 1
                                        view.lblExerciseName.textColor = .appthemeOffRedColor
                                        view.lblExerciseName.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: {
                //Code to run after animating
                (value: Bool) in
                
            })
            
        }
    }
    
    func disappearTimerCircle(view: StartWorkoutResistanceView){
        view.countdownTimer.trailLineColor = .clear
        view.countdownTimer.setNeedsDisplay()
        
        if self.timerUpdate != nil{
            self.timerUpdate?.invalidate()
            self.timerUpdate = nil
        }

        self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)

    }
    
    func isWellDoneAnimationOccur(view: StartWorkoutResistanceView){
        
        if self.checkCompletedLapsCount() == self.totalLapCount{
            view.countdownTimer.isSolidLine = false
            self.startCountDownTimer(text: "00:00")
            view.countdownTimer.setNeedsDisplay()
            
    //                                    self.isWellDoneAnimationDone = true
            self.wellDoneAnimation()
            
            if self.timerUpdate != nil{
                self.timerUpdate?.invalidate()
                self.timerUpdate = nil
            }

            self.timerUpdate = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.getTotalDuration), userInfo: nil, repeats: true)
            
        }else{
            view.countdownTimer.isSolidLine = true
        }
    }
    
    func ChangeNextWorkOutColorChange(isRedColor:Bool){
        
        if let view = self.theController?.view as? StartWorkoutResistanceView{
            
            if isRedColor{
                view.btnNext.isUserInteractionEnabled = true
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
                    view.vwNextWorkout.borderWidth = 0.9
                    view.vwNextWorkout.borderColors = UIColor.appthemeOffRedColor
                    view.vwNextWorkout.setShadowToView()
                    view.btnNext.setTitleColor(UIColor.appthemeOffRedColor, for: .normal)
                    view.btnNext.setImage(UIImage(named: "ic_next-1"), for: .normal)
                    view.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
                    view.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                }
            }else{
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
                    
                    view.btnNext.setTitleColor(UIColor.appthemeBlackColor, for: .normal)

                    if self.checkCompletedLapsCount() == self.totalLapCount{
                        view.btnNext.setTitle("Completed", for: .normal)
                        view.btnNext.setImage(nil, for: .normal)
                        view.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        view.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
                    }else{
                        
                        if self.checkCompletedLapsCount()  == self.totalLapCount - 1{
                            if self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCompleted == true && (self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCompletedRest == false || self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCompletedRest == nil){
                                
                                view.btnNext.setTitle("Completed", for: .normal)
                                view.btnNext.setImage(nil, for: .normal)
                                view.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                view.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                                
                            }else{
                                view.btnNext.setTitle("Next", for: .normal)
                                view.btnNext.setImage(UIImage(named: "ic_next_black"), for: .normal)
                                view.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
                                view.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                            }
                        }else{
                            view.btnNext.setTitle("Next", for: .normal)
                            view.btnNext.setImage(UIImage(named: "ic_next_black"), for: .normal)
                            view.btnNext.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
                            view.btnNext.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                        }
                    }
                    
                    view.vwNextWorkout.borderColors = .black
                    view.vwNextWorkout.shadowColors = .clear
                    view.vwNextWorkout.borderWidth = 0.9
                }
                view.btnNext.isUserInteractionEnabled = false
            }
        }
        
    }
    
    func checkCompletedLapsCount() -> Int{
        
        var count = 0
         
         for i in 0..<(self.exerciseAllResistanceArray.count){
             
             for j in 0..<(self.exerciseAllResistanceArray[i].data?.count ?? 0){
                 
                 let dict = self.exerciseAllResistanceArray[i].data?[j]
                 
                if dict?.isCompleted == true && dict?.isCompletedRest == true{
                    count += 1
                }
             }
         }

        return count
        
    }
    
    func checkNextSectionIsAvailableOrNot() -> Bool{
        
        let dataDict = self.exerciseAllResistanceArray[self.arrayIndex]
        
        if let count = dataDict.data?.count{
            
            if count - 1 == self.arrayRowIndex{
                //Last lap
                
                if self.exerciseAllResistanceArray.count - 1 == self.arrayIndex{
                    //Last section
                    return false
                }else{
                    // section next
                    return true
                }
            }
        }
        
        return false
    }
    
    func checkLinkAvailableOrNot(){
        
        if let vw = self.theController?.view as? StartWorkoutResistanceView{
            
            if self.exerciseAllResistanceArray[self.arrayIndex].exerciseLink == "" {
                vw.viewVideo.isHidden = true
                vw.viewVideo.isUserInteractionEnabled = false
            }else if self.exerciseAllResistanceArray[self.arrayIndex].exerciseLink.lowercased().contains("vimeo"){
                
                vw.vwYoutubeVideo.isHidden = true
                vw.vwYoutubeVideo.isUserInteractionEnabled = false
             
                vw.viewVideo.isHidden = false
                vw.viewVideo.isUserInteractionEnabled = true
                vw.webViewVimeo.isHidden = false
                
                let vimeoId = self.theController?.getVimeoVideoString(strStreamingURL: self.exerciseAllResistanceArray[self.arrayIndex].exerciseLink) ?? ""
                
                let embedHTML="<iframe src=\"https://player.vimeo.com/video/\(vimeoId)?autoplay=0&app_id=122963\" width=\"100%\" height=\"100%\" frameborder=\"0\" allow=\"fullscreen; picture-in-picture\" allowfullscreen></iframe>"

                let url = URL(string: "https://")!
                vw.webViewVimeo.loadHTMLString(embedHTML as String, baseURL:url )

            }else{
                vw.viewVideo.isHidden = false
                vw.viewVideo.isUserInteractionEnabled = true
                
                vw.vwYoutubeVideo.isHidden = false
                vw.vwYoutubeVideo.isUserInteractionEnabled = true
                
                self.theController?.playVideoInView(strVideoURL: self.exerciseAllResistanceArray[self.arrayIndex].exerciseLink.youtubeID ?? "")
            }
        }
    }

    func getTotalDurationForPause(){
        
        if let view = (self.theController?.view as? StartWorkoutResistanceView){
           
            if self.exerciseAllResistanceArray[0].data?[0].startTime == ""{
                return
            }
            
            let secondDifference = self.exerciseAllResistanceArray[0].data?[0].startTime.convertDateFormater().secondDifference(to: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].pauseTime.convertDateFormater() ?? Date())
            
            self.totalDurationInSecond = secondDifference ?? 0

            let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: secondDifference ?? 0)
            view.lblTotalDuration.text = self.makeTimeString(h: h1, m: m1, s: s1)

            /*
            let secondDifference = self.exerciseArray[0].startTime.convertDateFormater().secondDifference(to: self.exerciseArray[self.index].pauseTime.convertDateFormater())
            

            let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: secondDifference)
            view.lblTotalDuration.text = self.makeTimeString(h: h1, m: m1, s: s1)
            */
        }
    }
    
    func setColorWithOffRedName(mainString: String, stringToColor: String) -> NSAttributedString {
        let range = (mainString as NSString).range(of: stringToColor)
        
        let attribute = NSMutableAttributedString.init(string: mainString)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.appthemeOffRedColor , range: range)
        return attribute
    }
    
    func makeTimeStringForMMSS(h:Int, m:Int, s:Int) -> String {
       
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
        
        return minuteStr + ":" + secondStr
//        return hourStr + ":" + minuteStr + ":" + secondStr
        
        //Anil code
        /*var str:String = ""
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
        
        return str*/
    }
    
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
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func closeView()
    {
        
        self.theController?.dismiss(animated: true) {
            if self.timerUpdate != nil{
                self.timerUpdate?.invalidate()
                self.timerUpdate = nil
            }
        }
        
    }
    
    func calculateDuration(data:String?) -> Int {
        if data?.contains(":") ?? false {
            let firstArray = data?.split(separator: ":")
            // Anil set fHr for hour formate so index change
          //  let fHr = (Double(firstArray?[0] ?? "0") ?? 0) * 60 * 60
            let fHr = 0.0
            let fMin = (Double(firstArray?[0] ?? "0") ?? 0) * 60
            let fSec = (Double(firstArray?[1] ?? "0") ?? 0)
            let firstCount = fHr + fMin + fSec
            return Int(firstCount)
        }
        else {
            return Int(data ?? "0") ?? 0
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

}
