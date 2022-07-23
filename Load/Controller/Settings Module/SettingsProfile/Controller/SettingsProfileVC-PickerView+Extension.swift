//
//  SettingsProfileVC-PickerView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 25/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CountryPickerView

extension SettingsProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case mainModelView.genderPickerView:
            return genderArray().count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case mainModelView.genderPickerView:
            return mainModelView.genderArr[row]
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case mainModelView.genderPickerView:
            self.mainView.txtGender.text = mainModelView.genderArr[row]
        default:
            return
        }
    }
}

extension SettingsProfileVC: CountryPickerViewDelegate, CountryPickerViewDataSource {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        self.mainView.txtLocation.text = country.name
        self.mainView.txtCode.text = country.phoneCode
        self.mainModelView.locationId = country.code
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
}
