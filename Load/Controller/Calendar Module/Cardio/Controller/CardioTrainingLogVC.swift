//
//  CardioTrainingLogVC.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON
import IQKeyboardManagerSwift

class CardioTrainingLogVC: UIViewController, NewMessageSelectDelegate, UITextFieldDelegate {
    
    //MARK:- Variables
    lazy var mainView: CardioTrainingLogView = { [unowned self] in
        return self.view as! CardioTrainingLogView
        }()
    
    lazy var mainModelView: CardioTrainingLogViewModel = {
        return CardioTrainingLogViewModel(theController: self)
    }()
    
    var scrollCurrentOffset = CGFloat()
    var isKeyboardOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        
        self.mainView.mainScrollView.delegate = self
        
        print("selected date from calendar:\(self.mainModelView.selectedDateFromCalendar)")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.mainView.txtTargetHR.setAsNumericKeyboard(delegate: self,isUseHyphen:true)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func btnActivityClicked(_ sender: Any) {
        
        if self.mainView.txtActivity.text == "" {
            let activity = GetAllData?.data?.trainingActivity?.first
            
            if self.mainModelView.activityId != (activity?.id?.stringValue) ?? "" {
                self.mainModelView.exercisesArray.removeAll()
            }
            self.mainView.txtActivity.text = activity?.name?.capitalized ?? ""
            self.mainModelView.activityId = activity?.id?.stringValue ?? ""
            self.mainModelView.activityPickerView.selectRow(0, inComponent: 0, animated: false)
            self.mainModelView.showExerciseHeader()
            self.hideShowHeaderAccordingToActivity(name: self.mainView.txtActivity.text ?? "")
            self.mainView.tableView.reloadData()
        }
        self.mainView.txtActivity.becomeFirstResponder()
    }
    
