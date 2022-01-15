//
//  ExerciseResistancePreviewCell.swift
//  Load
//
//  Created by Haresh Bhai on 08/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

protocol ResistancePreviewCellDelegate {
    func getTextFieldRowSection(section:Int, row:Int, isTextFieldReps: Bool)
    func automaticallyCompleteLap(section:Int, row: Int)
    func automaticallyCompletdRestSet(section:Int, row: Int)
    func particularSetRepeat(section:Int, row: Int)
}

import UIKit

class ExerciseResistancePreviewCell: UITableViewCell {

    //MARK: - Outlet
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtReps: UITextField!
    @IBOutlet weak var txtRest: UITextField!
    
    @IBOutlet weak var vwCheckMark: checkmarkAnimation!
    @IBOutlet weak var btnRest: UIButton!
    @IBOutlet weak var vwUnderLine: UIView!
    @IBOutlet weak var imgRest: UIImageView!
    @IBOutlet weak var vwProgressbar: LinearProgressView!
    @IBOutlet weak var vwReps: UIView!
    @IBOutlet weak var vwRest: UIView!
    
    var sectionIndex:Int = 0
    
    var workingSection = 0
    var workingRowIndex = 0
    var allExerciseArray: [ExerciseResistance]?
    
    var gradientColor = UIColor()
    var timerofUpdateProgressbar: Timer?

    var delegateResistancePreviewCell: ResistancePreviewCellDelegate?
    
    //MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.setupFont()
        self.txtWeight.isUserInteractionEnabled = false
        
        self.txtReps.delegate = self
        self.txtRest.delegate = self
        
        self.txtWeight.setColor(color: .appthemeBlackColor)
        self.txtReps.setColor(color: .appthemeBlackColor)
        self.txtRest.setColor(color: .appthemeBlackColor)
        
