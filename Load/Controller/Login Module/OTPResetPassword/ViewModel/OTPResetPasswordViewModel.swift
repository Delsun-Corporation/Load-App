//
//  OTPViewModel.swift
//  Load
//
//  Created by David Christian on 13/07/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON

class OTPResetPasswordViewModel {

    //MARK:- Variables
    fileprivate weak var theController: OTPResetPasswordVC!
    
    init(theController: OTPResetPasswordVC) {
        self.theController = theController
    }
    
    //MARK: - API Integation
    func apiCallResendOTP(email: String) {
        let param = ["email":email]
        ApiManager.shared.MakePostAPI(name: FORGOT_PASSWORD, params: param as [String : Any], vc: self.theController) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                _ = json.getBool(key: .success)
                let msg = json.getString(key: .message)
                makeToast(strMessage: msg)
                
            }
            
        }
    }
    
    func apiCallVerifyOTP(email: String, otp: String, completion: @escaping (Bool?)->()) {
        let param = ["email":email, "otp": otp] as [String : String]
        ApiManager.shared.MakePostAPI(name: OTP_VERIFICATION, params: param as [String : Any], vc: self.theController) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let success = json.getBool(key: .success)
                let msg = json.getString(key: .message)
                makeToast(strMessage: msg)
                
                if success {
                    let obj: ChangePasswordVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                    obj.email = email
                    obj.isFromOTP = true
                    guard var viewControllers = self.theController.navigationController?.viewControllers else { return }
                    _ = viewControllers.popLast()
                    viewControllers.append(obj)
                    self.theController.navigationController?.setViewControllers(viewControllers, animated: true)
                }
                else {
                    completion(false)
                }
            }
        }
    }
}