    @IBAction func btnWhenClicked(_ sender: Any) {
        if self.mainView.txtWhen.text == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateFormat = "EEEE, dd MMM yyyy 'at' hh:mm a"
            
            if self.mainModelView.selectedDateFromCalendar == ""{
                self.mainView.txtWhen.text = dateFormatter.string(from: Date())
                self.mainModelView.selectedDate = DateToString(Formatter: "yyyy-MM-dd HH:mm:ss", date: Date())

            }else{
//                let convertToDate = convertDate(self.mainModelView.selectedDateFromCalendar, dateFormat:  "yyyy-MM-dd")
//                self.mainView.txtWhen.text = dateFormatter.string(from: convertToDate)
//                self.mainModelView.selectedDate = DateToString(Formatter: "yyyy-MM-dd HH:mm:ss", date: convertToDate)
                
                let convertToTime = DateToString(Formatter: "hh:mm a", date: Date())
                print("convertToTime: \(convertToTime)")
                
                let stringFullDate = self.mainModelView.selectedDateFromCalendar + " " + convertToTime
                print("stringFullDate: \(stringFullDate)")
                
                let convertToDate = convertDate(stringFullDate, dateFormat:  "yyyy-MM-dd hh:mm a")
                print("convertToDate:\(convertToDate)")

                self.mainView.txtWhen.text = dateFormatter.string(from: convertToDate)

                self.mainModelView.selectedDate = DateToString(Formatter: "yyyy-MM-dd HH:mm:ss", date: convertToDate)

            }
        }
        self.mainView.txtWhen.becomeFirstResponder()
    }
    
    @IBAction func btnIntensityClicked(_ sender: Any) {
        
        if self.mainView.txtActivity.text == ""{
            return
        }
        
        if self.mainView.txtIntensity.text == "" {
            
            self.mainModelView.intensityPickerView.selectRow(0, inComponent: 0, animated: false)
            self.mainModelView.targatHRPickerView.selectRow(0, inComponent: 0, animated: false)
            
            self.mainModelView.isTrainigGoalSelectAsCustomize = false
            
            let activity = GetAllData?.data?.trainingIntensity?.first
            self.mainView.txtIntensity.text = activity?.name?.capitalized ?? ""
            self.mainModelView.intensityId = activity?.id?.stringValue ?? ""
            self.mainModelView.targatHRId = activity?.targetHr ?? ""
            self.mainView.txtTrainingGoal.text = ""
            self.mainModelView.trainingGoalId = ""
            let hr = self.mainModelView.showTargetHr(hr: activity?.targetHr ?? "",activityID:self.mainModelView.activityId)
            self.mainView.txtTargetHR.text = hr == "0" ? "" : hr + " bpm"
            self.mainModelView.targatHRId = hr
//            self.mainView.txtTargetHR.isUserInteractionEnabled = hr == "0"
            //TODO: - Yash changes
//            self.mainModelView.targatHR = hr == "0" ? "" : hr + " Estimated HR"
            self.mainModelView.targatHR = hr == "0" ? "" : hr + " Estimated HR"
        }
        self.mainView.txtIntensity.becomeFirstResponder()
    }
    
    @IBAction func btnTargetHRClicked(_ sender: Any) {
        if self.mainView.txtIntensity.text?.toTrim() == "" {
            return
        }
        
        self.mainView.txtTargetHR.inputView = self.mainModelView.targatHRPickerView
        self.mainView.txtTargetHR.isUserInteractionEnabled = true
        self.mainView.txtTargetHR.becomeFirstResponder()
    }
    
    @IBAction func btnTrainingGoalClicked(_ sender: Any) {
        if self.mainView.txtIntensity.text?.toTrim() == "" {
            return
        }
        
        if self.mainView.txtActivity.text?.lowercased() == "Others".lowercased(){
            self.mainView.txtTrainingGoal.inputView = nil
            self.mainView.txtTrainingGoal.becomeFirstResponder()
            return
        }else{
            self.mainView.txtTrainingGoal.inputView = self.mainModelView.trainingGoalPickerView
        }
        
        if self.mainView.txtTrainingGoal.text == "" {
            
            let activity = self.mainModelView.getTrainingGoal().first
            let name = activity?.name?.capitalized ?? ""
            self.mainView.txtTrainingGoal.text = name
            self.mainModelView.selectedTrainingGoalName = name
            
            self.mainModelView.trainingGoalId = activity?.id?.stringValue ?? ""
            self.mainModelView.getValidationFromId()
//            var hr = self.mainModelView.showTargetHr(hr: self.mainModelView.targatHRId)
//            if name.lowercased() == "customize" {
//                hr = "0"
//            }
            self.mainModelView.trainingGoalPickerView.selectRow(0, inComponent: 0, animated: false)
            self.mainModelView.trainingGoalPickerView.reloadAllComponents()
            
            self.mainView.tableView.reloadData()
//            self.mainView.txtTargetHR.text = hr == "0" ? "" : hr + " bpm"
//            self.mainView.txtTargetHR.isUserInteractionEnabled = hr == "0"
        }
        self.mainView.txtTrainingGoal.becomeFirstResponder()
    }
    
    @IBAction func btnStyleTapped(_ sender: UIButton) {
        
        if self.mainView.txtStyle.text == "" {
            let style = GetAllData?.data?.trainingLogStyle?.first
            self.mainView.txtStyle.text = style?.name?.capitalized ?? ""
            self.mainModelView.selectedSwimmingStyle = style?.id ?? ""
        }
        self.mainView.txtStyle.becomeFirstResponder()
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        self.AddRowClicked()
    }
    
    @IBAction func btnSendCustomTrainingGoalClicked(_ sender: Any) {
        self.mainView.txtTrainingGoal.text = self.mainView.txtCustomTrainingGoal.text?.toTrim()
        self.mainView.txtCustomTrainingGoal.text = ""
        self.mainModelView.showCustomTrainingGoal(isShow: false)
        //TODO: - Yash Changes // add below line
        self.mainView.txtCustomTrainingGoal.resignFirstResponder()
    }
    
    @IBAction func btnSaveAsTempleteClicked(_ sender: Any) {
        self.mainModelView.ValidateDetails(isSavedWorkout: true)
    }
    
    @IBAction func btnSendToFriendClicked(_ sender: Any) {
        if !self.mainModelView.ValidateDetailsForShare() {
            return
        }
        let obj: NewMessageSelectVC
            = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "NewMessageSelectVC") as! NewMessageSelectVC
        obj.mainModelView.delegate = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnLogClicked(_ sender: Any) {
        
        self.view.endEditing(true)

        if self.mainModelView.isEdit {
            self.mainModelView.ValidateDetails()
        }
        else {
            if self.mainModelView.trainingId != "" {
                self.mainModelView.apiCallSaveIsLogFlag()
            }
            else {
                self.mainModelView.ValidateDetails()
            }
        }
    }
    
    @IBAction func btnDurationClicked(_ sender: Any) {
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.mainModelView.isShowDistance = !self.mainModelView.isShowDistance
            self.mainModelView.showDistance(isShow: self.mainModelView.isShowDistance)
        }
    }
    
    @IBAction func btnSpeedClicked(_ sender: Any) {
        self.view.endEditing(true)
        
        let checkActivity = self.mainView.txtActivity.text ?? ""
        
        if checkActivity.lowercased() == "Cycling (Outdoor)".lowercased() || checkActivity.lowercased() == "Cycling (Indoor)".lowercased() || checkActivity.lowercased() == "Swimming".lowercased() {
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.mainModelView.isShowSpeed = !self.mainModelView.isShowSpeed
            self.mainModelView.showSpeed(isShow: self.mainModelView.isShowSpeed)
        }
    }
    
    @IBAction func btnRPMClicked(_ sender: Any) {
        self.view.endEditing(true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.mainModelView.isShowRPM = !self.mainModelView.isShowRPM
            self.mainModelView.showRPM(isShow: self.mainModelView.isShowRPM)
        }
        
        print("RPM value change:\(self.mainModelView.isShowRPM)")
        
    }
    
    func NewMessageSelectDidFinish(name: String, id: String) {
        self.mainModelView.shareFriend(toId: id)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == self.mainView.txtTargetHR {
//            textField.text = textField.text!.toTrim().replace(target: " bpm", withString: "")
//        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == self.mainView.txtTargetHR {
            if textField.text!.toTrim() == "" {
                textField.text = ""
                self.mainModelView.targatHRId = ""
            }
            else {
                self.mainModelView.targatHRId =  textField.text!.toTrim()
                if  textField.text!.toTrim().contains("bpm") {
                    textField.text = textField.text!.toTrim()
                }
                else {
                    textField.text = textField.text!.toTrim() + " bpm"
                }
            }
        }
        else if textField == self.mainView.txtTrainingGoal{
            self.mainModelView.setTrainingGoal(isSet: true)
            self.mainModelView.getValidationFromId()
        }
        
        self.changeColorAccordingToClickable()
        self.mainView.lblLapsTitle.text = self.mainModelView.getTotalLaps(total: self.mainModelView.exercisesArray.count)
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == mainView.txtIntensity || textField == mainView.txtTargetHR || textField == mainView.txtTrainingGoal{
            IQKeyboardManager.shared.enableAutoToolbar = true
            
            if textField == mainView.txtTrainingGoal{
                self.mainView.heightCustomTrainingGoal.constant = 0
                self.mainView.viewCustomTrainingGoal.isHidden = true
            }
            
        }
        
        return true
    }
    
    func checkLogItClickableOrNot() -> Bool{
        
        var isClickable = true
        
        if mainView.txtActivity.text?.toTrim() == ""{
            isClickable = false
            
            return false
        }
            
        if mainView.txtWhen.text?.toTrim() == ""{
            isClickable = false
            return false
        }
        
        if mainView.txtName.text?.toTrim() == ""{
            isClickable = false
            return false
        }
        
        if mainView.txtIntensity.text?.toTrim() == ""{
            isClickable = false
            return false
        }
        
        if mainView.txtTargetHR.text?.toTrim() == ""{
            isClickable = false
            return false
        }
        
        if mainView.txtTrainingGoal.text?.toTrim() == ""{
            isClickable = false
            return false
        }
        
        if self.mainModelView.exercisesArray.count != 0 {
            var isAllFieled:Bool = true
            for model in self.mainModelView.exercisesArray {
                if model.laps == "" {
                    isAllFieled = false
                }
                
                print("Activity Name : \(self.mainView.txtActivity.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())")
                /*
                 if view?.txtActivity.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() !=  "Run (Indoor)".lowercased() && view?.txtActivity.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != "Run (Outdoor)".lowercased(){
                 
                 if model.percentage == "" {
                 isAllFieled = false
                 }
                 
                 if model.rest == "" || model.rest == nil || model.rest == "00:00" {
                 isAllFieled = false
                 }
                 
                 }*/
                
                let trainingGoalValue = mainView.txtTrainingGoal.text?.toTrim().lowercased()
                
                let speedIntervals = "Speed Intervals".lowercased()
                let lacateToleranceContinuous = "Lactate Tolerance (Continuous)".lowercased()
                let lacateToleranceIntervals = "Lactate Tolerance (Intervals)".lowercased()
                let aerobicIntervals = "Aerobic Intervals".lowercased()
                let aerobicCapacity = "Aerobic Capacity".lowercased()
                let sprint = "Sprint".lowercased()
                let speed = "Speed".lowercased()
                
                switch mainView.txtActivity.text?.toTrim().lowercased(){
                    
                case "Run (Outdoor)".lowercased():
                    
                    if (model.distance == "" || model.distance == nil || model.distance == "0.0") && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil || model.duration == "00:00:00") && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil || model.speed == "0.0") && self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if (model.pace == "" || model.pace == nil || model.pace == "00:00") && !self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == speedIntervals || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicIntervals{
                        if model.rest == "" || model.rest == nil || model.rest == "00:00" {
                            isAllFieled = false
                        }
                    }
                    
                case "Run (Indoor)".lowercased():
                    if (model.distance == "" || model.distance == nil || model.distance == "0.0") && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil || model.duration == "00:00:00") && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil || model.speed == "0.0") && self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if (model.pace == "" || model.pace == nil || model.pace == "00:00") && !self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == speedIntervals || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicIntervals{
                        if model.rest == "" || model.rest == nil || model.rest == "00:00" {
                            isAllFieled = false
                        }
                    }
                    
                case "Cycling (Indoor)".lowercased():
                    
                    if (model.distance == "" || model.distance == nil || model.distance == "0.0") && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil || model.duration == "00:00:00") && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil || model.speed == "0.0") && self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == sprint || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicCapacity{
                        if model.rest == "" || model.rest == nil || model.rest == "00:00" {
                            isAllFieled = false
                        }
                    }
                    
                    //Lvl is comment(CardioTrainingViewModel)(CardioTrainingLogVc)
