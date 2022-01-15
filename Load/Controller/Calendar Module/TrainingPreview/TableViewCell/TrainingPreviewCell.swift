//
//  ExerciseCardioCell.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol restDelegateForTrainingPreview {
    func currentWorkoutRestClick()
    func finalLapWithNullRest()
    func automaticallyCompleteLap(isRestNil:Bool)
    func checkNextLapDataDistanceDurationRestData(index:Int,isRestNil:Bool,isLastLap:Bool)
}


class TrainingPreviewCell: UITableViewCell {
    
    @IBOutlet weak var txtDistance: UITextField!
    @IBOutlet weak var txtPace: UITextField!
    @IBOutlet weak var txtPercentage: UITextField!
    @IBOutlet weak var txtRest: UITextField!
    
    @IBOutlet weak var btnDistance: UIButton!
    @IBOutlet weak var btnPace: UIButton!
    @IBOutlet weak var btnPercentage: UIButton!
    @IBOutlet weak var btnRest: UIButton!
    
    @IBOutlet weak var viewPercentage: UIView!
    @IBOutlet weak var leftViewPercentage: NSLayoutConstraint!
    @IBOutlet weak var rightViewPercentage: NSLayoutConstraint!
    
    @IBOutlet weak var vwCheckMark: checkmarkAnimation!
    @IBOutlet weak var imgRest: UIImageView!
    @IBOutlet weak var vwProgressbar: LinearProgressView!

    //MARK:- Varaible
    let distancePickerView = UIPickerView()
    let restPickerView = UIPickerView()
    let percentPickerView = UIPickerView()
    
    var hour:Int = 0
    var minutes:Int = 0
    var activityId:String = ""
    var raceDistanceId:Double?
    var raceTime:Double?
    var response: WeekWiseWorkoutLapsDetails?
    var isSpeedSelected:Bool = false
    
    var index = 0
    var selectedModelData : WeekWiseWorkoutLapsDetails?
    var totalCount = 0

    var timerofUpdateProgressbar: Timer?
    var gradientColor = UIColor()
    var coverdDistancePedoMeter : CGFloat = 0.0

    var delegateOfRest : restDelegateForTrainingPreview?
    var exerciseArray : [WeekWiseWorkoutLapsDetails?] = []

    //MARK:- life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI(data: WeekWiseWorkoutLapsDetails? , allLaps: [WeekWiseWorkoutLapsDetails]?) {
        self.response = data
        self.setupFont()
        self.txtDistance.text = data?.distance?.replacingOccurrences(of: "km", with: "") ?? "0.0"
        
        if data?.distance == nil {
            self.txtDistance.text = data?.duration ?? ""
        }
        else {
            let screen = UIScreen.main.bounds.width / 3
            let label = UILabel()
            label.textAlignment = .center
            label.font = themeFont(size: 21, fontname: .Regular)
            label.frame = CGRect(x: screen + 40, y: (distancePickerView.frame.height - 30) / 2, width: screen, height: 30)
            label.text = "km"
            
            label.textColor = .appthemeOffRedColor
            self.distancePickerView.addSubview(label)
        }
        if !self.isSpeedSelected {
            //            let pace = data?.pace?.doubleValue.rounded(toPlaces: 2)
            //            self.txtPace.text = "\(pace ?? 0)".replace(target: ".00", withString: "")
            self.txtPace.text = data?.pace ?? ""
        }
        else {
            //            let speed = data?.speed?.doubleValue.rounded(toPlaces: 2)
            //            self.txtPace.text = "\(speed ?? 0)".replace(target: ".00", withString: "")
            self.txtPace.text = data?.speed ?? "--:--"
        }
        self.txtPercentage.text = data?.percent ?? "-"
        self.txtRest.text = data?.rest ?? "--:--"
        
        self.txtDistance.isUserInteractionEnabled = false
        self.txtPace.isUserInteractionEnabled = false
        self.txtPercentage.isUserInteractionEnabled = false
        self.txtRest.isUserInteractionEnabled = false
        
