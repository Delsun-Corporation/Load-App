//
//  ExerciseResistanceCell.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol AddSubRowDelegate: class {
    func AddRowClicked(section:Int)
    func RemoveRowClicked(row:Int, section:Int)
    func ExerciseResistanceCellFinish(index:Int, section: Int, Weight:String, Reps:String, Duration:String, Rest:String)
    func showAlertForSaveInLibrary(reps:String, weight: String)
}

class ExerciseResistanceCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtReps: UITextField!
    @IBOutlet weak var txtRest: UITextField!
    
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var imgAdd: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var viewLIne: UIView!
    
    weak var delegate: AddSubRowDelegate?
    var index:Int = 0
    let pickerViewWeight = UIPickerView()
    
    
    let pickerViewReps = UIPickerView()
    let pickerViewDuration = UIPickerView()
    let pickerViewRest = UIPickerView()
    let pickerViewRestCustom = UIPickerView()
    let pickerViewRepsCustom = UIPickerView()
    let pickerViewDurationCustom = UIPickerView()
    
    let pickerViewDurationSimple = UIPickerView()
    let pickerViewWCustomWeightSelection = UIPickerView()
    
    var selectedResistanceValidationList: ResistanceValidationListData?
    var selectedResistanceWeightList : [RepetitionMax]?
    var arrayRequiredWeight = [String]()
    var isWeightCustom:Bool = false
    var strCustomTrainingGoal = ""
    var arrayDecimalForCustomTrainingGoal = Array(stride(from: 0, to: 10, by: 1))
    var firstComponent : Int = 0
    var secondComponent : Int = 0

    var isRepsCustom:Bool = false
    var isRestCustom:Bool = false
    var isRestCustomOpend:Bool = false
    var isRepsCustomOpend:Bool = false

    var isRestCustomMinute:Int = 0
    var isRestCustomSec:Int = 0

    var isRapsCustomMinute:Int = 0
    var isRapsCustomSec:Int = 0
    
    var isDurationMinute:Int = 0
    var isDurationSec:Int = 0
    
    var isDurationCustomMinute:Int = 0
    var isDurationCustomSec:Int = 0

    var isDurationSelected: Bool = true
    let labelDurationMin = UILabel()
    let labelDurationSec = UILabel()
    
    var arrayMinuteForRestCustome = [Int]()
    var arraySecondForRestCustome =  Array(stride(from: 0, to: 60, by: 1))
//    var arraySecondForRestCustome =  Array(stride(from: 0, to: 60, by: 15))
    var minuteComponentForCustome : Int = 0
    var secondComponentForCustome : Int = 0
    
    var arrayMinuteForDurationCustom = [Int]()
    var arraySecondForDuratonCustom = Array(stride(from: 0, to: 60, by: 1))
//    var arraySecondForDuratonCustom = Array(stride(from: 0, to: 60, by: 5))
    var minuteComponentForDurationCustome : Int = 0
    var secondComponentForDurationCustome : Int = 0
    
    var isSelectedCustomWeight : Bool = false
    var isShowAlertOrNot  : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtWeight.delegate = self
        
//        self.txtReps.delegate = self
//        self.txtRest.delegate = self
        
        pickerViewWeight.delegate = self
        pickerViewWeight.backgroundColor = UIColor.white
        
        pickerViewReps.delegate = self
        pickerViewReps.backgroundColor = UIColor.white
        
        pickerViewRest.delegate = self
        pickerViewRest.backgroundColor = UIColor.white
        
        let screenRest = UIScreen.main.bounds.width / 2
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 65 : 75
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (pickerViewRestCustom.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "min"
            }
            else {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (pickerViewRestCustom.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "sec"
            }
            label.textColor = .appthemeRedColor
            self.pickerViewRestCustom.addSubview(label)
        }
        
        pickerViewRestCustom.delegate = self
        pickerViewRestCustom.backgroundColor = UIColor.white
        
        //Custom Selection Weight
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 98 : 108
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (pickerViewWCustomWeightSelection.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "."
            }
            else {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (pickerViewWCustomWeightSelection.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "Kg"
            }
            label.textColor = .appthemeRedColor
            self.pickerViewWCustomWeightSelection.addSubview(label)
        }
        
        pickerViewWCustomWeightSelection.delegate = self
        pickerViewWCustomWeightSelection.backgroundColor = UIColor.white
        
        let screenDuration = UIScreen.main.bounds.width / 2
        
        //TODO: - add partation in custom
        for index in 0..<2 {
            if index == 0 {
//                labelDurationMin.textAlignment = .center
//                labelDurationMin.font = label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
                
//                let x = DEVICE_TYPE.IS_IPHONE_6 ? 65 : 75
//                labelDurationMin.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (pickerViewRestCustom.frame.height - 30) / 2, width: screenDuration, height: 30)
//                labelDurationMin.text = "min"
//
//                labelDurationMin.textColor = .appthemeRedColor
//                self.pickerViewDuration.addSubview(labelDurationMin)
            }
            else {
                labelDurationSec.textAlignment = .center
                labelDurationSec.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
                
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 40 : 38
                labelDurationSec.frame = CGRect(x: (screenRest) - CGFloat(x), y: (pickerViewDurationSimple.frame.height - 30) / 2, width: screenDuration, height: 30)
                labelDurationSec.text = "mins"
                labelDurationSec.textColor = .appthemeRedColor
                self.pickerViewDurationSimple.addSubview(labelDurationSec)
            }
        }
        
        pickerViewDuration.delegate = self
        pickerViewDuration.backgroundColor = UIColor.white
        
        pickerViewDurationSimple.delegate = self
        pickerViewDurationSimple.backgroundColor = UIColor.white
        
        let screenDurationCustom = UIScreen.main.bounds.width / 2
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 65 : 75
                label.frame = CGRect(x: (screenDurationCustom * CGFloat(index)) + CGFloat(x), y: (pickerViewDurationCustom.frame.height - 30) / 2, width: screenDurationCustom, height: 30)
                label.text = "min"
            }
            else {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
                label.frame = CGRect(x: (screenDurationCustom * CGFloat(index)) - CGFloat(x), y: (pickerViewDurationCustom.frame.height - 30) / 2, width: screenDurationCustom, height: 30)
                label.text = "sec"
            }
            label.textColor = .appthemeRedColor
            self.pickerViewDurationCustom.addSubview(label)
        }
        
        pickerViewDurationCustom.delegate = self
        pickerViewDurationCustom.backgroundColor = UIColor.white
        
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 65 : 75
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (pickerViewRepsCustom.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "min"
            }
            else {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (pickerViewRepsCustom.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "sec"
            }
            label.textColor = .appthemeRedColor
            self.pickerViewRepsCustom.addSubview(label)
        }
        
        pickerViewRepsCustom.delegate = self
        pickerViewRepsCustom.backgroundColor = UIColor.white
        
        self.txtWeight.inputView = pickerViewWeight