//                    if model.lvl == "" || model.lvl == nil {
//                        isAllFieled = false
//                    }
                    
                    if (model.rpm == "" || model.rpm == nil || model.rpm == "0") && self.mainModelView.isShowRPM {
                        isAllFieled = false
                    }
                    
                    if (model.watt == "" || model.watt == nil || model.watt == "0") && !self.mainModelView.isShowRPM {
                        isAllFieled = false
                    }
                    
                case "Cycling (Outdoor)".lowercased():
                    
                    if (model.distance == "" || model.distance == nil || model.distance == "0.0") && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil || model.duration == "00:00:00") && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil || model.speed == "0.0") && self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if (model.rpm == "" || model.rpm == nil || model.rpm == "0") && self.mainModelView.isShowRPM {
                        isAllFieled = false
                    }
                    
                    if (model.watt == "" || model.watt == nil || model.watt == "0") && !self.mainModelView.isShowRPM {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == sprint || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicCapacity{
                        if model.rest == "" || model.rest == nil || model.rest == "00:00" {
                            isAllFieled = false
                        }
                    }
                    
                case "Swimming".lowercased():
                    
                    if (model.distance == "" || model.distance == nil || model.distance == "0.0") && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil || model.duration == "00:00:00") && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.pace == "" || model.pace == nil || model.pace == "00:00") && !self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == speed{
                        if model.rest == "" || model.rest == nil || model.rest == "00:00" {
                            isAllFieled = false
                        }
                    }
                    
                case "Others".lowercased():
                    
                    if (model.distance == "" || model.distance == nil || model.distance == "0.0") && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil || model.duration == "00:00:00") && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    //                    if (model.speed == "" || model.speed == nil || model.speed == "0.0") && self.mainModelView.isShowSpeed {
                    //                        isAllFieled = false
                    //                    }
                    //
                    //                    if (model.pace == "" || model.pace == nil || model.pace == "00:00") && !self.mainModelView.isShowSpeed {
                    //                        isAllFieled = false
                    //                    }
                    //
                    //                    if (model.rpm == "" || model.rpm == nil || model.rpm == "0") && self.mainModelView.isShowRPM {
                    //                        isAllFieled = false
                    //                    }
                    //
                    //                    if (model.watt == "" || model.watt == nil || model.watt == "0") && !self.mainModelView.isShowRPM {
                    //                        isAllFieled = false
                    //                    }
                    //
                    //                    if model.lvl == "" || model.lvl == nil {
                    //                        isAllFieled = false
                    //                    }
                    //
                    //                   if model.rest == "" || model.rest == nil || model.rest == "00:00" {
                    //                        isAllFieled = false
                    //                    }
                    
                default:
                    
                    if model.rest == "" || model.rest == nil || model.rest == "00:00" {
                        isAllFieled = false
                    }
                }
                
                if !isAllFieled {
                    isClickable = false
                    return false
                }else{
                    isClickable = true
                }
            }
        }else{
            if self.mainModelView.exercisesArray.count == 0 {
                isClickable = false
                return false

            }
        }
        
        if isClickable == true{
            return true
        }else{
            return false
        }
    }
    
    func changeColorAccordingToClickable(){
        if checkLogItClickableOrNot(){
            mainView.btnLogIt.backgroundColor = UIColor.appthemeRedColor
            mainView.btnLogIt.isUserInteractionEnabled = true
            
            [self.mainView.btnSaveAsTemplete,self.mainView.btnSendToFriend].forEach { (btn) in
                btn?.borderColor = UIColor.appthemeOffRedColor
                btn?.borderWidth = 1
                btn?.setTitleColor(UIColor.appthemeOffRedColor, for: .normal)
                btn?.isUserInteractionEnabled = true
            }
            
        }else{
            mainView.btnLogIt.backgroundColor = UIColor.appthemeGrayColor
            mainView.btnLogIt.isUserInteractionEnabled = false
            
            [self.mainView.btnSaveAsTemplete,self.mainView.btnSendToFriend].forEach { (btn) in
                btn?.borderColor = UIColor.appthemeBlackColor
                btn?.borderWidth = 1
                btn?.setTitleColor(UIColor.appthemeBlackColor, for: .normal)
                btn?.isUserInteractionEnabled = false
            }
        }
    }
    
}

