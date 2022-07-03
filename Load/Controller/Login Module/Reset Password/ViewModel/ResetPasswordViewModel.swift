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
            makeToast(strMessage: getCommonString(key: "Enter_email_address_key"))
        }
        else if !isValidEmail(testStr: view!.txtEmail.text!) {
            makeToast(strMessage: getCommonString(key: "Enter_valid_email_address_key"))
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
                makeToast(strMessage: msg)
                if success {
                    self.theController.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
