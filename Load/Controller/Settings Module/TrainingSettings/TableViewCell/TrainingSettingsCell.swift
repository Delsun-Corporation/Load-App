//
//  TrainingSettingsCell.swift
//  Load
//
//  Created by Haresh Bhai on 30/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol TrainingSettingsDelegate: class {
    func TrainingSettingsTextField(text:String, section:Int, row:Int)
    func TrainingSettingsTextFieldDismissed()
    func TrainingSettingsButton(section:Int, row:Int)
    func TrainingSettingVO2MaxIsEstimated(isVO2MaxIsEstimated: Bool)
}

class TrainingSettingsCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!    
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblUnit: UILabel!
    
    //MARK:- Variables
    weak var delegate:TrainingSettingsDelegate?
    let arrayPlaceHolder: [String] = ["","cm", "kg", "",""]
    let arrayPlaceHolder2: [String] = ["","","ml/kg/min","",""]
    
    var VO2Value = ""
    var hrMax: CGFloat = 0.0
    var hrRest: CGFloat = 0.0
    let VO2PickerView = UIPickerView()
    var isVO2MaxIsEstimated = true
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.txtValue.setAsNumericKeyboard(delegate: self,isUseHyphen:false)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI(indexPath: IndexPath, title: [String], text:[String]) {
        self.setupFont()
        self.txtValue.delegate = self
        if title.count == 0 || indexPath.row == (title.count - 1) {
            self.viewLine.isHidden = true
        }else{
            self.viewLine.isHidden = false
        }
        self.lblTitle.text = title[indexPath.row]

        let doubleValue = Double(text[indexPath.row]) ?? 0.00
        let convertToDecimal = doubleValue.rounded(toPlaces: 1)
        
        if convertToDecimal == 0.0{
            self.txtValue.text = ""
        }else{
            self.txtValue.text = "\(convertToDecimal)".replace(target: ".0", withString: "")
        }
        
        self.txtValue.isUserInteractionEnabled = true
        
        self.txtValue.placeholder = "00"
        self.lblUnit.text = ""
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.btnCell.isHidden = false
                self.imgArrow.isHidden = false
                self.txtValue.isHidden = true
                self.txtValue.isUserInteractionEnabled = false
            }
            else if indexPath.row == 3 {
                self.btnCell.isHidden = true
                self.imgArrow.isHidden = true
                self.txtValue.isHidden = true
                if text[1] != "" && text[2] != "" {
                    self.txtValue.isHidden = false
                    let height = Float(text[1]) ?? 0
                    let weight = Float(text[2]) ?? 0
                    let bmi = Double((weight / height / height) * 10000)
                    self.txtValue.text = "\(bmi.rounded(toPlaces: 1))".replace(target: ".0", withString: "")
                }
                self.txtValue.isUserInteractionEnabled = false
            }
            else if indexPath.row == (title.count-1){
                self.btnCell.isHidden = false
                self.imgArrow.isHidden = false
                self.txtValue.isHidden = true
                self.txtValue.isUserInteractionEnabled = false
            }
            else {
                self.btnCell.isHidden = true
                self.imgArrow.isHidden = true
                self.txtValue.isHidden = false
//                self.txtValue.placeholder = self.arrayPlaceHolder[indexPath.row]
                self.lblUnit.text = self.arrayPlaceHolder[indexPath.row]
                self.txtValue.isUserInteractionEnabled = true
            }
        }
        else if indexPath.section == 1 {
            if indexPath.row == 2{
                self.btnCell.isHidden = true
                self.imgArrow.isHidden = true
                self.txtValue.isHidden = false
//                self.txtValue.placeholder = arrayPlaceHolder2[indexPath.row]
                self.lblUnit.text = arrayPlaceHolder2[indexPath.row]
                self.txtValue.isUserInteractionEnabled = true
                
                //PickerView set for VO2
                
                if self.isVO2MaxIsEstimated == true{
                    self.txtValue.text = "\(oneDigitAfterDecimal(value: self.calculationOfEstimatedVO2Max()))".replace(target: ".0", withString: "")
                    self.VO2PickerView.selectRow(0, inComponent: 0, animated: true)
                }else{
                    self.txtValue.text = "\(convertToDecimal)".replace(target: ".0", withString: "")
                    self.VO2PickerView.selectRow(1, inComponent: 0, animated: true)
                }
                
                VO2PickerView.delegate = self
                if #available(iOS 13.4, *) {
                    VO2PickerView.setValue(UIColor.clear, forKey: "magnifierLineColor")
                }
                VO2PickerView.backgroundColor = UIColor.white
                self.txtValue.inputView = self.VO2PickerView

            }else{
                self.btnCell.isHidden = false
                self.imgArrow.isHidden = false
                self.txtValue.isHidden = true
                self.txtValue.isUserInteractionEnabled = false
            }
        }
        else {
            self.btnCell.isHidden = false
            self.imgArrow.isHidden = false
            self.txtValue.isHidden = true
        }
    }
    
    //MARK: - TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