extension CardioTrainingLogVC: NumericKeyboardDelegate {
    
    func numericKeyPressed(key: Int) {
        print("Numeric key \(key) pressed!")
    }
    
    func numericBackspacePressed() {
        print("Backspace pressed!")
    }
    
    func numericSymbolPressed(symbol: String) {
        print("Symbol \(symbol) pressed!")
    }
    
}

//HideShow keyboard
extension CardioTrainingLogVC {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        isKeyboardOpen = true
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        isKeyboardOpen = false
    }
}
extension CardioTrainingLogVC{
    
    func hideShowHeaderAccordingToActivity(name:String){
        
        let activityNameInLowerCased = name.lowercased()
        
        self.mainView.btnRPM.isUserInteractionEnabled = false
        self.mainView.vwLvl.isHidden = false
        self.mainModelView.isShowSpeed = false
        self.mainModelView.showSpeed(isShow: self.mainModelView.isShowSpeed)
        self.mainView.imgSpeedArrow.isHidden = false
        self.mainView.imgRPMArrow.isHidden = true
        self.mainView.viewPercentage.isHidden = false
        self.mainView.viewRPM.isHidden = true
        self.mainView.vwStyle.isHidden = true
        
        self.mainView.vwCyclingOutdoorPercentage.isHidden = true
        
        self.mainView.widthSpeedArrowImage.constant = 9
        
        switch activityNameInLowerCased {
            
        case "Run (Outdoor)".lowercased():
            self.mainView.vwLvl.isHidden = true
            
            self.mainView.stackViewHeader.spacing = 20
            
        case "Run (Indoor)".lowercased():
            self.mainView.vwLvl.isHidden = true
            self.mainView.stackViewHeader.spacing = 20
            
        case "Cycling (Indoor)".lowercased():
            self.mainView.btnRPM.isUserInteractionEnabled = true
            self.mainModelView.isShowSpeed = true
            self.mainModelView.showSpeed(isShow: self.mainModelView.isShowSpeed)
            self.mainView.imgSpeedArrow.isHidden = true
            self.mainView.imgRPMArrow.isHidden = false
            self.mainView.vwLvl.isHidden = false
            self.mainView.viewRPM.isHidden = false
            self.mainView.widthSpeedArrowImage.constant = 0
            
            self.mainView.stackViewHeader.spacing = 0
            
        case "Cycling (Outdoor)".lowercased():
            self.mainView.vwCyclingOutdoorPercentage.isHidden = false
            self.mainView.btnRPM.isUserInteractionEnabled = true
            self.mainModelView.isShowSpeed = true
            self.mainModelView.showSpeed(isShow: self.mainModelView.isShowSpeed)
            self.mainView.imgSpeedArrow.isHidden = true
            self.mainView.imgRPMArrow.isHidden = false
            self.mainView.vwLvl.isHidden = true
            self.mainView.viewRPM.isHidden = false
            self.mainView.widthSpeedArrowImage.constant = 0
            
            self.mainView.stackViewHeader.spacing = 0
            
        case "Swimming".lowercased():
            self.mainView.btnRPM.isUserInteractionEnabled = true
            self.mainModelView.isShowSpeed = false
            self.mainModelView.showSpeed(isShow: self.mainModelView.isShowSpeed)
            self.mainView.imgSpeedArrow.isHidden = true
            self.mainView.imgRPMArrow.isHidden = false
            self.mainView.viewPercentage.isHidden = true
            self.mainView.vwLvl.isHidden = true
            self.mainView.vwStyle.isHidden = false
            
            self.mainView.stackViewHeader.spacing = 65
            
        case "Others".lowercased():
            self.mainView.btnRPM.isUserInteractionEnabled = true
            self.mainView.viewRPM.isHidden = false
            self.mainView.imgRPMArrow.isHidden = false
            self.mainView.stackViewHeader.spacing = 0
        default:
            self.mainView.vwLvl.isHidden = true
            self.mainView.stackViewHeader.spacing = 0
            
        }
        
    }
    
}

