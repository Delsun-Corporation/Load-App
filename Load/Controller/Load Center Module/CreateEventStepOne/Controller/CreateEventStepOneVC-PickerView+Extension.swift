//
//  CreateEventStepSecondVC-PickerView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 29/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension CreateEventStepOneVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.mainModelView.publicPickerView {
            return 1
        }
        else if pickerView == self.mainModelView.comeEarlierPickerView {
            return 1
        }
        else {
            return 2
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.mainModelView.publicPickerView {
            return self.mainModelView.publicArray.count
        }
        else if pickerView == self.mainModelView.comeEarlierPickerView {
            return self.mainModelView.comeEarlierArray.count
        }
        else {
            if component == 1 {
                return 60
            }
            else {
                return 24
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//        for view in pickerView.subviews{
//            view.backgroundColor = UIColor.clear
//        }
        
        if pickerView == self.mainModelView.publicPickerView {
            let activity = self.mainModelView.publicArray
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity[row]
            return myView
        }
        else if pickerView == self.mainModelView.comeEarlierPickerView {
            let activity = self.mainModelView.comeEarlierArray
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity[row]
            return myView
        }
        else {
            if component == 0 {
                let myView = PickerView.instanceFromNib() as! PickerView
                myView.setupUI()
                myView.imgIcon.image = nil
                myView.lblText.text = "\(row)"
                return myView
            }
            else {
                let myView = PickerView.instanceFromNib() as! PickerView
                myView.setupUI()
                myView.imgIcon.image = nil
                myView.lblText.text = "\(row)"
                return myView
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.mainModelView.publicPickerView {
            let activity = self.mainModelView.publicArray
            self.mainView.txtPublic.text = activity[row]
            self.mainModelView.selectedType = row
            self.mainView.imgPublic.image = UIImage(named: "ic_check_marck")
        }
        else if pickerView == self.mainModelView.comeEarlierPickerView {
            let activity = self.mainModelView.comeEarlierArray
            self.mainView.txtTimeArlier.text = activity[row]
            self.mainView.imgTimeArlier.image = UIImage(named: "ic_check_marck")
        }
        else {
            if component == 0 {
                self.mainModelView.totalHrs =  row
            }
            else {
                self.mainModelView.totalMins =  row
            }
            self.mainView.txtEventTime.text = getSecondsToHoursMinutesSeconds(seconds: self.mainModelView.getMinutes() * 60)//"\(self.mainModelView.getMinutes()) Mins"
            self.mainView.imgEventTime.isHidden = false
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return CGFloat(120) - 5
    }
}
