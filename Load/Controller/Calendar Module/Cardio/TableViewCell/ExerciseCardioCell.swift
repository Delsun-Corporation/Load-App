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
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var txtPercentage: UITextField!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var txtDuration: UITextField!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var txtRest: UITextField!
    @IBOutlet weak var lblRest: UILabel!
    
    @IBOutlet weak var vwStackView: UIStackView!
    @IBOutlet weak var viewPercentage: UIView!
    @IBOutlet weak var vwLvl: UIView!
    @IBOutlet weak var txtLvl: UITextField!
    @IBOutlet weak var lblLvl: UILabel!
    
    @IBOutlet weak var vwCyclingOutdoorPercentage: UIView!
    @IBOutlet weak var txtCyclingOutdoorPercentage: UITextField!
    @IBOutlet weak var lblCyclingOutdoorPercentage: UILabel!
    
    
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
    
    var isEdit: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //        self.txtLaps.delegate = self
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
     //   self.getTotalDistance = self.getDistanceArray()
        self.setupFont()
    }
    
    func setupFont() {
        //        self.txtLaps.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtSpeed.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblSpeed.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtPercentage.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblPercentage.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtDuration.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblDuration.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtRest.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblRest.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtLvl.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblLvl.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtCyclingOutdoorPercentage.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblCyclingOutdoorPercentage.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        
        //        self.txtLaps.setColor(color: .appthemeBlackColor)
        self.txtSpeed.setColor(color: .clear)
        self.lblSpeed.setColor(color: .appthemeBlackColor)
        self.txtPercentage.setColor(color: .clear)
        self.lblPercentage.setColor(color: .appthemeBlackColor)
        self.txtDuration.setColor(color: .clear)
        self.lblDuration.setColor(color: .appthemeBlackColor)
        self.txtRest.setColor(color: .clear)
        self.lblRest.setColor(color: .appthemeBlackColor)
        self.txtLvl.setColor(color: .clear)
        self.lblLvl.setColor(color: .appthemeBlackColor)
        self.txtCyclingOutdoorPercentage.setColor(color: .clear)
        self.lblCyclingOutdoorPercentage.setColor(color: .appthemeBlackColor)
        
        changeHeaderAccordingToActivityName()
    }
    
    @IBAction func btnRemoveClicked(_ sender: Any) {
        self.delegate?.RemoveRowClicked(tag: self.tag)
    }
    
    func setDetails(model: CardioExerciseModelClass) {
        
        print("isEdit:\(isEdit)")

        //        self.txtLaps.text = model.laps
        if self.isShowDistance {
            self.txtDuration.placeholder = "00"
            self.txtDuration.text = model.distance
            self.lblDuration.text = model.distance
        }
        else {
            self.txtDuration.placeholder = "00:00:00"
            self.txtDuration.text = model.duration
            self.lblDuration.text = model.duration
        }
        
        if self.isShowSpeed {
            self.txtSpeed.placeholder = "00"
            self.txtSpeed.text = model.speed
            self.lblSpeed.text = model.speed
        }
        else {
            self.txtSpeed.placeholder = "00:00"
            self.txtSpeed.text = model.pace
            self.lblSpeed.text = model.pace
        }
        
        if self.isShowRPM{
            self.txtPercentage.text = model.rpm
            self.lblPercentage.text = model.rpm
        }else{
            self.txtPercentage.text = model.watt
            self.lblPercentage.text = model.watt
        }
        
        self.txtLvl.text = model.lvl
        self.lblLvl.text = model.lvl
        
        if self.activityName == "Run (Outdoor)".lowercased() || self.activityName == "Run (Indoor)".lowercased() {
            self.txtPercentage.text = model.percentage
            self.lblPercentage.text = model.percentage
        }
        
        self.setupSpeed()
        self.setupDistance()
        
        //Remove dot and km from DistancePickerView
        reomveKmAndDotFromDistancePickerView()
        
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
            self.lblRest.text = "--:--"
            self.txtRest.isUserInteractionEnabled = false
        }else{
            self.txtRest.text = model.rest == "" ? "" : model.rest
            self.lblRest.text = model.rest == "" ? "" : model.rest
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
        
        if self.activityName == "Cycling (Indoor)".lowercased(){
            self.txtLvl.placeholder = "1"
        }else{
            self.txtLvl.placeholder = "0"
        }
        
        RestPickerView.delegate = self
        self.txtRest.inputView = RestPickerView
        
        
//       label.font = themeFont(size: 21, fontname: .Regular)
        let screen = UIScreen.main.bounds.width / 3
        let screenRest = UIScreen.main.bounds.width / 2
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 98 : 108
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (pacePickerView.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = ":"
            }
            else {
                
                //Frame set for swimming and others
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + 62, y: (pacePickerView.frame.height - 30) / 2, width: screen, height: 30)
                
                if self.activityName.lowercased() == "Swimming".lowercased(){
                    label.text = "min/100 m"
                    
                }else if self.activityName.lowercased() == "Others".lowercased(){
                    label.text = "min/500 m"
                }else{
                    label.text = "min/km"
                    label.frame = CGRect(x: (screenRest * CGFloat(index)) + 50, y: (pacePickerView.frame.height - 30) / 2, width: screen, height: 30)
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
        
        if  self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() {
            
            self.txtCyclingOutdoorPercentage.placeholder = "0.0"
            
            self.txtCyclingOutdoorPercentage.text = model.percentage
            self.lblCyclingOutdoorPercentage.text = model.percentage
            
            percentagePickerView.delegate = self
            percentagePickerView.backgroundColor = UIColor.white
            self.txtCyclingOutdoorPercentage.inputView = percentagePickerView
            
        }

        //MARK: - yash Changes
      //  self.showExerciseHeader()
    }
    
    /*
    func setPreviewDetails(model: Exercise) {
        //        self.txtLaps.text = model.laps
        self.txtSpeed.text = model.speed
        self.lblSpeed.text = model.speed
        self.txtPercentage.text = activityId == "2" ? model.rpm : model.percentage
        self.lblPercentage.text = activityId == "2" ? model.rpm : model.percentage
        
        self.txtDuration.text = model.duration
        self.lblDuration.text = model.duration

        self.txtRest.text = model.rest?.toTrim() ?? ""
        self.lblRest.text = model.rest?.toTrim() ?? ""
        
        //        self.txtLaps.isUserInteractionEnabled = false
        self.txtSpeed.isUserInteractionEnabled = false
        self.txtPercentage.isUserInteractionEnabled = false
        self.txtDuration.isUserInteractionEnabled = false
        self.txtRest.isUserInteractionEnabled = false
        //Yash changes
        self.showExerciseHeader()
    }*/
    
    //MARK: - Yash design changes
    
    func changeHeaderAccordingToActivityName(){
        
        let activityNameInLowerCased = self.activityName.lowercased()
        self.vwLvl.isHidden = false
        self.viewPercentage.isHidden = false
        self.vwCyclingOutdoorPercentage.isHidden = true
        
        switch activityNameInLowerCased {
            
        case "Run (Outdoor)".lowercased():
            self.vwLvl.isHidden = true
            self.vwStackView.spacing = 20
            
        case "Run (Indoor)".lowercased():
            self.vwLvl.isHidden = true
            self.vwStackView.spacing = 20
            
        case "Cycling (Indoor)".lowercased():
            self.vwLvl.isHidden = false
            self.vwStackView.spacing = 0
            
        case "Cycling (Outdoor)".lowercased():
            self.vwCyclingOutdoorPercentage.isHidden = false
            self.vwLvl.isHidden = true
            self.vwStackView.spacing = 0
            
        case "Swimming".lowercased():
            self.vwLvl.isHidden = true
            self.viewPercentage.isHidden = true
            
            self.vwStackView.spacing = 65
            
        case "Others".lowercased():
            self.vwLvl.isHidden = false
            self.vwStackView.spacing = 0
            
        default:
            self.vwStackView.spacing = 0
            self.vwLvl.isHidden = true
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if self.selectedCardioValidationList == nil{
            makeToast(strMessage: getCommonString(key: "Please_fill_up_above_details_key"))
            return false
        }
        
        if textField == self.txtSpeed {
            if self.isShowSpeed {
                
                self.calculateSpeedArray(data: self.selectedCardioValidationList?.speedRange ?? "")
                
                if textField.text?.toTrim() == ""{
                    speedFirstScrollndex = 0
                    speedSecondScrollIndex = 0
                    
                    self.speedPickerView.selectRow(0, inComponent: 0, animated: false)
                    self.speedPickerView.selectRow(0, inComponent: 1, animated: false)
                }
                
//                if isEdit{
                    if self.txtSpeed.text?.contains(".") ?? false{

                        let arraySpeed = self.txtSpeed.text?.split(separator: ".")
                        if arraySpeed?.count == 2{

                            let firstIndex = self.arraySpeedFirstData.firstIndex(where: {$0 == String(arraySpeed?[0] ?? "0")})
                            let secondIndex = self.arraySpeedSecondData.firstIndex(where: {$0 == String(arraySpeed?[1] ?? "0")})

                            print("FirstIndex:\(firstIndex) : secondINdex:\(secondIndex)")

                            self.speedPickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                            self.speedPickerView.selectRow(secondIndex ?? 0, inComponent: 1, animated: false)

                            self.speedFirstScrollndex = firstIndex ?? 0
                            self.speedSecondScrollIndex = secondIndex ?? 0
                            
                        }
                    }
//                }
                
                self.txtSpeed.text = "\(self.arraySpeedFirstData[speedFirstScrollndex]).\(self.arraySpeedSecondData[speedSecondScrollIndex])"
                self.lblSpeed.text = "\(self.arraySpeedFirstData[speedFirstScrollndex]).\(self.arraySpeedSecondData[speedSecondScrollIndex])"
                
                self.speedPickerView.reloadAllComponents()
                
            }
            else {
                
                if textField.text?.toTrim() == ""{
                    minutesPace = 0
                    secPace = 0
                    
                    self.pacePickerView.selectRow(0, inComponent: 0, animated: false)
                    self.pacePickerView.selectRow(0, inComponent: 1, animated: false)
                }
                
//                if isEdit{
                    if self.txtSpeed.text?.contains(":") ?? false{

                        let arrayPace = self.txtSpeed.text?.split(separator: ":")
                        if arrayPace?.count == 2{

                            let firstIndex = Int(String(arrayPace?[0] ?? "0"))
                            let secondIndex = Int(String(arrayPace?[1] ?? "0"))

                            print("FirstIndex:\(firstIndex) : secondINdex:\(secondIndex)")

                            self.pacePickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                            self.pacePickerView.selectRow(secondIndex ?? 0, inComponent: 1, animated: false)

                            self.minutesPace = firstIndex ?? 0
                            self.secPace = secondIndex ?? 0
                            
                        }
                    }
//                }
                
                self.txtSpeed.text = "\(minutesPace.makeRound()):\(secPace.makeRound())".toTrim()
                self.lblSpeed.text = "\(minutesPace.makeRound()):\(secPace.makeRound())".toTrim()

                
            }
            
            let Laps = "0"
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
            
            return true
        }
        else if textField == self.txtPercentage  {
            
             reomveDotFromPercentagePickerView()
            
            if  self.activityName.lowercased() == "Run (Outdoor)".lowercased() ||  self.activityName.lowercased() == "Run (Indoor)".lowercased()
            {
                if textField.text?.toTrim() == ""{
                    self.percentagePickerView.selectRow(0, inComponent: 0, animated: false)
                }
                
                if self.selectedCardioValidationList?.percentageRange.contains(",") ?? false
                {
                    if textField.text?.toTrim() == ""{
                        self.txtPercentage.text = self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "").first ?? ""
                        self.lblPercentage.text = self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "").first ?? ""
                    }
                    
//                    if isEdit{
                        let array = self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")
                        let firstIndex = array.firstIndex(where: {$0 == self.txtPercentage.text}) ?? 0
                        self.percentagePickerView.selectRow(firstIndex, inComponent: 0, animated: false)
//                    }
                    
                }else{
                    
                     if textField.text?.toTrim() == ""{
                        self.percentagePickerView.selectRow(0, inComponent: 1, animated: false)
                    }
                    
                    self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")
                    
                    if textField.text?.toTrim() == ""{
                        self.percentageFirstScrollIndex = 0
                        self.percentageSecondScrollInex = 0

                    }
                    
//                    if isEdit{
                        if self.txtPercentage.text?.contains(".") ?? false{

                            let arrayPercentage = self.txtPercentage.text?.split(separator: ".")
                            if arrayPercentage?.count == 2{

                                let firstIndex = arrayPercentageFirstData.firstIndex(where: {$0 == String(arrayPercentage?[0] ?? "")}) ?? 0
                                let secondIndex = arrayPercentageSecondData.firstIndex(where: {$0 == String(arrayPercentage?[1] ?? "")}) ?? 0

                                print("FirstIndex:\(firstIndex) : secondINdex:\(secondIndex)")

                                self.percentagePickerView.selectRow(firstIndex , inComponent: 0, animated: false)
                                self.percentagePickerView.selectRow(secondIndex , inComponent: 1, animated: false)

                                self.percentageFirstScrollIndex = firstIndex
                                self.percentageSecondScrollInex = secondIndex
                                
                            }
                        }
//                    }
                    
                    self.txtPercentage.text = "\(self.arrayPercentageFirstData[percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[percentageSecondScrollInex])"
                    self.lblPercentage.text = "\(self.arrayPercentageFirstData[percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[percentageSecondScrollInex])"
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
                
                if textField.text?.toTrim() == ""{
                    self.RPMPickerView.selectRow(0, inComponent: 0, animated: false)
                }
                
                if self.isShowRPM {
                    
                    if textField.text?.toTrim() == ""{
                        self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "").first ?? ""
                        self.lblPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "").first ?? ""
                    }
                    
//                    if isEdit{
                        let array = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "")
                        let firstIndex = array.firstIndex(where: {$0 == self.txtPercentage.text}) ?? 0
                        self.RPMPickerView.selectRow(firstIndex, inComponent: 0, animated: false)
//                    }
                    
                }
                else {
                    
                    if textField.text?.toTrim() == ""{
                        self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "").first ?? ""
                        self.lblPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "").first ?? ""
                    }
                    