//MARK: - scrollView Delegate
//MARK: - Animation of at one time bottom and above two bottom show
/*
extension CardioTrainingLogVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollCurrentOffset = scrollView.contentOffset.y
        
        print("scrollCurrentOffset:\(scrollCurrentOffset)")

        if isKeyboardOpen == true {
            return
        }
        
        if scrollView.contentSize.height <= mainView.safeAreaHeight {
            return
        }
        
        if self.mainView.mainScrollView.panGestureRecognizer.translation(in: scrollView).y > 0{
            print("Up")
            
            UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseOut, animations: {
                
                [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
                    vw?.alpha = 0.0
                }
                
                self.mainView.constraintTopVwLogIt.constant = -70
//                self.mainView.vwMainBottom.isUserInteractionEnabled = false
//                self.mainView.vwlogIt.isUserInteractionEnabled = false
//                self.mainView.vwBottom2Buttons.isUserInteractionEnabled = false
                
                self.mainView.layoutIfNeeded()
                
            }) { (state) in
                
                UIView.animate(withDuration: 0.2, delay: 0.4, options: .curveEaseIn, animations: {
                    
                    self.mainView.constraintBottomVwMainBottom.constant = -79
                    self.mainView.layoutIfNeeded()
                    
                    self.mainView.constraintVwMainBottomHeight.constant = 0
                    
                }, completion: nil)
                
            }
        }
        else{
            
            if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
                print("middle")
            }else{
                if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                    scrollEndMethod()
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        if isKeyboardOpen == true {
            return
        }

        NSObject.cancelPreviousPerformRequests(withTarget: self)
        scrollEndMethod()
    }
    
    func scrollEndMethod(){
        
        self.mainView.vwMainBottom.isHidden = false
//        self.mainView.vwMainBottom.isUserInteractionEnabled = true
//        self.mainView.vwlogIt.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            
            self.mainView.constraintBottomVwMainBottom.constant = 0
            self.mainView.layoutIfNeeded()
            
        }) { (state) in
            
            UIView.animate(withDuration: 0.2, delay: 0.3, options: .curveEaseOut, animations: {
                self.mainView.constraintTopVwLogIt.constant = 0
                
                [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
                    vw?.alpha = 1.0
                }
                
                self.mainView.layoutIfNeeded()
                
            }, completion: nil)
        }
    }
    
}*/

