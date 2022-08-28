//
//  BillingInformationCardCell.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CountryPickerView

class BillingInformationCardCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var lblRequired: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    
    //MARK:- Variables
    weak var delegate:BillingInformationDelegate?
    weak var viewController: UIViewController?
    var previousTextFieldContent: String?
    var previousSelection: UITextRange?
    let pickerView = UIPickerView()
    let cpvInternal = CountryPickerView()
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI(title:String, text:String, placeHolder:String) {
        self.setupFont()
        self.lblTitle.text = title
        if self.txtValue.tag != 1 && self.txtValue.tag != 8 {
            self.txtValue.delegate = self
            self.txtValue.removeTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        }
        else {
            if self.txtValue.tag == 1 {
                self.txtValue.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
            }
        }
        self.txtValue.placeholder = placeHolder
        self.txtValue.text = text
        if self.txtValue.tag == 1 || self.txtValue.tag == 3 || self.txtValue.tag == 4 || self.txtValue.tag == 11 {
            self.txtValue.keyboardType = .numberPad
        }
        else {
            self.txtValue.keyboardType = .default
        }
        self.btnCell.isHidden = true
        if self.txtValue.tag == 8 {
            self.btnCell.isHidden = false
            self.txtValue.delegate = self
            self.txtValue.inputView = cpvInternal
            self.btnCell.isHidden = false
        }
        else {
            self.txtValue.inputView = nil
            self.txtValue.delegate = self
        }
        
        countryPickerSetupUI()
    }
    
    @IBAction func btnCellClicked() {
        if self.txtValue.tag == 8, let viewController = viewController {
            self.cpvInternal.showCountriesList(from: viewController)
        } else {
            // Nothing to do
        }
    }
    
    func countryPickerSetupUI() {
        cpvInternal.delegate = self
        cpvInternal.dataSource = self
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtValue.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblRequired.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.txtValue.setColor(color: .appthemeBlackColor)
        self.lblRequired.setColor(color: .appthemeRedColor)
    }
    
    //MARK: - TextField Delegates
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.txtValue.tag == 8 && textField.text?.toTrim() == "" {
            let activity = GetAllData?.data?.countries?.first
            self.txtValue.text = activity?.name
            self.delegate?.BillingInformationTextFinish(text: activity?.code ?? "", row: self.txtValue.tag, section: self.tag)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        var txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        // Check if textfield is for card number input, if yes, set max character to 16
        if self.txtValue.tag == 1 {
            let maxLength = 19
            guard txtAfterUpdate.count <= maxLength else {
                return false
            }
        }
        
        // Check if textfield is for ZIP code
        if self.txtValue.tag == 11 {
            let maxLength = 6
            guard txtAfterUpdate.count <= maxLength else {
                return false
            }
        }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (isBackSpace == -92) {
            //            println("Backspace was pressed")
        }
        
        if self.txtValue.tag == 2 {
            self.delegate?.BillingInformationTextFinish(text: txtAfterUpdate, row: self.txtValue.tag, section: self.tag)
            return self.isValidName(testStr: txtAfterUpdate)
        }
        
        if self.txtValue.tag == 3 && isBackSpace != -92 {
            if txtAfterUpdate.count == 6 {
                return false
            }
            if txtAfterUpdate.count == 2 {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
                    self.txtValue.text = txtAfterUpdate + "/"
                    txtAfterUpdate += "/"
                }
            }
        }
        
        if self.txtValue.tag == 4 {
            if txtAfterUpdate.count == 4 {
                return false
            }
        }
        self.delegate?.BillingInformationTextFinish(text: txtAfterUpdate, row: self.txtValue.tag, section: self.tag)
        return true
    }
    
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 16 {
            //            textField.text = previousTextFieldContent
            //            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertCreditCardSpaces(cardNumberWithoutSpaces, preserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
        
        self.delegate?.BillingInformationTextFinish(text: textField.text!, row: self.txtValue.tag, section: self.tag)
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func insertCreditCardSpaces(_ string: String, preserveCursorPosition cursorPosition: inout Int) -> String {
        // Mapping of card prefix to pattern is taken from
        // https://baymard.com/checkout-usability/credit-card-patterns
        
        // UATP cards have 4-5-6 (XXXX-XXXXX-XXXXXX) format
        // Uncomment line below to use 456 format
        //        let is456 = string.hasPrefix("1")
        
        // These prefixes reliably indicate either a 4-6-5 or 4-6-4 card. We treat all these
        // as 4-6-5-4 to err on the side of always letting the user type more digits.
        // Uncomment line below to use 465 format
        //        let is465 = [
        //            // Amex
        //            "34", "37",
        //
        //            // Diners Club
        //            "300", "301", "302", "303", "304", "305", "309", "36", "38", "39"
        //            ].contains { string.hasPrefix($0) }
        
        // In all other cases, assume 4-4-4-4-3.
        // This won't always be correct; for instance, Maestro has 4-4-5 cards according
        // to https://baymard.com/checkout-usability/credit-card-patterns, but I don't
        // know what prefixes identify particular formats.
        let is4444 = true
        
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in 0..<string.count {
            let needs4444Spacing = (is4444 && i > 0 && (i % 4) == 0)
            
            if needs4444Spacing {
                stringWithAddedSpaces.append(" ")
                
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
    
    func isValidName(testStr:String) -> Bool {
        let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
        let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
        let typedCharacterSet = CharacterSet(charactersIn: testStr)
        let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
        if alphabet {
            let array = testStr.components(separatedBy: " ")
            if array.count > 2 {
                return false
            }
        }
        return alphabet
    }
    
    @IBAction func btnCellClicked(_ sender: Any) {
        self.txtValue.becomeFirstResponder()
    }
}


extension BillingInformationCardCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GetAllData?.data?.countries?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        //for view in pickerView.subviews{
        //                view.backgroundColor = UIColor.clear
        //            }
        let activity = GetAllData?.data?.countries?[row]
        let myView = PickerView.instanceFromNib() as! PickerView
        myView.setupUI()
        myView.imgIcon.image = nil
        myView.lblText.text = activity?.name
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let activity = GetAllData?.data?.countries?[row]
        self.txtValue.text = activity?.name
        self.delegate?.BillingInformationTextFinish(text: activity?.code ?? "", row: self.txtValue.tag, section: self.tag)
    }
}
extension BillingInformationCardCell: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.txtValue.text = country.name
        self.delegate?.BillingInformationTextFinish(text: country.name, row: self.txtValue.tag, section: self.tag)
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
}
