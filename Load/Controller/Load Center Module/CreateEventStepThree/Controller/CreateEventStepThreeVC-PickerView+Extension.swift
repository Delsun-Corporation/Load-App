//
//  CreateEventStepThreeVC-PickerView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 16/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension CreateEventStepThreeVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return GetAllData?.data?.currency?.count ?? 0
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
        myView.lblText.text = GetAllData?.data?.currency?[row].name
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.mainView.txtCurrency.text = GetAllData?.data?.currency?[row].name
        self.mainModelView.currencyId = (GetAllData?.data?.currency?[row].id?.intValue)!
    }
}
