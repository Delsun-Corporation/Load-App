//
//  CreateCardioTrainingProgramTextFieldCell.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol CreateResistanceTrainingProgramTextFieldDelegate: class {
    func CreateResistanceProgramFinish(text:String, isStartDate:Bool)
    func CreateResistanceDateFinish(text:String, date: Date)
    func CreateResistanceDayFinish(text:String, id: String, limit:Int)
}

class CreateResistanceTrainingProgramTextFieldCell: UITableViewCell {
   
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtText: UITextField!
    @IBOutlet weak var viewLine: UIView!
    
    //MARK:- Vaiables
    let pickerView = UIPickerView()
    var programArray: [String] = ["By start date", "By end date"]
    weak var delegate:CreateResistanceTrainingProgramTextFieldDelegate?
    var isStartDate:Bool?
    var responseData: ResistancePresetTrainingProgram?

    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(title: String, text: String, placeHolder: String) {
        self.setupFont()
        if self.tag == 1 {
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.backgroundColor = UIColor.white
            self.txtText.inputView = pickerView
        }
        else if self.tag == 2 {
            self.DOBSetup()
        }
        else {
            pickerView.delegate = self
            pickerView.dataSource = self
            pickerView.backgroundColor = UIColor.white
            self.txtText.inputView = pickerView
        }
        self.lblTitle.text = title
        self.txtText.text = text
        self.txtText.placeholder = placeHolder
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtText.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeLightGrayColor)
        self.txtText.setColor(color: .appthemeBlackColor)
    }
    
    func DOBSetup() {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
            //datePickerView.setValue(UIColor.clear, forKey: "magnifierLineColor")
            datePickerView.setValue(false, forKey: "highlightsToday")
        }
        datePickerView.backgroundColor = UIColor.white
        
        datePickerView.setValue(UIColor.appthemeOffRedColor, forKeyPath: "textColor")
        if self.isStartDate != nil {
            if self.isStartDate == true {
                datePickerView.minimumDate = Date()
            }
            else {
                let monthsToAdd = responseData?.weeks?.intValue ?? 0
                print(monthsToAdd)
                datePickerView.minimumDate = Calendar.current.date(byAdding: .weekOfYear, value: monthsToAdd, to: Date())
            }
        }
        else {
            datePickerView.minimumDate = Date()
        }
        
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        self.txtText.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChangedStart), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChangedStart(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "MM/dd/yyyy"
        self.txtText.text = dateFormatter.string(from: sender.date)
        self.delegate?.CreateResistanceDateFinish(text: self.txtText.text!, date: sender.date.setTimeZero()!)
    }
    
    //MARK:- @IBAction
    @IBAction func btnCellClicked(_ sender: Any) {
        if self.tag == 1 {
            if self.txtText.text == "" {
                self.txtText.text = self.programArray.first ?? ""
                self.pickerView.selectRow(0, inComponent: 0, animated: false)
                self.delegate?.CreateResistanceProgramFinish(text: self.programArray[0], isStartDate: true)
            }
            self.txtText.becomeFirstResponder()
        }
        else if self.tag == 2 {
            if isStartDate == nil {
                return
            }
            
            if self.txtText.text == "" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeStyle = DateFormatter.Style.none
                dateFormatter.dateFormat = "MM/dd/yyyy"
                
                if self.isStartDate == true {
                    self.txtText.text = dateFormatter.string(from: Date().setTimeZero() ?? Date())
                    self.delegate?.CreateResistanceDateFinish(text: self.txtText.text!, date: Date().setTimeZero() ?? Date())
                }
                else {
                    let monthsToAdd = responseData?.weeks?.intValue ?? 0
                    let date = Calendar.current.date(byAdding: .weekOfYear, value: monthsToAdd, to: Date())
                    self.txtText.text = dateFormatter.string(from:  date?.setTimeZero() ?? date!)
                    self.delegate?.CreateResistanceDateFinish(text: self.txtText.text!, date:  date?.setTimeZero() ?? date!)
                }
            }
            self.txtText.becomeFirstResponder()
        }
        else {
            if self.txtText.text == "" {
                let model = GetAllData?.data?.trainingFrequencies?.first
                self.txtText.text = model?.title
                self.pickerView.selectRow(0, inComponent: 0, animated: false)
                self.delegate?.CreateResistanceDayFinish(text: self.txtText.text!, id: model?.id?.stringValue ?? "", limit: model?.maxDays?.intValue ?? 0)
            }
            self.txtText.becomeFirstResponder()
        }
    }
}

extension CreateResistanceTrainingProgramTextFieldCell: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.tag == 3 {
            return GetAllData?.data?.trainingFrequencies?.count ?? 0
        }
        else {
            return self.programArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//for view in pickerView.subviews{
//                view.backgroundColor = UIColor.clear
//            }
        
        if self.tag == 3 {
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = GetAllData?.data?.trainingFrequencies?[row].title
            return myView
        }
        else {
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = self.programArray[row]
            return myView
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.tag == 3 {
            let model = GetAllData?.data?.trainingFrequencies?[row]
            self.txtText.text = model?.title
            self.delegate?.CreateResistanceDayFinish(text: self.txtText.text!, id: model?.id?.stringValue ?? "", limit: model?.maxDays?.intValue ?? 0)
        }
        else {
            self.txtText.text = self.programArray[row]
            self.delegate?.CreateResistanceProgramFinish(text: self.programArray[row], isStartDate: row == 0)
        }
    }
}
