//
//  HeartRateVc+ PickerViewDelegate.swift
//  Load
//
//  Created by iMac on 20/10/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

extension HeartRateVc: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        
        if pickerView == self.mainModelView.targatHRMaxPickerView {
            
            let model = self.mainModelView.getHRList()[row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            if row == 0{
                myView.lblText.text = "Estimated"
            }else{
                myView.lblText.text = self.mainModelView.getHRList()[row]
            }
            
            
            //        if model.trimmed().contains(" Estimated HR"){
            //            let str = " Estimated HR"
            //
            //            let estimatedCount = str.count
            //            let totalCount = model.count
            //
            //            let finalCount = totalCount - estimatedCount
            //
            //            let value = model.dropFirst(finalCount)
            //            print("Value :\(value)")
            //            myView.lblText.text = String(value)
            //        }else{
            //            myView.lblText.text = model.capitalized
            //        }
            
            return myView
            
            
        }
        
        return UIView()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.mainModelView.targatHRMaxPickerView {
            
            if row == 0 {
                self.mainModelView.isHrMaxIsEstimated = true
                self.mainView.txtHRMaxValue.text = self.mainModelView.getHRList()[row]
            }
            else {
                self.mainModelView.isHrMaxIsEstimated = false
                self.mainView.txtHRMaxValue.text = ""
                self.mainView.txtHRMaxValue.resignFirstResponder()
                self.mainView.txtHRMaxValue.inputView = nil
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                        self.mainView.txtHRMaxValue.setAsNumericKeyboard(delegate: self,isUseHyphen:true,withoutAnything: true)
                        self.mainView.txtHRMaxValue.becomeFirstResponder()
                    }, completion: nil)
                }
            }
            
        }
    }
    
}

extension HeartRateVc: NumericKeyboardDelegate {
    
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
