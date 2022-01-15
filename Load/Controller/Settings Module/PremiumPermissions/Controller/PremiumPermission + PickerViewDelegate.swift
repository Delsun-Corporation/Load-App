//
//  PremiumPermission + PickerViewDelegate.swift
//  Load
//
//  Created by Yash on 03/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation

extension PremiumPermissionVc: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.mainModelView.pickerViewPremiumProfile {
            return 1
        }
        else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.mainModelView.pickerViewPremiumProfile {
            //Data come from API set here
            return self.arrayViewProfile.count
        }
        else {
            //Data come from API set here
            return self.arrayViewFeeds.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if pickerView == self.mainModelView.pickerViewPremiumProfile {
            //change here to set Permium scroller data
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = self.arrayViewProfile[row]
            return myView
        }
        else {
            //change here to set Permium scroller data

            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = self.arrayViewFeeds[row]
            return myView
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.mainModelView.pickerViewPremiumProfile {
            self.mainView.txtPremiumProfileAnswer.text = self.arrayViewProfile[row]
            self.mainModelView.selectedViewMyProfile = self.arrayViewProfile[row]
        }
        else {
            self.mainView.txtFeedViewAnswer.text = self.arrayViewFeeds[row]
            self.mainModelView.selectedViewMyFeed = self.arrayViewFeeds[row]
        }
    }
}