//        self.txtReps.inputView = pickerView
//        self.txtRest.inputView = pickerView
        self.setRest()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setupUI()
        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.txtWeight.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtReps.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtRest.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.txtWeight.setColor(color: .appthemeBlackColor)
        self.txtReps.setColor(color: .appthemeBlackColor)
        self.txtRest.setColor(color: .appthemeBlackColor)
    }
    
    func setDetails(model: ResistanceExerciseModelClass) {
     
        self.txtWeight.text = model.weight
        
        if model.reps != nil && model.reps != ""{
            self.txtReps.text = model.reps
        }else if model.duration != nil && model.duration != ""{
            self.txtReps.text = model.duration
        }else{
            self.txtReps.text = ""
            self.txtWeight.text = ""
        }
         
        self.txtRest.text = model.rest
        
        if self.isDurationSelected {
             minuteComponentForDurationCustome = 0
             secondComponentForDurationCustome = 0
            
            self.txtReps.placeholder = "00:00"
            self.setDuration()
        }
        else {
            self.txtReps.placeholder = "00"
            self.setReps()
        }
        
        firstComponent = 0
        secondComponent = 0
        
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        
        self.delegate?.AddRowClicked(section: self.tag)
    }
    
    @IBAction func btnRemoveClicked(_ sender: Any) {
        self.delegate?.RemoveRowClicked(row: self.index, section: self.tag)
    }
    
    //MARK:- TextField delegate
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        print("Data:\(self.selectedResistanceValidationList?.toJSON())")
        
        if selectedResistanceValidationList == nil{
            return false
        }
        
        textField.textAlignment = .center
        
        if  textField == self.txtWeight{
            
            if txtReps.text?.toTrim() == ""{
                
                if !isDurationSelected{
                    makeToast(strMessage: getCommonString(key: "Please_fill_in_the_Reps_first_key"))
                    return false
                }
            }
            
            self.getArrayFromWeightList()
            if (self.selectedResistanceWeightList?.count != 0 || self.selectedResistanceWeightList != nil) && !isWeightCustom {
                self.pickerViewWeight.reloadAllComponents()
                
                if textField.text?.toTrim() == ""{
                    self.pickerViewWeight.selectRow(0, inComponent: 0, animated: true)
                    self.txtWeight.text = self.arrayRequiredWeight.first ?? ""
                }
                
                let firstIndex = arrayRequiredWeight.firstIndex(where: {$0 == self.txtWeight.text}) ?? 0
                self.pickerViewWeight.selectRow(firstIndex, inComponent: 0, animated: false)
                
            }
            
        }
        
        if textField == self.txtWeight {
            
            if self.selectedResistanceValidationList?.weightRange?.contains("|") ?? false && self.arrayRequiredWeight.count == 0{
                
                if textField.text?.toTrim() == ""{
                    self.pickerViewWeight.selectRow(0, inComponent: 0, animated: true)
                    self.pickerViewWeight.selectRow(0, inComponent: 1, animated: true)
                    
                    self.firstComponent = 0
                    self.secondComponent = 0
                }
                
                if self.txtWeight.text?.contains(".") ?? false{

                    let arrayWeigt = self.txtWeight.text?.split(separator: ".")
                    if arrayWeigt?.count == 2{

                        let firstIndex = Int(arrayWeigt?[0] ?? "")
                        let secondIndex = self.arrayDecimalForCustomTrainingGoal.firstIndex(where: {$0 == Int(arrayWeigt?[1] ?? "")})

                        print("FirstIndex:\(firstIndex) : secondINdex:\(secondIndex)")

                        self.pickerViewWeight.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                        self.pickerViewWeight.selectRow(secondIndex ?? 0, inComponent: 1, animated: false)

                        self.firstComponent = firstIndex ?? 0
                        self.secondComponent = secondIndex ?? 0
                        
                    }
                }
                
                self.txtWeight.text = "\(firstComponent).\(secondComponent)"
            }else{
                
                if (self.selectedResistanceWeightList?.count == 0 || self.selectedResistanceWeightList == nil) && !isWeightCustom
                {
                    
                    if textField.text?.toTrim() == ""{
                        
                        self.pickerViewWeight.selectRow(0, inComponent: 0, animated: true)
                        self.txtWeight.text = calculateDistanceArray(data: self.selectedResistanceValidationList?.weightRange ?? "").first ?? "0"
                    }
                    
                    let array = self.calculateDistanceArray(data: self.selectedResistanceValidationList?.weightRange ?? "")
                    let firstIndex = array.firstIndex(where: {$0 == self.self.txtWeight.text}) ?? 0
                    self.pickerViewWeight.selectRow(firstIndex, inComponent: 0, animated: false)

                }
                else{
                   // if !isWeightCustom{
                    
                    if textField.text?.toTrim() == ""{
                        self.txtWeight.text = self.arrayRequiredWeight.first ?? ""
                        self.pickerViewWeight.selectRow(0, inComponent: 0, animated: true)
                    }
                    
                    if !isWeightCustom{
                        let firstIndex = arrayRequiredWeight.firstIndex(where: {$0 == self.self.txtWeight.text}) ?? 0
                        self.pickerViewWeight.selectRow(firstIndex, inComponent: 0, animated: false)
                    }
                    
                    self.pickerViewWeight.reloadAllComponents()
                    
                   // }
                }
            }
            
            var weight = ""
            
            if self.txtWeight.text == "0.0"{
                weight = ""
            }else{
                weight = self.txtWeight.text ?? ""
            }

            
//            let weight = self.txtWeight.text ?? ""
            let reps = self.isDurationSelected ? "" : self.txtReps.text ?? ""
            let duration = self.isDurationSelected ? self.txtReps.text ?? "" : ""
            let rest = self.txtRest.text ?? ""

            self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: weight, Reps: reps, Duration: duration, Rest: rest)
        }
        else if textField == self.txtReps {
            
//            if txtWeight.text?.toTrim() != ""{
            
                if isSelectedCustomWeight{
                    
                    if !self.isDurationSelected{
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
                            
                            self.delegate?.showAlertForSaveInLibrary(reps: self.txtReps.text ?? "", weight: self.txtWeight.text ?? "")
                            
                        }
                        
                        if !self.isShowAlertOrNot{
                            return false
                        }
                    }
            }

            if  !isRepsCustom{
                
                if self.isDurationSelected {
                    
                    
                    if textField.inputView == self.pickerViewDurationSimple { // Use only for Masacular Endruance (Long)
                        
                        pickerViewDurationSimple.reloadAllComponents()
                        
                        //Old
                        //                    self.txtReps.text = calculateDurationArray(data: self.selectedResistanceValidationList?.repsTimeRange ?? "").first
                        //New
                        
                        if textField.text?.toTrim() == ""{
                            self.pickerViewDurationSimple.selectRow(0, inComponent: 0, animated: true)
                            self.txtReps.text = (calculateDurationArrayWith5SecGap(data: self.selectedResistanceValidationList?.durationRange ?? "", isShowHours: false).first ?? "")
                        }
                        
                        
                        let array = calculateDurationArrayWith5SecGap(data: self.selectedResistanceValidationList?.durationRange ?? "", isShowHours: false)
                        let firstIndex = array.firstIndex(where: {$0 == textField.text}) ?? 0
                        self.pickerViewDurationSimple.selectRow(firstIndex, inComponent: 0, animated: false)

                        
                    }
                    else {
                        //                    self.txtReps.text = "00:00"
                        
                        if let viewWithDifferentTag = self.pickerViewDuration.viewWithTag(100) {
                            viewWithDifferentTag.removeFromSuperview()
                        }else{
                            print("No!")
                        }
                        
                        if let viewWithDifferentTag = self.pickerViewDuration.viewWithTag(101) {
                            viewWithDifferentTag.removeFromSuperview()
                        }else{
                            print("No!")
                        }
                        
                        if textField.text?.toTrim() == ""{
                            self.pickerViewDuration.selectRow(0, inComponent: 0, animated: true)
                        }

                        pickerViewDuration.reloadAllComponents()
                        
                        if self.strCustomTrainingGoal.lowercased() == "customize".lowercased(){
                            calculateDurationArrayForDurationCustomise(data:self.selectedResistanceValidationList?.durationRange ?? "",isShowHours: false)
                            self.setCustomPickerForDurationCustom()
                            
                            if textField.text?.toTrim() == ""{
                                self.pickerViewDuration.selectRow(0, inComponent: 0, animated: true)
                                self.pickerViewDuration.selectRow(0, inComponent: 1, animated: true)
                                minuteComponentForDurationCustome = 0
                                secondComponentForDurationCustome = 0

                            }

                            if textField.text?.contains(":") ?? false{

                                let arrayDuration = textField.text?.split(separator: ":")
                                if arrayDuration?.count == 2{

                                    let firstIndex = self.arrayMinuteForDurationCustom.firstIndex(where: {$0 == Int(String(arrayDuration?[0] ?? "0"))})
                                    let secondIndex = self.arraySecondForDuratonCustom.firstIndex(where: {$0 == Int(String(arrayDuration?[1] ?? "0"))})

                                    print("FirstIndex:\(firstIndex) : secondINdex:\(secondIndex)")

                                    self.pickerViewDuration.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                                    self.pickerViewDuration.selectRow(secondIndex ?? 0, inComponent: 1, animated: false)

                                    self.minuteComponentForDurationCustome = firstIndex ?? 0
                                    self.secondComponentForDurationCustome = secondIndex ?? 0
                                    
                                }
                            }

                            self.txtReps.text = self.arrayMinuteForDurationCustom[minuteComponentForDurationCustome].makeRound() + ":" + self.arraySecondForDuratonCustom[secondComponentForDurationCustome].makeRound()
                            
                        }else{
                            
                            
                            if textField.text?.toTrim() == ""{
                                self.pickerViewDurationSimple.selectRow(0, inComponent: 0, animated: false)
                                self.txtReps.text = (calculateDurationArrayWith5SecGap(data: self.selectedResistanceValidationList?.durationRange ?? "", isShowHours: false).first ?? "")
                            }

                            minuteComponentForDurationCustome = 0
                            secondComponentForDurationCustome = 0
                            
                            pickerViewDuration.reloadAllComponents()
                            setPickerForDuration()
                            
                            let array = calculateDurationArrayWith5SecGap(data: self.selectedResistanceValidationList?.durationRange ?? "", isShowHours: false)
                            let firstIndex = array.firstIndex(where: {$0 == textField.text}) ?? 0
                            self.pickerViewDurationSimple.selectRow(firstIndex, inComponent: 0, animated: false)

                        }
                        
                    }
                    //                self.txtReps.text = calculateDistanceArray(data: self.selectedResistanceValidationList?.repsRange ?? "", isWeight: false).first ?? "0"
                }
                else {
                    
                    if textField.text?.toTrim() == ""{
                        self.pickerViewReps.selectRow(0, inComponent: 0, animated: true)
                        self.txtReps.text = calculateDistanceArray(data: self.selectedResistanceValidationList?.repsRange ?? "", isWeight: false).first ?? "0"
                    }
                    
                    self.pickerViewReps.reloadAllComponents()
                    
                    let array = calculateDistanceArray(data: self.selectedResistanceValidationList?.repsRange ?? "", isWeight: false)
                    let firstIndex = array.firstIndex(where: {$0 == textField.text}) ?? 0
                    self.pickerViewReps.selectRow(firstIndex, inComponent: 0, animated: false)

                    
                    if self.strCustomTrainingGoal.lowercased() != "customize".lowercased(){
                        self.txtWeight.text = self.changesRepsAndGetWeight(strSelectedReps: self.txtReps.text ?? "")
                    }
//                    self.txtWeight.text = self.changesRepsAndGetWeight(strSelectedReps: self.txtReps.text ?? "")
                }
                
                var duration = ""

                if isDurationSelected{
                    if self.txtReps.text == "00:00"{
                        duration = ""
                    }else{
                        duration = self.txtReps.text ?? ""
                    }
                }
                
                let weight = self.txtWeight.text ?? ""
                let reps = self.isDurationSelected ? "" : self.txtReps.text ?? ""
//                let duration = self.isDurationSelected ? self.txtReps.text ?? "" : ""
                let rest = self.txtRest.text ?? ""
                self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: weight, Reps: reps, Duration: duration, Rest: rest)
                
            }
                
           // }
            
        }
        else if textField == self.txtRest {
            
            if isSelectedCustomWeight{
                
                if !self.isDurationSelected{
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.2) {
                        
                        self.delegate?.showAlertForSaveInLibrary(reps: self.txtReps.text ?? "", weight: self.txtWeight.text ?? "")
                    }
                    if !self.isShowAlertOrNot{
                        return false
                    }
                }
                
            }
            
            if !isRestCustom {
                
                if let viewWithDifferentTag = self.pickerViewRest.viewWithTag(100) {
                    viewWithDifferentTag.removeFromSuperview()
                }else{
                    print("No!")
                }
                
                if let viewWithDifferentTag = self.pickerViewRest.viewWithTag(101) {
                    viewWithDifferentTag.removeFromSuperview()
                }else{
                    print("No!")
                }
                
                if self.strCustomTrainingGoal.lowercased() == "customize".lowercased(){
                    calculateDurationArrayForRestCustomise(data:self.selectedResistanceValidationList?.restRange ?? "")
                    setCustomPickerForRestCustom()
                    
                    if textField.text?.toTrim() == ""{
                        self.pickerViewRest.selectRow(0, inComponent: 0, animated: true)
                        self.pickerViewRest.selectRow(0, inComponent: 1, animated: true)
                    }

                    if textField.text?.contains(":") ?? false{

                        let arrayRestCustom = textField.text?.split(separator: ":")
                        if arrayRestCustom?.count == 2{

                            let firstIndex = self.arrayMinuteForRestCustome.firstIndex(where: {$0 == Int(String(arrayRestCustom?[0] ?? "0"))})
                            let secondIndex = self.arraySecondForRestCustome.firstIndex(where: {$0 == Int(String(arrayRestCustom?[1] ?? "0"))})

                            print("FirstIndex:\(firstIndex) : secondINdex:\(secondIndex)")

                            self.pickerViewRest.selectRow(firstIndex ?? 0, inComponent: 0, animated: false)
                            self.pickerViewRest.selectRow(secondIndex ?? 0, inComponent: 1, animated: false)

                            self.minuteComponentForCustome = firstIndex ?? 0
                            self.secondComponentForCustome = secondIndex ?? 0
                            
                        }
                    }

                    
                    self.txtRest.text =  self.arrayMinuteForRestCustome[minuteComponentForCustome].makeRound() + ":" + self.arraySecondForRestCustome[secondComponentForCustome].makeRound()
                    
                }else{
                    
                    if textField.text?.toTrim() == ""{
                        self.pickerViewRest.selectRow(0, inComponent: 0, animated: true)
                        minuteComponentForCustome = 0
                        secondComponentForCustome = 0
                        
                        self.txtRest.text = calculateDurationArray(data: self.selectedResistanceValidationList?.restRange ?? "",isShowHours: false).first ?? "0"

                    }
                    
                    
                    let array = calculateDurationArray(data: self.selectedResistanceValidationList?.restRange ?? "",isShowHours: false)
                    let firstIndex = array.firstIndex(where: {$0 == textField.text}) ?? 0
                    self.pickerViewRest.selectRow(firstIndex, inComponent: 0, animated: false)

                    
                    setPickerForRest()
                }
                
                var rest = ""

                    if self.txtRest.text == "00:00"{
                        rest = ""
                    }else{
                        rest = self.txtRest.text ?? ""
                    }
                
                let weight = self.txtWeight.text ?? ""
                let reps = self.isDurationSelected ? "" : self.txtReps.text ?? ""
                let duration = self.isDurationSelected ? self.txtReps.text ?? "" : ""
//                let rest = self.txtRest.text ?? ""
                self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: weight, Reps: reps, Duration: duration, Rest: rest)
            }
           
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
//        let allowedCharacters = CharacterSet.decimalDigits
//        let characterSet = CharacterSet(charactersIn: string)
//        let isNumber = allowedCharacters.isSuperset(of: characterSet)
//        if !isNumber {
//            return false
//        }
//        
//        let weight = self.txtWeight.text!
//        let reps = self.txtReps.text!
//        let rest = self.txtRest.text!
//        
//        if textField == self.txtWeight {
//            if (txtAfterUpdate != "" && Double(txtAfterUpdate)! > 999) {
//                return false
//            }
//            self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: txtAfterUpdate, Reps: reps, Rest: rest)
//        }
        if textField == self.txtReps {
            let weight = self.txtWeight.text ?? ""
            let reps = self.isDurationSelected ? "" : txtAfterUpdate
            let duration = self.isDurationSelected ? txtAfterUpdate : ""
            let rest = self.txtRest.text ?? ""
            self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: weight, Reps: reps, Duration: duration, Rest: rest)
        }
        else if textField == self.txtRest {
//            let weight = self.txtWeight.text ?? ""
//            let reps = self.txtReps.text ?? ""
//            let rest = txtAfterUpdate
//            self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: weight, Reps: reps, Rest: rest)
        }
