//
//  ConfirmationPageVc.swift
//  Load
//
//  Created by iMac on 03/06/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class ConfirmationPageVc: UIViewController {

    //MARK:- Variables

    lazy var mainView: ConfirmationPageView = { [unowned self] in
        return self.view as! ConfirmationPageView
    }()
    
    lazy var mainModelView: ConfirmationPageViewModel = {
        return ConfirmationPageViewModel(theController: self)
    }()
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainModelView.setupUI()
        mainView.setupUI(theController: self)
        
        mainView.txtTotalDuration.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        mainView.txtAvgPace.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Here's_what_you_just_completed!_key"))
    }
    
    @IBAction func btnTotalDurationTapped(_ sender: UIButton) {
        self.mainView.txtTotalDuration.becomeFirstResponder()
    }
    
    @IBAction func btnTotalDistanceTapped(_ sender: UIButton) {
        self.mainView.txtTotalDistance.becomeFirstResponder()
    }
    
    @IBAction func btnAvgSpeedTapped(_ sender: UIButton) {
        self.mainView.txtAvgSpeed.becomeFirstResponder()
    }
    
    @IBAction func btnAvgPaceTapped(_ sender: UIButton) {
        self.mainView.txtAvgPace.becomeFirstResponder()
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        if (mainView.txtTotalDuration.text?.trimmingCharacters(in: .whitespaces))!.isEmpty
        {
            makeToast(strMessage: getCommonString(key: "Please_enter_total_duration_key"))
        }else if (mainView.txtTotalDistance.text?.trimmingCharacters(in: .whitespaces))!.isEmpty{
            makeToast(strMessage: getCommonString(key: "Please_enter_total_distance_key"))
        }else {
            if self.mainModelView.confirmationData?.isPaceSelected ?? true{
                if (mainView.txtAvgPace.text?.trimmingCharacters(in: .whitespaces))!.isEmpty{
                    makeToast(strMessage: getCommonString(key: "Please_enter_avg_pace_key"))
                }else{
                    let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "RPESelectionVc") as! RPESelectionVc
                    obj.mainModelView.delegateDismissRPESelection = self
                    obj.mainModelView.controllerMoveFrom = .trainingLog
                    obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
                    let nav = UINavigationController(rootViewController: obj)
                    nav.modalPresentationStyle = .overCurrentContext
                    self.present(nav, animated: true, completion: nil)
                }
            }else{
                if (mainView.txtAvgSpeed.text?.trimmingCharacters(in: .whitespaces))!.isEmpty{
                    makeToast(strMessage: getCommonString(key: "Please_enter_avg_speed_key"))
                }else{
                    let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "RPESelectionVc") as! RPESelectionVc
                    obj.mainModelView.delegateDismissRPESelection = self
                    obj.mainModelView.controllerMoveFrom = .trainingLog
                    obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
                    let nav = UINavigationController(rootViewController: obj)
                    nav.modalPresentationStyle = .overCurrentContext
                    self.present(nav, animated: true, completion: nil)
                }
            }
        }
    }
}

//MARK: - TextField Delegate
extension ConfirmationPageVc: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == mainView.txtTotalDuration {
            
            let charsLimit = 10

            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace

            return newLength <= charsLimit

//            guard let text = textField.text, let textRange = Range(range, in: text) else {
//                return false
//            }
//
//            var updatedText = text.replacingCharacters(in: textRange, with: string)
//            updatedText.removeAll(where: {$0 == " "})
//
//            let finalLength = updatedText.count + updatedText.count/2 - 1
//
//            print("finalLength : \(finalLength)")

//            if finalLength > 8 {
//                return false
//            }

//            for i in stride(from: 2, to: finalLength, by: 3) {
//                let index = updatedText.index(updatedText.startIndex, offsetBy: i)
//                print("indx:\(index)")
//                updatedText.append("  ")
//            }

//            textField.text = updatedText
//            return false

        }
        else if textField == self.mainView.txtAvgSpeed || textField == self.mainView.txtTotalDistance{

            
            guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                return true
            }

            let newText = oldText.replacingCharacters(in: r, with: string)
            let isNumeric = newText.isEmpty || (Double(newText) != nil)
            let numberOfDots = newText.components(separatedBy: ".").count - 1

            let numberOfDecimalDigits: Int
            if let dotIndex = newText.firstIndex(of: ".") {
                numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
            } else {
                numberOfDecimalDigits = 0
            }

            return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 1

            
            /*
            let acitivityName = self.mainModelView.confirmationData?.trainingActivity?.name?.lowercased() ?? ""

            if acitivityName == "Run (Outdoor)".lowercased() || acitivityName == "Run (Indoor)".lowercased(){

                if self.mainModelView.confirmationData?.isPaceSelected == true{

                    guard let text = textField.text, let textRange = Range(range, in: text) else {
                        return false
                    }

                    var updatedText = text.replacingCharacters(in: textRange, with: string)

                    updatedText.removeAll(where: {$0 == ":"})
                    let finalLength = updatedText.count + updatedText.count/2 - 1

                    if finalLength > 5 {
                        return false
                    }

                    for i in stride(from: 2, to: finalLength, by: 3) {
                        let index = updatedText.index(updatedText.startIndex, offsetBy: i)
                        updatedText.insert(":", at: index)
                    }

                    textField.text = updatedText
                    return false

                }else{
                       
                    guard let oldText = textField.text, let r = Range(range, in: oldText) else {
                        return true
                    }

                    let newText = oldText.replacingCharacters(in: r, with: string)
                    let isNumeric = newText.isEmpty || (Double(newText) != nil)
                    let numberOfDots = newText.components(separatedBy: ".").count - 1

                    let numberOfDecimalDigits: Int
                    if let dotIndex = newText.index(of: ".") {
                        numberOfDecimalDigits = newText.distance(from: dotIndex, to: newText.endIndex) - 1
                    } else {
                        numberOfDecimalDigits = 0
                    }

                    return isNumeric && numberOfDots <= 1 && numberOfDecimalDigits <= 2

                }

            }else if acitivityName == "Swimming".lowercased() {

                guard let text = textField.text, let textRange = Range(range, in: text) else {
                    return false
                }

                var updatedText = text.replacingCharacters(in: textRange, with: string)
                updatedText.removeAll(where: {$0 == ":"})
                let finalLength = updatedText.count + updatedText.count/2 - 1

                if finalLength > 5 {
                    return false
                }

                for i in 	(from: 2, to: finalLength, by: 3) {
                    let index = updatedText.index(updatedText.startIndex, offsetBy: i)
                    updatedText.insert(":", at: index)
                }

                textField.text = updatedText
                return false

            }
*/
        }else if textField == mainView.txtAvgPace{
            
            let charsLimit = 6

            let startingLength = textField.text?.count ?? 0
            let lengthToAdd = string.count
            let lengthToReplace =  range.length
            let newLength = startingLength + lengthToAdd - lengthToReplace

            return newLength <= charsLimit
            
        }
        
        return true
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        if textField == self.mainView.txtTotalDuration{
            let str = mainView.txtTotalDuration.text!
            
            if mainView.txtTotalDuration.text?.count == 3{
                if mainView.txtTotalDuration.text?.last == " "{
                    
                }else{
                    let position = 1
                    let subStr = str.prefix(upTo: str.index(str.startIndex, offsetBy: position)) + str.suffix(from: str.index(str.startIndex, offsetBy: (position + 1)))
                    self.mainView.txtTotalDuration.text = String(subStr)
                }
            }
            
            if mainView.txtTotalDuration.text?.count == 7{
                if mainView.txtTotalDuration.text?.last == " "{
                    
                }else{
                    let position = 5
                    let subStr = str.prefix(upTo: str.index(str.startIndex, offsetBy: position)) + str.suffix(from: str.index(str.startIndex, offsetBy: (position + 1)))
                    self.mainView.txtTotalDuration.text = String(subStr)
                }
            }
            
            if mainView.txtTotalDuration.text?.count ?? 0 < 3{
                mainView.txtTotalDuration.text = mainView.txtTotalDuration.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                mainView.txtTotalDuration.text! += "  "
            }
            else if (mainView.txtTotalDuration.text?.count ?? 0 < 7) && (mainView.txtTotalDuration.text?.count ?? 0 > 3){
                mainView.txtTotalDuration.text = mainView.txtTotalDuration.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                mainView.txtTotalDuration.text! += "  "
            }
            
            if mainView.txtTotalDuration.text?.count == 3{
                mainView.txtTotalDuration.text = mainView.txtTotalDuration.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            }else if mainView.txtTotalDuration.text?.count == 7{
                mainView.txtTotalDuration.text = mainView.txtTotalDuration.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
            
        }else if textField == self.mainView.txtAvgPace{
            
            let str = mainView.txtAvgPace.text!
            
            if mainView.txtAvgPace.text?.count == 3{
                if mainView.txtAvgPace.text?.last == " "{
                    
                }else{
                    let position = 1
                    let subStr = str.prefix(upTo: str.index(str.startIndex, offsetBy: position)) + str.suffix(from: str.index(str.startIndex, offsetBy: (position + 1)))
                    self.mainView.txtAvgPace.text = String(subStr)
                }
            }
            
            if mainView.txtAvgPace.text?.count ?? 0 < 3{
                mainView.txtAvgPace.text = mainView.txtAvgPace.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                mainView.txtAvgPace.text! += "  "
            }
            
            if mainView.txtAvgPace.text?.count == 3{
                mainView.txtAvgPace.text = mainView.txtAvgPace.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
            
        if textField == mainView.txtTotalDuration{
            
            let strColon = mainView.txtTotalDuration.text?.replacingOccurrences(of: "  ", with: ":")
            print("text:\(strColon)")

            if strColon?.count ?? 0 < 8{
                makeToast(strMessage: getCommonString(key: "Please_enter_total_duration_key"))
                return false
            }
            
            if let textFiedlText = strColon?.contains(":"){
                let dataArray = strColon?.split(separator: ":")
                print("dataArray count : \(dataArray?.count)")

                if dataArray?.count == 3{
                    print("dataArray 3 count 0: \(dataArray?[0])")
                    print("dataArray 3 count 1: \(dataArray?[1])")
                    print("dataArray 3 count 2: \(dataArray?[2])")

                    if Int(String(dataArray?[1] ?? "")) ?? 0 > 59{
                        makeToast(strMessage: "Please enter valid minutes")
                        return false
                    }else if Int(String(dataArray?[2] ?? "")) ?? 0 > 59{
                        makeToast(strMessage: "Please enter valid seconds")
                        return false
                    }

                }
                //MARK: - For mm:ss formate uncomment this
                /*
                else if dataArray?.count == 2{
                    print("dataArray 2 count 0: \(dataArray?[0])")
                    print("dataArray 2 count 1: \(dataArray?[1])")

                    if Int(String(dataArray?[0] ?? "")) ?? 0 > 59{
                        makeToast(strMessage: "Please enter valid minutes")
                        return false
                    }else if Int(String(dataArray?[1] ?? "")) ?? 0 > 59{
                        makeToast(strMessage: "Please enter valid seconds")
                        return false
                    }
                }
                */
            }else{
                return false
            }

            
            if strColon == self.mainModelView.enteredTotalDuration{
                print("same duration value")
            } else {
                self.mainModelView.apiCallGetAndUpdateData(isForUpdate: true, txtTotalDuration: strColon ?? "", txtTotalDistance: "", txtAvgSpeed: "", txtAvgPace: "", progress: false)
            }
        }
        else if textField == self.mainView.txtTotalDistance{
            
            if !(mainView.txtTotalDistance.text?.trimmingCharacters(in: .whitespaces))!.isEmpty{
                
                if !(mainView.txtTotalDistance.text?.toFloat() == 0.0){
                    
                    
                    if oneDigitAfterDecimal(value: self.mainView.txtTotalDistance.text?.toFloat() ?? 0.0) == self.mainModelView.enteredTotalDistance{
                        print("same distance value")
                    } else {
                        self.mainModelView.apiCallGetAndUpdateData(isForUpdate: true, txtTotalDuration: "", txtTotalDistance: self.mainView.txtTotalDistance.text ?? "", txtAvgSpeed: "", txtAvgPace: "", progress: false)
                    }

                }else{
                    makeToast(strMessage: getCommonString(key: "Please_enter_total_distance_key"))
//                    return false
                }
                
            }else{
                makeToast(strMessage: getCommonString(key: "Please_enter_total_distance_key"))
                return false
            }
            
        }else if textField == self.mainView.txtAvgPace{
            
            let strColon = mainView.txtAvgPace.text?.replacingOccurrences(of: "  ", with: ":")
            print("text:\(strColon)")

            if strColon?.count ?? 0 < 5{
                makeToast(strMessage: getCommonString(key: "Please_enter_avg_pace_key"))
                return false
            }
0
            if let textFiedlText = strColon?.contains(":"){
                let dataArray = strColon?.split(separator: ":")
                print("dataArray count : \(dataArray?.count)")
                
                if dataArray?.count == 2{
                    print("dataArray 2 count 0: \(dataArray?[0])")
                    print("dataArray 2 count 1: \(dataArray?[1])")
                    
                    if Int(String(dataArray?[0] ?? "")) ?? 0 > 59{
                        makeToast(strMessage: "Please enter valid minutes")
                        return false
                    }else if Int(String(dataArray?[1] ?? "")) ?? 0 > 59{
                        makeToast(strMessage: "Please enter valid seconds")
                        return false
                    }
                }
            }else{
                return false
            }
            
            if !(mainView.txtAvgPace.text?.trimmingCharacters(in: .whitespaces))!.isEmpty{
                
                if strColon == self.mainModelView.enteredAvgPace{
                    print("same avg pace value")
                } else {
                    self.mainModelView.apiCallGetAndUpdateData(isForUpdate: true, txtTotalDuration: "", txtTotalDistance: "", txtAvgSpeed: "", txtAvgPace: strColon ?? "", progress: false)
                }
            }
            
            
        }else if textField == self.mainView.txtAvgSpeed{
            
            if !(mainView.txtAvgSpeed.text?.trimmingCharacters(in: .whitespaces))!.isEmpty{
                
                if !(mainView.txtAvgSpeed.text?.toFloat() == 0.0){
                    
                    if oneDigitAfterDecimal(value: self.mainView.txtAvgSpeed.text?.toFloat() ?? 0.0) == self.mainModelView.enteredAvgSpeed{
                        print("same avg speed value")
                    } else {
                        self.mainModelView.apiCallGetAndUpdateData(isForUpdate: true, txtTotalDuration: "", txtTotalDistance: "", txtAvgSpeed: self.mainView.txtAvgSpeed.text ?? "", txtAvgPace: "", progress: false)
                    }

                }else{
                    makeToast(strMessage: getCommonString(key: "Please_enter_avg_speed_key"))
//                    return false
                }

            }else{
                makeToast(strMessage: getCommonString(key: "Please_enter_avg_speed_key"))
                return false
            }
        }
            
        self.changeColorAccordingToClickable()
        
        return true
    }

}

//MARK: - Dismiss Delegate

extension ConfirmationPageVc: delegateDismissRPESelection{
    func dismissdelegateDismissRPESelection() {
        self.mainModelView.delegateConfirmation?.dismissConfirmationPage()
    }
}

//MARK: - check clikable

extension ConfirmationPageVc{
    
    func changeColorAccordingToClickable(){
        if checkNextClickableOrNot(){
            mainView.btnNext.backgroundColor = UIColor.appthemeRedColor
            mainView.btnNext.isUserInteractionEnabled = true
        }else{
            mainView.btnNext.backgroundColor = UIColor.appthemeGrayColor
            mainView.btnNext.isUserInteractionEnabled = false
        }
    }
    
    func checkNextClickableOrNot() -> Bool{
        
        var isClickable = true
        
        if ((mainView.txtTotalDuration.text?.trimmingCharacters(in: .whitespaces))!.isEmpty) || (mainView.txtTotalDuration.text == "00  00  00") {
            isClickable = false
        }
        
        if (mainView.txtTotalDistance.text?.trimmingCharacters(in: .whitespaces))!.isEmpty || (mainView.txtTotalDistance.text == "0") || (mainView.txtTotalDistance.text?.toFloat() == 0.0){
            isClickable = false
        }
        
        if self.mainModelView.confirmationData?.isPaceSelected ?? true{
            if (mainView.txtAvgPace.text?.trimmingCharacters(in: .whitespaces))!.isEmpty || (mainView.txtAvgPace.text == "00  00"){
                isClickable = false
            }
        }else{
            if (mainView.txtAvgSpeed.text?.trimmingCharacters(in: .whitespaces))!.isEmpty || (mainView.txtAvgSpeed.text == "0") || (mainView.txtAvgSpeed.text?.toFloat() == 0.0){
                isClickable = false
            }
        }
        
        return isClickable
    }
    
}
