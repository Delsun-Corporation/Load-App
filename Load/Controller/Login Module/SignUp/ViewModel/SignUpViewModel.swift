//
//  SignUpViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpViewModel {

    //MARK:- Variables
    fileprivate weak var theController:SignUpVC!
    var isAccepted:Bool = false
    
    init(theController:SignUpVC) {
        self.theController = theController
    }

    func ValidateDetails() {
        let view = (self.theController.view as? SignUpView)
        var message = ""

        if view!.txtEmail.text == "" {
            message = getCommonString(key: "Enter_email_address_key")
            makeToast(strMessage: message)
        }
        else if !isValidEmail(testStr: view!.txtEmail.text!) {
            message = getCommonString(key: "Enter_valid_email_address_key")
            makeToast(strMessage: message)
        }
        else if view!.txtPassword.text == "" {
            message = getCommonString(key: "Enter_password_key")
            makeToast(strMessage: message)
        }
        else if view!.txtPassword.text!.count < 8 {
            message = getCommonString(key: "Enter_password_minimum_8_characters_key")
            makeToast(strMessage: message)
        }
        else if view!.txtConfirmPassword.text == "" {
            message = getCommonString(key: "Enter_confirm_password_key")
            makeToast(strMessage: message)
        }
        else if view!.txtPassword.text != view!.txtConfirmPassword.text {
            message = getCommonString(key: "Password_not_match_key")
            makeToast(strMessage: message)
        }
        else if !isAccepted {
            message = getCommonString(key: "Please_accept_terms_key")
            makeToast(strMessage: message)
        }
        else {
            self.apiCall()
        }
        
        
    }
    
    func apiCall() {
        let view = (self.theController.view as? SignUpView)
        var param: [String: String] = [:]
        if (newApiConfig) {
            param = ["email":view?.txtEmail.text ?? "", "password":view?.txtPassword.text ?? ""]
        }
        else {
            param = ["email":view?.txtEmail.text ?? "", "password":view?.txtPassword.text ?? "", "confirm_password":view?.txtPassword.text ?? "", "step" : "1"]
        }
        
        ApiManager.shared.MakePostAPI(name: SIGN_UP, params: param as [String : Any], vc: self.theController) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let result = LoginModelClass(JSON: json.dictionaryObject!)
                if result?.success ?? false {
                    if (newApiConfig) {
                        let alert = UIAlertController(title: "Success", message: result?.message ?? "An activation link has been sent to your email.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "Ok", style: .default, handler: { _ in
                            alert.dismiss(animated: true, completion: nil)
                            self.theController.navigationController?.popToRootViewController(animated: true)
                        })
                        alert.addAction(action)
                        self.theController.present(alert, animated: true)
                    }
                    else {
                        let obj: SignUpSetupProfileVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SignUpSetupProfileVC") as! SignUpSetupProfileVC
                        obj.mainModelView.userEmail = view?.txtEmail.text ?? ""
                        self.theController.navigationController?.pushViewController(obj, animated: true)
                    }
                }
                else {
                    makeToast(strMessage: result?.message ?? "An error has occured. Please try again later.")
                }
            }
        }
    }
}
