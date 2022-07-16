//
//  ChangePasswordViewModel.swift
//  Load
//
//  Created by David Christian on 07/07/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON

class ChangePasswordViewModel {

    //MARK:- Variables
    fileprivate weak var theController: ChangePasswordVC!
    
    init(theController:ChangePasswordVC) {
        self.theController = theController
    }

    func ValidateDetails(isFromOTP: Bool) {
        let view = (self.theController.view as? ChangePasswordView)

        if view!.txtEmail.text == "" {
            makeToast(strMessage: getCommonString(key: "Enter_email_address_key"))
        }
        else if !isValidEmail(testStr: view!.txtEmail.text!) {
            makeToast(strMessage: getCommonString(key: "Enter_valid_email_address_key"))
        }
        else if view!.txtPassword.text == "" {
            makeToast(strMessage: getCommonString(key: "Enter_password_key"))
        }
        else if view!.txtPassword.text!.count < 8 {
            makeToast(strMessage: getCommonString(key: "Enter_password_minimum_8_characters_key"))
        }
        else if view!.txtConfirmPassword.text == "" {
            makeToast(strMessage: getCommonString(key: "Enter_confirm_password_key"))
        }
        else if view!.txtPassword.text != view!.txtConfirmPassword.text {
            makeToast(strMessage: getCommonString(key: "Password_not_match_key"))
        }
        else {
            self.apiCall(isFromOTP: isFromOTP)
        }
    }
    
    func apiCall(isFromOTP: Bool) {
        let view = (self.theController.view as? ChangePasswordView)
        var param: [String: Any] = [:]
        if (newApiConfig) {
            if isFromOTP {
                param = ["email":view?.txtEmail.text ?? "", "password":view?.txtPassword.text ?? "", "is_from_otp": isFromOTP]
            }
            else {
                param = ["email":view?.txtEmail.text ?? "", "password":view?.txtPassword.text ?? ""]
            }
        }
        else {
            param = ["email":view?.txtEmail.text ?? "", "password":view?.txtPassword.text ?? "", "confirm_password":view?.txtPassword.text ?? "", "step" : "1"]
        }
        
        ApiManager.shared.MakePutAPI(name: CHANGE_PASSWORD, params: param as [String : Any], vc: self.theController) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let result = LoginModelClass(JSON: json.dictionaryObject!)
                if result?.success ?? false {
                    makeToast(strMessage: getCommonString(key: "Change_Password_Success_key"))
                    if isFromOTP {
                        self.theController.navigationController?.popToRootViewController(animated: true)
                    }
                    else {
                        self.theController.navigationController?.popViewController(animated: true)
                    }
                }
                else {
                    makeToast(strMessage: result?.message ?? "")
                }
            }
        }
    }
}