//                    if isEdit{
                        let array = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "")
                        let firstIndex = array.firstIndex(where: {$0 == self.txtPercentage.text}) ?? 0
                        self.RPMPickerView.selectRow(firstIndex, inComponent: 0, animated: false)
//                    }
                    
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

        }else if textField == self.txtCyclingOutdoorPercentage{
            
            reomveDotFromPercentagePickerView()
            
            if self.selectedCardioValidationList?.percentageRange.contains(",") ?? false
            {
                if textField.text?.toTrim() == ""{
                    self.percentagePickerView.selectRow(0, inComponent: 0, animated: false)

                    self.txtCyclingOutdoorPercentage.text = self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "").first ?? ""
                    self.lblCyclingOutdoorPercentage.text = self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "").first ?? ""
                }
                
//                if isEdit{
                    let array = self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")
                    let firstIndex = array.firstIndex(where: {$0 == self.txtCyclingOutdoorPercentage.text}) ?? 0
                    self.percentagePickerView.selectRow(firstIndex, inComponent: 0, animated: false)
//                }
                
                
            }else{
                
                self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")
                
                if textField.text?.toTrim() == ""{
                    self.percentagePickerView.selectRow(0, inComponent: 0, animated: false)
                     self.percentagePickerView.selectRow(0, inComponent: 1, animated: false)
                    self.percentageFirstScrollIndex = 0
                    self.percentageSecondScrollInex = 0
                }
                
//                if isEdit{
                    if self.txtCyclingOutdoorPercentage.text?.contains(".") ?? false{

                        let arrayPercentage = self.txtCyclingOutdoorPercentage.text?.split(separator: ".")
                        if arrayPercentage?.count == 2{

                            let firstIndex = arrayPercentageFirstData.firstIndex(where: {$0 == String(arrayPercentage?[0] ?? "")}) ?? 0
                            let secondIndex = arrayPercentageSecondData.firstIndex(where: {$0 == String(arrayPercentage?[1] ?? "")}) ?? 0

                            print("FirstIndex:\(firstIndex) : secondINdex:\(secondIndex)")

                            self.percentagePickerView.selectRow(firstIndex , inComponent: 0, animated: false)
                            self.percentagePickerView.selectRow(secondIndex , inComponent: 1, animated: false)

                            self.percentageFirstScrollIndex = firstIndex
                            self.percentageSecondScrollInex = secondIndex
                            
                        }
                    }
//                }
                
                self.txtCyclingOutdoorPercentage.text = "\(self.arrayPercentageFirstData[percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[percentageSecondScrollInex])"
                self.lblCyclingOutdoorPercentage.text = "\(self.arrayPercentageFirstData[percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[percentageSecondScrollInex])"
                self.percentagePickerView.reloadAllComponents()
            }
            
            let Laps = "0"
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Percentage = self.txtCyclingOutdoorPercentage.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if textField == self.txtDuration {
            
            removeHrMinSecFromDuration()
            reomveKmAndDotFromDistancePickerView()
            
            if self.isShowDistance {
                
                if textField.text?.toTrim() == ""{
                    self.distancePickerView.selectRow(0, inComponent: 0, animated: false)
                }
                
                 if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                    
                    
                    if textField.text?.toTrim() == ""{
                        self.txtDuration.text = self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "").first
                        self.lblDuration.text = self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "").first
                    }
                    
                    if activityName.lowercased() == "Run (Outdoor)".lowercased() || self.activityName == "Run (Indoor)".lowercased(){
                        
                        if selectedCardioTrainingLogName.lowercased() == "Speed Intervals".lowercased() {
                            
                            let value = ((self.txtDuration.text!).toFloat())/1000.0
                            self.txtDuration.text = "\(value)"
                            
                            if isEdit{
                                
                            }
                            
                        }
                    }
                    
