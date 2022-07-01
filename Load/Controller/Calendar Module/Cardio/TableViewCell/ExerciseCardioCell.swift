//
//  ExerciseCardioCell.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ExerciseCardioCellDelegate: AnyObject {
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
    
    var arrayHourDuration : [String] = [] {
        didSet {
            print("🍍 arrayHourDuration: ", arrayHourDuration)
        }
    }
    var arrayMinDuration : [String] = [] {
        didSet {
            print("🍍 arrayMinDuration: ", arrayMinDuration)
        }
    }
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
        
        self.txtSpeed.delegate = self
        self.txtPercentage.delegate = self
        self.txtDuration.delegate = self
        self.txtRest.delegate = self
        self.txtLvl.delegate = self
        self.txtCyclingOutdoorPercentage.delegate = self
        // Initialization code
        
        [pacePickerView, RPMPickerView, speedPickerView, RestPickerView, distancePickerView, LvlPickerView, durationPickerView, percentagePickerView].forEach { pickerView in
            pickerView.delegate = self
            pickerView.backgroundColor = .white
        }
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
        [txtSpeed, txtPercentage, txtDuration, txtRest, txtLvl, txtCyclingOutdoorPercentage].forEach { label in
            label?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            label?.setColor(color: .clear)
        }
        
        [lblSpeed, lblPercentage, lblDuration, lblRest, lblLvl, lblCyclingOutdoorPercentage].forEach { label in
            label?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            label?.setColor(color: .appthemeBlackColor)
        }
        
        changeHeaderAccordingToActivityName()
    }
    
    @IBAction func btnRemoveClicked(_ sender: Any) {
        self.delegate?.RemoveRowClicked(tag: self.tag)
    }
    
    func setDetails(model: CardioExerciseModelClass) {
        
        print("isEdit:\(isEdit)")

        txtDuration.placeholder = isShowDistance ? "00" : "00:00:00"
        txtDuration.text = isShowDistance ? model.distance : model.duration
        lblDuration.text = isShowDistance ? model.distance : model.duration
        
        txtSpeed.placeholder = isShowSpeed ? "00" : "00:00"
        txtSpeed.text = isShowSpeed ? model.speed : model.pace
        lblSpeed.text = isShowSpeed ? model.speed : model.pace
        
        txtPercentage.text = isShowRPM ? model.rpm : model.watt
        lblPercentage.text = isShowRPM ? model.rpm : model.watt
        
        txtLvl.text = model.lvl
        lblLvl.text = model.lvl
        
        if self.activityName == "Run (Outdoor)".lowercased() || self.activityName == "Run (Indoor)".lowercased() {
            self.txtPercentage.text = model.percentage
            self.lblPercentage.text = model.percentage
        }
        
        self.setupSpeed()
        
        //Remove dot and km from DistancePickerView
        reomveKmAndDotFromDistancePickerView()
        self.setupDistance()
        
        setupSpeedPickerView()
        
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
        
        self.txtRest.inputView = RestPickerView
        
        setupPacePickerView()

        if  self.activityName.lowercased() == "Run (Outdoor)".lowercased() ||  self.activityName.lowercased() == "Run (Indoor)".lowercased()
        {
            self.txtPercentage.inputView = percentagePickerView
            
        }else{
            self.txtPercentage.inputView = RPMPickerView
            if !isShowRPM{
                self.setCustomPickerForRPM(unit: "w")
            }
            else{
                self.setCustomPickerForRPM(unit: "")
            }
        }
        
        self.txtLvl.inputView = LvlPickerView
        
        if  self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() {
            
            self.txtCyclingOutdoorPercentage.placeholder = "0.0"
            
            self.txtCyclingOutdoorPercentage.text = model.percentage
            self.lblCyclingOutdoorPercentage.text = model.percentage
            self.txtCyclingOutdoorPercentage.inputView = percentagePickerView
            
        }
    }
    
    func setupPickerViewLabel(pickerView: UIPickerView, separator: String?, unit: String?) {
        pickerView.subviews.filter({$0.tag >= 100}).forEach({$0.removeFromSuperview()})
        
        let firstLabel = UILabel()
        firstLabel.text = separator
        firstLabel.frame = CGRect(x: 0.36 * UIScreen.main.bounds.width, y: (pacePickerView.frame.height - 30) / 2, width: 0.06 * UIScreen.main.bounds.width, height: 30)
        firstLabel.textAlignment = .center
        firstLabel.tag = 101
        firstLabel.font = themeFont(size: 21, fontname: .Regular)
        firstLabel.textColor = .appthemeRedColor
        
        let secondLabel = UILabel()
        secondLabel.text = unit
        secondLabel.frame = CGRect(x: 0.6 * UIScreen.main.bounds.width, y: (pacePickerView.frame.height - 30) / 2, width: 0.4 * UIScreen.main.bounds.width, height: 30)
        secondLabel.textAlignment = .left
        secondLabel.tag = 102
        secondLabel.textColor = .appthemeRedColor
        secondLabel.font = themeFont(size: 21, fontname: .Regular)
        
        pickerView.addSubview(firstLabel)
        pickerView.addSubview(secondLabel)
    }
    
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
    
    func setExerciseCardioCellFinish(percentage: String? = nil) {
        let Laps = "0"
        let Percentage = percentage ?? self.activityName.lowercased() == "Cycling (Outdoor)".lowercased() ? self.txtCyclingOutdoorPercentage.text ?? "" : self.txtPercentage.text!
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if self.selectedCardioValidationList == nil{
            makeToast(strMessage: getCommonString(key: "Please_fill_up_above_details_key"))
            return false
        }
        
        if textField == self.txtSpeed {
            if self.isShowSpeed {
                
                self.calculateSpeedArray(data: self.selectedCardioValidationList?.speedRange ?? "")
                
                if textField.text?.toTrim() == "" {
                    speedFirstScrollndex = 0
                    speedSecondScrollIndex = 0
                    
                    self.speedPickerView.selectRow(0, inComponent: 0, animated: false)
                    self.speedPickerView.selectRow(0, inComponent: 1, animated: false)
                }
                
                if self.txtSpeed.text?.contains(".") ?? false{

                    let arraySpeed = self.txtSpeed.text?.split(separator: ".")
                    if arraySpeed?.count == 2{

                        let firstIndex = self.arraySpeedFirstData.firstIndex(where: {$0 == String(arraySpeed?[0] ?? "0")})
                        let secondIndex = self.arraySpeedSecondData.firstIndex(where: {$0 == String(arraySpeed?[1] ?? "0")})

                        self.speedPickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                        self.speedPickerView.selectRow(secondIndex ?? 0, inComponent: 1, animated: false)

                        self.speedFirstScrollndex = firstIndex ?? 0
                        self.speedSecondScrollIndex = secondIndex ?? 0
                    }
                }
                
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
                if self.txtSpeed.text?.contains(":") ?? false {

                    let arrayPace = self.txtSpeed.text?.split(separator: ":")
                    if arrayPace?.count == 2{

                        let firstIndex = Int(String(arrayPace?[0] ?? "0"))
                        let secondIndex = Int(String(arrayPace?[1] ?? "0"))

                        self.pacePickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                        self.pacePickerView.selectRow(secondIndex ?? 0, inComponent: 1, animated: false)

                        self.minutesPace = firstIndex ?? 0
                        self.secPace = secondIndex ?? 0
                    }
                }
                self.txtSpeed.text = "\(minutesPace.makeRound()):\(secPace.makeRound())".toTrim()
                self.lblSpeed.text = "\(minutesPace.makeRound()):\(secPace.makeRound())".toTrim()
            }
            setExerciseCardioCellFinish()
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
                    let array = self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")
                    let firstIndex = array.firstIndex(where: {$0 == self.txtPercentage.text}) ?? 0
                    self.percentagePickerView.selectRow(firstIndex, inComponent: 0, animated: false)
                }else{
                    
                     if textField.text?.toTrim() == ""{
                        self.percentagePickerView.selectRow(0, inComponent: 1, animated: false)
                    }
                    
                    self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")
                    
                    if textField.text?.toTrim() == ""{
                        self.percentageFirstScrollIndex = 0
                        self.percentageSecondScrollInex = 0

                    }
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
                    
                    self.txtPercentage.text = "\(self.arrayPercentageFirstData[percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[percentageSecondScrollInex])"
                    self.lblPercentage.text = "\(self.arrayPercentageFirstData[percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[percentageSecondScrollInex])"
                    self.percentagePickerView.reloadAllComponents()
                }
                
                setExerciseCardioCellFinish(percentage: self.txtPercentage.text?.toTrim() ?? "")
            }else{
                
                if textField.text?.toTrim() == ""{
                    self.RPMPickerView.selectRow(0, inComponent: 0, animated: false)
                }
                
                if self.isShowRPM {
                    
                    if textField.text?.toTrim() == ""{
                        self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "").first ?? ""
                        self.lblPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "").first ?? ""
                    }
                    let array = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "")
                    let firstIndex = array.firstIndex(where: {$0 == self.txtPercentage.text}) ?? 0
                    self.RPMPickerView.selectRow(firstIndex, inComponent: 0, animated: false)
                    
                } else {
                    if textField.text?.toTrim() == ""{
                        self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "").first ?? ""
                        self.lblPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "").first ?? ""
                    }
                    let array = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "")
                    let firstIndex = array.firstIndex(where: {$0 == self.txtPercentage.text}) ?? 0
                    self.RPMPickerView.selectRow(firstIndex, inComponent: 0, animated: false)
                }
                self.RPMPickerView.reloadAllComponents()
                setExerciseCardioCellFinish(percentage: "")
            }
        } else if textField == self.txtCyclingOutdoorPercentage {
            
            reomveDotFromPercentagePickerView()
            
            if self.selectedCardioValidationList?.percentageRange.contains(",") ?? false
            {
                if textField.text?.toTrim() == ""{
                    self.percentagePickerView.selectRow(0, inComponent: 0, animated: false)

                    self.txtCyclingOutdoorPercentage.text = self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "").first ?? ""
                    self.lblCyclingOutdoorPercentage.text = self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "").first ?? ""
                }
                let array = self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")
                let firstIndex = array.firstIndex(where: {$0 == self.txtCyclingOutdoorPercentage.text}) ?? 0
                self.percentagePickerView.selectRow(firstIndex, inComponent: 0, animated: false)
            } else {
                self.calculatePercentageArray(data: self.selectedCardioValidationList?.percentageRange ?? "")
                if textField.text?.toTrim() == ""{
                    self.percentagePickerView.selectRow(0, inComponent: 0, animated: false)
                     self.percentagePickerView.selectRow(0, inComponent: 1, animated: false)
                    self.percentageFirstScrollIndex = 0
                    self.percentageSecondScrollInex = 0
                }
                
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
                
                self.txtCyclingOutdoorPercentage.text = "\(self.arrayPercentageFirstData[percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[percentageSecondScrollInex])"
                self.lblCyclingOutdoorPercentage.text = "\(self.arrayPercentageFirstData[percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[percentageSecondScrollInex])"
                self.percentagePickerView.reloadAllComponents()
            }
            
            setExerciseCardioCellFinish(percentage: self.txtCyclingOutdoorPercentage.text?.toTrim() ?? "")
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
                    let array = self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "")
                    let firstIndex = array.firstIndex(where: {$0 == self.txtDuration.text}) ?? 0
                    self.distancePickerView.selectRow(firstIndex, inComponent: 0, animated: false)
                 } else {
                    
                    self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "")
                    
                    if textField.text?.toTrim() == ""{
                        self.distanceFirstData = 0
                        self.distanceSecondData = 0
                        
                        self.distancePickerView.selectRow(0, inComponent: 0, animated: false)

                    }

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
                    
                    let arrayDuration = calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange ?? "", isShowHours: true)
                    
                    let firstIndex = arrayDuration.firstIndex(where: {$0 == String(self.txtDuration.text ?? "")})
                    print("FirstIndex:\(firstIndex) ")
                    
                    self.durationPickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)

                    
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
                        
                    let dataArray = txtDuration.text?.split(separator: ":")
                    
                    if dataArray?.count == 3{

                        let firstData = Int(dataArray?[0] ?? "0") ?? 0
                        let secondData = Int(dataArray?[1] ?? "0") ?? 0
                        let thirdData = Int(dataArray?[2] ?? "0") ?? 0

                        let firstIndex = self.arrayHourDuration.firstIndex(where: {$0 == String(firstData)})
                        let secondIndex = self.arrayMinDuration.firstIndex(where: {$0 == String(secondData)})
                        let thirdIndex = self.arraySecDuration.firstIndex(where: {$0 == String(thirdData)})

                        DispatchQueue.main.async {
                            self.durationPickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                            self.durationPickerView.selectRow(secondIndex ?? 0, inComponent: 1, animated: false)
                            self.durationPickerView.selectRow(thirdIndex ?? 0, inComponent: 2, animated: false)

                        }
                        
                        hour = firstIndex ?? 0
                        minutes = secondIndex ?? 0
                        seconds = thirdIndex ?? 0

                    }
                    
                    
                    if arrayHourDuration.count != 0 && arrayMinDuration.count != 0 && arraySecDuration.count != 0{
                        self.txtDuration.text = "\(Int(self.arrayHourDuration[hour])!.makeRound()):\(Int(self.arrayMinDuration[minutes])!.makeRound()):\(Int(self.arraySecDuration[seconds])!.makeRound())"
                        
                        self.lblDuration.text = "\(Int(self.arrayHourDuration[hour])!.makeRound()):\(Int(self.arrayMinDuration[minutes])!.makeRound()):\(Int(self.arraySecDuration[seconds])!.makeRound())"
                    }
                    
                    self.durationPickerView.reloadAllComponents()
                }
            }
            setExerciseCardioCellFinish()
            
        } else if textField == self.txtRest{
            
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
                    let arrayRest = calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange ?? "", isShowHours: false)
                    
                    let firstIndex = arrayRest.firstIndex(where: {$0 == String(self.txtRest.text ?? "")})
                    print("FirstIndex:\(firstIndex) ")
                    
                    self.RestPickerView.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                }
            }else{
                if textField.text?.toTrim() == ""{
                    self.RestPickerView.selectRow(0, inComponent: 1, animated: false)
                    minutesRest = 0
                    secRest = 0
                }
                
                calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange ?? "", isShowHours: false)
                    
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
                
                self.txtRest.text = "\(Int(self.arrayMinRest[minutesRest])!.makeRound()):\(Int(self.arraySecRest[secRest])!.makeRound())"
                self.lblRest.text = "\(Int(self.arrayMinRest[minutesRest])!.makeRound()):\(Int(self.arraySecRest[secRest])!.makeRound())"
                
            }
            
            self.RestPickerView.reloadAllComponents()
            setExerciseCardioCellFinish()
        }
        if textField == self.txtLvl {

            if textField.text?.toTrim() == "" {
                self.LvlPickerView.selectRow(0, inComponent: 0, animated: false)
                
                self.txtLvl.text = self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "").first
                self.lblLvl.text = self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "").first

            }
            let array = self.calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "")
            let firstIndex = array.firstIndex(where: {$0 == self.txtLvl.text}) ?? 0
            self.LvlPickerView.selectRow(firstIndex, inComponent: 0, animated: false)
            self.LvlPickerView.reloadAllComponents()
            setExerciseCardioCellFinish()
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
            setExerciseCardioCellFinish()
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
                
                setExerciseCardioCellFinish(percentage: self.txtPercentage.text?.toTrim() ?? "")
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
                setExerciseCardioCellFinish(percentage: "")
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
            
            setExerciseCardioCellFinish(percentage: self.txtCyclingOutdoorPercentage.text?.toTrim() ?? "")
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
            setExerciseCardioCellFinish()
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
            setExerciseCardioCellFinish()
        }
        else if textField == self.txtLvl {

            if self.txtLvl.text == "0" || self.txtLvl.text == "00" || self.txtLvl.text == "0.0"{
                self.txtLvl.text = ""
                self.lblLvl.text = ""
            }
            setExerciseCardioCellFinish()
        }
        
        
        
        return true
    }
    
    func showExerciseHeader() {
        self.viewPercentage.isHidden = false
    }
    
    func setupDistance() {
        if self.isShowDistance {
            self.txtDuration.inputView = distancePickerView
        }
        else {
            self.txtDuration.inputView = durationPickerView
        }
    }
    
    func setupSpeed() {
        if self.isShowSpeed {
            self.txtSpeed.inputView = speedPickerView
        }
        else {
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
                setupDistancePickerView()
                
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
    
    func reomveKmAndDotFromDistancePickerView(){
        distancePickerView.subviews.filter({$0.tag >= 100}).forEach({$0.removeFromSuperview()})
        
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
    
    func setupDistancePickerView() {
        setupPickerViewLabel(pickerView: distancePickerView, separator: ".", unit: "km")
    }
    
    func setupSpeedPickerView() {
        setupPickerViewLabel(pickerView: speedPickerView, separator: ".", unit: "km/hr")
    }
    
    func setupPacePickerView() {
        let pickerViewUnit: String
        
        if self.activityName.lowercased() == "Swimming".lowercased(){
            pickerViewUnit = "min/100 m"
        } else if self.activityName.lowercased() == "Others".lowercased(){
            pickerViewUnit = "min/500 m"
        } else {
            pickerViewUnit = "min/km"
        }
        
        setupPickerViewLabel(pickerView: pacePickerView, separator: ":", unit: pickerViewUnit)
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
        
        let label = UILabel()
        label.textAlignment = .center
        label.tag = 100
        label.font = themeFont(size: 21, fontname: .Regular)
        let x = DEVICE_TYPE.IS_IPHONE_6 ? 98 : 108
        label.frame = CGRect(x: (screenRest * CGFloat(0)) + CGFloat(x), y: (percentagePickerView.frame.height - 30) / 2, width: screenRest, height: 30)
        label.text = "."
        label.textColor = .appthemeRedColor
        self.percentagePickerView.addSubview(label)
        
    }

    func reomveDotFromPercentagePickerView(){
        
        if let viewWithTag = self.percentagePickerView.viewWithTag(100){
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
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
            label.font = themeFont(size: 21, fontname: .Regular)
            if index == 0 {
                label.frame = CGRect(x: 0.26 * UIScreen.main.bounds.width, y: (durationPickerView.frame.height - 30) / 2, width: 0.2 * UIScreen.main.bounds.width, height: 30)
                label.text = "hrs"
            }
            else if index == 1 {
                label.frame = CGRect(x: 0.5 * UIScreen.main.bounds.width, y: (durationPickerView.frame.height - 30) / 2, width: 0.2 * UIScreen.main.bounds.width, height: 30)
                label.text = "min"
            }
            else {
                label.frame = CGRect(x: 0.72 * UIScreen.main.bounds.width, y: (durationPickerView.frame.height - 30) / 2, width: 0.2 * UIScreen.main.bounds.width, height: 30)
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

// MARK: UIPickerViewDelegate
extension ExerciseCardioCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.distancePickerView {
            if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                return 1
            }else{
                return 3
            }
        }
        else if pickerView == self.speedPickerView {
            return 3
        }
        else if pickerView == self.pacePickerView {
            return 3
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
            if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                return self.calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "").count
            }else{
                switch component {
                case 0:
                    return arrayDistanceFirstData.count
                case 1:
                    return self.arrayDistanceSecondData.count
                default:
                    return 0
                }
            }
            
        }
        else if pickerView == self.speedPickerView {
            switch component {
            case 0:
                return self.arraySpeedFirstData.count
            case 1:
                return self.arraySpeedSecondData.count
            default:
                return 0
            }
        }
        else if pickerView == self.pacePickerView {
            switch component {
            case 0, 1:
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
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let pickerTitle: String
        
        switch pickerView {
        case distancePickerView:
            if (self.selectedCardioValidationList?.distanceRange.contains("|") ?? false) {
                pickerTitle = calculateDistanceArray(data: self.selectedCardioValidationList?.distanceRange ?? "")[row]
            } else {
                pickerTitle = component == 0 ? arrayDistanceFirstData[row] : arrayDistanceSecondData[row]
            }
        case speedPickerView:
            pickerTitle = component == 0 ? arraySpeedFirstData[row] : arraySpeedSecondData[row]
        case pacePickerView:
            pickerTitle = "\(row)"
        case RPMPickerView:
            let rpmWattData = component == 0 ? (selectedCardioValidationList?.rpmRange ?? "") : (selectedCardioValidationList?.wattRange ?? "")
            pickerTitle = calculateRPMWAttArray(data: rpmWattData)[row]
        case percentagePickerView:
            if selectedCardioValidationList?.percentageRange.contains(",") ?? false {
                pickerTitle = calculatePercentageArray(data: selectedCardioValidationList?.percentageRange ?? "")[row]
            } else {
                pickerTitle = component == 0 ? arrayPercentageFirstData[row] : arrayPercentageSecondData[row]
            }
        case RestPickerView:
            if selectedCardioValidationList?.restRange.contains(",") ?? false || selectedCardioValidationList?.restRange == "00:00" {
                pickerTitle = calculateRestArrayWithGap(data: self.selectedCardioValidationList?.restRange, isShowHours: false)[row]
            } else {
                pickerTitle = component == 0 ? arrayMinRest[row] : arraySecRest[row]
            }
        case durationPickerView:
            if self.selectedCardioValidationList?.durationRange.contains(",") ?? false {
                pickerTitle = calculateDurationArrayWithGap(data: self.selectedCardioValidationList?.durationRange, isShowHours: true)[row]
            } else {
                if component == 0 {
                    #warning("Duration Picker View")
                    pickerTitle = arrayHourDuration[row]
                } else if component == 1 {
                    pickerTitle = arrayMinDuration[row]
                } else {
                    pickerTitle = arraySecDuration[row]
                }
            }
        case LvlPickerView:
            pickerTitle = calculateLvlArray(data: self.selectedCardioValidationList?.lvlRange ?? "")[row]
        default:
            pickerTitle = "\(row)"
        }
        
        let attributedString = NSAttributedString(string: pickerTitle, attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
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
            
            setExerciseCardioCellFinish()
        }
        else if pickerView == self.speedPickerView {
            
            if component == 0 {
                self.speedFirstScrollndex = row
            } else if component == 1 {
                self.speedSecondScrollIndex = row
            }
            
            self.txtSpeed.text = "\(self.arraySpeedFirstData[self.speedFirstScrollndex]).\(self.arraySpeedSecondData[self.speedSecondScrollIndex])"
            self.lblSpeed.text = "\(self.arraySpeedFirstData[self.speedFirstScrollndex]).\(self.arraySpeedSecondData[self.speedSecondScrollIndex])"
            
            setExerciseCardioCellFinish()
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
            
            setExerciseCardioCellFinish()
        }
        else if pickerView == self.RPMPickerView {
            
            if self.isShowRPM{
                self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "")[row]
                self.lblPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.rpmRange ?? "")[row]
            }else{
                self.txtPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "")[row]
                self.lblPercentage.text = self.calculateRPMWAttArray(data: self.selectedCardioValidationList?.wattRange ?? "")[row]
            }
            
            setExerciseCardioCellFinish(percentage: "")
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
                if component == 0{
                    self.percentageFirstScrollIndex = row
                } else {
                    self.percentageSecondScrollInex = row
                }
                
                let percentageText =  "\(self.arrayPercentageFirstData[self.percentageFirstScrollIndex]).\(self.arrayPercentageSecondData[self.percentageSecondScrollInex])"
                
                if self.activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
                    self.txtCyclingOutdoorPercentage.text = percentageText
                    self.lblCyclingOutdoorPercentage.text = percentageText
                } else {
                    self.txtPercentage.text = percentageText
                    self.lblPercentage.text = percentageText
                }
            }
            
            if self.activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
                setExerciseCardioCellFinish(percentage: txtCyclingOutdoorPercentage.text?.toTrim() ?? "")
            } else {
                setExerciseCardioCellFinish(percentage: txtPercentage.text?.toTrim() ?? "")
            }
            
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
            
        
            setExerciseCardioCellFinish()
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
            setExerciseCardioCellFinish()
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
            
            setExerciseCardioCellFinish()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch pickerView {
        case durationPickerView:
            if let list = selectedCardioValidationList,
                list.durationRange.contains(",") {
                return 120 - 5
            } else {
                return 0.22 * (UIScreen.main.bounds.width)
            }
        case pacePickerView, speedPickerView, distancePickerView:
            switch component {
           
            case 2:
                return 0.2 * (UIScreen.main.bounds.width)
            default:
                return 0.2 * (UIScreen.main.bounds.width)
            }
        default:
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