extension CardioTrainingLogVC : UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollCurrentOffset = scrollView.contentOffset.y
        
        if isKeyboardOpen == true {
            return
        }
        
        if scrollView.contentSize.height <= mainView.safeAreaHeight {
            return
        }
        
        if self.mainView.mainScrollView.panGestureRecognizer.translation(in: scrollView).y > 0{
            
            if scrollView.contentOffset.y <= (scrollView.contentSize.height - scrollView.frame.size.height){
//                print("scrollView.contentOffset.y :\(scrollView.contentOffset.y)")
//                print("scrollView.height :\(scrollView.frame.size.height)")
//
//                print("Final : \(scrollView.contentOffset.y - scrollView.frame.size.height)")
                
                let checkHeight = (scrollView.contentOffset.y + scrollView.frame.size.height) - scrollView.contentSize.height
                
                
//                if checkHeight <= -150{
//                    UIView.animate(withDuration: 0.2) {
//                        self.mainView.constraintBottomVwMainBottom.constant = -80
//                        self.mainView.layoutIfNeeded()
//                    }
//                }else{
//                    UIView.animate(withDuration: 0.2) {
//                        self.mainView.constraintBottomVwMainBottom.constant = 0
//                        self.mainView.layoutIfNeeded()
//                    }
//                }
                
                if checkHeight <= -80{
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.mainView.constraintBottomVwMainBottom.constant = -80
                        self.mainView.layoutIfNeeded()

                    }) { (status) in
                        [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
                            vw?.isHidden = true
                        }
                    }

                }else{
                    
                    UIView.animate(withDuration: 0.2, animations: {
                        self.mainView.constraintBottomVwMainBottom.constant = 0
                        self.mainView.layoutIfNeeded()
                        
                    }) { (status) in
                        
                        UIView.animate(withDuration: 0.1, delay: 0.4, options: .curveEaseInOut, animations: {
                            print("finish")
                        }) { (status) in
                            
                            if checkHeight >= (-60){
                                [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
                                    vw?.isHidden = false
                                }
                            }
                        }
                    }
                    
                }
                