//                    if isEdit{
                        let array = self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "")
                        let firstIndex = array.firstIndex(where: {$0 == self.txtDuration.text}) ?? 0
                        self.distancePickerView.selectRow(firstIndex, inComponent: 0, animated: false)
//                    }
                    
                 }else{
                    
                    self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "")
                    
                    if textField.text?.toTrim() == ""{
                        self.distanceFirstData = 0
                        self.distanceSecondData = 0
                        
                        self.distancePickerView.selectRow(0, inComponent: 0, animated: false)
                        self.distancePickerView.selectRow(0, inComponent: 1, animated: false)

                    }

//                    if isEdit{
                        if self.txtDuration.text?.contains(".") ?? false{

                            let arrayDistance = self.txtDuration.text?.split(separator: ".")
                            if arrayDistance?.count == 2{

                                let firstIndex = self.arrayDistanceFirstData.firstIndex(where: {$0 == String(arrayDistance?[0] ?? "0")})
                                let secondIndex = self.arrayDistanceSecondData.firstIndex(where: {$0 == String(arrayDistance?[1] ?? "0")})

                                print("FirstIndex:\(firstIndex) : secondINdex:\(secondIndex)")

                                self.distancePickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                                self.distancePickerView.selectRow(secondIndex ?? 0, inComponent: 1, animated: false)

                                self.distanceFirstData = firstIndex ?? 0
                                self.distanceSecondData = secondIndex ?? 0
                                
                            }
                        }