//        else if textField == self.txtWeight{
//
//            let weight = self.txtWeight.text ?? ""
//            let reps = self.isDurationSelected ? "" : self.txtReps.text ?? ""
//            let duration = self.isDurationSelected ? self.txtReps.text ?? "" : ""
//            let rest = self.txtRest.text ?? ""
//
//            self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: weight, Reps: reps, Duration: duration, Rest: rest)
//        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtWeight{
//            self.isWeightCustom = false
        //
//            if self.isWeightCustom && isSelectedCustomWeight{
//                self.setWeight(isSet: true)
//              //  isSelectedCustomWeight = false
//                return true
//            }
            
            if textField.text == "0.0"{
                self.txtWeight.text = ""
                
                if isSelectedCustomWeight{
                    isSelectedCustomWeight = false
                    
                    if isWeightCustom{
                        self.setWeight(isSet: true)
                    }
                }
            }
//
            if isSelectedCustomWeight{
                
                if textField.text?.toTrim() != "" || textField.text?.toTrim().count != 0 {
                    isSelectedCustomWeight = false
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                        
                        if !self.isDurationSelected{
                            self.delegate?.showAlertForSaveInLibrary(reps: self.txtReps.text ?? "", weight: self.txtWeight.text ?? "")
                        }
                    }
                    
                    if isWeightCustom{
                        
                        let weight = self.txtWeight.text ?? ""
                        let reps = self.isDurationSelected ? "" : self.txtReps.text ?? ""
                        let duration = self.isDurationSelected ? self.txtReps.text ?? "" : ""
                        let rest = self.txtRest.text ?? ""
                        
                        self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: weight, Reps: reps, Duration: duration, Rest: rest)
                        
                         self.setWeight(isSet: true)
                    }
                    
                    return true
                    
                }
            }
            
            let weight = self.txtWeight.text ?? ""
            let reps = self.isDurationSelected ? "" : self.txtReps.text ?? ""
            let duration = self.isDurationSelected ? self.txtReps.text ?? "" : ""
            let rest = self.txtRest.text ?? ""
            
            self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: weight, Reps: reps, Duration: duration, Rest: rest)

