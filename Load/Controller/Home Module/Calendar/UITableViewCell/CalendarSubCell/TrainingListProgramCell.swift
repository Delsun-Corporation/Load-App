//
//  TrainingListCell.swift
//  Load
//
//  Created by Haresh Bhai on 31/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class TrainingListProgramCell: UITableViewCell {

    @IBOutlet weak var vwMain: CustomView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblTimeStart: UILabel!
    @IBOutlet weak var lblTotalDurationAndDistance: UILabel!
    @IBOutlet weak var vwActivityIconAndTime: CustomView!
    
    @IBOutlet weak var lblIntencity: UILabel!
    @IBOutlet weak var lblGoalName: UILabel!
    
    @IBOutlet weak var vwPhase1: UIView!
    @IBOutlet weak var vwPhase1Round: CustomView!
    @IBOutlet weak var lblPhase1: UILabel!
    
    @IBOutlet weak var vwPhase2: UIView!
    @IBOutlet weak var vwPhase2Round: CustomView!
    @IBOutlet weak var lblPhase2: UILabel!
    
    @IBOutlet weak var btnPlay: UIButton!

    var isTrainingLog:Bool = true
    weak var delegate:TrainingListDelegate?
    var trainingId:String = ""
    var weekdayWiseMainIDForProgram = ""
    var isCompleted = false

    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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

    
    func setupUIForBlankData() {
        
        lblName.text = ""
        lblTimeStart.text = ""
        lblTotalDurationAndDistance.text = ""
        lblIntencity.text = ""
        lblGoalName.text = ""
        lblPhase1.text = ""
        lblPhase2.text = ""
        vwPhase1Round.backgroundColor = .white
        vwPhase2Round.backgroundColor = .white
        self.isUserInteractionEnabled = false
    }
    
    func setupUIProgram(model: TrainingProgramModel?) {
        
        self.isUserInteractionEnabled = true
        
        self.trainingId = model?.programDetail?.id?.stringValue ?? ""
        self.weekdayWiseMainIDForProgram = model?.id?.stringValue ?? ""
        self.isCompleted = model?.isComplete ?? false
        self.isTrainingLog = false
        self.setupFont()
        
        self.imgIcon.image = TRAINING_LOG_STATUS.CARDIO.rawValue == (model?.programDetail?.status ?? "") ? UIImage(named: "ic_like_pink_color") : UIImage(named: "ic_gym_icon_select")
        
        if TRAINING_LOG_STATUS.CARDIO.rawValue == (model?.programDetail?.status ?? ""){
            vwPhase2.isHidden = true
        }else{
            //below line is commnet because till now it's not completed
//            vwPhase2.isHidden = false
            vwPhase2.isHidden = true
        }
        
        self.changeColorAccordingToPhase(name: model?.weekWiseWorkoutDetail?.phaseName ?? "")
        
        var rest: Double = 0.0
        
        for data in model?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails ?? [] {
            rest += self.calculateDurationArray(data: data.rest)
        }
        
        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(rest))
        self.lblTimeStart.text = self.makeTimeStringForRest(h: h, m: m, s: s)

        if model?.isComplete == false{
            self.imgIcon.setImageColor(color: .white)
            self.lblTimeStart.textColor = UIColor.white
            self.vwActivityIconAndTime.backgroundColor = UIColor.appthemeOffRedColor
            self.vwActivityIconAndTime.borderColors = UIColor.appthemeOffRedColor
            self.vwActivityIconAndTime.borderWidth = 1
            self.vwMain.borderColors = UIColor.appthemeOffRedColor
            self.vwMain.borderWidth = 1
            self.lblName.textColor = UIColor.appthemeOffRedColor
            self.lblTotalDurationAndDistance.textColor = UIColor.appthemeOffRedColor
            
            if model?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[0].distance != nil && model?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[0].distance != ""{
                
                self.setDistanceInRange(model: model)
                
            } else {
                self.setDurationInRange(model: model)
            }
            
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
            
            self.lblPhase1.textColor = UIColor.appthemeBlackColor
            self.vwPhase1Round.backgroundColor = UIColor.appthemeBlackColor
            
            if model?.exercise?[0].updatedDuration != "" && model?.exercise?[0].updatedDuration != nil{
                self.lblTotalDurationAndDistance.text = model?.generatedCalculations?.totalDuration
            } else {
                self.lblTotalDurationAndDistance.text = oneDigitAfterDecimal(value: model?.generatedCalculations?.totalDistance ?? 0) + " " + (model?.generatedCalculations?.totalDistanceUnit ?? "")
            }

        }
        
        self.lblName.text = model?.weekWiseWorkoutDetail?.name ?? ""
        self.lblIntencity.text = getIntensityName(id: model?.weekWiseWorkoutDetail?.trainingIntensityId ?? 0) + " " + getCommonString(key: "Intensity_key")
        self.lblGoalName.text = getTrainingGoalName(id: model?.weekWiseWorkoutDetail?.trainingGoalId ?? 0)
        
    }
    
    func setDistanceInRange(model: TrainingProgramModel?) {
        
        var isDashValueAvailable = false
        /*
        let array = model?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?.map({ (data) -> String in
            return (data.distance ?? "")
        })
        print("array:\(array)")
        
        if array?.contains("-") ?? false{
            isDashValueAvailable = true
        }else{
            isDashValueAvailable = false
        }
        */
        
        let arrayValue = model?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?.filter({ (data) -> Bool in
            return (data.distance?.contains("-") ?? false)
        })
        
        if arrayValue?.count == 0{
            isDashValueAvailable = false
        }else {
            isDashValueAvailable = true
        }
        
        var distanceLower : CGFloat = 0.0
        var distanceUpper : CGFloat = 0.0
        
        var singleValue: CGFloat = 0.0

        for data in model?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails ?? [] {

            if data.distance?.contains("-") ?? false{
                
                let distance = data.distance?.replacingOccurrences(of: "km", with: "")
                
                if let array = distance?.split(separator: "-"){
                    
                    if array.count == 2{
                        
                        let firstData = "\(array[0])".toFloat()
                        distanceLower += firstData
                        
                        let secondData = "\(array[1])".toFloat()
                        distanceUpper += secondData
                        
                        self.lblTotalDurationAndDistance.text = "\(oneDigitAfterDecimal(value: distanceLower)) - \(oneDigitAfterDecimal(value: distanceUpper)) km"
                        
                    }
                    
                }
                
            } else {
                
                let value = data.distance?.replacingOccurrences(of: "km", with: "").toFloat() ?? 0.0
                singleValue += value
                
                if isDashValueAvailable {
//                    distanceLower += singleValue
//                    distanceUpper += singleValue
                    
                    distanceLower += value
                    distanceUpper += value
                    
                    self.lblTotalDurationAndDistance.text = "\(oneDigitAfterDecimal(value: distanceLower)) - \(oneDigitAfterDecimal(value: distanceUpper)) km"
                    
                } else {
                    self.lblTotalDurationAndDistance.text = oneDigitAfterDecimal(value: singleValue) + " " + "km"
                }
                
            }
            
        }
        
    }
    
    
    func setDurationInRange(model: TrainingProgramModel?) {
        
        var isDashValueAvailable = false
        
        let arrayValue = model?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?.filter({ (data) -> Bool in
            return ((data.duration?.contains("-") ?? false) || (data.rest?.contains("-") ?? false))
        })
        
        if arrayValue?.count == 0{
            isDashValueAvailable = false
        }else {
            isDashValueAvailable = true
        }
        
        var durationLower  = 0.0
        var durationUpper = 0.0
        
        var singleDurationValue = 0.0

        for data in model?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails ?? [] {
            
            if data.duration?.contains("-") ?? false{
                
                if let array = data.duration?.split(separator: "-"){
                    
                    if array.count == 2{
                        
                        let firstDuration = calculateDurationArray(data: "\(array[0])")
                        let secondDuration = calculateDurationArray(data: "\(array[1])")
                        
                        durationLower += firstDuration
                        durationUpper += secondDuration
                        
                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(durationLower))
                        let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: Int(durationUpper))

                        
                        self.lblTotalDurationAndDistance.text = makeTimeString(h: h, m: m, s: s) + " - " + makeTimeString(h: h1, m: m1, s: s1)
                        
                    }
                    
                }
                
            } else {
                let duration = calculateDurationArray(data: data.duration)
                
                if isDashValueAvailable {
                    durationLower += duration
                    durationUpper += duration
                    
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(durationLower))
                    let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: Int(durationUpper))

                    
                    self.lblTotalDurationAndDistance.text = makeTimeString(h: h, m: m, s: s) + " - " + makeTimeString(h: h1, m: m1, s: s1)

                } else {
                    singleDurationValue += duration
                    
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(singleDurationValue))
                    self.lblTotalDurationAndDistance.text = makeTimeString(h: h, m: m, s: s)

                }
            }
            
            //For rest
            
            if data.rest?.contains("-") ?? false{
                
                if let array = data.rest?.split(separator: "-"){
                    
                    if array.count == 2{
                        
                        let firstRest = calculateDurationArray(data: "\(array[0])")
                        let secondRest = calculateDurationArray(data: "\(array[1])")
                        
                        durationLower += firstRest
                        durationUpper += secondRest
                        
                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(durationLower))
                        let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: Int(durationUpper))

                        self.lblTotalDurationAndDistance.text = makeTimeString(h: h, m: m, s: s) + " - " + makeTimeString(h: h1, m: m1, s: s1)
                        
                    }
                    
                }
                
            } else {
                let rest = calculateDurationArray(data: data.rest)
                
                if isDashValueAvailable {
                    durationLower += rest
                    durationUpper += rest
                    
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(durationLower))
                    let (h1, m1, s1) = secondsToHoursMinutesSeconds(seconds: Int(durationUpper))

                    
                    self.lblTotalDurationAndDistance.text = makeTimeString(h: h, m: m, s: s) + " - " + makeTimeString(h: h1, m: m1, s: s1)

                } else {
                    singleDurationValue += rest
                    
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(singleDurationValue))
                    self.lblTotalDurationAndDistance.text = makeTimeString(h: h, m: m, s: s)

                }
            }
        }
        
    }
    
    
    func getTimeName(h: Int, m:Int, s:Int) -> String {
        if h != 0 {
            return "hr"
        }
        else if h != 0 {
            return "min"
        }
        else {
            return "sec"
        }
    }
    
    func setupFont() {
        
        self.lblTimeStart.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        
        self.lblName.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        
        self.lblGoalName.textColor = UIColor.appthemeBlackColor
        self.lblGoalName.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        
        self.lblIntencity.textColor = UIColor.appthemeBlackColor
        self.lblIntencity.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        
        self.lblTotalDurationAndDistance.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        
        [self.lblPhase1,self.lblPhase2].forEach { (lbl) in
            lbl?.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        }
        
        [self.vwPhase1Round,self.vwPhase2Round].forEach { (vw) in
            vw?.shadowColors = .clear
            vw?.cornerRadius = 5
            vw?.borderWidth = 1
            vw?.borderColors = UIColor.appthemeBlackColor
        }
        
    }

    func calculateDistanceArray(data:String?) -> Double {
        var total: Double = 0
        let dataArray = data?.split(separator: "-")
        if dataArray?.count == 2 {
            let second = dataArray?[1].replacingOccurrences(of: "km", with: "").toTrim()
            let secondDouble = (Double(second ?? "0") ?? 0)
            total = secondDouble.rounded(toPlaces: 2)
        }
        else if dataArray?.count == 1 {
            let first = dataArray?.first?.replacingOccurrences(of: "km", with: "").toTrim()
            let firstDouble = (Double(first ?? "0") ?? 0)
            total = firstDouble.rounded(toPlaces: 2)
        }
        return total
    }
    
    func calculateDurationArray(data:String?) -> Double {
        var total: Double = 0
        let dataArray = data?.split(separator: "-")
        if dataArray?.count == 2 {
//            let firstArray = dataArray?.first?.split(separator: ":")
            let secondArray = dataArray?[1].split(separator: ":")
//            let fHr = (Double(firstArray?[0] ?? "0") ?? 0) * 60 * 60
//            let fMin = (Double(firstArray?[1] ?? "0") ?? 0) * 60
//            let fSec = (Double(firstArray?[2] ?? "0") ?? 0)
            
            var sHr = 0.0
            var sMin = 0.0
            var sSec = 0.0
            
            if secondArray?.count == 3{
                sHr = (Double(secondArray?[0] ?? "0") ?? 0) * 60 * 60
                sMin = (Double(secondArray?[1] ?? "0") ?? 0) * 60
                sSec = (Double(secondArray?[2] ?? "0") ?? 0)
            }
            else if secondArray?.count == 2 {
                sMin = (Double(secondArray?[0] ?? "0") ?? 0) * 60
                sSec = (Double(secondArray?[1] ?? "0") ?? 0)
            }
            
//            let firstCount = fHr + fMin + fSec
            let secondCount = sHr + sMin + sSec
            
//            total = firstCount + secondCount
            total = secondCount
            print(total)
        }
        else if dataArray?.count == 1 {
            let firstArray = dataArray?.first?.split(separator: ":")
            
            var fHr = 0.0
            var fMin = 0.0
            var fSec = 0.0
            
            if firstArray?.count == 3 {
                fHr = (Double(firstArray?[0] ?? "0") ?? 0) * 60 * 60
                fMin = (Double(firstArray?[1] ?? "0") ?? 0) * 60
                fSec = (Double(firstArray?[2] ?? "0") ?? 0)

            }else if firstArray?.count == 2 {
                fMin = (Double(firstArray?[0] ?? "0") ?? 0) * 60
                fSec = (Double(firstArray?[1] ?? "0") ?? 0)
            }
            
            total = fHr + fMin + fSec
            print(total)
        }
        return total
    }
    
    @IBAction func btnPlayClicked(_ sender: UIButton) {
//        print(self.isTrainingLog)
//        print(sender.tag)
        self.delegate?.TrainingListFinish(isTrainingLog: false, tag: self.tag, trainingId: self.trainingId , weekdayWiseMainIDForProgram: self.weekdayWiseMainIDForProgram,isCompleted: self.isCompleted)
    }
    
    func changeColorAccordingToPhase(name: String){
        
        self.lblPhase1.text = name
        self.vwPhase1Round.borderWidth = 0
        
        switch name.lowercased() {
        case getCommonString(key: "Recovery_Phase_key").lowercased() :
            print("phase:\(getCommonString(key: "Recovery_Phase_key"))")
            
            self.lblPhase1.textColor = UIColor(red: 0, green: 189/255, blue: 156/250, alpha: 1.0)
            self.vwPhase1Round.backgroundColor = UIColor(red: 0, green: 189/255, blue: 156/250, alpha: 1.0)
            
            
        case getCommonString(key: "General_Conditioning_Phase_key").lowercased() :
            print("phase:\(getCommonString(key: "General_Conditioning_Phase_key"))")
            
            self.lblPhase1.textColor = UIColor(red: 46/255, green: 151/255, blue: 222/250, alpha: 1.0)
            self.vwPhase1Round.backgroundColor = UIColor(red: 46/255, green: 151/255, blue: 222/250, alpha: 1.0)
            
        case getCommonString(key: "Specific_Conditioning_Phase_key").lowercased() :
            print("phase:\(getCommonString(key: "Specific_Conditioning_Phase_key"))")
            
            self.lblPhase1.textColor = UIColor(red: 126/255, green: 89/255, blue: 176/250, alpha: 1.0)
            self.vwPhase1Round.backgroundColor = UIColor(red: 126/255, green: 89/255, blue: 176/250, alpha: 1.0)
            
        case getCommonString(key: "Maintenance_Phase_key").lowercased() :
            print("phase:\(getCommonString(key: "Maintenance_Phase_key"))")
            
            self.lblPhase1.textColor = UIColor(red: 232/255, green: 127/255, blue: 4/250, alpha: 1.0)
            self.vwPhase1Round.backgroundColor = UIColor(red: 232/255, green: 127/255, blue: 4/250, alpha: 1.0)
            
        case getCommonString(key: "Peaking_Phase_key").lowercased() :
            print("phase:\(getCommonString(key: "Peaking_Phase_key"))")
            
            self.lblPhase1.textColor = UIColor.appthemeOffRedColor
            self.vwPhase1Round.backgroundColor = UIColor.appthemeOffRedColor
            
        default:
            print("Default")
        }
        
    }
    
}