//                    }

                    self.txtDuration.text = "\(self.arrayDistanceFirstData[distanceFirstData]).\(self.arrayDistanceSecondData[distanceSecondData])"
                    self.lblDuration.text = "\(self.arrayDistanceFirstData[distanceFirstData]).\(self.arrayDistanceSecondData[distanceSecondData])"
                    
                    self.distancePickerView.reloadAllComponents()
                    
                }
                
            }
            else {
                
                if self.selectedCardioValidationList?.durationRange.contains(",") ?? false{
                    
                    if textField.text?.toTrim() == ""{
                        self.durationPickerView.selectRow(0, inComponent: 0, animated: false)
                        
                        self.txtDuration.text = calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange ?? "", isShowHours: true).first ?? ""
                        self.lblDuration.text = calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange ?? "", isShowHours: true).first ?? ""
                    }
                    
//                    if self.isEdit{
                        let arrayDuration = calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange ?? "", isShowHours: true)
                        
                        let firstIndex = arrayDuration.firstIndex(where: {$0 == String(self.txtDuration.text ?? "")})
                        print("FirstIndex:\(firstIndex) ")
                        
                        self.durationPickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)

//                    }
                    
                }else{
                    
                    calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange ?? "", isShowHours: true)
                    
                    if textField.text?.toTrim() == ""{
                        self.durationPickerView.selectRow(0, inComponent: 0, animated: false)
                        self.durationPickerView.selectRow(0, inComponent: 1, animated: false)
                        self.durationPickerView.selectRow(0, inComponent: 2, animated: false)
                        hour = 0
                        minutes = 0
                        seconds = 0
                    }
                    
