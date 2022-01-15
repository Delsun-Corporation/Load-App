//
//  TimeUndertensionHeaderView.swift
//  Load
//
//  Created by iMac on 01/08/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

protocol TimeUnderTensionSelectionDelegate {
    func timeUnderTensionSelectedRow(index: Int)
    func timeUnderTensionUpdatedData(index: Int, second1:String, second2: String, second3: String, second4: String)
}


class TimeUndertensionHeaderView: UITableViewCell {
    
    //MARK: - Outlet
    @IBOutlet weak var lblIntensity: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblImprovmentMsg: UILabel!
    @IBOutlet weak var btnArrow: UIButton!
    
    @IBOutlet weak var lblSecond1: UILabel!
    @IBOutlet weak var lblSecond2: UILabel!
    @IBOutlet weak var lblSecond3: UILabel!
    @IBOutlet weak var lblSecond4: UILabel!
    @IBOutlet weak var btnValue: UIButton!
    @IBOutlet weak var txtValueForInput: UITextField!
    @IBOutlet weak var vwUnderLine: UIView!
    
    var array0 = ["X","0","1","2","3","4","5","6","7","8","9","10"]
    var array1 = ["X","0","1","2","3","4","5","6","7","8","9","10"]
    var array2 = ["X","0","1","2","3","4","5","6","7","8","9","10"]
    var array3 = ["X","0","1","2","3","4","5","6","7","8","9","10"]
    
    //MARK: - Variable
    var delegate : TimeUnderTensionSelectionDelegate?
    let ValuePickerView = UIPickerView()

    //MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFont()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(data:TimeUnderTensionList){
        
        self.lblIntensity.text = data.intensity
        self.lblImprovmentMsg.text = data.description
        
        if data.selectedIndex == 0{
            self.lblImprovmentMsg.isHidden = true
            self.btnArrow.isSelected = false
        }else{
            self.lblImprovmentMsg.isHidden = false
            self.btnArrow.isSelected = true
        }

        if data.userUpdatedTempo.contains(":") {
            
            let arrayValue = data.userUpdatedTempo.split(separator: ":")
            if arrayValue.count == 4 {
                self.lblSecond1.text = String(arrayValue[0])
                self.lblSecond2.text = String(arrayValue[1])
                self.lblSecond3.text = String(arrayValue[2])
                self.lblSecond4.text = String(arrayValue[3])
                
                self.totalSeconds()
            }
        }
    }
    
    func totalSeconds(){
        
        let intSecond1 = Int(self.lblSecond1.text ?? "") ?? 0
        let intSecond2 = Int(self.lblSecond2.text ?? "") ?? 0
        let intSecond3 = Int(self.lblSecond3.text ?? "") ?? 0
        let intSecond4 = Int(self.lblSecond4.text ?? "") ?? 0
        
        self.lblTime.text = String(intSecond1 + intSecond2 + intSecond3 + intSecond4) + " " + getCommonString(key: "seconds_key")
            
    }
    
    func setupFont(){
        lblIntensity.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        lblTime.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        lblImprovmentMsg.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        
        [self.lblSecond1,self.lblSecond2,self.lblSecond3,self.lblSecond4].forEach { (lbl) in
            lbl?.textColor = UIColor.appthemeRedColor
            lbl?.font = themeFont(size: 20, fontname: .ProximaNovaRegular)
        }
        
        self.txtValueForInput.delegate = self
        setColonInPickerView()
        
    }
    
    func setColonInPickerView(){
        
        let screen = UIScreen.main.bounds.width / 3
        
        for index in 0..<3 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                label.frame = CGRect(x: (screen * CGFloat(index)) + 35, y: (ValuePickerView.frame.height - 30) / 2, width: screen, height: 30)
                label.text = ":"
            }
            else  if index == 1 {
                label.frame = CGRect(x: (screen * CGFloat(index)), y: (ValuePickerView.frame.height - 30) / 2, width: screen, height: 30)
                label.text = ":"
            }else{
                label.frame = CGRect(x: (screen * CGFloat(index)) - 35, y: (ValuePickerView.frame.height - 30) / 2, width: screen, height: 30)
                label.text = ":"

            }
            label.textColor = .appthemeRedColor
            self.ValuePickerView.addSubview(label)
        }
        
        ValuePickerView.delegate = self
        ValuePickerView.backgroundColor = UIColor.white
        txtValueForInput.inputView = ValuePickerView

        
    }

    
    //MARK:- IBAction method
    
    @IBAction func btnArrowTapped(_ sender: UIButton) {
        self.delegate?.timeUnderTensionSelectedRow(index: sender.tag)
    }
    
    @IBAction func btnValue(_ sender: Any) {
        
        let zeroComponenetIndex = array0.firstIndex(of: self.lblSecond1.text ?? "") ?? 0
        let firstComponenetIndex = array1.firstIndex(of: self.lblSecond2.text ?? "") ?? 0
        let secondComponenetIndex = array2.firstIndex(of: self.lblSecond3.text ?? "") ?? 0
        let thirdComponenetIndex = array3.firstIndex(of: self.lblSecond4.text ?? "") ?? 0
        
        ValuePickerView.selectRow(Int(zeroComponenetIndex), inComponent: 0, animated: false)
        ValuePickerView.selectRow(Int(firstComponenetIndex), inComponent: 1, animated: false)
        ValuePickerView.selectRow(Int(secondComponenetIndex), inComponent: 2, animated: false)
        ValuePickerView.selectRow(Int(thirdComponenetIndex), inComponent: 3, animated: false)
        
        txtValueForInput.becomeFirstResponder()
    }
    
}

//MARK:- Picker delegate methods
extension TimeUndertensionHeaderView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return array1.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        if component == 0{
            let attributedString = NSAttributedString(string:array0[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
            return attributedString
        }
        else if component == 1{
            let attributedString = NSAttributedString(string:array1[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
            return attributedString
        }
        else if component == 2{
            let attributedString = NSAttributedString(string:array2[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
            return attributedString
        }else{
            let attributedString = NSAttributedString(string:array3[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.appthemeOffRedColor])
            return attributedString
        }

    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0{
            self.lblSecond1.text = self.array0[row]
        }
        else if component == 1{
            self.lblSecond2.text = self.array1[row]
        }
        else if component == 2{
            self.lblSecond3.text = self.array2[row]
        }else{
            self.lblSecond4.text = self.array3[row]
        }
        
        self.totalSeconds()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        let screen = (UIScreen.main.bounds.width - 50) / 4
        return CGFloat(screen)
        
    }
}

//MARK:- TextField delegate
extension TimeUndertensionHeaderView: UITextFieldDelegate {
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        self.delegate?.timeUnderTensionUpdatedData(index: textField.tag , second1: self.lblSecond1.text ?? "", second2: self.lblSecond2.text ?? "", second3: self.lblSecond3.text ?? "", second4: self.lblSecond4.text ?? "" )
        
        return true
        
    }
    
}