//            else{
//                self.isSelectedCustomWeight = false
//            }
        }
        if textField == self.txtReps && (textField.inputView == self.pickerViewDuration || textField.inputView == self.pickerViewDurationCustom) {
            
    //        self.isSelectedCustomWeight = false
            
            if textField.text == "00:00"{
                self.txtReps.text = ""
            }
            
            let weight = self.txtWeight.text ?? ""
            let reps = self.isDurationSelected ? "" : self.txtReps.text ?? ""
            let duration = self.isDurationSelected ? self.txtReps.text ?? "" : ""
            let rest = self.txtRest.text ?? ""
            
            self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: weight, Reps: reps, Duration: duration, Rest: rest)

            self.isRepsCustomOpend = false
            self.setDuration()
        }
        else if textField == self.txtReps && textField.inputView == self.pickerViewDurationSimple {
    //        self.isSelectedCustomWeight = false
            
            self.setDuration(isSet: false)
        }
        else if textField == self.txtReps {
   //         self.isSelectedCustomWeight = false
            
            self.setReps(isSet: true)
        }
        else if textField == self.txtRest  {
            
    //        self.isSelectedCustomWeight = false
            
            if textField.text == "00:00"{
                self.txtRest.text = ""
            }
            
            if self.isRestCustomOpend{
                self.isRestCustomOpend = false
                self.setRest(isSet: true)
            }
            
            let weight = self.txtWeight.text ?? ""
            let reps = self.isDurationSelected ? "" : self.txtReps.text ?? ""
            let duration = self.isDurationSelected ? self.txtReps.text ?? "" : ""
            let rest = self.txtRest.text ?? ""
            textField.text = rest
            self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: weight, Reps: reps, Duration: duration, Rest: rest)
        }
        
//        if isSelectedCustomWeight{
//            self.endEditing(true)
//            return true
//        }else{
            return true
//        }
    }
    
    func calculateDistanceArray(data:String?, isWeight:Bool = true) -> [String] {
        if !(data!.contains(":")) {
            var array: [String] = []
            
            if data?.contains("|") ?? false{

            }
            
            let dataArray = data?.split(separator: "-")
            if dataArray?.count == 2 {
                let first = dataArray?.first?.replacingOccurrences(of: "km", with: "").toTrim()
                let second = dataArray?[1].replacingOccurrences(of: "km", with: "").toTrim()
                let firstDouble = (Double(first ?? "0") ?? 0)
                
                let data1 = firstDouble.rounded(toPlaces: 0)
                let data2 = firstDouble.rounded(toPlaces: 2)
                let final = data2 - data1
                if final != 0 {
                    array.append((first ?? "").replace(target: ".0", withString: ""))
                }
                let secondDouble = (Double(second ?? "0") ?? 0)
                let end = (Int(Double(second ?? "0") ?? 0)) + 1
                for index in 0..<end {
                    if Double(index) >= firstDouble && Double(index) <= secondDouble{
                        array.append(String(Double(index)).replace(target: ".0", withString: ""))
                    }
                }
                if !isWeight {
                    //TODO: - Yash Changes
                    if self.strCustomTrainingGoal.lowercased() == "customize"{
                       // array.append("Customize")
                    }
                }
            }
            return array
        }
        else {
            return calculateDurationArray(data: data)
        }
    }
    
    func checkIsDuration(data:String?) -> Bool {
        if !(data!.contains(":")) {
            return false
        }
        else {
            return true
        }
    }
    
    func calculateDurationArray(data:String?, isShowHours:Bool = true) -> [String] {
        let addTime:Double = 15
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
            
            let final = Int(((((sHr / 60 ) + (sMin / 60 )) - ((fHr / 60 ) + (fMin / 60 ))) + 1 ) * 2) * 4
            
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
            //TODO: - Yash Changes
          //  array.append("Customize")
        }
        return array
    }
    
    
    func calculateDurationArrayWith5SecGap(data:String?, isShowHours:Bool = true) -> [String] {
           let addTime:Double = 5
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
               
               let final = Int(((((sHr / 60 ) + (sMin / 60 )) - ((fHr / 60 ) + (fMin / 60 ))) + 1 ) * 2) * 12
               
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
               //TODO: - Yash Changes
             //  array.append("Customize")
           }
           return array
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
    
    func calculateDurationArrayForRestCustomise(data:String?, isShowHours:Bool = true)  {
        let addTime:Double = 15
        var array: [String] = []
        let dataArray = data?.split(separator: "-")
        if dataArray?.count == 2 {
            
            let firstArray = dataArray?.first?.split(separator: ":")
            let secondArray = dataArray?[1].split(separator: ":")
            let fMin = Int(firstArray?[1] ?? "0") ?? 0
            let fSec = (Int(firstArray?[2] ?? "0") ?? 0)
            
            let sMin = Int(secondArray?[1] ?? "0") ?? 0
            let sSec = (Int(secondArray?[2] ?? "0") ?? 0)
            
            self.arrayMinuteForRestCustome = []
            self.arrayMinuteForRestCustome = Array(stride(from: fMin, to: sMin + 1, by: 1))
            
            
            /*
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
            
            let final = Int(((((sHr / 60 ) + (sMin / 60 )) - ((fHr / 60 ) + (fMin / 60 ))) + 1 ) * 2) * 4
            
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
            //TODO: - Yash Changes
          //  array.append("Customize")
            
            
            */
        }
    }
    
    
    func calculateDurationArrayForDurationCustomise(data:String?, isShowHours:Bool = true)  {
        var array: [String] = []
        let dataArray = data?.split(separator: "-")
        if dataArray?.count == 2 {
            
            
            let firstArray = dataArray?.first?.split(separator: ":")
            let secondArray = dataArray?[1].split(separator: ":")
            let fMin = Int(firstArray?[1] ?? "0") ?? 0
            let fSec = (Int(firstArray?[2] ?? "0") ?? 0)
            
            let sMin = Int(secondArray?[1] ?? "0") ?? 0
            let sSec = (Int(secondArray?[2] ?? "0") ?? 0)
            
            self.arrayMinuteForDurationCustom = []
            self.arrayMinuteForDurationCustom = Array(stride(from: fMin, to: sMin + 1, by: 1))
            
            
            /*
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
            
            let final = Int(((((sHr / 60 ) + (sMin / 60 )) - ((fHr / 60 ) + (fMin / 60 ))) + 1 ) * 2) * 4
            
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
            //TODO: - Yash Changes
          //  array.append("Customize")
            
            
            */
        }
    }
}