//                    if self.isEdit{
                        
                        let dataArray = txtDuration.text?.split(separator: ":")
                        
                        if dataArray?.count == 3{

                            let firstData = Int(dataArray?[0] ?? "0") ?? 0
                            let secondData = Int(dataArray?[1] ?? "0") ?? 0
                            let thirdData = Int(dataArray?[2] ?? "0") ?? 0

                            let firstIndex = self.arrayHourDuration.firstIndex(where: {$0 == String(firstData)})
                            let secondIndex = self.arrayMinDuration.firstIndex(where: {$0 == String(secondData)})
                            let thirdIndex = self.arraySecDuration.firstIndex(where: {$0 == String(thirdData)})

                            print("FirstIndex:\(firstIndex) : secondINdex:\(secondIndex) : ThirdIndex: \(thirdIndex)")

                            
                            DispatchQueue.main.async {
                                self.durationPickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                                self.durationPickerView.selectRow(secondIndex ?? 0, inComponent: 1, animated: false)
                                self.durationPickerView.selectRow(thirdIndex ?? 0, inComponent: 2, animated: false)

                            }
                            
                            hour = firstIndex ?? 0
                            minutes = secondIndex ?? 0
                            seconds = thirdIndex ?? 0

                        }
//                    }
                    
                    
                    if arrayHourDuration.count != 0 && arrayMinDuration.count != 0 && arraySecDuration.count != 0{
                        self.txtDuration.text = "\(Int(self.arrayHourDuration[hour])!.makeRound()):\(Int(self.arrayMinDuration[minutes])!.makeRound()):\(Int(self.arraySecDuration[seconds])!.makeRound())"
                        
                        self.lblDuration.text = "\(Int(self.arrayHourDuration[hour])!.makeRound()):\(Int(self.arrayMinDuration[minutes])!.makeRound()):\(Int(self.arraySecDuration[seconds])!.makeRound())"
                    }
                    
                    self.durationPickerView.reloadAllComponents()
                }
            }
            let Laps = "0"
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if textField == self.txtRest{
            
            removeMinSecFromRest()
            
            if textField.text?.toTrim() == "" {
                self.RestPickerView.selectRow(0, inComponent: 0, animated: false)
            }
            
            if self.selectedCardioValidationList?.restRange.contains(",") ?? false || self.selectedCardioValidationList?.restRange == "00:00" {
                
                if self.selectedCardioValidationList?.restRange == "00:00"{
                    self.txtRest.text = "--:--"
                    self.lblRest.text = "--:--"
                    return false
                }else{
                    
                    if textField.text?.toTrim() == "" {
                        self.txtRest.text = calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange ?? "", isShowHours: false).first
                        self.lblRest.text = calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange ?? "", isShowHours: false).first
                    }
                    
//                    if self.isEdit{
                        let arrayRest = calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange ?? "", isShowHours: false)
                        
                        let firstIndex = arrayRest.firstIndex(where: {$0 == String(self.txtRest.text ?? "")})
                        print("FirstIndex:\(firstIndex) ")
                        
                        self.RestPickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)

//                    }

                    
                }
                
            }else{
                
                if textField.text?.toTrim() == ""{
                    self.RestPickerView.selectRow(0, inComponent: 1, animated: false)
                    minutesRest = 0
                    secRest = 0
                }
                
                calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange ?? "", isShowHours: false)
                
//                if self.isEdit{
                    
                    let dataArray = txtRest.text?.split(separator: ":")
                    
                    if dataArray?.count == 2{

                        let firstData = Int(dataArray?[0] ?? "0") ?? 0
                        let secondData = Int(dataArray?[1] ?? "0") ?? 0

                        let firstIndex = self.arrayMinRest.firstIndex(where: {$0 == String(firstData)})
                        let secondIndex = self.arraySecRest.firstIndex(where: {$0 == String(secondData)})

                        print("FirstIndex:\(firstIndex) : secondINdex:\(secondIndex)")

                        self.RestPickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                        self.RestPickerView.selectRow(secondIndex ?? 0, inComponent: 1, animated: false)

                        minutesRest = firstIndex ?? 0
                        secRest = secondIndex ?? 0

                    }
//                }
                
                self.txtRest.text = "\(Int(self.arrayMinRest[minutesRest])!.makeRound()):\(Int(self.arraySecRest[secRest])!.makeRound())"
                self.lblRest.text = "\(Int(self.arrayMinRest[minutesRest])!.makeRound()):\(Int(self.arraySecRest[secRest])!.makeRound())"
                
            }
            
            self.RestPickerView.reloadAllComponents()
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        if textField == self.txtLvl {

            if textField.text?.toTrim() == "" {
                self.LvlPickerView.selectRow(0, inComponent: 0, animated: false)
                
                self.txtLvl.text = self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "").first
                self.lblLvl.text = self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "").first

            }
            
//            if isEdit{
                let array = self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "")
                let firstIndex = array.firstIndex(where: {$0 == self.txtLvl.text}) ?? 0
                self.LvlPickerView.selectRow(firstIndex, inComponent: 0, animated: false)
