//
//  SettingsProfileVC-PickerView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 25/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension SettingsProfileVC: UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (GetAllData?.data?.countries?.count)!
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
        let model = GetAllData?.data?.countries![row]
        myView.lblText.text = model?.name
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let model = GetAllData?.data?.countries![row]
        self.mainView.txtLocation.text =  model?.name
        self.mainModelView.locationId = (model?.id?.stringValue)!
    }
}