extension ExerciseResistanceCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.pickerViewRestCustom || pickerView == self.pickerViewRepsCustom {
            return 2
        }
        else  if pickerView == self.pickerViewDuration || pickerView == self.pickerViewDurationCustom {
            
            if self.strCustomTrainingGoal.lowercased() == "customize"{
                return 2
            }else{
                return 1
            }
        }else if pickerView == self.pickerViewWeight{
            
            if self.selectedResistanceValidationList?.weightRange?.contains("|") ?? false  && self.arrayRequiredWeight.count == 0 {
                return 2
            }else{
                return 1
            }
        }else if pickerView == self.pickerViewRest{
            if self.strCustomTrainingGoal.lowercased() == "customize"{
               return 2
            }else{
                return 1
            }
        }else if pickerView == self.pickerViewWCustomWeightSelection{
            return 2
        }
        
        return 1
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if pickerView == self.pickerViewWeight {
            
            if self.selectedResistanceValidationList?.weightRange?.contains("|") ?? false && self.arrayRequiredWeight.count == 0{
                if component == 0{
                    return 1000
                }else{
                    return self.arrayDecimalForCustomTrainingGoal.count
                }
            }else{
                if self.selectedResistanceWeightList?.count == 0 || self.selectedResistanceWeightList == nil{
                    return calculateDistanceArray(data: self.selectedResistanceValidationList?.weightRange ?? "").count
                }else{
                    return arrayRequiredWeight.count
                }
            }
        }else if pickerView == self.pickerViewWCustomWeightSelection{
            if component == 0{
                return 1000
            }else{
                return self.arrayDecimalForCustomTrainingGoal.count
            }
        }
        else if pickerView == self.pickerViewReps {
            return calculateDistanceArray(data: self.selectedResistanceValidationList?.repsRange ?? "", isWeight: false).count
        }
        else if pickerView == self.pickerViewRestCustom || pickerView == self.pickerViewRepsCustom {
            if component == 0 {
               return 60
            }
            else {
                return 60
            }
        }
        else if pickerView == self.pickerViewDuration {
            
            if self.strCustomTrainingGoal.lowercased() == "customize"{
                
                if component == 0{
                    return self.arrayMinuteForDurationCustom.count
                }else{
                    return self.arraySecondForDuratonCustom.count
                }
                
            }else{
                 return calculateDurationArrayWith5SecGap(data: self.selectedResistanceValidationList?.durationRange ?? "",isShowHours: false).count
            }
            
            /*
            if component == 0 {
               return 10 // set value 10 beacuse customize isHidden from scroller if show in scroller value set as 11
            }
            else {
                return 60 // set value 60 beacuse customize isHidden from scroller if show in scroller value set as 61
            }*/
        }
        else if pickerView == self.pickerViewDurationCustom {
            if component == 0 {
                return 60
            }
            else {
                return 60
            }
        }
        else if pickerView == self.pickerViewDurationSimple {
            return calculateDurationArrayWith5SecGap(data: self.selectedResistanceValidationList?.durationRange ?? "").count
//            return calculateDurationArray(data: self.selectedResistanceValidationList?.repsTimeRange ?? "").count
        }
        else if pickerView == self.pickerViewRest{
            if self.strCustomTrainingGoal.lowercased() == "customize"{
                
                if component == 0{
                    return self.arrayMinuteForRestCustome.count
                }else{
                    return self.arraySecondForRestCustome.count
                }
                
            }else{
                 return calculateDurationArray(data: self.selectedResistanceValidationList?.restRange ?? "").count
            }
        }
        else {
            return calculateDurationArray(data: self.selectedResistanceValidationList?.restRange ?? "").count
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
        
        if pickerView == self.pickerViewWeight {
            
            if self.selectedResistanceValidationList?.weightRange?.contains("|") ?? false && self.arrayRequiredWeight.count == 0{
                if component == 0{
                    myView.lblText.text = String(row)
                }else {
                    myView.lblText.text = String(self.arrayDecimalForCustomTrainingGoal[row])
                }
            }else{
                if self.selectedResistanceWeightList?.count == 0 || self.selectedResistanceWeightList == nil{
                    myView.lblText.text = calculateDistanceArray(data: self.selectedResistanceValidationList?.weightRange ?? "")[row]
                }else{
                    myView.lblText.text = arrayRequiredWeight[row]
                }
            }
            
        }
        else if pickerView == self.pickerViewWCustomWeightSelection{
            if component == 0{
                myView.lblText.text = String(row)
            }else {
                myView.lblText.text = String(self.arrayDecimalForCustomTrainingGoal[row])
            }
        }
        else if pickerView == self.pickerViewReps {
            myView.lblText.text = calculateDistanceArray(data: self.selectedResistanceValidationList?.repsRange ?? "", isWeight: false)[row]
        }
        else if pickerView == self.pickerViewRestCustom || pickerView == self.pickerViewRepsCustom {
            if component == 0 {
                myView.lblText.text = "\(row)"
            }
            else {
                myView.lblText.text = "\(row)"
            }
        }
        else if pickerView == self.pickerViewDuration {
            
            //TODO: - Yash changes
            
            if self.strCustomTrainingGoal.lowercased() == "customize"{
                if component == 0{
                    myView.lblText.text = String(self.arrayMinuteForDurationCustom[row].makeRound())
                }else{
                    myView.lblText.text =  String(self.arraySecondForDuratonCustom[row].makeRound())
                }
                
            }else{
                 myView.lblText.text = calculateDurationArrayWith5SecGap(data: self.selectedResistanceValidationList?.durationRange ?? "",isShowHours: false)[row]
            }
            
            /*
            if component == 0 {
                self.labelDurationMin.isHidden = row == 10
                
                myView.lblText.text = row == 10 ? "Customize" : "\(row)"
            }
            else {
                self.labelDurationSec.isHidden = row == 60
                myView.lblText.text = row == 60 ? "Customize" : "\(row)"
            }*/
        }
        else if pickerView == self.pickerViewDurationCustom {
            
            if component == 0 {
                myView.lblText.text = "\(row)"
            }
            else {
                myView.lblText.text = "\(row)"
            }
        }
        else if pickerView == self.pickerViewDurationSimple {
            
            myView.lblText.text = calculateDurationArrayWith5SecGap(data: self.selectedResistanceValidationList?.durationRange ?? "",isShowHours: false)[row]
            
            //myView.lblText.text = calculateDurationArray(data: self.selectedResistanceValidationList?.repsTimeRange ?? "", isShowHours: false)[row]
        }else if pickerView == self.pickerViewRest{
            
            if self.strCustomTrainingGoal.lowercased() == "customize"{
               
                if component == 0{
                    myView.lblText.text = String(self.arrayMinuteForRestCustome[row].makeRound())
                }else{
                    myView.lblText.text = String(self.arraySecondForRestCustome[row].makeRound())
                }
                
            }else{
                myView.lblText.text = calculateDurationArray(data: self.selectedResistanceValidationList?.restRange ?? "", isShowHours: false)[row]
            }
            
        }
        else {
            myView.lblText.text = calculateDurationArray(data: self.selectedResistanceValidationList?.restRange ?? "", isShowHours: false)[row]
        }
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerViewWeight {
            
            if self.selectedResistanceValidationList?.weightRange?.contains("|") ?? false && self.arrayRequiredWeight.count == 0{
                if component == 0{
                    firstComponent = row
                }else {
                    secondComponent = self.arrayDecimalForCustomTrainingGoal[row]
                }
                
                self.txtWeight.text = String("\(firstComponent).\(secondComponent)")
                    
                //Show Alert
                
                self.isSelectedCustomWeight = true
                
            }else{
                if self.selectedResistanceWeightList?.count == 0 || self.selectedResistanceWeightList == nil{
                    self.txtWeight.text = calculateDistanceArray(data: self.selectedResistanceValidationList?.weightRange ?? "")[row]
                }else{
                    
                    let name = arrayRequiredWeight[row]
                    if name.lowercased() != "customize".lowercased(){
                        self.isWeightCustom = false
                        self.txtWeight.text = name

                    }else{
                        //Show Alert
                        
                        firstComponent = 0
                        secondComponent = 0
                        
                        self.isWeightCustom = true
                        self.endEditing(true)
                        self.setWeight(isSet: false)
                        self.txtWeight.text = String("\(firstComponent).\(secondComponent)")

                        self.isSelectedCustomWeight = true
                    }
                }
            }
            
        }
        else if pickerView == self.pickerViewWCustomWeightSelection{
            if component == 0{
                firstComponent = row
            }else {
                secondComponent = self.arrayDecimalForCustomTrainingGoal[row]
            }
            
            self.txtWeight.text = String("\(firstComponent).\(secondComponent)")
            
            //Show Alert
            
            self.isSelectedCustomWeight = true
        }
        else if pickerView == self.pickerViewReps {
            let name = calculateDistanceArray(data: self.selectedResistanceValidationList?.repsRange ?? "", isWeight: false)[row]
            
            if name.lowercased() != "customize".lowercased() {
                self.txtReps.text = name
                self.isRepsCustom = false
                
                
                if self.strCustomTrainingGoal.lowercased() != "customize"{
                    self.txtWeight.text = self.changesRepsAndGetWeight(strSelectedReps: self.txtReps.text ?? "")
                }else{
                    self.txtWeight.text = ""
                }
                
                self.pickerViewWeight.selectRow(0, inComponent: 0, animated: false)
            }
            else {
                self.txtReps.text = ""
                self.isRepsCustom = true
                self.endEditing(true)
                self.setReps(isSet: false)
            }
            //MARK: - Yash Changes
//            self.txtWeight.text = ""
            firstComponent = 0
            secondComponent = 0

        }
        else if pickerView == self.pickerViewRestCustom {
            if component == 0 {
                isRestCustomMinute = row
            }
            else {
                isRestCustomSec = row
            }
            self.txtRest.text = "00:" + "\(isRestCustomMinute.makeRound()):\(isRestCustomSec.makeRound())"
        }
        else if pickerView == self.pickerViewRepsCustom {
            if component == 0 {               
                isDurationMinute = row
            }
            else {
                
                isDurationSec = row
            }
            self.txtReps.text = "00:" + "\(isDurationMinute.makeRound()):\(isDurationSec.makeRound())"
        }
        else if pickerView == self.pickerViewDuration {
            
             if self.strCustomTrainingGoal.lowercased() == "customize"{
                
                if component == 0{
                    minuteComponentForDurationCustome = row
                }else{
                    secondComponentForDurationCustome = row
                }
                
                self.txtReps.text = "\(self.arrayMinuteForDurationCustom[minuteComponentForDurationCustome].makeRound()):\(self.arraySecondForDuratonCustom[secondComponentForDurationCustome].makeRound())"
                
             }else{
                let name = calculateDurationArrayWith5SecGap(data: self.selectedResistanceValidationList?.durationRange ?? "",isShowHours: false)[row]
                if name.lowercased() != "customize" {
                    self.txtReps.text = name
                }
                else {
                    self.txtReps.text = ""
                    self.endEditing(true)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        self.setDuration(isSet: false)
                    }
                }
            }
                
            //TODO: - yash comment
            /*
            if component == 0 {
                isDurationCustomMinute = row
                if row == 10 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        self.setDuration(isSet: false)
                    }
                }
            }
            else {
                isDurationCustomSec = row
                if row == 60 {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        self.setDuration(isSet: false)
                    }
                }
            }*/
            //self.txtReps.text = "00:" + "\(isDurationCustomMinute.makeRound()):\(isDurationCustomSec.makeRound())"
        }
        else if pickerView == self.pickerViewDurationCustom {
            if component == 0 {
                isRapsCustomMinute = row
            }
            else {
                isRapsCustomSec = row
            }
            self.txtReps.text = "\(isRapsCustomMinute.makeRound()):\(isRapsCustomSec.makeRound())"
        }
        else if pickerView == self.pickerViewDurationSimple {
            
            let name = calculateDurationArrayWith5SecGap(data: self.selectedResistanceValidationList?.durationRange ?? "", isShowHours: false)[row]
            if name.lowercased() != "customize" {
                self.txtReps.text =  name
                self.isRepsCustom = false
            }
            else {
                self.txtReps.text = ""
                self.isRepsCustom = true
                self.isRepsCustomOpend = true
                self.endEditing(true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.setDuration(isSet: false)
                }
            }
            
            //TODO: - yash comment
            /*
            let name = calculateDurationArray(data: self.selectedResistanceValidationList?.repsTimeRange ?? "", isShowHours: false)[row]
            if name.lowercased() != "customize" {
                self.txtReps.text = "00:" + name
                self.isRepsCustom = false
            }
            else {
                self.txtReps.text = ""
                self.isRepsCustom = true
                self.isRepsCustomOpend = true
                self.endEditing(true)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.setDuration(isSet: false)
                }
            }
            
            */
        }
        else if pickerView == self.pickerViewRest{
            
            if self.strCustomTrainingGoal.lowercased() == "customize".lowercased(){
                
                if component == 0{
                    minuteComponentForCustome = row
                }else{
                    secondComponentForCustome = row
                }
                
                self.txtRest.textAlignment = .center
                self.txtRest.text = "\(self.arrayMinuteForRestCustome[minuteComponentForCustome].makeRound()):\(self.arraySecondForRestCustome[secondComponentForCustome].makeRound())"
                
            }else{
                let name = calculateDurationArray(data: self.selectedResistanceValidationList?.restRange ?? "",isShowHours: false)[row]
                
                self.txtRest.textAlignment = .center
                if name.lowercased() != "customize" {
                    self.txtRest.text = name
                    self.isRestCustom = false
                }
                else {
                    self.txtRest.text = ""
                    self.isRestCustom = true
                    self.endEditing(true)
                    self.setRest(isSet: false)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        self.isRestCustomOpend = true
                    }
                }
            }
            
        }
        else {
            let name = calculateDurationArray(data: self.selectedResistanceValidationList?.restRange ?? "")[row]
            if name.lowercased() != "customize" {
                self.txtRest.text = name
                self.isRestCustom = false
            }
            else {
                self.txtRest.text = ""
                self.isRestCustom = true
                self.endEditing(true)
                self.setRest(isSet: false)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.isRestCustomOpend = true
                }
            }
        }

        var weight = ""
        
        if self.txtWeight.text == "0.0"{
            weight = ""
        }else{
            weight = self.txtWeight.text ?? ""
        }
        
        var duration = ""
        
        if isDurationSelected{
            if self.txtReps.text == "00:00"{
                duration = ""
            }else{
                duration = self.txtReps.text ?? ""
            }
        }

        var rest = ""
        
        if self.txtRest.text == "00:00"{
            rest = ""
        }else{
            rest = self.txtRest.text ?? ""
        }

        
