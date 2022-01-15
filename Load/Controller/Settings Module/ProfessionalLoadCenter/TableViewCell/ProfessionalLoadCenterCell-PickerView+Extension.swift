//
//  ProfessionalLoadCenterCell.swift
//  Load
//
//  Created by Haresh Bhai on 31/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension ProfessionalLoadCenterCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == self.pickerViewDuration {
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerViewTypes {
            return GetAllData?.data?.professionalTypes?.count ?? 0
        } else if pickerView == self.pickerViewNumberOfClients {
            return self.arrayNumberOfClients.count
        } else if pickerView == self.pickerViewSessionPerPackage {
            return self.arraySessionPerPackage.count
        } else if pickerView == self.pickerViewDuration{
            
            if component == 0 {
                return self.arrayHours.count
            } else {
                return self.arrayMinutes.count
            }
            
        }
        else {
            return self.arrayOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = PickerView.instanceFromNib() as! PickerView
        myView.setupUI()
        myView.imgIcon.image = nil
        if pickerView == self.pickerViewTypes {
            myView.lblText.text = GetAllData?.data?.professionalTypes?[row].name ?? ""
        } else if pickerView == self.pickerViewNumberOfClients {
            myView.lblText.text = self.arrayNumberOfClients[row]
        } else if pickerView == self.pickerViewSessionPerPackage {
            myView.lblText.text = "\(self.arraySessionPerPackage[row])"
        } else if pickerView == self.pickerViewDuration {
            
            if component == 0 {
                myView.lblText.text = self.arrayHours[row]
            } else {
                myView.lblText.text = self.arrayMinutes[row]
            }
            
        }
        
        else {
            myView.lblText.text = self.arrayOptions[row]
        }
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.pickerViewTypes{
            self.txtValue.text = GetAllData?.data?.professionalTypes?[row].name ?? ""
            self.textMainArrayForPickerValueCheck[1] = GetAllData?.data?.professionalTypes?[row].name ?? ""
            self.delegate?.ProfessionalLoadCenterType(text:GetAllData?.data?.professionalTypes?[row].name ?? "" , section: self.tag, row: self.btnCell.tag)
            
            //For text
//            self.delegate?.ProfessionalLoadCenterDidFinish(text:GetAllData?.data?.professionalTypes?[row].name ?? "" , section: self.tag, row: self.btnCell.tag)
            //For button
            //            self.delegate?.ProfessionalLoadCenterButtonDidFinish(text:GetAllData?.data?.professionalTypes?[row].name ?? "" , section: self.tag, row: self.btnCell.tag)
        } else if pickerView == self.pickerViewNumberOfClients {
            //TextField Did End Editing method call so don't need to set delegate here
            self.txtValue.text = self.arrayNumberOfClients[row]
        } else if pickerView == self.pickerViewSessionPerPackage {
            self.txtValue.text = "\(self.arraySessionPerPackage[row])"
        } else if pickerView == self.pickerViewDuration {
            
            if component == 0 {
                    
                self.selectedHours = self.arrayHours[row]
                
            } else {
                
                self.selectedMinute = self.arrayMinutes[row]
            }
            
            self.txtValue.text = selectedHours + " hr " + selectedMinute + " mins"
            
        }
        
        else {
            self.txtValue.text = self.arrayOptions[row]
            self.delegate?.ProfessionalLoadCenterButtonDidFinish(text:self.arrayOptions[row], section: self.tag, row: self.btnCell.tag)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if pickerView == self.pickerViewDuration {
            let screen = (UIScreen.main.bounds.width - 50) / 3
            return CGFloat(screen)
        }
        
        return CGFloat(120) - 5
        
    }
    
}
