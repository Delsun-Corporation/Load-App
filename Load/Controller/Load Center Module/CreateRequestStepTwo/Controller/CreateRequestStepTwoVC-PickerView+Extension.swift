//
//  CreateRequestStepTwoVC-PickerView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 24/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension CreateRequestStepTwoVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.mainModelView.coachExperiencePickerView {
            return coachExperienceArray().count
        }       
        else if pickerView == self.mainModelView.locationPickerView {
            return GetAllData?.data?.countries?.count ?? 0
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
        
        if pickerView == self.mainModelView.coachExperiencePickerView {
            let activity = coachExperienceArray()
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity[row]
            return myView
        }
        else if pickerView == self.mainModelView.locationPickerView {
            let activity = GetAllData?.data?.countries![row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity!.name?.capitalized
            return myView
        }
        
        return UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.mainModelView.coachExperiencePickerView {
            let activity = coachExperienceArray()
            self.mainView.txtCoachExperience.text = activity[row] + " years"
            self.mainModelView.coachExperience = activity[row]
        }
        else if pickerView == self.mainModelView.locationPickerView {
            let activity = GetAllData?.data?.countries![row]
            self.mainView.txtLocation.text = activity?.name?.capitalized
            self.mainModelView.location = (activity?.id?.stringValue)!
        }
    }
}
