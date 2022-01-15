//
//  ProfessionalBasicProfileVC-PickerView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 02/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension ProfessionalBasicProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.mainModelView.langSpokenPickerView {
            return GetAllData?.data?.languages?.count ?? 0
        }
        else if pickerView == self.mainModelView.langWritenPickerView {
            return GetAllData?.data?.languages?.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//for view in pickerView.subviews{
//                view.backgroundColor = UIColor.clear
//            }
        let myView = PickerView.instanceFromNib() as! PickerView
        myView.setupUI()
        myView.imgIcon.image = nil
        if pickerView == self.mainModelView.langSpokenPickerView {
            myView.lblText.text = GetAllData?.data?.languages?[row].name
        }
        else if pickerView == self.mainModelView.langWritenPickerView {
            myView.lblText.text = GetAllData?.data?.languages?[row].name
        }
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.mainModelView.langSpokenPickerView {
            self.mainView.txtLanguageSpoken.text = GetAllData?.data?.languages?[row].name
            self.mainModelView.selectedLangSpoken = GetAllData?.data?.languages?[row].id?.intValue ?? 0
        }
        else if pickerView == self.mainModelView.langWritenPickerView {
            self.mainView.txtLanguageWriten.text = GetAllData?.data?.languages?[row].name
            self.mainModelView.selectedLangWriten = GetAllData?.data?.languages?[row].id?.intValue ?? 0
        }
    }
}
