//
//  ExerciseCardioCell.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ExerciseCardioCellDelegate: class {
    func ExerciseCardioCellFinish(index:Int, Laps:String, Speed:String, Pace:String, Percentage:String, Duration:String, Distance:String, Rest:String, Lvl:String, RPM: String, Watt: String)
    func RemoveRowClicked(tag:Int)
}

class ExerciseCardioCell: UITableViewCell, UITextFieldDelegate {
    
    //    @IBOutlet weak var txtLaps: UITextField!
    @IBOutlet weak var txtSpeed: UITextField!
    @IBOutlet weak var txtPercentage: UITextField!
    @IBOutlet weak var txtDuration: UITextField!
    @IBOutlet weak var txtRest: UITextField!
    
    @IBOutlet weak var viewPercentage: UIView!
    @IBOutlet weak var vwLvl: UIView!
    @IBOutlet weak var txtLvl: UITextField!
    
    @IBOutlet weak var btnRemove: UIButton!
    
    weak var delegate: ExerciseCardioCellDelegate?
    
    let durationPickerView = UIPickerView()
    let distancePickerView = UIPickerView()
    let speedPickerView = UIPickerView()
    let pacePickerView = UIPickerView()
    let percentagePickerView = UIPickerView()
    let RPMPickerView = UIPickerView()
    let RestPickerView = UIPickerView()
    let LvlPickerView = UIPickerView()
    
    var hour:Int = 0
    var minutes:Int = 0
    var seconds:Int = 0
    
    var arrayHourDuration : [String] = []
    var arrayMinDuration : [String] = []
    var arraySecDuration : [String] = []
    
    var minutesRest:Int = 0
    var secRest:Int = 0
    var arrayMinRest : [String] = []
    var arraySecRest : [String] = []
    
    var activityId:String = ""
    var activityName: String = ""
    var isShowDistance:Bool = true
    var isShowSpeed:Bool = false
    var isShowRPM: Bool = true
    
    var isTrainigGoalSelectAsCustomize:Bool = false
    var selectedCardioTrainingLogName = ""
    var selectedCardioValidationList: CardioValidationListData?
    
    var minutesPace:Int = 0
    var secPace:Int = 0
    
//    var getTotalDistance: [String] = []
    var getTotalPace: [String] = []
    
    var distanceFirstData:Int = 0
    var distanceSecondData:Int = 0
    var arrayDistanceFirstData : [String] = []
    var arrayDistanceSecondData : [String] = []
    
    var speedFirstScrollndex: Int = 0
    var speedSecondScrollIndex: Int = 0
    var arraySpeedFirstData : [String] = []
    var arraySpeedSecondData : [String] = []
    
    var percentageFirstScrollIndex : Int = 0
    var percentageSecondScrollInex : Int = 0
    var arrayPercentageFirstData : [String] = []
    var arrayPercentageSecondData : [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        self.txtLaps.delegate = self
        self.txtSpeed.delegate = self
        self.txtPercentage.delegate = self
        self.txtDuration.delegate = self
        self.txtRest.delegate = self
        self.txtLvl.delegate = self
    
        
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI() {
     //   self.getTotalDistance = self.getDistanceArray()
        self.setupFont()
    }
    
    func setupFont() {
        //        self.txtLaps.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtSpeed.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtPercentage.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtDuration.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtRest.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtLvl.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        //        self.txtLaps.setColor(color: .appthemeBlackColor)
        self.txtSpeed.setColor(color: .appthemeBlackColor)
        self.txtPercentage.setColor(color: .appthemeBlackColor)
        self.txtDuration.setColor(color: .appthemeBlackColor)
        self.txtRest.setColor(color: .appthemeBlackColor)
        self.txtLvl.setColor(color: .appthemeBlackColor)
        
        changeHeaderAccordingToActivityName()
        
    }
    
    @IBAction func btnRemoveClicked(_ sender: Any) {
        self.delegate?.RemoveRowClicked(tag: self.tag)
    }
    
    func setDetails(model: CardioExerciseModelClass) {
        //        self.txtLaps.text = model.laps
        if self.isShowDistance {
            self.txtDuration.placeholder = "00"
            self.txtDuration.text = model.distance
        }
        else {
            self.txtDuration.placeholder = "00:00:00"
            self.txtDuration.text = model.duration
        }
        
        if self.isShowSpeed {
            self.txtSpeed.placeholder = "00"
            self.txtSpeed.text = model.speed
        }
        else {
            self.txtSpeed.placeholder = "00:00"
            self.txtSpeed.text = model.pace
        }
        
        if self.isShowRPM{
            self.txtPercentage.text = model.rpm
        }else{
            self.txtPercentage.text = model.watt
        }
        
        self.txtLvl.text = model.lvl
        
        if self.activityName == "Run (Outdoor)".lowercased() || self.activityName == "Run (Indoor)".lowercased() {
            self.txtPercentage.text = model.percentage
        }
        
        self.setupSpeed()
        self.setupDistance()
        
        //Remove dot and km from DistancePickerView
//        reomveKmAndDotFromDistancePickerView()
        
        //setSpeed PickerView
        setSpeedPickerViewInPartation()
        
        //Remove hr/min/sec
//        removeHrMinSecFromDuration()
        
//        //Remove Min/sec
//        removeMinSecFromRest()
        
        setMinSecRest()
        
        //Remove dot fromn percentage
 //       reomveDotFromPercentagePickerView()
  
        //Remove unit
        reomveUnitForRPMPickerView()
        
        //remove unit from pacepicker
        reomveFromPacePickerView()
        
        if  self.selectedCardioValidationList?.restRange == "00:00"{
            self.txtRest.text = "--:--"
            self.txtRest.isUserInteractionEnabled = false
        }else{
            self.txtRest.text = model.rest == "" ? "" : model.rest
            self.txtRest.isUserInteractionEnabled = true
        }
        
        if activityName.lowercased() == "Run (Outdoor)".lowercased(){
            
            if selectedCardioTrainingLogName.lowercased() == "Hill Run".lowercased() {
                self.txtPercentage.placeholder = "3.0"
            }else{
                self.txtPercentage.placeholder = "1.0"
            }
            
        }else if activityName.lowercased() == "Run (Indoor)".lowercased(){
            
            if selectedCardioTrainingLogName.lowercased() == "Hill Run".lowercased() {
                self.txtPercentage.placeholder = "3.0"
            }else{
                self.txtPercentage.placeholder = "0.0"
            }
        }
        else{
            self.txtPercentage.placeholder = "00"
        }
        
        RestPickerView.delegate = self
        self.txtRest.inputView = RestPickerView
        
        let screen = UIScreen.main.bounds.width / 3
        let screenRest = UIScreen.main.bounds.width / 2
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = UIFont.systemFont(ofSize: 17) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + 116, y: (pacePickerView.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "min"
            }
            else {
                
                //Frame set for swimming and others
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + 62, y: (pacePickerView.frame.height - 30) / 2, width: screen, height: 30)
                
                if self.activityName.lowercased() == "Swimming".lowercased(){
                    label.text = "sec/100 m"
                    
                }else if self.activityName.lowercased() == "Others".lowercased(){
                    label.text = "sec/500 m"
                }else{
                    label.text = "sec/km"
                    label.frame = CGRect(x: (screenRest * CGFloat(index)) + 45, y: (pacePickerView.frame.height - 30) / 2, width: screen, height: 30)
                }
                
            }
            label.textColor = .appthemeRedColor
            self.pacePickerView.addSubview(label)
        }
        
        
        if  self.activityName.lowercased() == "Run (Outdoor)".lowercased() ||  self.activityName.lowercased() == "Run (Indoor)".lowercased()
        {
            percentagePickerView.delegate = self
            percentagePickerView.backgroundColor = UIColor.white
            self.txtPercentage.inputView = percentagePickerView
            
        }else{
            RPMPickerView.delegate = self
            RPMPickerView.backgroundColor = UIColor.white
            self.txtPercentage.inputView = RPMPickerView
            if !isShowRPM{
                self.setCustomPickerForRPM(unit: "w")
            }
            else{
                self.setCustomPickerForRPM(unit: "")
            }
        }
       
