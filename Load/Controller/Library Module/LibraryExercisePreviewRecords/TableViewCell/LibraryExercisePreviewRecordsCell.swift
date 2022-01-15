//
//  LibraryExercisePreviewRecordsCell.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol LibraryPreviewRecordsDelegate: class {
    func LibraryPreviewRecordsEstWeightDidFinish(index:Int, txtEstWeight: String)
    func LibraryPreviewRecordsActWeightDidFinish(index:Int, txtActWeight: String)
}

class LibraryExercisePreviewRecordsCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblRM: UILabel!
    @IBOutlet weak var txtEstWeight: UITextField!
    @IBOutlet weak var txtActWeight: UITextField!
    
    var actualWeightPikerView = UIPickerView()
    var enteredWeight = String()

    //MARK:- Variables
    weak var delegate:LibraryPreviewRecordsDelegate?
    var arrayActual : [String] = []
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.txtEstWeight.delegate = self
        self.txtActWeight.setAsNumericKeyboard(delegate: self,isUseHyphen:false)
        self.txtActWeight.delegate = self
        
        //TODO: - Picker disable
    //    actualWeightPikerView.delegate = self
   //     actualWeightPikerView.backgroundColor = UIColor.white
    //    self.txtActWeight.inputView = actualWeightPikerView
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(index: IndexPath, model: RepetitionMax?) {
        self.setupFont()
        self.tag = index.row
        self.txtActWeight.tag = index.row
        self.lblRM.text = model?.name ?? ""
        
        self.txtEstWeight.text = model?.estWeight == "0" ? "" : "\((Double(model?.estWeight ?? "0") ?? 0).rounded(toPlaces: 1))".replace(target: ".0", withString: "")
        self.txtActWeight.text = model?.actWeight == "0" ? "" :"\((Double(model?.actWeight ?? "0") ?? 0).rounded(toPlaces: 1))".replace(target: ".0", withString: "")
    }
    
    func setupFont() {
        self.lblRM.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.txtEstWeight.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.txtActWeight.font = themeFont(size: 13, fontname: .ProximaNovaRegular)

        self.lblRM.setColor(color: .appthemeBlackColor)
        self.txtEstWeight.setColor(color: .appthemeBlackColor)
        self.txtActWeight.setColor(color: .appthemeBlackColor)
    }
    
    func getEstiamedWeightWithCustomize(strEstimatedWeight:String) -> [String]{
        
        if strEstimatedWeight != ""{
            var arrayData = [String]()
            arrayData.append(strEstimatedWeight)
            return arrayData
        }
        
        return []
        
    }
    
    
    // MARK: TextFeild Delegates
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
//        if txtAfterUpdate.count > 4 {
//            return false
//        }
        if textField == self.txtEstWeight {
            self.delegate?.LibraryPreviewRecordsEstWeightDidFinish(index: self.tag, txtEstWeight: txtAfterUpdate)
        }
        else {
            self.delegate?.LibraryPreviewRecordsActWeightDidFinish(index: self.tag, txtActWeight: txtAfterUpdate)
        }
        return true
    }*/
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.txtEstWeight {
            self.delegate?.LibraryPreviewRecordsEstWeightDidFinish(index: self.tag, txtEstWeight: textField.text?.toTrim() ?? "")
        }
        else {
            self.delegate?.LibraryPreviewRecordsActWeightDidFinish(index: self.tag, txtActWeight: textField.text?.toTrim() ?? "")
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.txtActWeight{
            if textField.text == "0"{
               textField.text = ""
            }
        }
        
        return true
    }
    
    
    //TODO: - Disable pickerview
    
    /*
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {

        if textField == self.txtActWeight{

            if enteredWeight.count == 0 || enteredWeight == "" || txtEstWeight.text == "" || txtEstWeight.text == "0" || txtEstWeight.text?.count == 0{
                //  makeToast(strMessage: getCommonString(key: "Please_enter_weight_lifted_for_the_number_of_repetations_key"))
                return false
            }

            self.arrayActual = []
            self.arrayActual.append(self.txtEstWeight.text ?? "")
            self.arrayActual.append("Customize")

            if textField.text?.toTrim() == "" || textField.text?.toTrim() == "0" || textField.text?.count == 0{
                self.txtActWeight.text = self.arrayActual.first ?? ""
            }

        }

        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.txtActWeight{
            self.setupPickerView(isSetHidden: false)
            self.delegate?.LibraryPreviewRecordsActWeightDidFinish(index: self.tag, txtActWeight: txtActWeight.text ?? "")
        }
    }
    */
}


extension LibraryExercisePreviewRecordsCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayActual.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if row == 1{
            setupPickerView(isSetHidden: true)
        }else{
            self.txtActWeight.text = self.arrayActual[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//for view in pickerView.subviews{
//                view.backgroundColor = UIColor.clear
//            }
        let myView = PickerView.instanceFromNib() as! PickerView
        myView.setupUI()
        myView.imgIcon.image = nil
        myView.lblText.text = self.arrayActual[row]
        return myView
    }
    
    func setupPickerView(isSetHidden:Bool){
        self.txtActWeight.delegate = self
        self.txtActWeight.backgroundColor = UIColor.white
        if isSetHidden{
            self.endEditing(true)
            self.txtActWeight.delegate = self
            self.txtActWeight.inputView = nil
            self.txtActWeight.becomeFirstResponder()
            self.txtActWeight.text = ""
        }else{
            self.txtActWeight.inputView = self.actualWeightPikerView
        }
    }
    
}

extension LibraryExercisePreviewRecordsCell: NumericKeyboardDelegate {
    
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
