//
//  HeartRateVc.swift
//  Load
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class HeartRateVc: UIViewController {

    //MARK: - Variable
    
    lazy var mainView: HeartRateView = { [unowned self] in
        return self.view as! HeartRateView
    }()
    
    lazy var mainModelView: HeartRateViewModel = {
        return HeartRateViewModel(theController: self)
    }()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.setupUI(theController:self)
        self.mainModelView.setupUI()

        self.mainView.txtHRRestValue.setAsNumericKeyboard(delegate: self,isUseHyphen:true,withoutAnything: true)

//        self.mainView.txtHRMaxValue.text = (getUserDetail().data?.user?.dateOfBirth ?? "") == "" ? "" : self.getHRMax(date: getUserDetail().data?.user?.dateOfBirth ?? "")
//            self.mainModelView.hrMax
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
                
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Heart_Rate_key"))
        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }

}

//MARK: - IBAction method

extension HeartRateVc{
    
    func btnCloseClicked() {
        
        if self.mainView.txtHRMaxValue.text?.toTrim() == ""{
            makeToast(strMessage: getCommonString(key: "Please_enter_a_valid_maximum_heart_rate_key"))
            return
        }
        
        self.mainModelView.delegate?.HeartRateFinish(HRMaxValue: (self.mainView.txtHRMaxValue.text ?? "").replacingOccurrences(of: " bpm", with: ""), HRRestValue: self.mainView.txtHRRestValue.text ?? "",isHrMaxIsEstimated: self.mainModelView.isHrMaxIsEstimated)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func btnHRMaxTapped(_ sender: UIButton) {
        
        self.mainView.txtHRMaxValue.inputView = self.mainModelView.targatHRMaxPickerView
        
        let dataCheck = (getUserDetail()?.data?.user?.dateOfBirth ?? "") == "" ? "" : self.mainModelView.getHRMax(date: getUserDetail()?.data?.user?.dateOfBirth ?? "")
        
        if self.mainModelView.isHrMaxIsEstimated{
            self.mainModelView.targatHRMaxPickerView.selectRow(0, inComponent: 0, animated: false)
        }else{
            self.mainModelView.targatHRMaxPickerView.selectRow(1, inComponent: 0, animated: false)
        }
        
//        if self.mainView.txtHRMaxValue.text?.toTrim() == dataCheck{
//            
//        }else{
//            self.mainModelView.targatHRMaxPickerView.selectRow(1, inComponent: 0, animated: false)
//        }
        
        self.mainView.txtHRMaxValue.becomeFirstResponder()

    }
    
    @IBAction func btnHRRestTapped(_ sender: UIButton) {
        self.mainView.txtHRRestValue.becomeFirstResponder()
    }
    
}

//MARK: - TextField delegate method

extension HeartRateVc: UITextFieldDelegate{
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.mainView.txtHRMaxValue{
            
            if self.mainView.txtHRMaxValue.text?.toTrim() != "" {
                
                if self.mainView.txtHRMaxValue.text?.toTrim().toFloat() ?? 0.0 <= 100.0 {
                    makeToast(strMessage: getCommonString(key: "Please_enter_a_valid_maximum_heart_rate_key"))
                    return false
                }
            }
            let valueText = "\(self.mainView.txtHRMaxValue.text ?? "")"
            print("valueText:\(valueText)")
            self.mainView.txtHRMaxValue.text = valueText
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.mainView.txtHRMaxValue{
            
//            self.mainView.txtHRMaxValue.text = (self.mainView.txtHRMaxValue.text ?? "").replacingOccurrences(of: " bpm", with: "")
            
        }
        
        return true
        
    }
    
}