        LvlPickerView.delegate = self
        LvlPickerView.backgroundColor = UIColor.white
        self.txtLvl.inputView = LvlPickerView
        
        //MARK: - yash Changes
      //  self.showExerciseHeader()
    }
    
    
    func setPreviewDetails(model: Exercise) {
        //        self.txtLaps.text = model.laps
        self.txtSpeed.text = model.speed
        self.txtPercentage.text = activityId == "2" ? model.rpm : model.percentage
        self.txtDuration.text = model.duration
        self.txtRest.text = model.rest?.toTrim() ?? ""
        
        //        self.txtLaps.isUserInteractionEnabled = false
        self.txtSpeed.isUserInteractionEnabled = false
        self.txtPercentage.isUserInteractionEnabled = false
        self.txtDuration.isUserInteractionEnabled = false
        self.txtRest.isUserInteractionEnabled = false
        //Yash changes
        self.showExerciseHeader()
    }
    
    //MARK: - Yash design changes
    
    func changeHeaderAccordingToActivityName(){
        
        let activityNameInLowerCased = self.activityName.lowercased()
        self.vwLvl.isHidden = false
        self.viewPercentage.isHidden = false
        
        switch activityNameInLowerCased {
            
        case "Run (Outdoor)".lowercased():
            self.vwLvl.isHidden = true
            
        case "Run (Indoor)".lowercased():
            self.vwLvl.isHidden = true
            
        case "Cycling (Indoor)".lowercased():
            self.vwLvl.isHidden = false
            
        case "Cycling (Outdoor)".lowercased():
            self.vwLvl.isHidden = true
            
        case "Swimming".lowercased():
            self.vwLvl.isHidden = true
            self.viewPercentage.isHidden = true
            
        case "Others".lowercased():
            self.vwLvl.isHidden = false
            
        default:
            self.vwLvl.isHidden = true
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if self.selectedCardioValidationList == nil{
            makeToast(strMessage: getCommonString(key: "Please_fill_up_above_details_key"))
            return false
        }
        
        if textField == self.txtSpeed && textField.text?.toTrim() == "" {
            if self.isShowSpeed {
                
                self.calculateSpeedArray(data: self.selectedCardioValidationList?.speedRange ?? "")
                
                speedFirstScrollndex = 0
                speedSecondScrollIndex = 0
                
                self.txtSpeed.text = "\(self.arraySpeedFirstData[0]).\(self.arraySpeedSecondData[0])"
                
                self.speedPickerView.selectRow(0, inComponent: 0, animated: false)
                self.speedPickerView.selectRow(0, inComponent: 1, animated: false)
                
                self.speedPickerView.reloadAllComponents()
                
            }
            else {
                
                minutesPace = 0
                secPace = 0
                
                self.txtSpeed.text = "\(minutesPace.makeRound()):\(secPace.makeRound())".toTrim()
                self.pacePickerView.selectRow(0, inComponent: 0, animated: false)
                self.pacePickerView.selectRow(0, inComponent: 1, animated: false)
            }
            
            let Laps = "0"
            let Percentage = self.txtPercentage.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if textField == self.txtPercentage && textField.text?.toTrim() == "" {
            
             reomveDotFromPercentagePickerView()
            
            if  self.activityName.lowercased() == "Run (Outdoor)".lowercased() ||  self.activityName.lowercased() == "Run (Indoor)".lowercased()
            {
                self.percentagePickerView.selectRow(0, inComponent: 0, animated: false)
                
                if self.selectedCardioValidationList?.percentageRange.contains(",") ?? false
                {
                    self.txtPercentage.text = self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "").first ?? ""
                    
                }else{
                    
                    self.percentagePickerView.selectRow(0, inComponent: 1, animated: false)
                    
                    self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")
                    
                    self.percentageFirstScrollIndex = 0
                    self.percentageSecondScrollInex = 0
                    
                    self.txtPercentage.text = "\(self.arrayPercentageFirstData[0]).\(self.arrayPercentageSecondData[0])"
                    self.percentagePickerView.reloadAllComponents()
                }
                
                let Laps = "0"
                let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
                let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
                let Duration = self.isShowDistance ? "" : self.txtDuration.text!
                let Distance = self.isShowDistance ? self.txtDuration.text! : ""
                let Rest = self.txtRest.text?.toTrim() ?? ""
                let Percentage = self.txtPercentage.text?.toTrim() ?? ""
                let Lvl = self.txtLvl.text?.toTrim() ?? ""
                let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
                let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
                
                self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
            }else{
                
                self.RPMPickerView.selectRow(0, inComponent: 0, animated: false)
                
                if self.isShowRPM {

                    self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "").first ?? ""
                }
                else {

                     self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "").first ?? ""
                }
                
                 self.RPMPickerView.reloadAllComponents()
                
                let Laps = "0"
                let Percentage = ""
                let Duration = self.isShowDistance ? "" : self.txtDuration.text!
                let Distance = self.isShowDistance ? self.txtDuration.text! : ""
                let Rest = self.txtRest.text?.toTrim() ?? ""
                let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
                let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
                let Lvl = self.txtLvl.text?.toTrim() ?? ""
                let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
                let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
                
                self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
                
            }

        }
        else if textField == self.txtDuration && textField.text?.toTrim() == "" {
            
            removeHrMinSecFromDuration()
            reomveKmAndDotFromDistancePickerView()
            
            if self.isShowDistance {
                
                self.distancePickerView.selectRow(0, inComponent: 0, animated: false)
                 if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                        self.txtDuration.text = self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "").first
                 }else{
                    
                    self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "")
                    
                    self.distanceFirstData = 0
                    self.distanceSecondData = 0
                    
                    self.txtDuration.text = "\(self.arrayDistanceFirstData[0]).\(self.arrayDistanceSecondData[0])"
                    
                    self.distancePickerView.selectRow(0, inComponent: 0, animated: false)
                    self.distancePickerView.selectRow(0, inComponent: 1, animated: false)
                    
                    self.distancePickerView.reloadAllComponents()
                }
                
            }
            else {
                
                if self.selectedCardioValidationList?.durationRange.contains(",") ?? false{
                    
                    self.durationPickerView.selectRow(0, inComponent: 0, animated: false)
                    
                    self.txtDuration.text = calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange ?? "", isShowHours: true).first ?? ""
                }else{
                    
                    calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange ?? "", isShowHours: true)
                    
                    self.durationPickerView.selectRow(0, inComponent: 0, animated: false)
                    self.durationPickerView.selectRow(0, inComponent: 1, animated: false)
                    self.durationPickerView.selectRow(0, inComponent: 2, animated: false)
                    
                    hour = 0
                    minutes = 0
                    seconds = 0
                    
                    if arrayHourDuration.count != 0 && arrayMinDuration.count != 0 && arraySecDuration.count != 0{
                        self.txtDuration.text = "\(Int(self.arrayHourDuration[hour])!.makeRound()):\(Int(self.arrayMinDuration[minutes])!.makeRound()):\(Int(self.arraySecDuration[seconds])!.makeRound())"
                    }
                    
                    self.durationPickerView.reloadAllComponents()
                }
            }
            let Laps = "0"
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if textField == self.txtRest && textField.text?.toTrim() == "" {
            
            removeMinSecFromRest()
            
            self.RestPickerView.selectRow(0, inComponent: 0, animated: false)
            
            if self.selectedCardioValidationList?.restRange.contains(",") ?? false || self.selectedCardioValidationList?.restRange == "00:00" {
                
                if self.selectedCardioValidationList?.restRange == "00:00"{
                    self.txtRest.text = "--:--"
                    return false
                }else{
                    self.txtRest.text = calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange ?? "", isShowHours: false).first
                }
                
            }else{
                self.RestPickerView.selectRow(0, inComponent: 1, animated: false)
                
                minutesRest = 0
                secRest = 0
                
                calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange ?? "", isShowHours: false)
                
                self.txtRest.text = "\(Int(self.arrayMinRest[minutesRest])!.makeRound()):\(Int(self.arraySecRest[secRest])!.makeRound())"
            }
            
            self.RestPickerView.reloadAllComponents()
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        if textField == self.txtLvl && textField.text?.toTrim() == "" {

            self.LvlPickerView.selectRow(0, inComponent: 0, animated: false)
            
            self.txtLvl.text = self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "").first
            self.LvlPickerView.reloadAllComponents()
            
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)

        }
        
