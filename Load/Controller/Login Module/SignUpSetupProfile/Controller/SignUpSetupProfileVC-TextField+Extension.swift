//
//  SignUpSetupProfileVC-TextField+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 29/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CountryPickerView

extension SignUpSetupProfileVC {
    //MARK:- TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        if textField == self.mainView.txtFirstName {
            self.mainView.viewFirstName.borderColors = txtAfterUpdate == "" ? UIColor.appThemeDarkGrayColor : UIColor.appthemeRedColor
            self.mainView.txtFirstName.textColor = txtAfterUpdate == "" ? UIColor.appThemeDarkGrayColor : UIColor.appthemeRedColor
            self.mainModelView.showNext()
            return true
        } else if textField == self.mainView.txtLastName {
            self.mainView.viewLastName.borderColors = txtAfterUpdate == "" ? UIColor.appThemeDarkGrayColor : UIColor.appthemeRedColor
            self.mainView.txtLastName.textColor = txtAfterUpdate == "" ? UIColor.appThemeDarkGrayColor : UIColor.appthemeRedColor
            self.mainModelView.showNext()
            return true
        }
        else if textField == self.mainView.txtHeight {
            self.mainModelView.isHeightSelected = txtAfterUpdate.count != 0
            self.mainView.viewHeight.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            
            self.mainView.txtHeight.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            
            self.mainModelView.showNext()
            
            return true
        }
        else if textField == self.mainView.txtWeight {
            self.mainModelView.isWeightSelected = txtAfterUpdate.count != 0
            self.mainView.viewWeight.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainView.txtWeight.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainModelView.showNext()
            return true
        }
        else if textField == self.mainView.txtLocation {
            self.mainView.viewLocation.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainView.txtLocation.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainModelView.showNext()
            return true
        }
        else if textField == self.mainView.txtPhoneArea {
            self.mainView.viewPhoneArea.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainView.txtPhoneArea.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainModelView.showNext()
            return true
        }
        else if textField == self.mainView.txtPhoneNumber {
            self.mainView.viewPhoneNumber.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainView.txtPhoneNumber.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainModelView.showNext()
            return true
        }
        return true
    }
}


extension SignUpSetupProfileVC: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.mainView.txtLocation.text = country.name
        self.mainView.txtPhoneArea.insertText(country.phoneCode)
        self.mainView.viewPhoneArea.borderColors = UIColor.appthemeRedColor
        self.mainView.txtPhoneArea.textColor = UIColor.appthemeRedColor
        self.mainView.viewLocation.borderColors = UIColor.appthemeRedColor
        self.mainView.viewLocationDropDown.backgroundColor = UIColor.appthemeRedColor
        self.mainView.txtLocation.textColor = UIColor.appthemeRedColor
        self.mainView.imgLocationDropDown.image = UIImage(named: "ic_right_birthday")
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
}

extension SignUpSetupProfileVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case mainModelView.heightPickerView:
            return mainModelView.heightArray.count
        case mainModelView.weightPickerView:
            return mainModelView.weightArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case mainModelView.heightPickerView:
            guard row <= mainModelView.heightArray.count else { return "0" }
            return mainModelView.heightArray[row]
        case mainModelView.weightPickerView:
            guard row <= mainModelView.weightArray.count else { return "0" }
            return mainModelView.weightArray[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case mainModelView.heightPickerView:
            guard row <= mainModelView.heightArray.count else { return }
            self.mainModelView.isHeightSelected = true
            self.mainView.txtHeight.text = mainModelView.heightArray[row] + " cm"
            self.mainView.viewHeight.borderColors = UIColor.appthemeRedColor
            self.mainView.viewHeightDropDown.backgroundColor = UIColor.appthemeRedColor
            self.mainView.txtHeight.textColor = UIColor.appthemeRedColor
            self.mainView.imgHeightDropDown.image = UIImage(named: "ic_right_birthday")
            return
        case mainModelView.weightPickerView:
            guard row <= mainModelView.weightArray.count else { return }
            self.mainModelView.isWeightSelected = true
            self.mainView.txtWeight.text = mainModelView.weightArray[row] + " kg"
            self.mainView.viewWeight.borderColors = UIColor.appthemeRedColor
            self.mainView.viewWeightDropDown.backgroundColor = UIColor.appthemeRedColor
            self.mainView.txtWeight.textColor = UIColor.appthemeRedColor
            self.mainView.imgWeightDropDown.image = UIImage(named: "ic_right_birthday")
            return
        default:
            return
        }
    }
}