        vwProgressbar.isCornersRounded = false

    }
    
    func setupFont() {
        self.txtWeight.font = themeFont(size: 22, fontname: .ProximaNovaRegular)
        self.txtReps.font = themeFont(size: 22, fontname: .ProximaNovaRegular)
        self.txtRest.font = themeFont(size: 22, fontname: .ProximaNovaRegular)
        
        gradientColor = self.drawGradientColor(colors: [UIColor(red: 116/255, green: 48/255, blue: 153/255, alpha: 1).cgColor,UIColor(red: 199/255, green: 50/255, blue: 50/255, alpha: 0.88).cgColor]) ?? UIColor.red

    }
    
    func setDetails(model: DataExercise) {
        self.txtWeight.text = model.weight
        self.txtReps.text = model.reps == nil || model.reps == "" ? model.duration : model.reps
        self.txtRest.text = model.rest
        
        if model.isCompleted == true && model.isCompletedRest == true{
            self.btnRest.isUserInteractionEnabled = true
        }else{
            self.btnRest.isUserInteractionEnabled = false
        }
        
        //set for text color

        //set condfitin only for index 0 and section 0 for repeatTime other thing is same
        if sectionIndex == 0 && self.txtReps.tag == 0{
            
            if model.isCompleted ?? false || model.repeatTime != "" {
                if model.reps == nil || model.reps == ""{
                    self.txtReps.textColor = .black
                    self.txtReps.isUserInteractionEnabled = false
                }else{
                    self.txtReps.textColor = .black
                    self.txtReps.isUserInteractionEnabled = false
                }
            }else{
                if model.reps == nil || model.reps == ""{
                    self.txtReps.textColor = .appthemeOffRedColor
                    self.txtRest.textColor = .black
                    
                    self.txtReps.isUserInteractionEnabled = true
                    self.txtRest.isUserInteractionEnabled = false
                }else{
                    self.txtReps.textColor = .black
                    self.txtRest.textColor = .black
                    
                    self.txtReps.isUserInteractionEnabled = false
                    self.txtRest.isUserInteractionEnabled = false
                }
            }
            
        }else{
            if model.isCompleted ?? false || model.startTime != "" {
                if model.reps == nil || model.reps == ""{
                    self.txtReps.textColor = .black
                    self.txtReps.isUserInteractionEnabled = false
                }else{
                    self.txtReps.textColor = .black
                    self.txtReps.isUserInteractionEnabled = false
                }
            }else{
                if model.reps == nil || model.reps == ""{
                    self.txtReps.textColor = .appthemeOffRedColor
                    self.txtRest.textColor = .black
                    
                    self.txtReps.isUserInteractionEnabled = true
                    self.txtRest.isUserInteractionEnabled = false
                }else{
                    self.txtReps.textColor = .black
                    self.txtRest.textColor = .black
                    
                    self.txtReps.isUserInteractionEnabled = false
                    self.txtRest.isUserInteractionEnabled = false
                }
            }

        }
        
        if !(model.reps == nil || model.reps == ""){
            if model.isCompleted ?? false{
                self.txtRest.textColor = .black
                self.txtRest.isUserInteractionEnabled = false
            }else{
                self.txtRest.textColor = .appthemeOffRedColor
                self.txtRest.isUserInteractionEnabled = true
            }
        }else{
            if model.isCompleted ?? false{
                self.txtRest.textColor = .black
                self.txtRest.isUserInteractionEnabled = false
            }
        }
        
//        let image = model.isCompleted == true ? "ic_round_check_box_select" : "ic_round_check_box_unselect"
//        self.btnStart.setImage(UIImage(named: image), for: .normal)
        
        if model.rest == "" || model.rest == nil{
            if (model.isCompleted ?? false) && (model.isCompletedRest == true){
                self.imgRest.image = UIImage(named: "ic_lap_completed")
                
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
        
        //Timer related changes and conditions
        
        if let dataModel = allExerciseArray?[workingSection].data?[workingRowIndex]{
            
            if dataModel.isCurrentLapWorking == false{
                return
            }
            
            if workingSection == self.sectionIndex && workingRowIndex == self.txtReps.tag && ((dataModel.isCompleted == false || dataModel.isCompleted == nil) || (dataModel.isCompleted == true && (dataModel.isCompletedRest == false || dataModel.isCompletedRest == nil))) && dataModel.isCurrentLapWorking == true{
                
                if self.sectionIndex == 0 && self.txtReps.tag == 0{
                    if dataModel.repeatTime == "" || dataModel.repeatTime == nil{
                        return
                    }
                }else{
                    if dataModel.startTime == "" || dataModel.startTime == nil{
                        return
                    }
                }
                
                
    //            self.imgRest.image = UIImage(named: "ic_timer")
                self.imgRest.alpha = 0
                self.vwCheckMark.isHidden = true

                print("workingSection:\(workingSection) WorkingRowIndex:\(workingRowIndex)")

    //            self.txtRest.text = model.rest
                
                if ((dataModel.isCompleted == true && (dataModel.isCompletedRest == false || dataModel.isCompletedRest == nil))){
                    
                    self.vwProgressbar.trackColor = .white
                    self.vwProgressbar.barColor = .white
                    self.vwProgressbar.trackColor = .black
                    
                    print("Progress Value:\(self.vwProgressbar.progress)")
                    
                    if self.vwProgressbar.progress == 0.0 {
                        let mainRestValue = geHoursMinutesSecondsTOSecondsFormate(data: model.rest ?? "")
                        self.vwProgressbar.maximumValue = Float(mainRestValue.toFloat())
                        self.vwProgressbar.setProgress(Float(CGFloat(mainRestValue.toFloat())), animated: false)
                    }
                    
                    timerCheckProgress(progressbarView: self.vwProgressbar,model: dataModel, section: workingSection, row: workingRowIndex)
                    
                }else{
                    
                    self.vwProgressbar.trackColor = .white
                    self.vwProgressbar.barColor = .white
                    
                    if self.vwProgressbar.progress == 0.0 {
                        self.vwProgressbar.setProgress(Float(CGFloat(0.0)), animated: false)
                    }

                    timerCheckProgress(progressbarView: self.vwProgressbar,model: dataModel, section: workingSection, row: workingRowIndex)
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

    }
    
    @IBAction func btnRestTapped(_ sender: UIButton) {
        
        if let modelData = allExerciseArray?[sectionIndex].data?[sender.tag]{
         
            if modelData.isCompleted == true && modelData.isCompletedRest == true{
                self.delegateResistancePreviewCell?.particularSetRepeat(section: sectionIndex, row: sender.tag)
            }
        }
    }
    
    func timerCheckProgress(progressbarView:LinearProgressView,model: DataExercise, section: Int, row: Int){
        
        if ((model.isCompleted == true && (model.isCompletedRest == false || model.isCompletedRest == nil))){
            
            let mainRestValue = geHoursMinutesSecondsTOSecondsFormate(data: model.rest ?? "")
//            let startTime = Date().secondDifference(to: model.addedRestTime.convertDateFormater())
            
            var startTime = 0
            
            if model.isPause == true{
                startTime = model.pauseTime.convertDateFormater().secondDifference(to: model.addedRestTime.convertDateFormater())
            }else{
                startTime = Date().secondDifference(to: model.addedRestTime.convertDateFormater())
            }
            
            print("addedRest Time:\(model.addedRestTime)")
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
            
            if startTime <= 0{
                //TODO: - Yash (24/02)
                self.delegateResistancePreviewCell?.automaticallyCompletdRestSet(section: section, row: row)
            }else{
                
                timerofUpdateProgressbar =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callTimerMethod), userInfo: model, repeats: true)
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
                
                if self.workingSection == 0 && self.workingRowIndex == 0{
                    
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
                    
                    if allExerciseArray?[workingSection].data?.count == self.workingRowIndex+1{
                        if model.rest == nil{
                            //TODO: - Yash (24/02)
                            // No chances of Rest nil
//                            self.delegateOfRest?.finalLapWithNullRest()
                        }else{
                            //TODO: - Yash (24/02)
                            self.delegateResistancePreviewCell?.automaticallyCompleteLap(section: section, row: row)
                        }
                    }else{
                        //TODO: - Yash (24/02)
                        self.delegateResistancePreviewCell?.automaticallyCompleteLap(section: section, row: row)
                    }
                    
                }else{
                    
                    timerofUpdateProgressbar =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callTimerMethod), userInfo: model, repeats: true)
                }
                
            }
            /*else if model.distance != nil {
                
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
                            self.delegateOfRest?.automaticallyCompleteLap()
                        }
                    }else{
                        self.delegateOfRest?.automaticallyCompleteLap()
                    }
                    
                }else{
                    
                    timerofUpdateProgressbar =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(callTimerMethod), userInfo: nil, repeats: true)
                }
                
            }*/
            
        }
        
    }
    
    @objc func callTimerMethod(timer:Timer){
        
        if let modelData = timer.userInfo as? DataExercise{
            if modelData.isPause == false{
                self.timerCheckProgress(progressbarView: self.vwProgressbar, model: modelData, section: self.workingSection, row: self.workingRowIndex)
            }
        }
    }
}

//MARK: - textField delegate

extension ExerciseResistancePreviewCell: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtReps{
            
            self.delegateResistancePreviewCell?.getTextFieldRowSection(section: self.sectionIndex, row: textField.tag, isTextFieldReps: true)
            return false
            
        }else if textField == txtRest{
            
            self.delegateResistancePreviewCell?.getTextFieldRowSection(section: self.sectionIndex, row: textField.tag, isTextFieldReps: false)
            return false
            
        }
        
        return false
    }
    
}
