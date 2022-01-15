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
        else if !isAccepted {
            makeToast(strMessage: getCommonString(key: "Please_accept_terms_key"))
        }
        else {
            self.apiCall()
        }
    }
    
    func apiCall() {
        let view = (self.theController.view as? SignUpView)

//        let param = ["email":view?.txtEmail.text!, "password":view?.txtPassword.text!, "confirm_password":view?.txtPassword.text!,    "step" : "1"]
        
        let param = ["email":view?.txtEmail.text ?? "", "password":view?.txtPassword.text  ?? "", "confirm_password":view?.txtPassword.text  ?? "",  "step" : "1"]
        
        ApiManager.shared.MakePostAPI(name: SIGN_UP, params: param as [String : Any], vc: self.theController) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let result = LoginModelClass(JSON: json.dictionaryObject!)
                if result?.success ?? false {
                    let obj: SignUpSetupProfileVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SignUpSetupProfileVC") as! SignUpSetupProfileVC
                    obj.mainModelView.userId = result?.data?.user?.id?.stringValue ?? ""
                    self.theController.navigationController?.pushViewController(obj, animated: true)
                }
                else {
                    makeToast(strMessage: result?.message ?? "")
                }
            }
        }
    }
}