//        textField.setNeedsLayout()
        textField.layoutIfNeeded()
        self.contentView.layoutIfNeeded()
        UIView.performWithoutAnimation({
          //  textField.setNeedsLayout()
            textField.layoutIfNeeded()
            self.contentView.layoutIfNeeded()
        })
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        let Laps = "0" //self.txtLaps.text!
        let Speed = self.txtSpeed.text!
        let Pace = self.txtSpeed.text!
        let Percentage = self.txtPercentage.text!
        let Duration = self.txtDuration.text!
        let Distance = self.txtDuration.text!
        let Rest = self.txtRest.text?.toTrim() ?? ""
        let Lvl = self.txtLvl.text?.toTrim() ?? ""
        let Watt = self.txtPercentage.text?.toTrim() ?? ""
        let RPM = self.txtPercentage.text?.toTrim() ?? ""
        
        print("txtAfterUpdate:\(txtAfterUpdate)")
        
        //        if textField == self.txtLaps {
        //            if (txtAfterUpdate != "" && Double(txtAfterUpdate)! > 100) {
        //                return false
        //            }
        //            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: txtAfterUpdate, Speed: Speed, Percentage: Percentage, Duration: Duration, Rest: Rest)
        //        }
        //        else
        if textField == self.txtSpeed {
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: txtAfterUpdate, Pace: txtAfterUpdate, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if textField == self.txtPercentage {
            
            if (txtAfterUpdate != "" && Double(txtAfterUpdate)! > 100) || txtAfterUpdate.count > 5 {
                return false
            }
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: txtAfterUpdate, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if textField == self.txtDuration {
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: txtAfterUpdate, Distance: txtAfterUpdate, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if textField == self.txtRest {
            if (txtAfterUpdate != "" && Double(txtAfterUpdate)! > 300) {
                return false
            }
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: txtAfterUpdate, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if textField == self.txtLvl {
            if txtAfterUpdate != "" {
                return false
            }
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: txtAfterUpdate, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        textField.setNeedsLayout()
        
        UIView.performWithoutAnimation({
           // textField.setNeedsLayout()
            textField.layoutIfNeeded()
            self.contentView.layoutIfNeeded()
        })
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.performWithoutAnimation({
         //   textField.setNeedsLayout()
            textField.layoutIfNeeded()
            self.contentView.layoutIfNeeded()
        })
        
    }

    func showExerciseHeader() {
        self.viewPercentage.isHidden = false
    }
    
    func getPercentages() -> [String] {
        var str: [String] = []
        for i in 0..<51 {
            str.append("\(i)")
            str.append("\(Double(i)+0.5)")
        }
        str.removeLast()
        return str
    }
    
    func getSpeed() -> [String] {
        var str: [String] = []
        for i in 1..<151 {
            str.append("\(i)")
            str.append("\(Double(i)+0.5)")
        }
        str.removeLast()
        return str
    }
    
    func getDistanceArray() -> [String] {
        var distanceArray: [String] = []
        
        for i in 0..<1000 {
            for j in 0..<10 {
                let value: Double = Double(i) + (Double(j) * 0.10)
                distanceArray.append("\(value.rounded(toPlaces: 2))")
            }
        }
        return distanceArray
    }
    
    func setupDistance() {
        if self.isShowDistance {
            distancePickerView.delegate = self
            distancePickerView.backgroundColor = UIColor.white
            self.txtDuration.inputView = distancePickerView
        }
        else {
            durationPickerView.delegate = self
            durationPickerView.backgroundColor = UIColor.white
            self.txtDuration.inputView = durationPickerView
        }
    }
    
    func setupSpeed() {
        if self.isShowSpeed {
            speedPickerView.delegate = self
            speedPickerView.backgroundColor = UIColor.white
            self.txtSpeed.inputView = speedPickerView
        }
        else {
            pacePickerView.delegate = self
            pacePickerView.backgroundColor = UIColor.white
            self.txtSpeed.inputView = pacePickerView
        }
    }
    
    //MARK: - Yash changes
    
    func calculateDistanceArray(data:String) -> [String] {
        if (data.contains("|")) {
            var array: [String] = []
            
            let dataArray = data.split(separator: "-")
            if dataArray.count == 2 {
                let startFrom = dataArray.first
                let valueWithUnit = dataArray[1]
                
                let splitEndWithUnit = valueWithUnit.split(separator: "|")
                let unit = splitEndWithUnit[1]
                
                let endValueArray = splitEndWithUnit[0].split(separator: ",")
                
                let endValue = endValueArray.first
                let incrementWith = endValueArray[1]
                
                print("startFrom  :\(startFrom)")
                print("endValue  :\(endValue)")
                print("incrementWith  :\(incrementWith)")
                
                let floatStart = String(startFrom ?? "").toFloat()
                let floatEnd = String(endValue ?? "").toFloat()
                let floatIncrement = String(incrementWith ?? "").toFloat()
                
                let array = Array(stride(from: floatStart, to:floatEnd + floatIncrement, by: floatIncrement))
                
                let stringArray = array.map { (value) -> String in
                    return String(format: "%.01f", value)
                }
                
                
                reomveKmAndDotFromDistancePickerView()
                self.setUnitBehindDistancePicker(unit: String(unit))
                
                return stringArray
                
            }
            return array
        }
        else {
            
            let dataArray = data.split(separator: "-")
            if dataArray.count == 2 {
                
                let startFrom = dataArray.first
                let endTo = dataArray[1]
                
                let firstDataStart = startFrom?.split(separator: ".")
                let secondData = endTo.split(separator: ".")
                
                var no1 = 0
                var no2 = 0
                var no3 = 0
                var no4 = 0
                
                if firstDataStart?.count == 2{
                    no1 = Int(String(firstDataStart?[0] ?? "")) ?? 0
                    no2 = Int(String(firstDataStart?[1] ?? "")) ?? 0
                }
                
                if secondData.count == 2{
                    no3 = Int(String(secondData[0])) ?? 0
                    no4 = Int(String(secondData[1])) ?? 0
                }
                
                self.arrayDistanceFirstData = []
                self.arrayDistanceSecondData = []
                
                let arrayFirstData = Array(stride(from: no1, to: no3 + 1, by: 1))
                self.arrayDistanceFirstData = arrayFirstData.map { (value) -> String in
                    return "\(value)"
                }
                
                let arraySecondData = Array(stride(from: no2, to: no4 + 1, by: 1))
                self.arrayDistanceSecondData = arraySecondData.map { (value) -> String in
                    return "\(value)"
                }
                
                reomveKmAndDotFromDistancePickerView()
                setCustomPickerForDistance()
                
            }
            
            return []
        }
    }
    
    func setUnitBehindDistancePicker(unit:String){
        for index in 0..<1 {
            let screen = UIScreen.main.bounds.width
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = UIFont.systemFont(ofSize: 17) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            label.frame = CGRect(x: (screen * CGFloat(index)) + 50, y: (distancePickerView.frame.height - 30) / 2, width: screen, height: 30)
            label.text = unit.lowercased()
            
            label.textColor = .appthemeRedColor
            self.distancePickerView.addSubview(label)
        }
    }
    
    func setCustomPickerForDistance(){
        
        let screenRest = UIScreen.main.bounds.width / 2
        
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = UIFont.systemFont(ofSize: 17) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 98 : 108
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (distancePickerView.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "."
            }
            else {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (distancePickerView.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "km"
            }
            label.textColor = .appthemeRedColor
            self.distancePickerView.addSubview(label)
        }
        
        distancePickerView.delegate = self
        distancePickerView.backgroundColor = UIColor.white
        
    }
    
    func reomveKmAndDotFromDistancePickerView(){
        if let viewWithTag = self.distancePickerView.viewWithTag(100){
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        if let viewWithDifferentTag = self.distancePickerView.viewWithTag(101) {
            viewWithDifferentTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        self.distancePickerView.layoutIfNeeded()
        self.distancePickerView.layoutSubviews()
    }
    
    //Setup speed pickerview
    
    
    func calculateSpeedArray(data:String) {
        
        let dataArray = data.split(separator: "-")
        if dataArray.count == 2 {
            
            let startFrom = dataArray.first
            let endTo = dataArray[1]
            
            let firstDataStart = startFrom?.split(separator: ".")
            let secondData = endTo.split(separator: ".")
            
            var no1 = 0
            var no2 = 0
            var no3 = 0
            var no4 = 0
            
            if firstDataStart?.count == 2{
                no1 = Int(String(firstDataStart?[0] ?? "")) ?? 0
                no2 = Int(String(firstDataStart?[1] ?? "")) ?? 0
            }
            
            if secondData.count == 2{
                no3 = Int(String(secondData[0])) ?? 0
                no4 = Int(String(secondData[1])) ?? 0
            }
            
            self.arraySpeedFirstData = []
            self.arraySpeedSecondData = []
            
            let arrayFirstData = Array(stride(from: no1, to: no3 + 1, by: 1))
            self.arraySpeedFirstData = arrayFirstData.map { (value) -> String in
                return "\(value)"
            }
            
            let arraySecondData = Array(stride(from: no2, to: no4 + 1, by: 1))
            self.arraySpeedSecondData = arraySecondData.map { (value) -> String in
                return "\(value)"
            }
            
            print("arrayDistanceFirstData: \(arraySpeedFirstData)")
            print("arrayDistanceSecondData: \(arraySpeedSecondData)")
            
        }
    }
    
    func setSpeedPickerViewInPartation(){
        
        let screenRest = UIScreen.main.bounds.width / 2
        
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = UIFont.systemFont(ofSize: 17) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 98 : 108
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (speedPickerView.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "."
            }
            else {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? -12 : -2
                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (speedPickerView.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "km/hr"
            }
            label.textColor = .appthemeRedColor
            self.speedPickerView.addSubview(label)
        }
        
        speedPickerView.delegate = self
        speedPickerView.backgroundColor = UIColor.white
        
    }
    
    //Calcualte Percentage
    
    func calculatePercentageArray(data:String) -> [String] {
        
        if data.contains(",")
        {
            let dataArray = data.split(separator: "-")
            if dataArray.count == 2 {
                
                let startFrom = String(dataArray.first ?? "").toFloat()
                let endToArray = dataArray[1]
                
                let endData = endToArray.split(separator: ",")
                
                var endTo : CGFloat = 0.0
                var incrementWith : CGFloat = 0.0
                
                if endData.count == 2{
                    endTo = String(endData[0]).toFloat()
                    incrementWith = String(endData[1]).toFloat()
                }
                
                let arrayFirstData = Array(stride(from: startFrom, to: endTo + incrementWith, by:incrementWith))
                let arrayFinal = arrayFirstData.map { (value) -> String in
                    return "\(value)"
                }

                reomveDotFromPercentagePickerView()
                
                return arrayFinal
                
            }
            
        }else{
            
            
            let dataArray = data.split(separator: "-")
            if dataArray.count == 2 {
                
                let startFrom = dataArray.first
                let endTo = dataArray[1]
                
                let firstDataStart = startFrom?.split(separator: ".")
                let secondData = endTo.split(separator: ".")
                
                var no1 = 0
                var no2 = 0
                var no3 = 0
                var no4 = 0
                
                if firstDataStart?.count == 2{
                    no1 = Int(String(firstDataStart?[0] ?? "")) ?? 0
                    no2 = Int(String(firstDataStart?[1] ?? "")) ?? 0
                }
                
                if secondData.count == 2{
                    no3 = Int(String(secondData[0])) ?? 0
                    no4 = Int(String(secondData[1])) ?? 0
                }
                
                self.arrayPercentageFirstData = []
                self.arrayPercentageSecondData = []
                
                let arrayFirstData = Array(stride(from: no1, to: no3 + 1, by: 1))
                self.arrayPercentageFirstData = arrayFirstData.map { (value) -> String in
                    return "\(value)"
                }
                
                let arraySecondData = Array(stride(from: no2, to: no4 + 1, by: 1))
                self.arrayPercentageSecondData = arraySecondData.map { (value) -> String in
                    return "\(value)"
                }
                
                print("arrayPercentageFirstData: \(arrayPercentageFirstData)")
                print("arrayPercentageSecondData: \(arrayPercentageSecondData)")
                
                setPercentagePickerViewInPartation()
                
            }
            
        }
        
        return []
    }
    
    func setPercentagePickerViewInPartation(){
        
        let screenRest = UIScreen.main.bounds.width / 2
        
//        for index in 0..<1 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100
            label.font = UIFont.systemFont(ofSize: 17) //themeFont(size: 15, fontname: .ProximaNovaRegular)
//            if index == 0 {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 98 : 108
                label.frame = CGRect(x: (screenRest * CGFloat(0)) + CGFloat(x), y: (percentagePickerView.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "."
//            }
//            else {
//                let x = DEVICE_TYPE.IS_IPHONE_6 ? -12 : -2
//                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (speedPickerView.frame.height - 30) / 2, width: screenRest, height: 30)
//                label.text = ""
//            }
            label.textColor = .appthemeRedColor
            self.percentagePickerView.addSubview(label)
//        }
        
        percentagePickerView.delegate = self
        percentagePickerView.backgroundColor = UIColor.white
        
    }

    func reomveDotFromPercentagePickerView(){
        
        if let viewWithTag = self.percentagePickerView.viewWithTag(100){
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
//        if let viewWithDifferentTag = self.distancePickerView.viewWithTag(101) {
//            viewWithDifferentTag.removeFromSuperview()
//        }else{
//            print("No!")
//        }
        
        self.percentagePickerView.layoutIfNeeded()
        self.percentagePickerView.layoutSubviews()
    }
    
    func calculateDurationArrayWithGap(data:String?, isShowHours:Bool = true) -> [String] {
        
        if data?.contains(",") ?? false
        {
            
            var addTime:Double = 0 // AddTime set in second for increment
            var array: [String] = []
            let dataArray = data?.split(separator: "-")
            
            if dataArray?.count == 2 {
                let firstArray = dataArray?.first?.split(separator: ":")
                let dataWithGapValue = dataArray?[1].split(separator: ",")
                
                let secondArray = dataWithGapValue?[0].split(separator: ":")
                
                let gapValue = dataWithGapValue?[1].split(separator: ":")
                print("GapValue : \(gapValue)")
                
                let hrIncremnt = String(gapValue?[0] ?? "")
                let minIncrement = String(gapValue?[1] ?? "")
                let secIncrement = String(gapValue?[2] ?? "")
                
                if hrIncremnt != "00"{
                    addTime = Double((Int(hrIncremnt) ?? 0) * 3600)
                }
                 
                if minIncrement != "00"{
                    addTime = Double((Int(minIncrement) ?? 0) * 60)
                }
                  
                if secIncrement != "00" {
                    addTime = Double(Int(secIncrement) ?? 0)
                }
                
                let fHr = (Double(firstArray?[0] ?? "0") ?? 0) * 60 * 60
                let fMin = (Double(firstArray?[1] ?? "0") ?? 0) * 60
                let fSec = (Double(firstArray?[2] ?? "0") ?? 0)
                
                let sHr = (Double(secondArray?[0] ?? "0") ?? 0) * 60 * 60
                let sMin = (Double(secondArray?[1] ?? "0") ?? 0) * 60
                let sSec = (Double(secondArray?[2] ?? "0") ?? 0)
                
                var firstCount = fHr + fMin + fSec
                let secondCount = sHr + sMin + sSec
                
                let final = Int(((((sHr / 60 ) + (sMin / 60 )) - ((fHr / 60 ) + (fMin / 60 ))) + 1 ) * 2)*60  //Final must be in minue
                //                * 12
                
                print("final : \(final)")
                
                for _ in 0..<final {
                    if secondCount >= firstCount {
                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(firstCount))
                        array.append(self.makeTimeString(h: h, m: m, s: s, isShowHours: isShowHours))
                    }
                    else {
                        
                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(secondCount))
                        
                        if Int(secondCount) % 2 != 0{
                            array.append(self.makeTimeString(h: h, m: m, s: s, isShowHours: isShowHours))
                        }
                        break
                        
                    }
                    firstCount += addTime
                }
                
                if array.count == 1 {
                    let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(secondCount))
                    array.append(self.makeTimeString(h: h, m: m, s: s, isShowHours: isShowHours))
                }
                
                print("Array : \(array)")
            }
            
            removeHrMinSecFromDuration()
            return array
            
        }else{
            
            var addTime:Double = 0 // AddTime set in second for increment
            var array: [String] = []
            let dataArray = data?.split(separator: "-")
            
            if dataArray?.count == 2 {
                let firstArray = dataArray?.first?.split(separator: ":")
                let secondArray = dataArray?[1].split(separator: ":")
                
                let fHr = (Double(firstArray?[0] ?? "0") ?? 0)
                let fMin = (Double(firstArray?[1] ?? "0") ?? 0)
                let fSec = (Double(firstArray?[2] ?? "0") ?? 0)
                
                let sHr = (Double(secondArray?[0] ?? "0") ?? 0)
                let sMin = (Double(secondArray?[1] ?? "0") ?? 0)
                let sSec = (Double(secondArray?[2] ?? "0") ?? 0)
                
                arrayHourDuration = []
                arrayMinDuration = []
                arraySecDuration = []
                
                let arrayHr = Array(stride(from: fHr, to:sHr + 1, by: 1))
                
                self.arrayHourDuration = arrayHr.map { (value) -> String in
                    return String(format: "%.00f", value)
                }
                
                let arrayMin = Array(stride(from: fMin, to:sMin + 1, by: 1))
                
                self.arrayMinDuration = arrayMin.map { (value) -> String in
                    return String(format: "%.00f", value)
                }
                
                let arraySec = Array(stride(from: fSec, to:sSec + 1, by: 1))
                
                self.arraySecDuration = arraySec.map { (value) -> String in
                    return String(format: "%.00f", value)
                }

            }
            
            setDurationPicker()
            
            return []
            
        }
    }
    
    func makeTimeString(h:Int, m:Int, s:Int, isShowHours:Bool) -> String {
        var hr:String = ""
        var min:String = ""
        var sec:String = ""
        
        hr = "\(h)".count == 1 ? "0\(h)" : "\(h)"
        min = "\(m)".count == 1 ? "0\(m)" : "\(m)"
        sec = "\(s)".count == 1 ? "0\(s)" : "\(s)"
        if isShowHours {
            let str = hr + ":" + min + ":" + sec
            return str
        }
        else {
            let str = min + ":" + sec
            return str
        }
    }
    
    func setDurationPicker(){
        
        let screen = UIScreen.main.bounds.width / 3
        for index in 0..<3 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = UIFont.systemFont(ofSize: 17) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                label.frame = CGRect(x: (screen * CGFloat(index)) + 48, y: (durationPickerView.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "hrs"
            }
            else if index == 1 {
                label.frame = CGRect(x: (screen * CGFloat(index)) + 38, y: (durationPickerView.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "min"
            }
            else {
                label.frame = CGRect(x: (screen * CGFloat(index)) + 25, y: (durationPickerView.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "sec"
            }
            label.textColor = .appthemeRedColor
            self.durationPickerView.addSubview(label)
        }
    }
    
    
    func removeHrMinSecFromDuration(){
        if let viewWithTag = self.durationPickerView.viewWithTag(100){
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        if let viewWithDifferentTag = self.durationPickerView.viewWithTag(101) {
            viewWithDifferentTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        if let viewWithDifferentTag = self.durationPickerView.viewWithTag(102) {
            viewWithDifferentTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        self.durationPickerView.layoutIfNeeded()
        self.durationPickerView.layoutSubviews()
    }
    
    func calculateRestArrayWithGap(data:String?, isShowHours:Bool = true) -> [String] {
        
        if data == "00:00"{
            removeMinSecFromRest()
            return [data ?? ""]
        }else{
            
            if data?.contains(",") ?? false
            {
                
                var addTime:Double = 0 // AddTime set in second for increment
                var array: [String] = []
                let dataArray = data?.split(separator: "-")
                
                if dataArray?.count == 2 {
                    let firstArray = dataArray?.first?.split(separator: ":")
                    let dataWithGapValue = dataArray?[1].split(separator: ",")
                    
                    let secondArray = dataWithGapValue?[0].split(separator: ":")
                    
                    let gapValue = dataWithGapValue?[1].split(separator: ":")
                    print("GapValue : \(gapValue)")
                    
                    let hrIncremnt = String(gapValue?[0] ?? "")
                    let minIncrement = String(gapValue?[1] ?? "")
                    let secIncrement = String(gapValue?[2] ?? "")
                    
                    if hrIncremnt != "00"{
                        addTime = Double((Int(hrIncremnt) ?? 0) * 3600)
                    }
                     
                    if minIncrement != "00"{
                        addTime = Double((Int(minIncrement) ?? 0) * 60)
                    }
                      
                    if secIncrement != "00" {
                        addTime = Double(Int(secIncrement) ?? 0)
                    }
                    
                    let fHr = (Double(firstArray?[0] ?? "0") ?? 0) * 60 * 60
                    let fMin = (Double(firstArray?[1] ?? "0") ?? 0) * 60
                    let fSec = (Double(firstArray?[2] ?? "0") ?? 0)
                    
                    let sHr = (Double(secondArray?[0] ?? "0") ?? 0) * 60 * 60
                    let sMin = (Double(secondArray?[1] ?? "0") ?? 0) * 60
                    let sSec = (Double(secondArray?[2] ?? "0") ?? 0)
                    
                    var firstCount = fHr + fMin + fSec
                    let secondCount = sHr + sMin + sSec
                    
                    let final = Int(((((sHr / 60 ) + (sMin / 60 )) - ((fHr / 60 ) + (fMin / 60 ))) + 1 ) * 2)*60  //Final must be in minue
                    //                * 12
                    
                    print("final : \(final)")
                    
                    for _ in 0..<final {
                        if secondCount >= firstCount {
                            let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(firstCount))
                            array.append(self.makeTimeString(h: h, m: m, s: s, isShowHours: isShowHours))
                        }
                        else {
                            
                            let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(secondCount))
                            
                            if Int(secondCount) % 2 != 0{
                                array.append(self.makeTimeString(h: h, m: m, s: s, isShowHours: isShowHours))
                            }
                            break
                            
                        }
                        firstCount += addTime
                    }
                    
                    if array.count == 1 {
                        let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(secondCount))
                        array.append(self.makeTimeString(h: h, m: m, s: s, isShowHours: isShowHours))
                    }
                    
                    removeMinSecFromRest()
                    print("Array : \(array)")
                }
                
                return array
                
            }else{
                
                var addTime:Double = 0 // AddTime set in second for increment
                var array: [String] = []
                let dataArray = data?.split(separator: "-")
                
                if dataArray?.count == 2 {
                    let firstArray = dataArray?.first?.split(separator: ":")
                    let secondArray = dataArray?[1].split(separator: ":")
                    
                    let fHr = (Double(firstArray?[0] ?? "0") ?? 0)
                    let fMin = (Double(firstArray?[1] ?? "0") ?? 0)
                    let fSec = (Double(firstArray?[2] ?? "0") ?? 0)
                    
                    let sHr = (Double(secondArray?[0] ?? "0") ?? 0)
                    let sMin = (Double(secondArray?[1] ?? "0") ?? 0)
                    let sSec = (Double(secondArray?[2] ?? "0") ?? 0)
                    
                    arrayMinRest = []
                    arraySecRest = []
                    
                    let arraymin = Array(stride(from: fMin, to:sMin + 1, by: 1))
                    
                    self.arrayMinRest = arraymin.map { (value) -> String in
                        return String(format: "%.00f", value)
                    }
                    
                    let arraySec = Array(stride(from: fSec, to:sSec + 1, by: 1))
                    
                    self.arraySecRest = arraySec.map { (value) -> String in
                        return String(format: "%.00f", value)
                    }
                    
                }
                
                setMinSecRest()
                
                return []
                
            }
        }
        
    }
    
    func setMinSecRest(){
        
        let screen = UIScreen.main.bounds.width / 3
        
        let screenRest = UIScreen.main.bounds.width / 2
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = UIFont.systemFont(ofSize: 17) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + 116, y: (RestPickerView.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "min"
            }
            else {
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + 35, y: (RestPickerView.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "sec"
            }
            label.textColor = .appthemeRedColor
            self.RestPickerView.addSubview(label)
        }
        
        RestPickerView.delegate = self
        RestPickerView.backgroundColor = UIColor.white
        
    }
    
    func removeMinSecFromRest(){
        if let viewWithTag = self.RestPickerView.viewWithTag(100){
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        if let viewWithDifferentTag = self.RestPickerView.viewWithTag(101) {
            viewWithDifferentTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        
        self.RestPickerView.layoutIfNeeded()
        self.RestPickerView.layoutSubviews()
    }
    
    func calculateRPMWAttArray(data: String) -> [String]{
        
        if (data.contains("|")) {
            var array: [String] = []
            
            let dataArray = data.split(separator: "-")
            if dataArray.count == 2 {
                let startFrom = dataArray.first
                let valueWithUnit = dataArray[1]
                
                let splitEndWithUnit = valueWithUnit.split(separator: "|")
                let unit = splitEndWithUnit[1]
                
                let endValueArray = splitEndWithUnit[0].split(separator: ",")
                
                let endValue = endValueArray.first
                let incrementWith = endValueArray[1]
                
                print("startFrom  :\(startFrom)")
                print("endValue  :\(endValue)")
                print("incrementWith  :\(incrementWith)")
                
                let floatStart = Int(String(startFrom ?? "")) ?? 0
                let floatEnd = Int(String(endValue ?? "")) ?? 0
                let floatIncrement = Int(String(incrementWith ?? "")) ?? 0
                
                let array = Array(stride(from: floatStart, to:floatEnd + floatIncrement, by: floatIncrement))
                
                let stringArray = array.map { (value) -> String in
                    return String(value)
                }
         //       self.setCustomPickerForRPM(unit: String(unit))
                
                return stringArray
                
            }
        }
        
        return []
        
    }
    
    func setCustomPickerForRPM(unit: String){
        
        for index in 0..<1 {
            let screen = UIScreen.main.bounds.width
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = UIFont.systemFont(ofSize: 17) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            label.frame = CGRect(x: (screen * CGFloat(index)) + 50, y: (RPMPickerView.frame.height - 30) / 2, width: screen, height: 30)
            label.text = unit.lowercased()
            
            label.textColor = .appthemeRedColor
            self.RPMPickerView.addSubview(label)
        }
        
    }
    
    func reomveUnitForRPMPickerView(){
        
        if let viewWithTag = self.RPMPickerView.viewWithTag(100){
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        self.RPMPickerView.layoutIfNeeded()
        self.RPMPickerView.layoutSubviews()
    }
    
    
    func calculateLvlArray(data: String) -> [String]{
        
        let dataArray = data.split(separator: "-")
        if dataArray.count == 2 {
            let startFrom = Int(String(dataArray[0])) ?? 0
            let endTO = Int(String(dataArray[1])) ?? 0

            let array = Array(stride(from: startFrom, to:endTO + 1, by: 1))
            
            let stringArray = array.map { (value) -> String in
                return String(value)
            }
            //       self.setCustomPickerForRPM(unit: String(unit))
            
            return stringArray
            
        }
        
        return []
    }
    
    
    func reomveFromPacePickerView(){
        if let viewWithTag = self.pacePickerView.viewWithTag(100){
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        if let viewWithDifferentTag = self.pacePickerView.viewWithTag(101) {
            viewWithDifferentTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        self.pacePickerView.layoutIfNeeded()
        self.pacePickerView.layoutSubviews()
    }
    
}


extension ExerciseCardioCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.distancePickerView {
            if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                return 1
            }else{
                return 2
            }
        }
        else if pickerView == self.speedPickerView {
            return 2
        }
        else if pickerView == self.pacePickerView {
            return 2
        }
        else if pickerView == self.RPMPickerView {
            return 1
        }
        else if pickerView == self.percentagePickerView {
            if self.selectedCardioValidationList?.percentageRange.contains(",") ?? false
            {
                return 1
            }
            else{
                return 2
            }
        }else if pickerView == self.LvlPickerView{
            return 1
        }
        else if pickerView == self.RestPickerView {
            
            if self.selectedCardioValidationList?.restRange.contains(",") ?? false || self.selectedCardioValidationList?.restRange == "00:00"{
                return 1
            }else{
                return 2
            }
            
        }
        else if pickerView == self.durationPickerView{
            if self.selectedCardioValidationList?.durationRange.contains(",") ?? false{
                return 1
            }else{
                return 3
            }
        }
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.distancePickerView {
//            return self.getTotalDistance.count
            if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                return self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "").count
            }else{
                
                if component == 0{
                    return self.arrayDistanceFirstData.count
                }else {
                    return self.arrayDistanceSecondData.count
                }
            }
            
        }
        else if pickerView == self.speedPickerView {
            
            if component == 0{
                return self.arraySpeedFirstData.count
            }
            else{
                return self.arraySpeedSecondData.count
            }
//            return self.getSpeed().count
        }
        else if pickerView == self.pacePickerView {
            switch component {
            case 0:
                return 60
            case 1:
                return 60
            default:
                return 0
            }
        }
        else if pickerView == self.RPMPickerView {
            if self.isShowRPM{
                return self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "").count
            }else{
                return self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "").count
            }
            
        }
        else if pickerView == self.percentagePickerView {
            
            if self.selectedCardioValidationList?.percentageRange.contains(",") ?? false
            {
                return self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "").count
            }else{
                if component == 0{
                    return self.arrayPercentageFirstData.count
                }else{
                    return self.arrayPercentageSecondData.count
                }
            }
            
        }
        else if pickerView == self.durationPickerView{
            if self.selectedCardioValidationList?.durationRange.contains(",") ?? false{
                return self.calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange).count
            }else{
                if component == 0{
                    return self.arrayHourDuration.count
                }else if component == 1{
                    return self.arrayMinDuration.count
                }else{
                    return self.arraySecDuration.count
                }
                
            }
        }
        else if pickerView == self.RestPickerView {
            
            
            if self.selectedCardioValidationList?.restRange.contains(",") ?? false || self.selectedCardioValidationList?.restRange == "00:00"{
                return calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange, isShowHours: false).count
            }else{
                if component == 0{
                    return arrayMinRest.count
                }else{
                    return arraySecRest.count
                }
            }
            
//            switch component {
//            case 0:
//                return 60
//            case 1:
//                return 60
//            default:
//                return 0
//            }
        }
        else if pickerView == self.LvlPickerView{
            return self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "").count
        }
        else {
            switch component {
            case 0:
                return 24
            case 1:
                return 60
            case 2:
                return 60
            default:
                return 0
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if pickerView == self.distancePickerView {
            
            if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                
                let attributedString = NSAttributedString(string:self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "")[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
                
            }else{
                
                if component == 0{
                    let attributedString = NSAttributedString(string: self.arrayDistanceFirstData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                    return attributedString
                }else{
                    let attributedString = NSAttributedString(string: self.arrayDistanceSecondData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                    return attributedString
                }
               
            }
            
        }
        else if pickerView == self.speedPickerView {
            
            if component == 0{
                let attributedString = NSAttributedString(string: self.arraySpeedFirstData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
            }else{
                let attributedString = NSAttributedString(string: self.arraySpeedSecondData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
            }
            
        }
        else if pickerView == self.pacePickerView {
            let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
            return attributedString
        }
        else if pickerView == self.RPMPickerView {
            
            if self.isShowRPM{
                let attributedString = NSAttributedString(string: self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "")[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
                
            }else{
                let attributedString = NSAttributedString(string: self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "")[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
                
            }
        }
        else if pickerView == self.percentagePickerView {
            
            
            if self.selectedCardioValidationList?.percentageRange.contains(",") ?? false
            {
                let attributedString = NSAttributedString(string: calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
                
            }else{
                
                if component == 0{
                    let attributedString = NSAttributedString(string: self.arrayPercentageFirstData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                    return attributedString
                }
                else{
                    let attributedString = NSAttributedString(string: self.arrayPercentageSecondData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                    return attributedString
                }
                
            }
            
        }
        else if pickerView == self.RestPickerView {
            
            if self.selectedCardioValidationList?.restRange.contains(",") ?? false || self.selectedCardioValidationList?.restRange == "00:00"{
                
                let restRangeValue = calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange, isShowHours: false)[row]
                
                let attributedString = NSAttributedString(string: restRangeValue, attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                               
                return attributedString
                
                 
            }else{
                
                if component == 0{
                    let attributedString = NSAttributedString(string: self.arrayMinRest[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                    return attributedString
                }else{
                    let attributedString = NSAttributedString(string: self.arraySecRest[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                    return attributedString
                }
                
            }
            /*
            switch component {
            case 0:
                let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                
                return attributedString
            case 1:
                let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
            default:
                let attributedString = NSAttributedString(string: "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
            }
             */
        }else if pickerView == self.durationPickerView{
            
            if self.selectedCardioValidationList?.durationRange.contains(",") ?? false{
                
                let attributedString = NSAttributedString(string: self.calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange,isShowHours: true)[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
            }else{
                
                if component == 0{
                    let attributedString = NSAttributedString(string: self.arrayHourDuration[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                    return attributedString
                }else if component == 1{
                    let attributedString = NSAttributedString(string: self.arrayMinDuration[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                    return attributedString
                }else{
                    let attributedString = NSAttributedString(string: self.arraySecDuration[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                    return attributedString
                }
                
            }
        }else if pickerView == self.LvlPickerView{
            
            let attributedString = NSAttributedString(string: self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "")[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
            return attributedString
            
        }
        else {
            switch component {
            case 0:
                let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
            case 1:
                let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
            case 2:
                let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
            default:
                let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeRedColor])
                return attributedString
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.distancePickerView {
             if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                self.txtDuration.text = self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "")[row]
             }else{
                
                if component == 0 {
                    self.distanceFirstData = row
                }else{
                    self.distanceSecondData = row
                }
                
                self.txtDuration.text = "\(self.arrayDistanceFirstData[self.distanceFirstData]).\(self.arrayDistanceSecondData[self.distanceSecondData])"
            }
            
            let Laps = "0" //self.txtLaps.text!
            let Percentage = self.txtPercentage.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if pickerView == self.speedPickerView {
//            let value = self.getSpeed()[row].replace(target: ".0", withString: "")
//            self.txtSpeed.text = value
            
            if component == 0 {
                self.speedFirstScrollndex = row
            }else{
                self.speedSecondScrollIndex = row
            }
            
            self.txtSpeed.text = "\(self.arraySpeedFirstData[self.speedFirstScrollndex]).\(self.arraySpeedSecondData[self.speedSecondScrollIndex])"
            
            
            let Laps = "0" //self.txtLaps.text!
            let Percentage = self.txtPercentage.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if pickerView == self.pacePickerView {
            switch component {
            case 0:
                minutesPace = row
            case 1:
                secPace = row
            default:
                break;
            }
            self.txtSpeed.text = "\(minutesPace.makeRound()):\(secPace.makeRound())".toTrim()
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if pickerView == self.RPMPickerView {
            
            if self.isShowRPM{
                self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "")[row]
            }else{
                self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "")[row]
            }
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: "", Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if pickerView == self.percentagePickerView {
            
            if self.selectedCardioValidationList?.percentageRange.contains(",") ?? false
            {
                self.txtPercentage.text = calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")[row]
                
            }else{
                if component == 0{
                    self.percentageFirstScrollIndex = row
                }else{
                    self.percentageSecondScrollInex = row
                }
                
                self.txtPercentage.text = "\(self.arrayPercentageFirstData[self.percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[self.percentageSecondScrollInex])"
            }
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Percentage = self.txtPercentage.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if pickerView == self.RestPickerView {
            switch component {
            case 0:
                minutesRest = row
            case 1:
                secRest = row
            default:
                break
            }
           // self.txtRest.text = "\(minutesRest.makeRound()):\(secRest.makeRound())".toTrim()
            
            if self.selectedCardioValidationList?.restRange.contains(",") ?? false || self.selectedCardioValidationList?.restRange == "00:00"{
                self.txtRest.text = self.calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange ?? "", isShowHours: false)[row]
            }else{
                self.txtRest.text = "\(Int(self.arrayMinRest[minutesRest])!.makeRound()):\(Int(self.arraySecRest[secRest])!.makeRound())"
            }
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }else if pickerView == durationPickerView{
            
            if self.selectedCardioValidationList?.durationRange.contains(",") ?? false{
                self.txtDuration.text = self.calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange, isShowHours: true)[row]
            }else{
                
                if component == 0{
                    hour = row
                }else if component == 1{
                    minutes = row
                }else{
                    seconds = row
                }
                
                if arrayHourDuration.count != 0 && arrayMinDuration.count != 0 && arraySecDuration.count != 0{
                    self.txtDuration.text = "\(Int(self.arrayHourDuration[hour])!.makeRound()):\(Int(self.arrayMinDuration[minutes])!.makeRound()):\(Int(self.arraySecDuration[seconds])!.makeRound())"
                }
                
            }
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if pickerView == self.LvlPickerView{
            self.txtLvl.text = self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "")[row]
        }
        else {
            switch component {
            case 0:
                hour = row
            case 1:
                minutes = row
            case 2:
                seconds = row
            default:
                break;
            }
            self.txtDuration.text = "\(hour.makeRound()):\(minutes.makeRound()):\(seconds.makeRound())"
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView == durationPickerView {
            if self.selectedCardioValidationList?.durationRange.contains(",") ?? false{
                return 120
            }else{
                let screen = (UIScreen.main.bounds.width - 50) / 3
                return CGFloat(screen)
            }
        }
        else {
            return CGFloat(120)
        }
    }
}

extension Int {
    func makeRound() -> String {
        if self > 9 {
            return "\(self)"
        }
        else {
            return "0\(self)"
        }
    }
}
