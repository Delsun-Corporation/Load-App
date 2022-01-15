//
//  TopUpPaymentPopUpVc.swift
//  Load
//
//  Created by Yash on 07/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class TopUpPaymentPopUpVc: UIViewController {

    //MARK:- Variables
    lazy var mainView: TopUpPaymentPopupView = { [unowned self] in
        return self.view as! TopUpPaymentPopupView
        }()
    
    lazy var mainModelView: TopUpPaymentPopupViewModel = {
        return TopUpPaymentPopupViewModel(theController: self)
    }()

    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        self.mainModelView.setupUI()
        
        self.mainView.txtTopUpAmount.setAsNumericKeyboard(delegate: self,isUseHyphen:false)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissableViewTapped))
        self.mainView.vwBackground.addGestureRecognizer(gestureRecognizer)
    }
    
}

//MARK: - IBAction method

extension TopUpPaymentPopUpVc {
    
    @IBAction func btnTopUpTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "TopUpPaymentSuccessPopupVc") as! TopUpPaymentSuccessPopupVc
        obj.handlerClose = {[weak self] in
            self?.dismissableViewTapped()
        }
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true, completion: nil)
        
    }
    
    @objc func dismissableViewTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func isButtonClickable() -> Bool{
        
        if self.mainView.txtTopUpAmount.text?.toTrim().contains(".") ?? false {
            
            if let data = self.mainView.txtTopUpAmount.text?.toTrim().split(separator: "."){
                
                if data.count == 2 {
                    let firstData = data[0]
                    let secondData = data[1]
                    
                    if Int(firstData) == 0 && Int(secondData) == 0{
                        return false
                    }

                } else if data.count == 1{
                    let firstData = data[0]
                    if Int(firstData) == 0{
                        return false
                    }
                }
                
            }
            
        } else {
            
            if Int(self.mainView.txtTopUpAmount.text?.toTrim() ?? "0") == 0 || Int(self.mainView.txtTopUpAmount.text?.toTrim() ?? "0") == nil {
                return false
            }
            
        }
        
        return true
    }
    
    func changeColorAccordingToValue(){
        
        if self.isButtonClickable() {
            self.mainView.btnTopUp.backgroundColor = UIColor.appthemeOffRedColor
            self.mainView.btnTopUp.isUserInteractionEnabled = true
        }
        else {
            
            self.mainView.btnTopUp.backgroundColor = UIColor.appthemeGrayColor
            self.mainView.btnTopUp.isUserInteractionEnabled = false
        }
        
    }

}

//MARK: - TextField Delegate method

extension TopUpPaymentPopUpVc: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        let str = self.mainView.txtTopUpAmount.text?.replacingOccurrences(of: "$", with: "")
        self.mainView.txtTopUpAmount.text = str?.toTrim()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if self.isButtonClickable(){
            
        }else {
            self.mainView.btnTopUp.backgroundColor = UIColor.appthemeGrayColor
        }
        
        let str = "$ " + (self.mainView.txtTopUpAmount.text ?? "")
        self.mainView.txtTopUpAmount.text = str.toTrim()

    }
    
}

//MARK:- numerice keyboard

extension TopUpPaymentPopUpVc: NumericKeyboardDelegate {

    func numericKeyPressed(key: Int) {
        
        if self.mainView.txtTopUpAmount.text?.contains(".") ?? false{
            let data = self.mainView.txtTopUpAmount.text?.split(separator: ".")
            if (data?.count ?? 0) == 2 {
                if (data?[1].count ?? 0) > 2 {
                    self.mainView.txtTopUpAmount.text?.removeLast()
                    return
                }
            }
            
        }
        
        self.changeColorAccordingToValue()
        
    }

    func numericBackspacePressed() {
        print("Backspace pressed!")
        self.changeColorAccordingToValue()
    }

    func numericSymbolPressed(symbol: String) {
        self.changeColorAccordingToValue()
    }

}