        if data?.distance != nil  {
            let dataArray = data?.distance?.split(separator: "-")
            if dataArray?.count == 2 {
                
                self.txtDistance.text = oneDigitAfterDecimal(value: self.response?.updatedDistance ?? (self.calculateDistanceArray(data: self.response?.distance).first ?? "").toFloat())
                
                if allLaps?[0].startTime == ""{
                    self.txtDistance.textColor = .appthemeOffRedColor
                }else{
                    self.txtDistance.textColor = .appthemeBlackColor
                }
                
                self.response?.updatedDistance = setOneDigitWithFloorInCGFLoat(value: self.response?.updatedDistance ?? (self.calculateDistanceArray(data: self.response?.distance).first ?? "").toFloat())
                
                self.txtDistance.isUserInteractionEnabled = true
                distancePickerView.delegate = self
                distancePickerView.backgroundColor = UIColor.white
                self.txtDistance.inputView = distancePickerView
            }else{
                self.response?.updatedDistance = setOneDigitWithFloorInCGFLoat(value: data?.distance?.replacingOccurrences(of: "km", with: "").toFloat() ?? 0.0)
                self.txtDistance.isUserInteractionEnabled = false
            }
        }else{
            if data?.duration != nil  {
                let dataArray = data?.duration?.split(separator: "-")
                if dataArray?.count == 2 {
                    
                    self.txtDistance.text = self.response?.updatedDuration ?? self.calculateDurationArray(data: self.response?.duration).first
                    
                    if allLaps?[0].startTime == ""{
                        self.txtDistance.textColor = .appthemeOffRedColor
                    }else{
                        self.txtDistance.textColor = .appthemeBlackColor
                    }
                    
                    self.response?.updatedDuration = self.response?.updatedDuration ?? self.calculateDurationArray(data: self.response?.duration).first
                    
                    self.txtDistance.isUserInteractionEnabled = true
                    distancePickerView.delegate = self
                    distancePickerView.backgroundColor = UIColor.white
                    self.txtDistance.inputView = distancePickerView
                }else{
                    self.response?.updatedDuration = data?.duration ?? nil
                    self.txtDistance.isUserInteractionEnabled = false
                }
            }else{
                self.txtDistance.text = "--:--"
                print("Tag : \(self.tag)")
                self.txtDistance.textColor = .appthemeBlackColor
                self.txtDistance.isUserInteractionEnabled = false
            }

        }
        
        if data?.rest != nil  {
            let dataArray = data?.rest?.split(separator: "-")
            if dataArray?.count == 2 {
                self.txtRest.text = ((self.response?.updatedRest == "") || (self.response?.updatedRest == nil)) ? self.calculateRestArray(data: self.response?.rest).first : self.response?.updatedRest
                
                if allLaps?[0].startTime == ""{
                    self.txtRest.textColor = .appthemeOffRedColor
                }else{
                    self.txtRest.textColor = .appthemeBlackColor
                }
                
                
                self.response?.updatedRest = ((self.response?.updatedRest == "") || (self.response?.updatedRest == nil)) ? self.calculateRestArray(data: self.response?.rest).first : self.response?.updatedRest

                self.txtRest.isUserInteractionEnabled = true
                restPickerView.delegate = self
                restPickerView.backgroundColor = UIColor.white
                self.txtRest.inputView = restPickerView
            }else{
                response?.updatedRest = data?.rest ?? nil
                self.txtRest.isUserInteractionEnabled = false
            }
        }else{
            self.txtRest.text = "--:--"
            self.txtRest.textColor = .appthemeBlackColor
            self.txtRest.isUserInteractionEnabled = false
        }
        
        
        if data?.percent != nil {
            let dataArray = data?.percent?.split(separator: "-")
            if dataArray?.count == 2 {
                self.txtPercentage.text = (self.response?.updatedPercent == "" || self.response?.updatedPercent == nil) ? self.calculatePercentageArray(data: self.response?.percent).first : self.response?.updatedPercent
             
                if allLaps?[0].startTime == ""{
                    self.txtPercentage.textColor = .appthemeOffRedColor
                }else{
                    self.txtPercentage.textColor = .appthemeBlackColor
                }

                self.response?.updatedPercent = (self.response?.updatedPercent == "" || self.response?.updatedPercent == nil) ? self.calculatePercentageArray(data: self.response?.percent).first : self.response?.updatedPercent

                self.txtPercentage.isUserInteractionEnabled = true
                percentPickerView.delegate = self
                percentPickerView.backgroundColor = UIColor.white
                self.txtPercentage.inputView = percentPickerView
            }else{
                if data?.percent == "0" || data?.percent == "0.00"{
                    self.txtPercentage.text = "-"
                    self.txtPercentage.textColor = .appthemeBlackColor
                    response?.updatedPercent = nil
                    self.txtPercentage.isUserInteractionEnabled = false
                }
            }
        }else{
            self.txtPercentage.text = "-"
            self.txtPercentage.textColor = .appthemeBlackColor
            self.txtPercentage.isUserInteractionEnabled = false
        }
        