//        let weight = self.txtWeight.text ?? ""
        let reps = self.isDurationSelected ? "" : self.txtReps.text ?? ""
//        let duration = self.isDurationSelected ? self.txtReps.text ?? "" : ""
//        let rest = self.txtRest.text ?? ""
        
        self.delegate?.ExerciseResistanceCellFinish(index: self.index, section: self.tag, Weight: weight, Reps: reps, Duration: duration, Rest: rest)
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if pickerView == self.pickerViewWeight{
            if self.selectedResistanceValidationList?.weightRange?.contains("|") ?? false  && self.arrayRequiredWeight.count == 0 {
                return CGFloat(80)
            }else{
                return CGFloat(120) - 5
            }
        }else{
            return CGFloat(120) - 5
        }
    }
    
    func setDuration(isSet:Bool = true) {
        let isDuration =  (self.selectedResistanceValidationList?.repsRange == nil ||  self.selectedResistanceValidationList?.repsRange == "") || (self.selectedResistanceValidationList?.repsRange != nil && self.selectedResistanceValidationList?.repsRange != "" && self.selectedResistanceValidationList?.repsTimeRange != nil && self.selectedResistanceValidationList?.repsTimeRange != "")

//        let isDuration =  self.selectedResistanceValidationList?.repsRange == nil ||  self.selectedResistanceValidationList?.repsRange == ""
        if isDuration && !isRepsCustomOpend {
            self.txtReps.delegate = self
            self.txtReps.backgroundColor = UIColor.white
            self.txtReps.inputView = pickerViewDurationSimple
        }
        else {
//            self.isRepsCustomOpend = false
            self.endEditing(true)
            self.txtReps.delegate = self
            self.txtReps.inputView = nil
            if isSet {
                self.txtReps.placeholder = "00:00"
                self.txtReps.backgroundColor = UIColor.white
                self.txtReps.inputView = pickerViewDuration
            }
            else {
                self.txtReps.backgroundColor = UIColor.white
                self.pickerViewDurationCustom.selectRow(0, inComponent: 0, animated: false)
                self.pickerViewDurationCustom.selectRow(0, inComponent: 1, animated: false)
                self.txtReps.inputView = pickerViewDurationCustom
                self.txtReps.becomeFirstResponder()
            }
        }
    }
    
    func setReps(isSet:Bool = true) {
        self.txtReps.delegate = self
        if isSet {
            self.txtReps.delegate = self
            self.txtReps.backgroundColor = UIColor.white
            self.txtReps.placeholder = "00"
            self.txtReps.inputView = pickerViewReps
        }
        else {
            if checkIsDuration(data: self.selectedResistanceValidationList?.repsRange ?? "") {
                self.txtReps.delegate = self
                self.txtReps.backgroundColor = UIColor.white
                self.pickerViewRepsCustom.selectRow(0, inComponent: 0, animated: false)
                self.pickerViewRepsCustom.selectRow(0, inComponent: 1, animated: false)
                self.txtReps.inputView = pickerViewRepsCustom
                self.txtReps.becomeFirstResponder()
            }
            else {
                self.txtReps.inputView = nil
                self.txtReps.becomeFirstResponder()
            }
        }
    }

    func setRest(isSet:Bool = true) {
        self.txtRest.delegate = self
        self.txtRest.backgroundColor = UIColor.white
        if isSet {
            self.txtRest.inputView = pickerViewRest
        }
        else {
            self.pickerViewRestCustom.selectRow(0, inComponent: 0, animated: false)
            self.pickerViewRestCustom.selectRow(0, inComponent: 1, animated: false)
            self.txtRest.inputView = pickerViewRestCustom
            self.txtRest.becomeFirstResponder()
        }
    }
    
    func setWeight(isSet:Bool = true){
        self.txtWeight.delegate = self
        self.txtWeight.backgroundColor = UIColor.white
        if isSet{
            self.txtWeight.inputView = pickerViewWeight
        }else{
            self.txtWeight.inputView = nil
            self.pickerViewWCustomWeightSelection.selectRow(0, inComponent: 0, animated: false)
            self.pickerViewWCustomWeightSelection.selectRow(0, inComponent: 1, animated: false)
            self.txtWeight.inputView = pickerViewWCustomWeightSelection
            self.txtWeight.becomeFirstResponder()
        }
    }
    
    
    func getArrayFromWeightList(){
        
        self.arrayRequiredWeight = []
        
        if self.strCustomTrainingGoal.lowercased() == "customize"{
           setCustomPickerForWeight()
           return
        }
        
        var arrayForWeight = [String]()
        var selectedRPforWeight : RepetitionMax?
        
        if selectedResistanceWeightList?.count ?? 0 > 0 && self.selectedResistanceWeightList != nil{
            if (selectedResistanceWeightList!.contains(where: { (repetation) -> Bool in
                
                if repetation.name?.replacingOccurrences(of: " RM", with: "") == self.txtReps.text?.toTrim(){
                    selectedRPforWeight = repetation
                    return true
                }
                return false
            })){
                
                print("Estimated Weight:\(selectedRPforWeight?.estWeight)")
                print("Actual Weight:\(selectedRPforWeight?.actWeight)")
                
                if selectedRPforWeight?.actWeight == "" || selectedRPforWeight?.actWeight == "0"{
                    if selectedRPforWeight?.estWeight == "" || selectedRPforWeight?.estWeight == "0"{
                        print("Both are blank")
                        setCustomPickerForWeight()
                        return
                    }else{
                        arrayForWeight.append(selectedRPforWeight?.estWeight ?? "")
                    }
                }else{
                    arrayForWeight.append(selectedRPforWeight?.actWeight ?? "")
                }
            }
            else{
                
                let value = self.txtReps.text?.toTrim()
                
//                if value == "13" || value == "14"{
//                    selectedRPforWeight = selectedResistanceWeightList?[11]
//                }else if value == "16" || value == "17" || value == "18" || value == "19" || value == "20"{
//                    selectedRPforWeight = selectedResistanceWeightList?[12]
//                }else{
                //last change comment this both line
//                    setCustomPickerForWeight()
//                    return
//                }
                
                print("Estimated Weight:\(selectedRPforWeight?.estWeight)")
                print("Actual Weight:\(selectedRPforWeight?.actWeight)")

                if selectedRPforWeight?.actWeight == "" || selectedRPforWeight?.actWeight == "0"{
                    if selectedRPforWeight?.estWeight == "" || selectedRPforWeight?.estWeight == "0"{
                        print("Both are blank")
                        setCustomPickerForWeight()
                        return
                    }else{
                        arrayForWeight.append(selectedRPforWeight?.estWeight ?? "")
                    }
                }else{
                    
//                    if  !(self.selectedResistanceValidationList?.weightRange?.contains("|") ?? false) {
                        arrayForWeight.append(selectedRPforWeight?.actWeight ?? "")
//                    }else{
                        
//                        setCustomPickerForWeight()
//                        return
//                    }
                }
            }
            
            arrayForWeight.append("Customize")
            
            print("aray For Weight :\(arrayForWeight)")
            
            self.arrayRequiredWeight = arrayForWeight
                
            if let viewWithTag = self.pickerViewWeight.viewWithTag(100){
                viewWithTag.removeFromSuperview()
            }else{
                print("No!")
            }
            
            if let viewWithDifferentTag = self.pickerViewWeight.viewWithTag(101) {
                viewWithDifferentTag.removeFromSuperview()
            }else{
                print("No!")
            }
            
            self.pickerViewWeight.reloadAllComponents()
            
            self.pickerViewWeight.layoutIfNeeded()
            self.pickerViewWeight.layoutSubviews()
            
        }else{
            if (self.selectedResistanceValidationList?.weightRange?.contains("|") ?? false) {
                setCustomPickerForWeight()
            }
        }
    }
    
    func changesRepsAndGetWeight(strSelectedReps:String) -> String{
        
        print("selectedResistanceWeightList JSONM:\(selectedResistanceWeightList?.toJSON())")
        
        var selectedRPforWeight : RepetitionMax?
        
        if selectedResistanceWeightList?.count ?? 0 > 0 && self.selectedResistanceWeightList != nil{
            if (selectedResistanceWeightList!.contains(where: { (repetation) -> Bool in
                
                if repetation.name?.replacingOccurrences(of: " RM", with: "") == self.txtReps.text?.toTrim(){
                    selectedRPforWeight = repetation
                    return true
                }
                return false
            })){
                
                if selectedRPforWeight?.actWeight == "" || selectedRPforWeight?.actWeight == "0"{
                    if selectedRPforWeight?.estWeight == "" || selectedRPforWeight?.estWeight == "0"{
                        print("Both are blank")
                        return ""
                    }else{
                        return selectedRPforWeight?.estWeight ?? ""
                    }
                }else{
                    return selectedRPforWeight?.actWeight ?? ""
                }
            }
            else{
                
                let value = self.txtReps.text?.toTrim()
                
                //TODO: - Change here for according reps
                
//                if value == "13" || value == "14"{
//                    selectedRPforWeight = selectedResistanceWeightList?[11]
//                }else if value == "16" || value == "17" || value == "18" || value == "19" || value == "20"{
//                    selectedRPforWeight = selectedResistanceWeightList?[12]
//                }
                
                print("selectedRPForWeight:\(selectedRPforWeight)")
                
                if selectedRPforWeight?.actWeight == "" || selectedRPforWeight?.actWeight == "0"{
                    if selectedRPforWeight?.estWeight == "" || selectedRPforWeight?.estWeight == "0"{
                        print("Both are blank")
                        return ""
                    }else{
                        return selectedRPforWeight?.estWeight ?? ""
                        
                    }
                }else{
                    return selectedRPforWeight?.actWeight ?? ""
                }
            }
        }
        
        return ""
    }
    
    
    //MARK: - Custom pickerView
    
    func setCustomPickerForWeight(){
        
        if let viewWithTag = self.pickerViewWeight.viewWithTag(100){
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        if let viewWithDifferentTag = self.pickerViewWeight.viewWithTag(101) {
            viewWithDifferentTag.removeFromSuperview()
        }else{
            print("No!")
        }
        
        let screenRest = UIScreen.main.bounds.width / 2
        
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 98 : 108
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (pickerViewWeight.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "."
            }
            else {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (pickerViewWeight.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "Kg"
            }
            label.textColor = .appthemeRedColor
            self.pickerViewWeight.addSubview(label)
        }
        
        pickerViewWeight.delegate = self
        pickerViewWeight.backgroundColor = UIColor.white
        
    }
    
    func setCustomPickerForRestCustom(){
        
        let screen = UIScreen.main.bounds.width / 3
        let screenRest = UIScreen.main.bounds.width / 2

        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + 116, y: (pickerViewRest.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "min"
            }
            else {
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + 35, y: (pickerViewRest.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "sec"
            }
            label.textColor = .appthemeRedColor
            self.pickerViewRest.addSubview(label)
        }
        
        /*
        //        for index in 0..<1 {
        let label = UILabel()
        label.textAlignment = .center
        label.tag = 100
        label.font = label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
        //            if index == 0 {
        let x = DEVICE_TYPE.IS_IPHONE_6 ? 98 : 108
        label.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (pickerViewRest.frame.height - 30) / 2, width: screenRest, height: 30)
        label.text = ":"
        //            }
        //            else {
        //                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
        //                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (pickerViewRestCustom.frame.height - 30) / 2, width: screenRest, height: 30)
        //                label.text = "Kg"
        //            }
        label.textColor = .appthemeRedColor
        self.pickerViewRest.addSubview(label)
        //        }*/
        
        pickerViewRest.delegate = self
        pickerViewRest.backgroundColor = UIColor.white
        
    }
    

    func setPickerForRest(){
        
        let screenRest = UIScreen.main.bounds.width / 2
        
        //        for index in 0..<1 {
        let label = UILabel()
        label.textAlignment = .center
        label.tag = 100
        label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
        //                    if index == 0 {
        let x = DEVICE_TYPE.IS_IPHONE_6 ? 40 : 38
        label.frame = CGRect(x: (screenRest) - CGFloat(x), y: (pickerViewRest.frame.height - 30) / 2, width: screenRest, height: 30)
        label.text = "mins"
        //                    }
        //            else {
        //                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
        //                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (pickerViewRestCustom.frame.height - 30) / 2, width: screenRest, height: 30)
        //                label.text = "Kg"
        //            }
        label.textColor = .appthemeRedColor
        self.pickerViewRest.addSubview(label)
        //        }
        
        pickerViewRest.delegate = self
        pickerViewRest.backgroundColor = UIColor.white
        
    }
    
    func setCustomPickerForDurationCustom(){
        
        let screen = UIScreen.main.bounds.width / 3
        
        let screenRest = UIScreen.main.bounds.width / 2
        
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + 116, y: (pickerViewDuration.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "min"
            }
            else {
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + 35, y: (pickerViewDuration.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "sec"
            }
            label.textColor = .appthemeRedColor
            self.pickerViewDuration.addSubview(label)
        }
        
        /*
        //        for index in 0..<1 {
        let label = UILabel()
        label.textAlignment = .center
        label.tag = 100
        label.font = label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
        //            if index == 0 {
        let x = DEVICE_TYPE.IS_IPHONE_6 ? 98 : 108
        label.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (pickerViewDuration.frame.height - 30) / 2, width: screenRest, height: 30)
        label.text = ":"
        //            }
        //            else {
        //                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
        //                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (pickerViewRestCustom.frame.height - 30) / 2, width: screenRest, height: 30)
        //                label.text = "Kg"
        //            }
        label.textColor = .appthemeRedColor
        self.pickerViewDuration.addSubview(label)
        //        }
         */
        pickerViewDuration.delegate = self
        pickerViewDuration.backgroundColor = UIColor.white
        
    }
    
    func setPickerForDuration(){
        
        let screenRest = UIScreen.main.bounds.width / 2
        
        //        for index in 0..<1 {
        let label = UILabel()
        label.textAlignment = .center
        label.tag = 100
        label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
//                    if index == 0 {
        let x = DEVICE_TYPE.IS_IPHONE_6 ? 40 : 38
        label.frame = CGRect(x: (screenRest) - CGFloat(x), y: (pickerViewDuration.frame.height - 30) / 2, width: screenRest, height: 30)
        label.text = "mins"
//                    }
        //            else {
        //                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
        //                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (pickerViewRestCustom.frame.height - 30) / 2, width: screenRest, height: 30)
        //                label.text = "Kg"
        //            }
        label.textColor = .appthemeRedColor
        self.pickerViewDuration.addSubview(label)
        //        }
         
        pickerViewDuration.delegate = self
        pickerViewDuration.backgroundColor = UIColor.white
        
    }
    
}
