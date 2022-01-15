//
//  FeedCommentVc+PickerView.swift
//  Load
//
//  Created by iMac on 06/02/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

extension FeedCommentVC: UIPickerViewDataSource, UIPickerViewDelegate {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.mainModelView.reportPickerView {
            return self.mainModelView.arayReportList.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//for view in pickerView.subviews{
//                view.backgroundColor = UIColor.clear
//            }
        
//        if pickerView == self.mainModelView.reportPickerView {
            let activity = self.mainModelView.arayReportList[row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI(isShowImage: true)
            print("NAME : \(activity.name ?? "")")
            myView.lblText.text = activity.name ?? ""
            myView.lblText.textAlignment = .center
            myView.imgWidth.constant = 0
            self.mainModelView.feedReportId = Int(activity.id ?? 0)
            return myView
//        }
//        return UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.mainModelView.reportPickerView {
                
        }
    }
}