        self.vwProgressbar.isHidden = true
        self.vwCheckMark.isHidden = true

    }
    
    func setupDataWithSpecificValueAndAnimation(data: WeekWiseWorkoutLapsDetails? ,index:Int,totalCount:Int ){
        self.response = data
        self.setupFont()
        
        self.txtDistance.isUserInteractionEnabled = false
        self.txtPace.isUserInteractionEnabled = false
        self.txtPercentage.isUserInteractionEnabled = false
        self.txtRest.isUserInteractionEnabled = false
        
        [self.txtDistance,self.txtPace, self.txtPercentage,self.txtRest].forEach { (txt) in
            txt?.isUserInteractionEnabled = false
            txt?.textColor = .appthemeBlackColor
        }
        
        if data?.updatedDistance != nil{
            self.txtDistance.text = oneDigitAfterDecimal(value: data?.updatedDistance ?? 0.0)
        }else if data?.updatedDuration != nil {
            self.txtDistance.text = self.response?.updatedDuration ?? "--:--"
        }else{
            self.txtDistance.text = "--:--"
        }
        
        self.txtRest.text = self.response?.updatedRest ?? "--:--"
        
        if self.response?.updatedPercent != nil || self.response?.updatedPercent == "0" ||  self.response?.updatedPercent == "0.00"{
            self.txtPercentage.text = self.response?.updatedPercent ?? "-"
        }else {
            self.txtPercentage.text = "-"
        }
        
        if !self.isSpeedSelected {
            self.txtPace.text = data?.pace ?? ""
        }
        else {
            self.txtPace.text = data?.speed ?? "--:--"
        }
        
        
        if (data?.isCompleted ?? false) && (data?.isCompletedRest == true) {
            self.imgRest.image = UIImage(named: "ic_lap_completed")
            
            self.vwCheckMark.isHidden = false
            //                self.vwCheckMark.removeAllAnimation()
            
            if data?.isCheckMarkAlreadyDone == true{
                self.imgRest.alpha = 1
                
                //                    self.vwCheckMark.animationDuration = 0.0
                //                    self.vwCheckMark.animateCircle()
            }else{
                self.imgRest.alpha = 0
                
                self.vwCheckMark.removeAllAnimation()
                self.vwCheckMark.animationDuration = 0.5
                self.vwCheckMark.animateCircle()
                data?.isCheckMarkAlreadyDone = true
            }
            
            self.txtRest.text = ""
        }else{
            //                self.imgRest.image = UIImage(named: "ic_timer_red")
            self.imgRest.alpha = 0
            self.vwCheckMark.isHidden = true
            
            self.txtRest.text = self.response?.updatedRest ?? "--:--"
        }
        
        
        if index == self.tag && (data?.startTime != "") && ((data?.isCompleted == false || data?.isCompleted == nil) || (data?.isCompleted == true && (data?.isCompletedRest == false || data?.isCompletedRest == nil))){
//            self.imgRest.image = UIImage(named: "ic_timer")
            self.imgRest.alpha = 0
            self.vwCheckMark.isHidden = true

            //For Rest
            if ((data?.isCompleted == true && (data?.isCompletedRest == false || data?.isCompletedRest == nil))){
                
                self.vwProgressbar.trackColor = .white
                self.vwProgressbar.barColor = .white
                self.vwProgressbar.trackColor = .black
                
                if self.vwProgressbar.progress == 0.0 {
                    let mainRestValue = geHoursMinutesSecondsTOSecondsFormate(data: data?.rest ?? "")
                    self.vwProgressbar.maximumValue = Float(mainRestValue.toFloat())
                    self.vwProgressbar.setProgress(Float(CGFloat(mainRestValue.toFloat())), animated: false)
                }
                
                timerCheckProgress(index:index,progressbarView: self.vwProgressbar,model: data!,totalCount: totalCount)
                
            }else{
                
                self.vwProgressbar.trackColor = .white
                self.vwProgressbar.barColor = .white
                
                if self.vwProgressbar.progress == 0.0 {
                    self.vwProgressbar.setProgress(Float(CGFloat(0.0)), animated: false)
                }

                timerCheckProgress(index:index,progressbarView: self.vwProgressbar,model: data!,totalCount: totalCount)
                self.vwProgressbar.trackColor = gradientColor

            }
            
            self.vwProgressbar.isHidden = false
        }else{
            self.vwProgressbar.isHidden = true
            
            if timerofUpdateProgressbar != nil{
                timerofUpdateProgressbar?.invalidate()
                timerofUpdateProgressbar = nil
            }
        }
    }
    
    func setupFont() {
        self.txtDistance.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        self.txtPace.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        self.txtPercentage.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        self.txtRest.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        
        self.txtDistance.setColor(color: .appthemeBlackColor)
        self.txtPace.setColor(color: .appthemeBlackColor)
        self.txtPercentage.setColor(color: .appthemeBlackColor)
        self.txtRest.setColor(color: .appthemeBlackColor)
        
        gradientColor = self.drawGradientColor(colors: [UIColor(red: 116/255, green: 48/255, blue: 153/255, alpha: 1).cgColor,UIColor(red: 199/255, green: 50/255, blue: 50/255, alpha: 0.88).cgColor])!

    }
    
    func timerCheckProgress(index:Int,progressbarView:LinearProgressView,model: WeekWiseWorkoutLapsDetails,totalCount:Int){
        
        self.selectedModelData = model
        self.index = index
        self.totalCount = totalCount
        
//        if model.isPause == true{
//            return
//        }
        
        //For Rest
        if ((model.isCompleted == true && (model.isCompletedRest == false || model.isCompletedRest == nil))){
            
            let mainRestValue = geHoursMinutesSecondsTOSecondsFormate(data: model.updatedRest ?? "")
//            let startTime = Date().secondDifference(to: model.addedRestTime.convertDateFormater())
            
            var startTime = 0
            
            if model.isPause == true{
                startTime = model.pauseTime.convertDateFormater().secondDifference(to: model.addedRestTime.convertDateFormater())
            }else{
                startTime = Date().secondDifference(to: model.addedRestTime.convertDateFormater())
            }
            
            print("startTime: \(startTime)")
//            print("mainRestValue : \(Int(mainRestValue.toFloat()))")
//
            progressbarView.maximumValue = Float(mainRestValue.toFloat())
            progressbarView.minimumValue = 0.0
//            progressbarView.progressValue = CGFloat(startTime)
            
//            UIView.animate(withDuration: 2) {
                progressbarView.setProgress(Float(CGFloat(startTime)), animated: true)
//            }

            if model.isPause == true{
                return
            }

//            progressbarView.layoutIfNeeded()

            /*
            UIView.animate(withDuration: 0.25, animations: {
                progressbarView.layoutIfNeeded()
            })*/
            
            if timerofUpdateProgressbar != nil{
                timerofUpdateProgressbar?.invalidate()
                timerofUpdateProgressbar = nil
            }
            
            if startTime < 0{
                self.delegateOfRest?.currentWorkoutRestClick()
            }else{
                
                timerofUpdateProgressbar =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callTimerMethod), userInfo: nil, repeats: true)
            }
            
            /*
             if startTime > (Int(mainRestValue.toFloat())){
             print("Methods true")
             }else{
             print("Method call Timer")
             timerofUpdateProgressbar =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callTimerMethod), userInfo: nil, repeats: true)
             }
             */
        }else{
            
            if model.updatedDuration != nil && model.updatedDuration !=  "" {
                
                let mainDurationValue = geHoursMinutesSecondsTOSecondsFormate(data: model.updatedDuration ?? "")
                var startTime = 0
                
                if index == 0{
                    
                    if model.isPause == true{
                        startTime = model.repeatTime.convertDateFormater().secondDifference(to: model.pauseTime.convertDateFormater())
                    }else{
                        startTime = model.repeatTime.convertDateFormater().secondDifference(to: Date())
                    }
                    
                }else{
                    
                    if model.isPause == true{
                        startTime = model.startTime.convertDateFormater().secondDifference(to: model.pauseTime.convertDateFormater())
                    }else{
                        startTime = model.startTime.convertDateFormater().secondDifference(to: Date())
                    }
                    
                }

//                print("Int mainDuraiton : \(Int(mainDurationValue.toFloat()))")
//                print("startTime : \(Int(startTime))")
                
                progressbarView.maximumValue = Float(mainDurationValue.toFloat())
                progressbarView.minimumValue = 0.0
                
//                progressbarView.progressValue = CGFloat(startTime)
                
//                UIView.animate(withDuration: 2) {
                    progressbarView.setProgress(Float(CGFloat(startTime)), animated: true)
//                }
                
                if model.isPause == true{
                    return
                }

//                progressbarView.layoutIfNeeded()

                if timerofUpdateProgressbar != nil{
                    timerofUpdateProgressbar?.invalidate()
                    timerofUpdateProgressbar = nil
                }
                
                if startTime > (Int(mainDurationValue.toFloat())){
                    
//                    finalLapWithNullRest() -=----Competed and CompletedRest true
//                    automaticallyCompleteLap ---- Completed true
//                                                    isRestNil - true == CompletedRest true
//                                                                false == CompletedRest not true
                    
                    if self.totalCount == self.index+1{
                        
                        if model.updatedRest == nil{
                            self.delegateOfRest?.finalLapWithNullRest()
                        }else{
                            self.delegateOfRest?.automaticallyCompleteLap(isRestNil: false)
                        }

                    }
                    else{
                        print("Timer finish")
                        
                        if self.exerciseArray[self.index]?.updatedRest == nil || self.exerciseArray[self.index]?.updatedRest == "" {
                            
                            if (self.exerciseArray[self.index+1]?.updatedDuration == nil || self.exerciseArray[self.index+1]?.updatedDuration == "") && (self.exerciseArray[self.index+1]?.updatedDistance == nil || self.exerciseArray[self.index+1]?.updatedDistance == 0.0){
                                
                                if self.exerciseArray[self.index+1]?.updatedRest == "" || self.exerciseArray[self.index+1]?.updatedRest == nil{

                                    if self.index+2 == self.totalCount{
//                                        self.delegateOfRest?.finalLapWithNullRest()
                                        self.delegateOfRest?.checkNextLapDataDistanceDurationRestData(index: self.index, isRestNil: true, isLastLap:true)

                                    }else{
                                        self.delegateOfRest?.checkNextLapDataDistanceDurationRestData(index: self.index+1, isRestNil: true,isLastLap: false)
                                    }
                                }else{
                                    //Completedd
                                    self.delegateOfRest?.checkNextLapDataDistanceDurationRestData(index: self.index, isRestNil: false,isLastLap: false)
                                }
                                
                            }else{
                                //current completedRest true
                                self.delegateOfRest?.automaticallyCompleteLap(isRestNil: true)
                            }
                            
                        } else {
                             self.delegateOfRest?.automaticallyCompleteLap(isRestNil: false)
                        }
                        
                    }
                    
                }else{
                    
                    timerofUpdateProgressbar =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callTimerMethod), userInfo: nil, repeats: true)
                }
                
            }
            else if model.updatedDistance != nil {
                
                //TODO: - This is comment beacuse of Duration not set in distance
                /*
                let mainDurationValue = findingDurationFromDistance(model: model)
                var startTime = 0
                
                if index == 0{
                    startTime = model.repeatTime.convertDateFormater().secondDifference(to: Date())
                }else{
                    startTime = model.startTime.convertDateFormater().secondDifference(to: Date())
                }
                
//                print("Int mainDuraiton : \(mainDurationValue)")
                */
                
                let totalDistance = Float(CGFloat(model.updatedDistance ?? 0.0)) * 1000
                
                progressbarView.maximumValue = totalDistance
                progressbarView.minimumValue = 0.0
//                progressbarView.progressValue = CGFloat(startTime)
                
                UIView.animate(withDuration: 2) {
                    progressbarView.setProgress(Float(CGFloat(self.coverdDistancePedoMeter)), animated: true)
                }

                if model.isPause == true{
                    return
                }
                
                progressbarView.layoutIfNeeded()
                
                if timerofUpdateProgressbar != nil{
                    timerofUpdateProgressbar?.invalidate()
                    timerofUpdateProgressbar = nil
                }

                print("DISTNACE CELL DATA ^^^^^^^^^^^^^^^^ \(coverdDistancePedoMeter) ^^^^^^^^^^^^^^^^^^^ INDEXXX :\(self.index)")

                if coverdDistancePedoMeter > (CGFloat(totalDistance)){
                    
                    if self.totalCount == self.index+1{
                        
                        if model.updatedRest == nil{
                            self.delegateOfRest?.finalLapWithNullRest()
                        }else{
                            self.delegateOfRest?.automaticallyCompleteLap(isRestNil: false)
                        }

                    }
                    else{
                        print("Timer finish")
                        
                        if self.exerciseArray[self.index]?.updatedRest == nil || self.exerciseArray[self.index]?.updatedRest == "" {
                            
                            if (self.exerciseArray[self.index+1]?.updatedDuration == nil || self.exerciseArray[self.index+1]?.updatedDuration == "") && (self.exerciseArray[self.index+1]?.updatedDistance == nil || self.exerciseArray[self.index+1]?.updatedDistance == 0.0){
                                
                                if self.exerciseArray[self.index+1]?.updatedRest == "" || self.exerciseArray[self.index+1]?.updatedRest == nil{
                                    
                                    if self.index+2 == self.totalCount{
//                                        self.delegateOfRest?.finalLapWithNullRest()
                                        self.delegateOfRest?.checkNextLapDataDistanceDurationRestData(index: self.index, isRestNil: true, isLastLap:true)

                                    }else{
                                        self.delegateOfRest?.checkNextLapDataDistanceDurationRestData(index: self.index+1, isRestNil: true, isLastLap: false)
                                    }
                                }else{
                                    //Completedd
                                    self.delegateOfRest?.checkNextLapDataDistanceDurationRestData(index: self.index, isRestNil: false, isLastLap: false)
                                }
                                
                            }else{
                                //current completedRest true
                                self.delegateOfRest?.automaticallyCompleteLap(isRestNil: true)
                            }
                            
                        } else {
                             self.delegateOfRest?.automaticallyCompleteLap(isRestNil: false)
                        }
                        
                    }
                    
                }else{
                    
                    timerofUpdateProgressbar =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callTimerMethod), userInfo: nil, repeats: true)
                }
                
            }
            
        }
        
    }
    
    @objc func callTimerMethod(){
        if selectedModelData?.isPause == false{
            self.timerCheckProgress(index: self.index, progressbarView: self.vwProgressbar, model: selectedModelData!, totalCount: self.totalCount)
        }
        
    }

    
    func showExerciseHeader() {
        self.viewPercentage.isHidden = false
        if self.activityId == "1" {
            self.leftViewPercentage.constant = 0
            self.rightViewPercentage.constant = 0
        }
        else if self.activityId == "2" {
            self.leftViewPercentage.constant = 0
            self.rightViewPercentage.constant = 0
        }
        else if self.activityId == "3" {
            self.viewPercentage.isHidden = true            
            let width = (self.viewPercentage.bounds.width) / 2
            self.leftViewPercentage.constant = -width
            self.rightViewPercentage.constant = -width
        }
        else {
            self.leftViewPercentage.constant = 0
            self.rightViewPercentage.constant = 0
        }
    }
    
    func getDistance(total:Int = 0) -> [String] {
        var array: [String] = []
        for i in 2..<total {
            if (Double(i) + 0.5) > 43 {
                break
            }
            array.append("\(Double(i) + 0.5)".replace(target: ".00", withString: ""))
        }
        return array
    }
    
    func getPace(dist:Double, T:Double) -> [String] {
        var array: [String] = []
        let value1 = self.calculateE(dist: dist * 1000, T: T)
        array.append(value1)
        return array
    }
    
    //    dist :Miles, T: Minute
    func calculateE(dist:Double, T:Double) -> String {
        let data = Double(Int((dist / T))^2)
        let VO2 = -4.6 + 0.182258 * Double(dist / T) + 0.000104 * data
        print(VO2)
        let per_max = 0.8 + 0.1894393 * exp(-0.012778 * T) + 0.2989558 * exp(-0.1932605 * T)
        
        let vDot = VO2 / per_max
        let value1 = Double(dist * 2 * 0.000104)
        let sqr = sqrt(Double(Int(0.182258)^2) - 4 * 0.000104 * (-4.6 - 0.67 * vDot))
        let value2 = (-0.182258 + sqr)
        
        let target = (value1 / value2)
        return "\(target.rounded(toPlaces: 2))".replace(target: ".00", withString: "")
    }
    
    func calculateDistanceArray(data:String?) -> [String] {
        
        self.txtDistance.textColor = UIColor.appthemeOffRedColor
        
        if data?.lowercased() == "2-2.5km".lowercased() {
            return ["2.0", "2.5"]
        }
        else if data?.lowercased() == "0.8-1.6km".lowercased() || data?.lowercased() == "0.8km-1.6km".lowercased() || data?.lowercased() == "2.4-3km".lowercased() || data?.lowercased() == "0.8-1.2km".lowercased() {
            var array: [String] = []
            let dataArray = data?.split(separator: "-")
            if dataArray?.count == 2 {
                let first = dataArray?.first?.replacingOccurrences(of: "km", with: "").toTrim()
                let second = dataArray?[1].replacingOccurrences(of: "km", with: "").toTrim()
                var firstDouble = (Double(first ?? "0") ?? 0)
                
                if firstDouble != 0 {
                    array.append(String(Double(first ?? "0")?.rounded(toPlaces: 2) ?? 0))
                }
                let secondDouble = (Double(second ?? "0") ?? 0)
                
                for index in 0..<Int(secondDouble * 5) {
                    if Double(secondDouble) >= firstDouble && Double(secondDouble) <= secondDouble{
                        if Double(index) != secondDouble {
                            firstDouble = Double(firstDouble) + 0.2
                            array.append(String(Double(firstDouble).rounded(toPlaces: 2)))
                        }
                    }
                }
                if array.last != (String(Double(second ?? "0")?.rounded(toPlaces: 2) ?? 0)) {
                    array.removeLast()
                }
            }
            return array
        }
        else {
            return calculateDistanceOldArray(data: data)
        }
    }
    
    //    func calculateDistanceArray(data:String?) -> [String] {
    //        var array: [String] = []
    //        let dataArray = data?.split(separator: "-")
    //        if dataArray?.count == 2 {
    //            let first = dataArray?.first?.replacingOccurrences(of: "km", with: "")
    //            let second = dataArray?[1].replacingOccurrences(of: "km", with: "")
    //            let firstDouble = (Double(first ?? "0") ?? 0)
    //
    //            let data1 = firstDouble.rounded(toPlaces: 0)
    //            let data2 = firstDouble.rounded(toPlaces: 2)
    //            let final = data2 - data1
    //            if final != 0 {
    //                array.append((first ?? "") + "km")
    //            }
    //            let secondDouble = (Double(second ?? "0") ?? 0)
    //            let end = (Int(Double(second ?? "0") ?? 0)) + 1
    //            for index in 0..<end {
    //                if Double(index) >= firstDouble && Double(index) <= secondDouble{
    //                    array.append(String(index) + "km")
    //                    if Double(index) != secondDouble {
    //                        array.append(String(Double(index) + 0.2) + "km")
    //                    }
    //                }
    //            }
    //            if array.last != "\(second ?? "")km" {
    //                array.removeLast()
    //                array.append("\(second ?? "")km")
    //            }
    //        }
    //        return array
    //    }
    
    func calculateDistanceOldArray(data:String?) -> [String] {
        var array: [String] = []
        let dataArray = data?.split(separator: "-")
        if dataArray?.count == 2 {
            let first = dataArray?.first?.replacingOccurrences(of: "km", with: "").toTrim()
            let second = dataArray?[1].replacingOccurrences(of: "km", with: "").toTrim()
            let firstDouble = (Double(first ?? "0") ?? 0)
            
            let data1 = firstDouble.rounded(toPlaces: 0)
            let data2 = firstDouble.rounded(toPlaces: 2)
            let final = data2 - data1
            if final != 0 {
                array.append((first ?? ""))
            }
            let secondDouble = (Double(second ?? "0") ?? 0)
            let end = (Int(Double(second ?? "0") ?? 0)) + 1
            for index in 0..<end {
                if Double(index) >= firstDouble && Double(index) <= secondDouble{
                    array.append(String(Double(index)))
                    if Double(index) != secondDouble {
                        array.append(String(Double(Double(index) + 0.5).rounded(toPlaces: 2)))
                    }
                }
            }
        }
        return array
    }
    
    func calculateDurationArray(data:String?) -> [String] {
        
        var addTime:Double = 30
        if data?.lowercased() == "2:00:00-2:30:00".lowercased() || data?.lowercased() == "0:30:00 - 0:40:00" || data?.lowercased() == "0:50:00-0:60:00" || data?.lowercased() == "0:50:00-0:65:00" || data?.lowercased() == "0:30:00-0:40:00" || data?.lowercased() == "0:40:00-0:45:00" || data?.lowercased() == "0:40:00-00:45:00" || data?.lowercased() == "0:20:00-0:25:00" || data?.lowercased() == "0:20:00-0:30:00" || data?.lowercased() == "0:10:00-0:15:00" || data?.lowercased() == "0:45:00-0:60:00" || data?.lowercased() == "0:90:00-01:45:00" || data?.lowercased() == "0:15:00-0:25:00" || data?.lowercased() == "0:15:00-0:20:00" || data?.lowercased() == "0:10:00-0:20:00" || data?.lowercased() == "1:00:00-1:15:00" || data?.lowercased() == "0:35:00-0:45:00" {
            addTime = 300
        }
        var array: [String] = []
        let dataArray = data?.split(separator: "-")
        if dataArray?.count == 2 {
            let firstArray = dataArray?.first?.split(separator: ":")
            let secondArray = dataArray?[1].split(separator: ":")
            let fHr = (Double(firstArray?[0] ?? "0") ?? 0) * 60 * 60
            let fMin = (Double(firstArray?[1] ?? "0") ?? 0) * 60
            let fSec = (Double(firstArray?[2] ?? "0") ?? 0)
            
            let sHr = (Double(secondArray?[0] ?? "0") ?? 0) * 60 * 60
            let sMin = (Double(secondArray?[1] ?? "0") ?? 0) * 60
            let sSec = (Double(secondArray?[2] ?? "0") ?? 0)
            
            var firstCount = fHr + fMin + fSec
            let secondCount = sHr + sMin + sSec
            
            let final = Int(((((sHr / 60 ) + (sMin / 60 )) - ((fHr / 60 ) + (fMin / 60 ))) + 1 ) * 2)
            
            for _ in 0..<final {
                if secondCount >= firstCount {
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(firstCount))
                    array.append(self.makeTimeString(h: h, m: m, s: s))
                }
                firstCount += addTime//300
            }
            
            if array.count == 1 {
                let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(secondCount))
                array.append(self.makeTimeString(h: h, m: m, s: s))
            }
            
        }
        return array
    }
    
    func calculateRestArray(data:String?) -> [String] {
        
        let addTime:Double = 30

        var array: [String] = []
        let dataArray = data?.split(separator: "-")
        if dataArray?.count == 2 {
            let firstArray = dataArray?.first?.split(separator: ":")
            let secondArray = dataArray?[1].split(separator: ":")
            let fHr = 0.0
            let fMin = (Double(firstArray?[0] ?? "0") ?? 0) * 60
            let fSec = (Double(firstArray?[1] ?? "0") ?? 0)
            
            let sHr = 0.0
            let sMin = (Double(secondArray?[0] ?? "0") ?? 0) * 60
            let sSec = (Double(secondArray?[1] ?? "0") ?? 0)
            
            var firstCount = fHr + fMin + fSec
            let secondCount = sHr + sMin + sSec
            
            let final = Int(((((sHr / 60 ) + (sMin / 60 )) - ((fHr / 60 ) + (fMin / 60 ))) + 1 ) * 2)
            
            for _ in 0..<final {
                if secondCount >= firstCount {
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(firstCount))
                    array.append(self.makeTimeStringForRest(h: h, m: m, s: s))
                }
                firstCount += addTime//300
            }
            
            if array.count == 1 {
                let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(secondCount))
                array.append(self.makeTimeStringForRest(h: h, m: m, s: s))
            }
            
        }
        return array
    }
    
    func calculatePercentageArray(data:String?) -> [String] {
        
        self.txtPercentage.textColor = UIColor.appthemeOffRedColor
        
        var array: [String] = []
        let dataArray = data?.split(separator: "-")
        if dataArray?.count == 2 {
            let firstArray = Int(dataArray?.first ?? "0") ?? 0
            let secondArray = Int(dataArray?[1] ?? "0") ?? 0
            
            for index in 0..<(secondArray + 1) {
                if firstArray <= index && secondArray >= index {
                    array.append(String(Double(index)))
                    array.append(String(Double(index) + 0.5))
                }
            }
            array.removeLast()
            //            let final = secondArray! + 1
            //            for index in firstArray!..<final {
            //                array.append(String(index))
            //            }
        }
        return array
    }
    
    func makeTimeString(h:Int, m:Int, s:Int) -> String {
        var hr:String = ""
        var min:String = ""
        var sec:String = ""
        
        hr = "\(h)".count == 1 ? "0\(h)" : "\(h)"
        min = "\(m)".count == 1 ? "0\(m)" : "\(m)"
        sec = "\(s)".count == 1 ? "0\(s)" : "\(s)"
        let str = hr + ":" + min + ":" + sec
        return str
    }
    
    func makeTimeStringForRest(h:Int, m:Int, s:Int) -> String {
        
        var min:String = ""
        var sec:String = ""
        
        min = "\(m)".count == 1 ? "0\(m)" : "\(m)"
        sec = "\(s)".count == 1 ? "0\(s)" : "\(s)"
        let str = min + ":" + sec
        return str
    }

    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @IBAction func btnDistanceClicked(_ sender: Any) {
        var isOpen:Bool = false
        if self.response?.distance != nil  {
            let data = self.response?.distance?.split(separator: "-")
            if data?.count == 2 {
                isOpen = true
            }
        }
        
        if self.response?.duration != nil  {
            let data = self.response?.duration?.split(separator: "-")
            if data?.count == 2 {
                isOpen = true
            }
        }
        if isOpen {
            if self.response?.distance != nil {
                
                if self.response?.updatedDistance == 0.0 || self.response?.updatedDistance == nil{
                    self.txtDistance.text = (self.calculateDistanceArray(data: self.response?.distance).first ?? "")
                    self.distancePickerView.selectRow(0, inComponent: 0, animated: false)
                    self.response?.updatedDistance = setOneDigitWithFloorInCGFLoat(value: (self.calculateDistanceArray(data: self.response?.distance).first ?? "").toFloat())
                }
                
            }
            else {
                
                if self.response?.duration != nil {
                    
                    if self.response?.updatedDuration == "" || self.response?.updatedDuration == nil{
                        self.txtDistance.text =  self.calculateDurationArray(data: self.response?.duration).first
                        self.distancePickerView.selectRow(0, inComponent: 0, animated: false)
                        self.response?.updatedDuration =  self.calculateDurationArray(data: self.response?.duration).first
                    }
                }
                
            }
            
            self.txtDistance.becomeFirstResponder()
        }
    }
    