//            }

            self.LvlPickerView.reloadAllComponents()
            
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)

        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        let Laps = "0" //self.txtLaps.text!
        let Speed = self.txtSpeed.text!
        let Pace = self.txtSpeed.text!
        let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
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
        
        if textField == self.txtSpeed {
            if self.isShowSpeed {
                
                if self.txtSpeed.text == "0.0" || self.txtSpeed.text == "00" || self.txtSpeed.text == "0"{
                    self.txtSpeed.text = ""
                    self.lblSpeed.text = ""
                    speedFirstScrollndex = 0
                    speedSecondScrollIndex = 0
                }
            }
            else {
                
                let secondsDifference = geHoursMinutesSecondsTOSecondsFormate(data: self.txtSpeed.text ?? "0")
                print("secondsDifference : \(secondsDifference)")
                
                if secondsDifference == "00" || secondsDifference == "0.0"{
                    self.txtSpeed.text = ""
                    self.lblSpeed.text = ""
                    minutesPace = 0
                    secPace = 0
                }
            }
            
            let Laps = "0"
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
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
        else if textField == self.txtPercentage {
            
            
            if  self.activityName.lowercased() == "Run (Outdoor)".lowercased() ||  self.activityName.lowercased() == "Run (Indoor)".lowercased()
            {
                
                if self.selectedCardioValidationList?.percentageRange.contains(",") ?? false
                {
                    if self.txtPercentage.text == "0.0" || self.txtPercentage.text == "0" || self.txtPercentage.text == "00"{
                        self.txtPercentage.text = ""
                        self.lblPercentage.text = ""
                    }
                    
                }else{
                    
                    if self.txtPercentage.text == "0.0" || self.txtPercentage.text == "0" || self.txtPercentage.text == "00"{
                        self.txtPercentage.text = ""
                        self.lblPercentage.text = ""
                        self.percentageFirstScrollIndex = 0
                        self.percentageSecondScrollInex = 0
                    }
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
                
                if self.isShowRPM {
                    
                    if self.txtPercentage.text == "00" || self.txtPercentage.text == "0.0" || self.txtPercentage.text == "0"{
                        self.txtPercentage.text = ""
                        self.lblPercentage.text = ""
                    }
                    
                }
                else {

                    if self.txtPercentage.text == "00" || self.txtPercentage.text == "0.0" || self.txtPercentage.text == "0"{
                        self.txtPercentage.text = ""
                        self.lblPercentage.text = ""
                    }
                }
                
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
        else if textField == self.txtCyclingOutdoorPercentage{
            
            if self.selectedCardioValidationList?.percentageRange.contains(",") ?? false
            {
                if self.txtCyclingOutdoorPercentage.text == "0.0" || self.txtCyclingOutdoorPercentage.text == "0" || self.txtCyclingOutdoorPercentage.text == "00"{
                    self.txtCyclingOutdoorPercentage.text = ""
                    self.lblCyclingOutdoorPercentage.text = ""
                }
                
            }else{
                
                if self.txtCyclingOutdoorPercentage.text == "0.0" || self.txtCyclingOutdoorPercentage.text == "0" || self.txtCyclingOutdoorPercentage.text == "00"{
                    self.txtCyclingOutdoorPercentage.text = ""
                    self.lblCyclingOutdoorPercentage.text = ""
                    self.percentageFirstScrollIndex = 0
                    self.percentageSecondScrollInex = 0
                }
            }
            
            let Laps = "0"
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Percentage = self.txtCyclingOutdoorPercentage.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if textField == self.txtDuration {
            
            if self.isShowDistance {
                
                 if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                    
                    if self.txtDuration.text == "0.0" || self.txtDuration.text == "00" || self.txtDuration.text == "0"{
                        self.txtDuration.text = ""
                        self.lblDuration.text = ""
                    }
                    
                 }else{
                    
                    if self.txtDuration.text == "0.0" || self.txtDuration.text == "00" || self.txtDuration.text == "0"{
                        self.txtDuration.text = ""
                        self.lblDuration.text = ""
                        self.distanceFirstData = 0
                        self.distanceSecondData = 0
                    }
                    
                }
                
            }
            else {
                
                if self.selectedCardioValidationList?.durationRange.contains(",") ?? false{
                    
                    
                    let secondsDifference = geHoursMinutesSecondsTOSecondsFormate(data: self.txtDuration.text ?? "0")
                    print("secondsDifference : \(secondsDifference)")
                    
                    if secondsDifference == "00" || secondsDifference == "0.0"{
                        self.txtDuration.text = ""
                        self.lblDuration.text = ""
                    }
                    
                }else{
                    
                    if arrayHourDuration.count != 0 && arrayMinDuration.count != 0 && arraySecDuration.count != 0{
              
                        let secondsDifference = geHoursMinutesSecondsTOSecondsFormate(data: self.txtDuration.text ?? "0")
                        print("secondsDifference : \(secondsDifference)")
                        
                        if secondsDifference == "00" || secondsDifference == "0.0"{
                            hour = 0
                            minutes = 0
                            seconds = 0

                            self.txtDuration.text = ""
                            self.lblDuration.text = ""
                        }
                    }
                    
                }
            }
            let Laps = "0"
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if textField == self.txtRest{
            
            if self.selectedCardioValidationList?.restRange.contains(",") ?? false || self.selectedCardioValidationList?.restRange == "00:00" {
                
                if self.selectedCardioValidationList?.restRange == "00:00"{
                    self.txtRest.text = "--:--"
                    self.lblRest.text = "--:--"
                    return false
                }else{
                    
                    let secondsDifference = geHoursMinutesSecondsTOSecondsFormate(data: self.txtRest.text ?? "0")
                    print("secondsDifference : \(secondsDifference)")
                    
                    if secondsDifference == "00" || secondsDifference == "0.0"{
                        self.txtRest.text = ""
                        self.lblRest.text = ""
                    }
                }
                
            }else{

                let secondsDifference = geHoursMinutesSecondsTOSecondsFormate(data: self.txtRest.text ?? "0")
                print("secondsDifference : \(secondsDifference)")
                
                if secondsDifference == "00" || secondsDifference == "0.0"{
                    self.txtRest.text = ""
                    self.lblRest.text = ""
                    minutesRest = 0
                    secRest = 0
                }
            }
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if textField == self.txtLvl {

            if self.txtLvl.text == "0" || self.txtLvl.text == "00" || self.txtLvl.text == "0.0"{
                self.txtLvl.text = ""
                self.lblLvl.text = ""
            }
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)

        }
        
        
        
        return true
    }
    
    func showExerciseHeader() {
        self.viewPercentage.isHidden = false
    }
    
//    func getPercentages() -> [String] {
//        var str: [String] = []
//        for i in 0..<51 {
//            str.append("\(i)")
//            str.append("\(Double(i)+0.5)")
//        }
//        str.removeLast()
//        return str
//    }
    
//    func getSpeed() -> [String] {
//        var str: [String] = []
//        for i in 1..<151 {
//            str.append("\(i)")
//            str.append("\(Double(i)+0.5)")
//        }
//        str.removeLast()
//        return str
//    }
    
//    func getDistanceArray() -> [String] {
//        var distanceArray: [String] = []
//
//        for i in 0..<1000 {
//            for j in 0..<10 {
//                let value: Double = Double(i) + (Double(j) * 0.10)
//                distanceArray.append("\(value.rounded(toPlaces: 2))")
//            }
//        }
//        return distanceArray
//    }
    
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
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
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
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
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
        }
    }
    
    func setSpeedPickerViewInPartation(){
        
        let screenRest = UIScreen.main.bounds.width / 2
        
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
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
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
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
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
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
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
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
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
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
        
//for view in pickerView.subviews{
//                view.backgroundColor = UIColor.clear
//            }        
        if pickerView == self.distancePickerView {
            
            if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                
                let attributedString = NSAttributedString(string:self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "")[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                return attributedString
                
            }else{
                
                if component == 0{
                    let attributedString = NSAttributedString(string: self.arrayDistanceFirstData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                    return attributedString
                }else{
                    let attributedString = NSAttributedString(string: self.arrayDistanceSecondData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                    return attributedString
                }
               
            }
            
        }
        else if pickerView == self.speedPickerView {
            
            if component == 0{
                let attributedString = NSAttributedString(string: self.arraySpeedFirstData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                return attributedString
            }else{
                let attributedString = NSAttributedString(string: self.arraySpeedSecondData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                return attributedString
            }
            
        }
        else if pickerView == self.pacePickerView {
            let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
            return attributedString
        }
        else if pickerView == self.RPMPickerView {
            
            if self.isShowRPM{
                let attributedString = NSAttributedString(string: self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "")[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                return attributedString
                
            }else{
                let attributedString = NSAttributedString(string: self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "")[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                return attributedString
                
            }
        }
        else if pickerView == self.percentagePickerView {
            
            
            if self.selectedCardioValidationList?.percentageRange.contains(",") ?? false
            {
                let attributedString = NSAttributedString(string: calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                return attributedString
                
            }else{
                
                if component == 0{
                    let attributedString = NSAttributedString(string: self.arrayPercentageFirstData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                    return attributedString
                }
                else{
                    let attributedString = NSAttributedString(string: self.arrayPercentageSecondData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                    return attributedString
                }
                
            }
            
        }
        else if pickerView == self.RestPickerView {
            
            if self.selectedCardioValidationList?.restRange.contains(",") ?? false || self.selectedCardioValidationList?.restRange == "00:00"{
                
                let restRangeValue = calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange, isShowHours: false)[row]
                
                let attributedString = NSAttributedString(string: restRangeValue, attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                               
                return attributedString
                
                 
            }else{
                
                if component == 0{
                    let attributedString = NSAttributedString(string: self.arrayMinRest[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                    return attributedString
                }else{
                    let attributedString = NSAttributedString(string: self.arraySecRest[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
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
                
                let attributedString = NSAttributedString(string: self.calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange,isShowHours: true)[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                return attributedString
            }else{
                
                if component == 0{
                    let attributedString = NSAttributedString(string: self.arrayHourDuration[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                    return attributedString
                }else if component == 1{
                    let attributedString = NSAttributedString(string: self.arrayMinDuration[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                    return attributedString
                }else{
                    let attributedString = NSAttributedString(string: self.arraySecDuration[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                    return attributedString
                }
                
            }
        }else if pickerView == self.LvlPickerView{
            
            let attributedString = NSAttributedString(string: self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "")[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
            return attributedString
            
        }
        else {
            switch component {
            case 0:
                let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                return attributedString
            case 1:
                let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                return attributedString
            case 2:
                let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                return attributedString
            default:
                let attributedString = NSAttributedString(string: "\(row)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
                return attributedString
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        pickerView.subviews[1].backgroundColor = UIColor.clear
        
        if pickerView == self.distancePickerView {
             if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                self.txtDuration.text = self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "")[row]
                self.lblDuration.text = self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "")[row]
                
                if activityName.lowercased() == "Run (Outdoor)".lowercased() || self.activityName == "Run (Indoor)".lowercased(){
                    
                    if selectedCardioTrainingLogName.lowercased() == "Speed Intervals".lowercased() {
                        
                        let value = ((self.txtDuration.text!).toFloat())/1000.0
                        self.txtDuration.text = "\(value)"
                    }
                }
             }else{
                
                if component == 0 {
                    self.distanceFirstData = row
                }else{
                    self.distanceSecondData = row
                }
                
                self.txtDuration.text = "\(self.arrayDistanceFirstData[self.distanceFirstData]).\(self.arrayDistanceSecondData[self.distanceSecondData])"
                self.lblDuration.text = "\(self.arrayDistanceFirstData[self.distanceFirstData]).\(self.arrayDistanceSecondData[self.distanceSecondData])"
            }
            
            let Laps = "0" //self.txtLaps.text!
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
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
            self.lblSpeed.text = "\(self.arraySpeedFirstData[self.speedFirstScrollndex]).\(self.arraySpeedSecondData[self.speedSecondScrollIndex])"
            
            let Laps = "0" //self.txtLaps.text!
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
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
            self.lblSpeed.text = "\(minutesPace.makeRound()):\(secPace.makeRound())".toTrim()
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if pickerView == self.RPMPickerView {
            
            if self.isShowRPM{
                self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "")[row]
                self.lblPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "")[row]
            }else{
                self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "")[row]
                self.lblPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "")[row]
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
                
                if self.activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
                    self.txtCyclingOutdoorPercentage.text = calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")[row]
                    self.lblCyclingOutdoorPercentage.text = calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")[row]

                }else{
                    self.txtPercentage.text = calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")[row]
                    self.lblPercentage.text = calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")[row]
                }
                
            }else{
                
                if self.activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
                    if component == 0{
                        self.percentageFirstScrollIndex = row
                    }else{
                        self.percentageSecondScrollInex = row
                    }
                    
                    self.txtCyclingOutdoorPercentage.text = "\(self.arrayPercentageFirstData[self.percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[self.percentageSecondScrollInex])"
                    self.lblCyclingOutdoorPercentage.text = "\(self.arrayPercentageFirstData[self.percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[self.percentageSecondScrollInex])"
                }
                else{
                    if component == 0{
                        self.percentageFirstScrollIndex = row
                    }else{
                        self.percentageSecondScrollInex = row
                    }
                    
                    self.txtPercentage.text = "\(self.arrayPercentageFirstData[self.percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[self.percentageSecondScrollInex])"
                    self.lblPercentage.text = "\(self.arrayPercentageFirstData[self.percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[self.percentageSecondScrollInex])"
                }
                
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
            
            var Percentage = ""
            
            if self.activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
                Percentage = self.txtCyclingOutdoorPercentage.text?.toTrim() ?? ""
            }else{
                Percentage = self.txtPercentage.text?.toTrim() ?? ""
            }
                        
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
                self.lblRest.text = self.calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange ?? "", isShowHours: false)[row]
                
            }else{
                self.txtRest.text = "\(Int(self.arrayMinRest[minutesRest])!.makeRound()):\(Int(self.arraySecRest[secRest])!.makeRound())"
                self.lblRest.text = "\(Int(self.arrayMinRest[minutesRest])!.makeRound()):\(Int(self.arraySecRest[secRest])!.makeRound())"
            }
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }else if pickerView == durationPickerView{
            
            if self.selectedCardioValidationList?.durationRange.contains(",") ?? false{
                self.txtDuration.text = self.calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange, isShowHours: true)[row]
                self.lblDuration.text = self.calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange, isShowHours: true)[row]
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
                    self.lblDuration.text = "\(Int(self.arrayHourDuration[hour])!.makeRound()):\(Int(self.arrayMinDuration[minutes])!.makeRound()):\(Int(self.arraySecDuration[seconds])!.makeRound())"
                }
                
            }
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
            let Rest = self.txtRest.text?.toTrim() ?? ""
            let Lvl = self.txtLvl.text?.toTrim() ?? ""
            let RPM = self.isShowRPM ? self.txtPercentage.text! : ""
            let Watt = self.isShowRPM ?  "" : self.txtPercentage.text!
            
            self.delegate?.ExerciseCardioCellFinish(index: self.tag, Laps: Laps, Speed: Speed, Pace: Pace, Percentage: Percentage, Duration: Duration, Distance: Distance, Rest: Rest, Lvl: Lvl, RPM: RPM, Watt: Watt)
        }
        else if pickerView == self.LvlPickerView{
            self.txtLvl.text = self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "")[row]
            self.lblLvl.text = self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "")[row]
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
            self.lblDuration.text = "\(hour.makeRound()):\(minutes.makeRound()):\(seconds.makeRound())"
            
            let Laps = "0" //self.txtLaps.text!
            let Speed = self.isShowSpeed ? self.txtSpeed.text! : ""
            let Pace = self.isShowSpeed ? "" : self.txtSpeed.text!
            let Duration = self.isShowDistance ? "" : self.txtDuration.text!
            let Distance = self.isShowDistance ? self.txtDuration.text! : ""
            let Percentage = self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
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
                return 120 - 5
            }else{
                let screen = (UIScreen.main.bounds.width - 50) / 3
                return CGFloat(screen)
            }
        }
        else {
            return CGFloat(120) - 5
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
