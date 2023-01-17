//
//  TrainingListCell.swift
//  Load
//
//  Created by Haresh Bhai on 31/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
protocol TrainingListDelegate: class {
    func TrainingListFinish(isTrainingLog: Bool, tag:Int, trainingId:String, weekdayWiseMainIDForProgram: String, isCompleted: Bool?)
}

class TrainingListCell: UITableViewCell {

    @IBOutlet weak var vwMain: CustomView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblTotalDurationAndDistance: UILabel!
    @IBOutlet weak var vwActivityIconAndTime: CustomView!
    
    @IBOutlet weak var lblIntencity: UILabel!
    @IBOutlet weak var lblGoalName: UILabel!
    
    @IBOutlet weak var vwPhase1Round: CustomView!
    @IBOutlet weak var lblPhaseUnavailable: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    
    var isTrainingLog:Bool = true
    weak var delegate:TrainingListDelegate?
    var trainingId:String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(model: TrainingLogList) {
        
        self.trainingId = model.id ?? ""
        self.isTrainingLog = true
        self.setupFont()
        
        if TRAINING_LOG_STATUS.CARDIO.rawValue == model.status{
            let activityName = model.trainingActivity?.name?.lowercased() ?? ""
            
            if (activityName == "Run (Outdoor)".lowercased()) || (activityName == "Run (Indoor)".lowercased()){
                self.imgIcon.image = UIImage(named: "run_white_image_summary")
            }
            else if (activityName == "Cycling (Indoor)".lowercased()) || (activityName == "Cycling (Outdoor)".lowercased()){
                self.imgIcon.image = UIImage(named: "cycle_white_image_summary")
            }
            else if activityName == "Swimming".lowercased(){
                self.imgIcon.image = UIImage(named: "swimming_white_image_summary")
            }
            else{
                self.imgIcon.image = UIImage(named: "others_white_image_summary")
            }
            
        }else{
            self.imgIcon.image = UIImage(named: "ic_resistance_white")
        }
        
        if model.isComplete == 0{
            self.imgIcon.setImageColor(color: .white)
            self.lblTimeStart.textColor = UIColor.white
            self.vwActivityIconAndTime.backgroundColor = UIColor.appthemeOffRedColor
            self.vwActivityIconAndTime.borderColors = UIColor.appthemeOffRedColor
            self.vwActivityIconAndTime.borderWidth = 1
            self.vwMain.borderColors = UIColor.appthemeOffRedColor
            self.vwMain.borderWidth = 1
            self.lblName.textColor = UIColor.appthemeOffRedColor
            self.lblTotalDurationAndDistance.textColor = UIColor.appthemeOffRedColor

        }else{
            self.imgIcon.setImageColor(color: .appthemeBlackColor)
            self.lblTimeStart.textColor = UIColor.appthemeBlackColor
            self.vwActivityIconAndTime.backgroundColor = UIColor(red: 234/255, green: 233/255, blue: 234/255, alpha: 1)
            self.vwActivityIconAndTime.borderColors = UIColor(red: 234/255, green: 233/255, blue: 234/255, alpha: 1)
            self.vwActivityIconAndTime.borderWidth = 1
            self.vwMain.borderColors = UIColor(red: 234/255, green: 233/255, blue: 234/255, alpha: 1)
            self.vwMain.borderWidth = 1
            
            self.lblName.textColor = UIColor.appthemeBlackColor
            self.lblTotalDurationAndDistance.textColor = UIColor.appthemeBlackColor
        }
        
        self.lblName.text = model.workoutName
        self.lblIntencity.text = (model.trainingIntensity?.name ?? "") + " " + getCommonString(key: "Intensity_key")
        self.lblTimeStart.text = convertDateFormater(model.date ?? "", format: "yyyy-MM-dd HH:mm:ss",  dateFormat: "HH:mm")
        
        let trainigGoalCustom = model.trainingGoalCustom
        self.lblGoalName.text = (model.trainingGoal?.name ?? "") == "" ? trainigGoalCustom : model.trainingGoal?.name
        
        if TRAINING_LOG_STATUS.CARDIO.rawValue == model.status {
            
            if model.isComplete == 0 {
                var distance: CGFloat = 0.0
                var time = 0
                
                for data in model.exercise ?? [] {
                    
                    if data.duration != nil && data.duration != ""{
                        time += Int(getSeconds(data: data.duration))
                    }else{
                        distance += data.distance ?? 0.0
                    }
                }
                
                if model.exercise?[0].duration != nil && model.exercise?[0].duration != ""{
                    
                    let hour = secondsToHoursMinutesSeconds(seconds: time).0
                    let minute = secondsToHoursMinutesSeconds(seconds: time).1
                    let second = secondsToHoursMinutesSeconds(seconds: time).2
                    
                    self.lblTotalDurationAndDistance.text = "\(hour)h \(minute)m \(second)s"
                }else{
                    self.lblTotalDurationAndDistance.text = "\(oneDigitAfterDecimal(value: distance)) km"
                }

            } else {
                
                if model.exercise?[0].duration != nil && model.exercise?[0].duration != ""{
                    
                    let time = Int(getSeconds(data: model.generatedCalculations?.totalDuration))
                    
                    let hour = secondsToHoursMinutesSeconds(seconds: time).0
                    let minute = secondsToHoursMinutesSeconds(seconds: time).1
                    let second = secondsToHoursMinutesSeconds(seconds: time).2
                    
                    self.lblTotalDurationAndDistance.text = "\(hour)h \(minute)m \(second)s"
                    
                }else {
                    self.lblTotalDurationAndDistance.text = "\(oneDigitAfterDecimal(value: model.generatedCalculations?.totalDistance ?? 0.0)) km"
                }
            }
            
        }
        else {
            
            if model.isComplete == 0{
                self.lblTotalDurationAndDistance.text = "\(model.targetedVolume )".replace(target: ".0", withString: "") + " " + "\(model.targetedVolumeUnit)"
            }else{
                self.lblTotalDurationAndDistance.text = "\(model.completedVolume )".replace(target: ".0", withString: "") + " " + "\(model.completedVolumeUnit)"
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
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
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
        
        if h == 0 && m == 0 && s != 0 {
            str = "00:" + str
        }
        
        return str
    }
    
    func setupUIProgram(model: TrainingProgramList) {
        self.trainingId = model.id?.stringValue ?? ""
        self.isTrainingLog = false
        self.setupFont()
        self.imgIcon.image = TRAINING_LOG_STATUS.CARDIO.rawValue == model.status ? UIImage(named: "ic_like_pink_color") : UIImage(named: "ic_gym_pink_color")
        self.lblName.text = model.presetTrainingProgram?.title
        self.lblIntencity.text = ""//model.trainingIntensity?.name
        self.lblTimeStart.text = ""
        
        self.lblGoalName.isHidden = true
    }
    
    func setupFont() {
        
        self.lblTimeStart.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        
        self.lblName.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        
        self.lblGoalName.textColor = UIColor.appthemeBlackColor
        self.lblGoalName.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        
        self.lblIntencity.textColor = UIColor.appthemeBlackColor
        self.lblIntencity.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        
        self.lblTotalDurationAndDistance.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        
        self.lblPhaseUnavailable.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lblPhaseUnavailable.text = getCommonString(key: "Phase_unavailable_key")
        
        self.vwPhase1Round.shadowColors = .white
        self.vwPhase1Round.cornerRadius = 5
        self.vwPhase1Round.borderWidth = 1
        self.vwPhase1Round.borderColors = UIColor.appthemeBlackColor
        
    }
    
    @IBAction func btnPlayClicked(_ sender: UIButton) {
//        print(self.isTrainingLog)
//        print(sender.tag)
        self.delegate?.TrainingListFinish(isTrainingLog: self.isTrainingLog, tag: self.tag, trainingId: self.trainingId, weekdayWiseMainIDForProgram: "", isCompleted: nil)
    }    
}