//TODO: - REst remoaing
    
    @IBAction func btnRestClicked(_ sender: Any) {
        if self.response?.rest != nil  {
            let data = self.response?.rest?.split(separator: "-")
            if data?.count == 2 {
                
                if self.response?.updatedRest == "" || self.response?.updatedRest == nil{
                    self.txtRest.text = self.calculateRestArray(data: self.response?.rest).first
                    self.restPickerView.selectRow(0, inComponent: 0, animated: false)
                    self.response?.updatedRest = self.calculateRestArray(data: self.response?.rest).first ?? ""
                }
            }
        }
        
        self.txtRest.becomeFirstResponder()

    }
    
    
    @IBAction func btnPercentClicked(_ sender: Any) {
        if self.response?.percent != nil  {
            let data = self.response?.percent?.split(separator: "-")
            if data?.count == 2 {
                
                if self.response?.updatedPercent == "" || self.response?.updatedPercent == nil{
                    self.txtPercentage.text = self.calculatePercentageArray(data: self.response?.percent).first
                    self.percentPickerView.selectRow(0, inComponent: 0, animated: false)
                    self.response?.updatedPercent = self.calculatePercentageArray(data: self.response?.percent).first
                }
            }
        }
        
        self.txtPercentage.becomeFirstResponder()

    }
    
    @IBAction func btnPaceClicked(_ sender: Any) {
        //        if self.txtDistance.text?.toTrim() == "" {
        //
        //        }
        //        else {
        //            self.txtPace.becomeFirstResponder()
        //        }
    }
}

