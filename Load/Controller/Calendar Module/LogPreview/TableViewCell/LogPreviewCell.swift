//
//  ExerciseCardioCell.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol restDelegateForLogPreview {
    func currentWorkoutRestClick()
    func finalLapWithNullRest()
    func automaticallyCompleteLap(isRestNil:Bool)
}

class LogPreviewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txtSpeed: UITextField!
    @IBOutlet weak var txtPercentage: UITextField!
    @IBOutlet weak var txtDuration: UITextField!
    @IBOutlet weak var txtRest: UITextField!
    @IBOutlet weak var txtLvl: UITextField!
    @IBOutlet weak var vwLvl: UIView!
    @IBOutlet weak var vwCyclingOutdoorPercentage: UIView!
    @IBOutlet weak var txtCyclingOutdoorPercentage: UITextField!
    @IBOutlet weak var vwCheckMark: checkmarkAnimation!
    
    @IBOutlet weak var viewPercentage: UIView!
    @IBOutlet weak var btnTimer: UIButton!
    
    @IBOutlet weak var vwStackView: UIStackView!
//    @IBOutlet weak var leftViewPercentage: NSLayoutConstraint!
//    @IBOutlet weak var rightViewPercentage: NSLayoutConstraint!
//    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var imgRest: UIImageView!
    @IBOutlet weak var vwProgressbar: LinearProgressView!

    var timerofUpdateProgressbar: Timer?
    var activityId:String = ""
    var activityName = ""
    
    var delegateOfRest : restDelegateForLogPreview?
    
    var index = 0
    var modelData : Exercise?
    var totalCount = 0
    
    var coverdDistancePedoMeter : CGFloat = 0.0
    
    var gradientColor = UIColor()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtSpeed.delegate = self
        self.txtPercentage.delegate = self
        self.txtDuration.delegate = self
        self.txtRest.delegate = self
        self.txtLvl.delegate = self
        self.txtCyclingOutdoorPercentage.delegate = self
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.txtSpeed.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        self.txtPercentage.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        self.txtDuration.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        self.txtRest.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        self.txtLvl.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        self.txtCyclingOutdoorPercentage.font = themeFont(size: 16, fontname: .ProximaNovaRegular)
        
        self.txtSpeed.setColor(color: .appthemeBlackColor)
        self.txtPercentage.setColor(color: .appthemeBlackColor)
        self.txtDuration.setColor(color: .appthemeBlackColor)
        self.txtRest.setColor(color: .appthemeBlackColor)
        self.txtLvl.setColor(color: .appthemeBlackColor)
        self.txtCyclingOutdoorPercentage.setColor(color: .appthemeBlackColor)
        vwProgressbar.isCornersRounded = false
        
        gradientColor = self.drawGradientColor(colors: [UIColor(red: 116/255, green: 48/255, blue: 153/255, alpha: 1).cgColor,UIColor(red: 199/255, green: 50/255, blue: 50/255, alpha: 0.88).cgColor])!
    }
    
    func setPreviewDetails(model: Exercise,index:Int,totalCount:Int) {
        
//        let formattedString = NSMutableAttributedString()
       
        if model.speed != nil  {
//            formattedString.normal( self.oneDigitAfterDecimal(value: model.speed ?? 0.0)).normal12(" km/hr", font: themeFont(size: 10, fontname: .ProximaNovaRegular))
//            self.txtSpeed.attributedText = formattedString
            self.txtSpeed.text = self.oneDigitAfterDecimal(value: model.speed ?? 0.0)
        }
        else {
//            formattedString.normal(model.pace ?? "")//.normal12(" km/hr")
//            self.txtSpeed.attributedText = formattedString
            
            self.txtSpeed.text = model.pace ?? ""
            
            if model.pace == "" || model.pace == nil{
                self.txtSpeed.text = "-"
            }
            
        }
        
        if model.duration != nil && model.duration != "" {
            self.txtDuration.text = model.duration
        }
        else {
//            let formattedString = NSMutableAttributedString()
//            formattedString.normal(oneDigitAfterDecimal(value: model.distance ?? 0.0)).normal12(" km", font: themeFont(size: 10, fontname: .ProximaNovaRegular))
////            normal12(" km")
//            self.txtDuration.attributedText = formattedString
            
            self.txtDuration.text = oneDigitAfterDecimal(value: model.distance ?? 0.0)
            
            if model.distance == 0.0 || model.distance == nil{
                self.txtDuration.text = "-"
            }
        }
        
        if self.activityName == "Run (Outdoor)".lowercased() || self.activityName == "Run (Indoor)".lowercased() {
            if model.percentage != nil{
                self.txtPercentage.text = self.oneDigitAfterDecimal(value: model.percentage ?? 0.0)
            }else{
                self.txtPercentage.text = "-"
            }
        }else{
            if model.watt != nil{
                self.txtPercentage.text = String(model.watt ?? 0) == "0" ? "-" : String(model.watt ?? 0)
            }else{
                self.txtPercentage.text = String(model.rpm ?? 0) == "0" ? "-" : String(model.rpm ?? 0)
            }
        }
        
        if self.activityName == "Cycling (Outdoor)".lowercased(){
            if model.percentage != nil{
                self.txtCyclingOutdoorPercentage.text = self.oneDigitAfterDecimal(value: model.percentage ?? 0.0)
            }else{
                self.txtCyclingOutdoorPercentage.text = "-"
            }
        }
        
        self.txtLvl.text = String(model.lvl ?? 0) == "0" ? "-" : String(model.lvl ?? 0)
        
//        self.txtRest.text = model.rest
        self.btnTimer.tag = self.tag
        
        if model.rest == "" || model.rest == nil{
            if (model.isCompleted ?? false) && (model.isCompletedRest == true){
                self.imgRest.image = UIImage(named: "ic_lap_completed")
                imageDesignChanges()
                
                self.vwCheckMark.isHidden = false
                
                if model.isCheckMarkAlreadyDone == true{
                    self.imgRest.alpha = 1
                    
//                    self.vwCheckMark.animationDuration = 0.0
//                    self.vwCheckMark.animateCircle()
                }else{
                    
                    self.imgRest.alpha = 0

                    self.vwCheckMark.removeAllAnimation()
                    self.vwCheckMark.animationDuration = 0.5
                    self.vwCheckMark.animateCircle()
                    model.isCheckMarkAlreadyDone = true
                }
                
//                self.vwCheckMark.removeAllAnimation()
//                self.vwCheckMark.animateCircle(duration: 0.5)
                
                self.txtRest.text = ""
            }else{
//                self.imgRest.image = UIImage(named: "ic_timer_empty")
                
                self.imgRest.alpha = 0
                self.vwCheckMark.isHidden = true

                self.txtRest.text = "--:--"
            }
        }else{
            if (model.isCompleted ?? false) && (model.isCompletedRest == true) {
                self.imgRest.image = UIImage(named: "ic_lap_completed")
                
                imageDesignChanges()
                self.vwCheckMark.isHidden = false
//                self.vwCheckMark.removeAllAnimation()

                if model.isCheckMarkAlreadyDone == true{
                    self.imgRest.alpha = 1

//                    self.vwCheckMark.animationDuration = 0.0
//                    self.vwCheckMark.animateCircle()
                }else{
                    self.imgRest.alpha = 0

                    self.vwCheckMark.removeAllAnimation()
                    self.vwCheckMark.animationDuration = 0.5
                    self.vwCheckMark.animateCircle()
                    model.isCheckMarkAlreadyDone = true
                }
                
                self.txtRest.text = ""
            }else{
//                self.imgRest.image = UIImage(named: "ic_timer_red")
                self.imgRest.alpha = 0
                self.vwCheckMark.isHidden = true
                
                self.txtRest.text = model.rest
            }
        }
        
        if index == self.tag && (model.startTime != "") && ((model.isCompleted == false || model.isCompleted == nil) || (model.isCompleted == true && (model.isCompletedRest == false || model.isCompletedRest == nil))){
//            self.imgRest.image = UIImage(named: "ic_timer")
            self.imgRest.alpha = 0
            self.vwCheckMark.isHidden = true

//            self.txtRest.text = model.rest
            
            if ((model.isCompleted == true && (model.isCompletedRest == false || model.isCompletedRest == nil))){
                
                btnTimer.addTarget(self, action: #selector(bntRestTapped), for: .touchUpInside)
                btnTimer.isUserInteractionEnabled = true
                
                self.vwProgressbar.trackColor = .white
                self.vwProgressbar.barColor = .white
                self.vwProgressbar.trackColor = .black
                
                if self.vwProgressbar.progress == 0.0 {
                    let mainRestValue = geHoursMinutesSecondsTOSecondsFormate(data: model.rest ?? "")
                    self.vwProgressbar.maximumValue = Float(mainRestValue.toFloat())
                    self.vwProgressbar.setProgress(Float(CGFloat(mainRestValue.toFloat())), animated: false)
                }
                
                timerCheckProgress(index:index,progressbarView: self.vwProgressbar,model: model,totalCount: totalCount)
                
            }else{
                btnTimer.isUserInteractionEnabled = false
                
                self.vwProgressbar.trackColor = .white
                self.vwProgressbar.barColor = .white
                
                if self.vwProgressbar.progress == 0.0 {
                    self.vwProgressbar.setProgress(Float(CGFloat(0.0)), animated: false)
                }

                timerCheckProgress(index:index,progressbarView: self.vwProgressbar,model: model,totalCount: totalCount)
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
        
//        self.imgRest.image = (model.rest ?? "") == "" || (model.rest ?? "") == "0" ? UIImage(named: "ic_timer") : UIImage(named: "ic_timer_red")

        self.txtSpeed.isUserInteractionEnabled = false
        self.txtPercentage.isUserInteractionEnabled = false
        self.txtDuration.isUserInteractionEnabled = false
        self.txtRest.isUserInteractionEnabled = false
        self.txtLvl.isUserInteractionEnabled = false
        
        self.changeHeaderAccordingToActivityName()
        
    //    self.showExerciseHeader()
    }
    
/*    func showExerciseHeader() {
        self.viewPercentage.isHidden = false
        if self.activityId == "1" {
//            self.leftViewPercentage.constant = 0
//            self.rightViewPercentage.constant = 0
        }
        else if self.activityId == "2" {
//            self.leftViewPercentage.constant = 0
//            self.rightViewPercentage.constant = 0
        }
        else if self.activityId == "3" {
            self.viewPercentage.isHidden = true
//            let width = (self.viewPercentage.bounds.width) / 2
//            self.leftViewPercentage.constant = -width
//            self.rightViewPercentage.constant = -width
        }
        else {
//            self.leftViewPercentage.constant = 0
//            self.rightViewPercentage.constant = 0
        }
    }*/
    
    //MARK: - Yash design changes
    
    func imageDesignChanges(){
//        UIView.animate(withDuration: 1.2, delay: 0, options: UIView.AnimationOptions.autoreverse, animations: { () -> Void in
//            self.imgRest.alpha = 1
//            //self.imgRest.isHidden = false
//             }, completion: { (Bool) -> Void in    }
//        )
    }
    
    func changeHeaderAccordingToActivityName(){
        
        self.vwLvl.isHidden = false
        self.viewPercentage.isHidden = false
        self.vwCyclingOutdoorPercentage.isHidden = true
        
        switch activityName {
            
        case "Run (Outdoor)".lowercased():
            self.vwLvl.isHidden = true
            self.vwStackView.spacing = 5
            
        case "Run (Indoor)".lowercased():
            self.vwLvl.isHidden = true
            self.vwStackView.spacing = 5
            
        case "Cycling (Indoor)".lowercased():
            self.vwLvl.isHidden = false
            self.vwStackView.spacing = -5

        case "Cycling (Outdoor)".lowercased():
            self.vwLvl.isHidden = true
            self.vwCyclingOutdoorPercentage.isHidden = false
            self.vwStackView.spacing = -5

        case "Swimming".lowercased():
            self.vwLvl.isHidden = true
            self.viewPercentage.isHidden = true
            self.vwStackView.spacing = 35
            
        case "Others".lowercased():
            self.vwLvl.isHidden = false
            self.vwStackView.spacing = -5
            
        default:
            self.vwLvl.isHidden = true
            self.vwStackView.spacing = 0

        }
        
    }
    
    @objc func bntRestTapped(sender:UIButton){
        print("Rest Clicked")
        if ((modelData?.isCompleted == true && (modelData?.isCompletedRest == false || modelData?.isCompletedRest == nil))){
            self.delegateOfRest?.currentWorkoutRestClick()
        }
    }
    
    func timerCheckProgress(index:Int,progressbarView:LinearProgressView,model: Exercise,totalCount:Int){
        
        self.modelData = model
        self.index = index
        self.totalCount = totalCount
        
//        if model.isPause == true{
//            return
//        }
        
        if ((model.isCompleted == true && (model.isCompletedRest == false || model.isCompletedRest == nil))){
            
            let mainRestValue = geHoursMinutesSecondsTOSecondsFormate(data: model.rest ?? "")
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
            
            if model.duration != nil && model.duration !=  "" {
                
                let mainDurationValue = geHoursMinutesSecondsTOSecondsFormate(data: model.duration ?? "")
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
                    if self.totalCount == self.index+1{
                        if model.rest == nil{
                            self.delegateOfRest?.finalLapWithNullRest()
                        }else{
                            self.delegateOfRest?.automaticallyCompleteLap(isRestNil: false)
                        }
                    }else{
                        
                        if model.rest == nil{
                            self.delegateOfRest?.automaticallyCompleteLap(isRestNil: true)
                        }else{
                            self.delegateOfRest?.automaticallyCompleteLap(isRestNil: false)
                        }
                    }
                    
                }else{
                    
                    timerofUpdateProgressbar =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callTimerMethod), userInfo: nil, repeats: true)
                }
                
            }
            else if model.distance != nil {
                
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
                
                let totalDistance = Float(CGFloat(model.distance ?? 0.0)) * 1000
                
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
                
                if coverdDistancePedoMeter > (CGFloat(totalDistance)){
                    if self.totalCount == self.index+1{
                        if model.rest == nil{
                            self.delegateOfRest?.finalLapWithNullRest()
                        }else{
                            self.delegateOfRest?.automaticallyCompleteLap(isRestNil: false)
                        }
                    }else{
                        if model.rest == nil{
                            self.delegateOfRest?.automaticallyCompleteLap(isRestNil: true)
                        }else{
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
        if modelData?.isPause == false{
            self.timerCheckProgress(index: self.index, progressbarView: self.vwProgressbar, model: modelData!, totalCount: self.totalCount)
        }
        
    }
    
    func findingDurationFromDistance(model:Exercise) -> Int{
        
        if model.speed != nil {
            
            guard let distance = model.distance else { return 0 }
            guard let speed = model.speed else { return 0}
            
            let duration = (distance/speed) * 60
            
            return getSecondsFromFloatValue(value: duration)
        }
        else if model.pace != nil || model.pace != ""{
            
            guard let distance = model.distance else { return 0 }
            guard let pace = model.pace else { return 0}

            let seconds = CGFloat(getSeconds(data: pace))
            
            let speed = (60*60) / seconds
            
            let durationInMin = (distance/speed)*60

            return getSecondsFromFloatValue(value: durationInMin)
        }
        
        return 0
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

    func getSecondsFromFloatValue(value:CGFloat) -> Int{
        
        let stringValue = "\(value)"
        print("stringValue : \(stringValue)")
        
        let dataArray = stringValue.split(separator: ".")

        let sHr = (Double(dataArray[0] ) ?? 0) * 60
        let sMin = (Double("0.\(dataArray[1] )") ?? 0) * 60
        
        let TotalNumber = Int(sHr) + Int(sMin)
        print("TotalNumber : \(TotalNumber)")
        
        return TotalNumber

    }
}
