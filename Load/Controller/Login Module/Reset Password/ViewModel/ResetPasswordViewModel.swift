//
//  ResetPasswordViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class ResetPasswordViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:ResetPasswordVC!
    
    init(theController:ResetPasswordVC) {
        self.theController = theController
    }
    
    //MARK:- Functions
    func ValidateDetails() {
        let view = (self.theController.view as? ResetPasswordView)
        if  view?.txtEmail.text == "" {
            let alert = UIAlertController(title: "Warning", message: getCommonString(key: "Enter_email_address_key"), preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            self.theController.present(alert, animated: true)
        }
        else if !isValidEmail(testStr: view!.txtEmail.text!) {
            let alert = UIAlertController(title: "Warning", message: getCommonString(key: "Enter_valid_email_address_key"), preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            self.theController.present(alert, animated: true)
        }
        else {
            self.apiCall()
        }
    }
    
    //MARK:- API Integation
    func apiCall() {
        let view = (self.theController.view as? ResetPasswordView)

        let param = ["email":view?.txtEmail.text!]
        ApiManager.shared.MakePostAPI(name: FORGOT_PASSWORD, params: param as [String : Any], vc: self.theController) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let success = json.getBool(key: .success)
                let msg = json.getString(key: .message)
                if success {
                    let alert = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                        let obj: OTPResetPasswordVC = AppStoryboard.OTP.instance.instantiateViewController(withIdentifier: "OTPResetPasswordVC") as! OTPResetPasswordVC
                        obj.email = view?.txtEmail.text ?? ""
                        self.theController.navigationController?.pushViewController(obj, animated: true)
                    })
                    alert.addAction(action)
                    self.theController.present(alert, animated: true)
                    
                    
//                    self.theController.navigationController?.popViewController(animated: true)
                }
                else {
                    let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                        alert.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(action)
                    self.theController.present(alert, animated: true)
                }
            }
            else {
                let alert = UIAlertController(title: "Error", message: "An error has occured. Please try again later", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                self.theController.present(alert, animated: true)
            }
        }
    }
}
