//
//  FilterDropDownCell.swift
//  Load
//
//  Created by Haresh Bhai on 26/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol FilterSpecializationDelegate: class {
    func FilterSpecializationSelect()
    func FilterSelected(section:Int, id:String, name:String)
}

class FilterDropDownCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var txtDropDown: UITextField!
    
    //MARK:- Variables
    let pickerView = UIPickerView()
    var index:Int = 0
    weak var delegate:FilterSpecializationDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)       
        // Configure the view for the selected state
    }
    
    func setupUI() {
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        self.txtDropDown.delegate = self
        self.txtDropDown.inputView = pickerView
    }
    
    func setupFont() {
        self.txtDropDown.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtDropDown.setColor(color: .appthemeBlackColor)
    }
   
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if self.index == 0 && self.txtDropDown.text?.toTrim() == "" {
            let model = GetAllData?.data?.countries?.first
            self.txtDropDown.text =  model?.name
        }
        else if self.index == 1 && self.txtDropDown.text?.toTrim() == "" {
            let model = GetAllData?.data?.languages?.first
            self.txtDropDown.text =  model?.name
        }
        else if self.index == 2 && self.txtDropDown.text?.toTrim() == "" {
            let model = genderArray()
            self.txtDropDown.text = model.first
        }
        else if self.index == 4 && self.txtDropDown.text?.toTrim() == "" {
            let model = GetAllData?.data?.services?.first
            self.txtDropDown.text =  model?.name
        }
        else if self.index == 5 && self.txtDropDown.text?.toTrim() == "" {
            let model = rateArray()
            self.txtDropDown.text = model.first
        }
        return true
    }
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.index == 0 {
            return (GetAllData?.data?.countries?.count)!
        }
        else if self.index == 1 {
            return (GetAllData?.data?.languages?.count)!
        }
        else if self.index == 2 {
            return genderArray().count
        }
        else if self.index == 4 {
            return (GetAllData?.data?.services?.count)!
        }
        else if self.index == 5 {
            return rateArray().count
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
        if self.index == 0 {
            let model = GetAllData?.data?.countries![row]
            myView.lblText.text = model?.name
            self.delegate?.FilterSelected(section: self.index, id: (model?.id?.stringValue)!, name: (model?.name)!)
        }
        else if self.index == 1 {
            let model = GetAllData?.data?.languages![row]
            myView.lblText.text = model?.name
            self.delegate?.FilterSelected(section: self.index, id: (model?.id?.stringValue)!, name: (model?.name)!)
        }
        else if self.index == 2 {
            let model = genderArray()
            myView.lblText.text = model[row]
            self.delegate?.FilterSelected(section: self.index, id: model[row], name: "")
        }
        else if self.index == 4 {
            let model = GetAllData?.data?.services![row]
            myView.lblText.text = model?.name
            self.delegate?.FilterSelected(section: self.index, id: (model?.id?.stringValue)!, name: (model?.name)!)
        }
        else if self.index == 5 {
            let model = rateArray()
            myView.lblText.text = model[row]
            self.delegate?.FilterSelected(section: self.index, id: model[row], name: "")
        }
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.index == 0 {
            let model = GetAllData?.data?.countries![row]
            self.txtDropDown.text =  model?.name
        }
        else if self.index == 1 {
            let model = GetAllData?.data?.languages![row]
            self.txtDropDown.text =  model?.name
        }
        else if self.index == 2 {
            let model = genderArray()
            self.txtDropDown.text = model[row]
        }
        else if self.index == 4 {
            let model = GetAllData?.data?.services![row]
            self.txtDropDown.text =  model?.name
        }
        else if self.index == 5 {
            let model = rateArray()
            self.txtDropDown.text = model[row]
        }
    }
    
    //MARK:- @IBAction
    @IBAction func btnSelectClicked(_ sender: Any) {
        if index == 3 {
            self.delegate?.FilterSpecializationSelect()
        }
        else {
            self.txtDropDown.becomeFirstResponder()
        }
    }
}