//                checkHeight-> 50 ---> 1(alpha)
//                     checkHeight ---> (?)
                
                if checkHeight >= -63{
                    self.mainView.vwSendToFriend.alpha = 1 - (((-checkHeight) * 1)/50)
                    self.mainView.vwSaveAsTemplate.alpha = 1 - (((-checkHeight) * 1)/50)
                }else{
                    self.mainView.vwSendToFriend.alpha = 0
                    self.mainView.vwSaveAsTemplate.alpha = 0
                }
            }
        }
        else{
            
            if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height) - 80){
            }else{
                
                if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) - 80) {
                    print("Call method")
                    scrollEndMethod()
                }
            }
        }
    }
    
    func scrollEndMethod(){
        
        self.mainView.vwMainBottom.isHidden = false
        if (self.mainView.mainScrollView.contentOffset.y >= (self.mainView.mainScrollView.contentSize.height - self.mainView.mainScrollView.frame.size.height) - 80){
            
//            UIView.animate(withDuration: 0.2) {
//                self.mainView.constraintBottomVwMainBottom.constant = 0
//                self.mainView.layoutIfNeeded()
//            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.mainView.constraintBottomVwMainBottom.constant = 0
                self.mainView.layoutIfNeeded()
                
            }) { (status) in
                
                UIView.animate(withDuration: 0.1, delay: 0.4, options: .curveEaseInOut, animations: {
                    print("finish")
                }) { (status) in

//                    [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
//                        makeToast(strMessage: "DOWN DOWN DOWN")
//                        print("DOWN DOWN DONW")
//                        vw?.isHidden = false
//                    }
                }
            }

            print("Bottom Constant: \((self.mainView.mainScrollView.contentOffset.y + self.mainView.mainScrollView.frame.size.height) - self.mainView.mainScrollView.contentSize.height)")
            
            let checkHeight = (self.mainView.mainScrollView.contentOffset.y + self.mainView.mainScrollView.frame.size.height) - self.mainView.mainScrollView.contentSize.height
            
            if checkHeight < -80{
                
                UIView.animate(withDuration: 0.2, animations: {
                    
                }) { (status) in
                    [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
                        vw?.isHidden = true
                    }
                }
                
            }else{
                
                if checkHeight >= (-65){
                    [self.mainView.vwSendToFriend,self.mainView.vwSaveAsTemplate].forEach { (vw) in
                        vw?.isHidden = false
                    }
                }
            }
            
//                     checkHeight-> 50 ---> 1(alpha)
//                     checkHeight ---> (?)

            if checkHeight >= -63{
                self.mainView.vwSendToFriend.alpha = 1 - (((-checkHeight) * 1)/50)/1
                self.mainView.vwSaveAsTemplate.alpha = 1 - (((-checkHeight) * 1)/50)/1
            }else{
                self.mainView.vwSendToFriend.alpha = 0
                self.mainView.vwSaveAsTemplate.alpha = 0
            }
        }
        
    }
    
}

