//
//  RaceTimeVC-PickerView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 05/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension RaceTimeVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.mainModelView.pickerViewDistance {
            return 1
        }
        else {
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.mainModelView.pickerViewDistance {
            return GetAllData?.data?.raceDistance?.count ?? 0
        }
        else {
            if component == 0 {
                return 60
            }
            else if component == 1 {
                return 60
            }
            else {
                return 60
            }
        }
    }
    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return 100
//    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView != self.mainModelView.pickerViewDistance {
            let screen = (UIScreen.main.bounds.width - 50) / 3
            return CGFloat(screen)
        }
        else {
            return CGFloat(120) - 5
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//for view in pickerView.subviews{
//                view.backgroundColor = UIColor.clear
//            }        
        if pickerView == self.mainModelView.pickerViewDistance {
            let activity = GetAllData?.data?.raceDistance?[row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity?.name
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
            else if component == 1 {
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
        if pickerView == self.mainModelView.pickerViewDistance {
            let activity = GetAllData?.data?.raceDistance?[row]
            self.mainView.txtDistance.text = activity?.name
            self.mainModelView.raceDistanceId = activity?.id?.stringValue ?? ""
        }
        else {
            var data = "\(row)"
            if row < 9 {
                data = "0\(row)"
            }
            if component == 0 {
                self.mainModelView.totalDays = data
            }
            else if component == 1 {
                self.mainModelView.totalHrs =  data
            }
            else {
                self.mainModelView.totalMins =  data
            }
            self.mainView.txtTime.text = self.mainModelView.totalDays + ":" + self.mainModelView.totalHrs + ":" + self.mainModelView.totalMins
            self.mainModelView.raceTime = self.mainView.txtTime.text!
        }
    }
}
