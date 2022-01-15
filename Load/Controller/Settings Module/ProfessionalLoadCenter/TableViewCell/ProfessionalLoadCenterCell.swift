//
//  ProfessionalLoadCenterCell.swift
//  Load
//
//  Created by Haresh Bhai on 31/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ProfessionalLoadCenterDelegate: class {
    func ProfessionalLoadCenterButtonDidFinish(text:String, section:Int, row:Int)
    func ProfessionalLoadCenterDidFinish(text:String, section:Int, row:Int)
    func ProfessionalLoadCenterType(text: String, section: Int, row: Int)
}

class ProfessionalLoadCenterCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var btnUpload: UIButton!
    @IBOutlet weak var lblMinForDuration: UILabel!
    @IBOutlet weak var constraintTxtTrainling: NSLayoutConstraint!
    
    //MARK:- Variables
    weak var delegate:ProfessionalLoadCenterDelegate?
    let arrayPlaceHolder: [String] = ["xxx cm", "xxx kg"]
    let arrayOptions: [String] = ["eWallet", "Cash"]
    
    let pickerViewDuration = UIPickerView()
    let arrayHours = ["00","01","02","03","04","05","06","07","08","09","10","11","12"]
    let arrayMinutes = ["00","15","30","45"]
    var selectedMinute = "00"
    var selectedHours = "00"
    
    let pickerViewTypes = UIPickerView()
    var professionalTypeId = 1
    
    var pickerViewSessionPerPackage = UIPickerView()
    var arraySessionPerPackage = Array(stride(from: 2, through: 10, by: 1))
    
    var pickerViewNumberOfClients = UIPickerView()
    var arrayNumberOfClients = ["1","2","3","4"]
    
    var textMainArrayForPickerValueCheck : [String] = []
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI(indexPath: IndexPath, title: [String], text: [String], placeholder: [String]) {
        self.textMainArrayForPickerValueCheck = text
        self.tag = indexPath.section
        self.txtValue.tag = indexPath.row
        self.btnCell.tag = indexPath.row
        self.btnUpload.tag = indexPath.row
        self.setupFont()
        self.txtValue.placeholder = ""
        self.txtValue.text = ""
        self.txtValue.delegate = self
        if title.count == 0 || indexPath.row == (title.count - 1) {
            self.viewLine.isHidden = true
        }else{
            self.viewLine.isHidden = false
        }
        self.lblTitle.text = title[indexPath.row]
        
        self.txtValue.isUserInteractionEnabled = true
        self.txtValue.inputView = nil
        self.txtValue.tintColor = UIColor.systemBlue
        
        self.lblMinForDuration.text = ""
        self.constraintTxtTrainling.constant = 25
        
        if indexPath.section == 0 {
            self.setView(btnCell: false, imgArrow: false, txtValue: true, btnUpload: true)
        }
        else if indexPath.section == 1 {
            
            self.txtValue.tintColor = UIColor.clear
            
            if indexPath.row == 0 {
                
                if text[indexPath.row] == ""{
                    self.lblMinForDuration.text = "mins"
                    self.constraintTxtTrainling.constant = 62
                } else {
                    self.lblMinForDuration.text = ""
                    self.constraintTxtTrainling.constant = 25
                }
                
                self.setHourMinutesInDuraitonPicker()
                pickerViewDuration.delegate = self
                pickerViewDuration.backgroundColor = UIColor.white
                self.txtValue.inputView = pickerViewDuration
                self.setView(btnCell: true, imgArrow: true, txtValue: false, btnUpload: true)

            } else if indexPath.row == 1 {
                
                pickerViewTypes.delegate = self
                pickerViewTypes.backgroundColor = UIColor.white
                self.txtValue.inputView = pickerViewTypes

                self.setView(btnCell: true, imgArrow: true, txtValue: false, btnUpload: true)
                
            } else if indexPath.row == 2 {
                self.setView(btnCell: true, imgArrow: true, txtValue: false, btnUpload: true)
                
                if text[1].lowercased() == "Package".lowercased() || text[1].lowercased() == "Single and package".lowercased() {
                    self.txtValue.isUserInteractionEnabled = true
                    self.lblTitle.textColor = .appthemeBlackColor
                    self.txtValue.textColor = .appthemeBlackColor
                    
                    pickerViewSessionPerPackage.delegate = self
                    pickerViewSessionPerPackage.backgroundColor = .white
                    self.txtValue.inputView = pickerViewSessionPerPackage
                    
                } else {
                    self.txtValue.isUserInteractionEnabled = false
                    self.lblTitle.textColor = .appthemeGrayColor
                    self.txtValue.textColor = .appthemeGrayColor
                }
                
            } else if indexPath.row == 3{
             
                pickerViewNumberOfClients.delegate = self
                pickerViewNumberOfClients.backgroundColor = .white
                self.txtValue.inputView = pickerViewNumberOfClients
                
                self.setView(btnCell: true, imgArrow: true, txtValue: false, btnUpload: true)

            }
            else {
                self.setView(btnCell: true, imgArrow: true, txtValue: false, btnUpload: true)
            }
            self.txtValue.placeholder = placeholder[indexPath.row]
            self.txtValue.text = text[indexPath.row]
        }
        else  if indexPath.section == 2 {
            self.setView(btnCell: false, imgArrow: false, txtValue: true, btnUpload: true)            
        }
        else if indexPath.section == 3 {
            self.setView(btnCell: false, imgArrow: false, txtValue: true, btnUpload: true)
//            self.txtValue.placeholder = placeholder[indexPath.row]
//            self.txtValue.text = text[indexPath.row]
        }
        else if indexPath.section == 4 {
            self.setView(btnCell: false, imgArrow: false, txtValue: true, btnUpload: true)
        }
        else if indexPath.section == 5 {
//            if indexPath.row == 0 {
//                self.setView(btnCell: false, imgArrow: true, txtValue: false, btnUpload: true)
//                self.txtValue.text = text[indexPath.row]
//            }
//            else {
                self.setView(btnCell: true, imgArrow: true, txtValue: false, btnUpload: true)
                self.txtValue.text = "$" + text[indexPath.row]
//            }
            self.txtValue.placeholder = placeholder[indexPath.row]
        }
        else if indexPath.section == 6 {
            self.setView(btnCell: false, imgArrow: false, txtValue: true, btnUpload: true)
        }
    }
        
    func setHourMinutesInDuraitonPicker(){
        
        let screen = UIScreen.main.bounds.width / 3
        
        let screenRest = UIScreen.main.bounds.width / 2
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + 116, y: (pickerViewDuration.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "hr"
            }
            else {
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + 35, y: (pickerViewDuration.frame.height - 30) / 2, width: screen, height: 30)
                label.text = "min"
            }
            label.textColor = .appthemeRedColor
            self.pickerViewDuration.addSubview(label)
        }
        
    }
    
    func setView(btnCell:Bool, imgArrow:Bool, txtValue:Bool, btnUpload:Bool) {
        self.btnCell.isHidden = btnCell
        self.imgArrow.isHidden = imgArrow
        self.txtValue.isHidden = txtValue
        self.btnUpload.isHidden = btnUpload
    }
    
    //MARK: - TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        print("Tag : \(self.tag)")
        print("TextField Tag : \(textField.tag)")
        
        if self.tag == 1 && textField.tag == 0{
            
            print("textField text:\(textField.text)")
            
            if textField.text == "" {
                self.lblMinForDuration.text = ""
                self.constraintTxtTrainling.constant = 25
                self.pickerViewDuration.selectRow(0, inComponent: 0, animated: false)
                self.pickerViewDuration.selectRow(0, inComponent: 1, animated: false)
                
                self.txtValue.text = selectedHours + " hr " + selectedMinute + " mins"

            } else {
                
                if let array = textField.text?.split(separator: " "){
                        
                    if array.count == 4{
                        selectedHours = "\(array[0])"
                        selectedMinute = "\(array[2])"
                        
                        let selectedHourIndex = self.arrayHours.firstIndex(of: selectedHours) ?? 0
                        let selectedMinuteIndex = self.arrayMinutes.firstIndex(of: selectedMinute) ?? 0
                            
                        self.pickerViewDuration.selectRow(Int(selectedHourIndex), inComponent: 0, animated: false)
                        self.pickerViewDuration.selectRow(Int(selectedMinuteIndex), inComponent: 1, animated: false)
                    }
                }
            }
            
        } else if self.tag == 1 && textField.tag == 1 {
            
            self.txtValue.text = self.textMainArrayForPickerValueCheck[textField.tag]
            for (index, data) in (GetAllData?.data?.professionalTypes?.enumerated())! {
                if self.professionalTypeId == data.id?.intValue {
                    self.pickerViewTypes.selectRow(index, inComponent: 0, animated: false)
                }
            }
            
        } else if self.tag == 1 && textField.tag == 3{
            
            if self.txtValue.text?.toTrim() == "" {
                self.pickerViewNumberOfClients.selectRow(0, inComponent: 0, animated: false)
            } else {
                self.txtValue.text = self.textMainArrayForPickerValueCheck[textField.tag]
                
                let index = self.arrayNumberOfClients.firstIndex(of: self.txtValue.text ?? "") ?? 0
                self.pickerViewNumberOfClients.selectRow(index, inComponent: 0, animated: false)
                
            }
            
        }
        else if self.tag == 5 {
            let str = self.txtValue.text?.replacingOccurrences(of: "$", with: "")
            self.txtValue.text = str
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if self.tag == 1 && textField.tag == 2 {
            
            
        } else if self.tag == 5 {
            let str = "$" + (self.txtValue.text ?? "")
            self.txtValue.text = str
        }
        
        self.delegate?.ProfessionalLoadCenterDidFinish(text: textField.text ?? "", section: self.tag, row: self.txtValue.tag)
        
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtValue.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMinForDuration.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.btnUpload.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.txtValue.setColor(color: .appthemeBlackColor)
        self.btnUpload.setColor(color: .appthemeRedColor)
    }
    
    //MARK:- @IBAction
    @IBAction func btnCellClicked(_ sender: UIButton) {
        
        if self.tag == 5 && sender.tag != 0 {
            self.txtValue.becomeFirstResponder()
        }
        else {
            self.delegate?.ProfessionalLoadCenterButtonDidFinish(text:"", section: self.tag, row: sender.tag)
        }
    }
    
    @IBAction func btnUploadClicked(_ sender: UIButton) {
        self.delegate?.ProfessionalLoadCenterButtonDidFinish(text:"", section: self.tag, row: sender.tag)
    }
}