extension TrainingPreviewCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.restPickerView {
            return self.calculateRestArray(data: self.response?.rest).count
        }
        else if pickerView == self.percentPickerView {
            return self.calculatePercentageArray(data: self.response?.percent).count
        }
        else {
            if self.response?.distance != nil {
                return self.calculateDistanceArray(data: self.response?.distance).count
            }
            else {
                return self.calculateDurationArray(data: self.response?.duration).count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//        for view in pickerView.subviews{
//            view.backgroundColor = UIColor.clear
//        }
        
        let myView = PickerView.instanceFromNib() as! PickerView
        myView.setupUI()
        myView.imgIcon.image = nil
        if pickerView == self.restPickerView {
            myView.lblText.text = self.calculateRestArray(data: self.response?.rest)[row]
        }
        else if pickerView == self.percentPickerView {
            myView.lblText.text = self.calculatePercentageArray(data: self.response?.percent)[row]
        }
        else {
            if self.response?.distance != nil {
                myView.lblText.text = self.calculateDistanceArray(data: self.response?.distance)[row]
            }
            else {
                myView.lblText.text = self.calculateDurationArray(data: self.response?.duration)[row]
            }
        }
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.restPickerView {
            self.txtRest.text = self.calculateRestArray(data: self.response?.rest)[row]
            self.response?.updatedRest = self.calculateRestArray(data: self.response?.rest)[row]
        }
        else if pickerView == self.percentPickerView {
            self.txtPercentage.text = self.calculatePercentageArray(data: self.response?.percent)[row]
            self.response?.updatedPercent = self.calculatePercentageArray(data: self.response?.percent)[row]
        }
        else {
            if self.response?.distance != nil {

                //km remove from both line  ( + "km")
                self.txtDistance.text = self.calculateDistanceArray(data: self.response?.distance)[row]
                self.response?.updatedDistance = setOneDigitWithFloorInCGFLoat(value: self.calculateDistanceArray(data: self.response?.distance)[row].toFloat())
            }
            else {
                self.txtDistance.text = self.calculateDurationArray(data: self.response?.duration)[row]
                self.response?.updatedDuration = self.calculateDurationArray(data: self.response?.duration)[row]
            }
        }
    }
}