//        self.delegate?.TrainingSettingsTextField(text: txtAfterUpdate, section: self.tag, row: self.txtValue.tag)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let textFieldText: String = textField.text ?? ""
        
        if textFieldText != ""{
            print("TextFieldText Inner:\(textFieldText)")
            self.delegate?.TrainingSettingsTextField(text: textFieldText, section: self.tag, row: self.txtValue.tag)
        }
        
        //set for show pickerView
        if self.tag == 1 && textField.tag == 2{
            self.txtValue.inputView = self.VO2PickerView
        }else if self.tag == 0 && textField.tag == 3{
            self.delegate?.TrainingSettingsTextFieldDismissed()
        }

    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtValue.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblUnit.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblUnit.setColor(color: .appthemeBlackColor)
        self.txtValue.setColor(color: .appthemeBlackColor)
    }
    
    @IBAction func btnCellClicked(_ sender: UIButton) {
        self.delegate?.TrainingSettingsButton(section: self.tag, row: sender.tag)
    }
}

extension TrainingSettingsCell: NumericKeyboardDelegate {
    
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

//MARK: - PickerVIew delegate method

extension TrainingSettingsCell: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if pickerView == self.VO2PickerView {
            
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()

            myView.imgIcon.image = nil
            if row == 0{
                myView.lblText.text = "Estimated"
                self.isVO2MaxIsEstimated = true
                self.delegate?.TrainingSettingVO2MaxIsEstimated(isVO2MaxIsEstimated: self.isVO2MaxIsEstimated)

            }else{
                myView.lblText.text = "Customize"
                self.isVO2MaxIsEstimated = false
                self.delegate?.TrainingSettingVO2MaxIsEstimated(isVO2MaxIsEstimated: self.isVO2MaxIsEstimated)

            }
            
            return myView
            
        }
        
        return UIView()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.VO2PickerView {
            
            if row == 0 {
                self.isVO2MaxIsEstimated = true
                self.delegate?.TrainingSettingVO2MaxIsEstimated(isVO2MaxIsEstimated: self.isVO2MaxIsEstimated)
                self.txtValue.text = "\(oneDigitAfterDecimal(value: calculationOfEstimatedVO2Max()))".replace(target: ".0", withString: "")
            }
            else {
                
                self.isVO2MaxIsEstimated = false
                self.delegate?.TrainingSettingVO2MaxIsEstimated(isVO2MaxIsEstimated: self.isVO2MaxIsEstimated)
//                self.mainModelView.isHrMaxIsEstimated = false
                self.txtValue.text = ""
                self.txtValue.resignFirstResponder()
                self.txtValue.inputView = nil
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                        self.txtValue.setAsNumericKeyboard(delegate: self,isUseHyphen:true,withoutAnything: true)
                        self.txtValue.becomeFirstResponder()
                    }, completion: nil)
                }
            }
            
        }
    }

    func calculationOfEstimatedVO2Max() -> CGFloat{
        
        if hrRest == 0.0{
            return 0.0
        }else{
            return (15.3 * CGFloat((hrMax/hrRest)))
        }
    }

}
