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
        if textField == self.mainView.txtFullName {
            self.mainView.viewFirstName.borderColors = txtAfterUpdate == "" ? UIColor.appThemeDarkGrayColor : UIColor.appthemeRedColor
            self.mainView.txtFullName.textColor = txtAfterUpdate == "" ? UIColor.appThemeDarkGrayColor : UIColor.appthemeRedColor
            self.mainModelView.showNext(txtFullName: txtAfterUpdate, txtPhoneArea: self.mainView.txtPhoneArea.text ?? "", txtPhoneNumber: self.mainView.txtPhoneNumber.text ?? "", txtLocation: self.mainView.txtLocation.text ?? "")
            return true
        }
        else if textField == self.mainView.txtHeight {
            self.mainModelView.isHeightSelected = txtAfterUpdate.count != 0
            self.mainView.viewHeight.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            
            self.mainView.txtHeight.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            
            self.mainModelView.showNext(txtFullName: self.mainView.txtFullName.text ?? "", txtPhoneArea: self.mainView.txtPhoneArea.text ?? "", txtPhoneNumber: self.mainView.txtPhoneNumber.text ?? "", txtLocation: self.mainView.txtLocation.text ?? "")
            
            return true
        }
        else if textField == self.mainView.txtWeight {
            self.mainModelView.isWeightSelected = txtAfterUpdate.count != 0
            self.mainView.viewWeight.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainView.txtWeight.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainModelView.showNext(txtFullName: self.mainView.txtFullName.text ?? "", txtPhoneArea: self.mainView.txtPhoneArea.text ?? "", txtPhoneNumber: self.mainView.txtPhoneNumber.text ?? "", txtLocation: self.mainView.txtLocation.text ?? "")
            return true
        }
        else if textField == self.mainView.txtLocation {
            self.mainView.viewLocation.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainView.txtLocation.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainModelView.showNext(txtFullName: self.mainView.txtFullName.text ?? "", txtPhoneArea: self.mainView.txtPhoneArea.text ?? "", txtPhoneNumber: self.mainView.txtPhoneNumber.text ?? "", txtLocation: txtAfterUpdate)
            return true
        }
        else if textField == self.mainView.txtPhoneArea {
            self.mainView.viewPhoneArea.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainView.txtPhoneArea.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainModelView.showNext(txtFullName: self.mainView.txtFullName.text ?? "", txtPhoneArea: txtAfterUpdate, txtPhoneNumber: self.mainView.txtPhoneNumber.text ?? "", txtLocation: self.mainView.txtLocation.text ?? "")
            return true
        }
        else if textField == self.mainView.txtPhoneNumber {
            self.mainView.viewPhoneNumber.borderColors = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainView.txtPhoneNumber.textColor = txtAfterUpdate == "" ? UIColor.appthemeBlackColorAlpha30 : UIColor.appthemeRedColor
            self.mainModelView.showNext(txtFullName: self.mainView.txtFullName.text ?? "", txtPhoneArea: self.mainView.txtPhoneArea.text ?? "", txtPhoneNumber: txtAfterUpdate, txtLocation: self.mainView.txtLocation.text ?? "")
            return true
        }
        return true
    }
}


extension SignUpSetupProfileVC: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.mainView.txtLocation.text = country.name
        self.mainView.txtPhoneArea.text = country.phoneCode
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
}
