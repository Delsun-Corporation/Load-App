//
//  LoginViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class LoginViewModel {

    //MARK:- Variables
    fileprivate weak var theController:LoginVC!
    
    init(theController:LoginVC) {
        self.theController = theController
    }
    
    //MARK:- Functions
    func ValidateDetails() {
        guard let view = (self.theController.view as? LoginView) else {
            return
        }
        let emailTextValue = (view.txtEmail.text ?? String()).toTrim()
        let passwordTextValue = view.txtPassword.text ?? String()
        
        if  emailTextValue.isEmpty {
            makeToast(strMessage: getCommonString(key: "Enter_email_address_key"))
        }
        else if !isValidEmail(testStr: emailTextValue) {
            makeToast(strMessage: getCommonString(key: "Enter_valid_email_address_key"))
        }
        else if passwordTextValue.isEmpty {
            makeToast(strMessage: getCommonString(key: "Enter_password_key"))
        }
        else {
            self.apiCall()
        }
    }
    
    //MARK:- API Integration
    func apiCall() {
        let view = (self.theController.view as? LoginView)

        let param = ["email":view?.txtEmail.text?.toTrim() ?? "", "password":view?.txtPassword.text?.toTrim() ?? "", "latitude": AppDelegate.shared?.lattitude ?? "", "longitude": AppDelegate.shared?.longitude ?? ""] as [String : Any]
        // TODO: Uncomment for v1 API
        //        ApiManager.shared.MakePostAPI(name: LOGIN, params: param as [String : Any], vc: self.theController) { (response, error) in
        //            if response != nil {
        //                let json = JSON(response!)
        //                print(json)
        //                let result = LoginModelClass(JSON: json.dictionaryObject!)
        //                if (result?.success)! {
        //                    let name = result?.data?.user?.name
        //                    let emailVerifiedAt = result?.data?.user?.emailVerifiedAt ?? ""
        //                    if emailVerifiedAt == "" {
        //                        makeToast(strMessage: getCommonString(key: "Please_verify_your_email_address_key"))
        //                    }
        //                    else if name != "" && name != nil {
        //                        saveJSON(j: json, key: USER_DETAILS_KEY)
        ////                        let obj: TabbarVC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
        ////                        self.theController.present(obj, animated: true, completion: nil)
        //                        AppDelegate.shared?.sidemenu()
        //                        AppDelegate.shared?.apiCallForDynamicData()
        //                    }
        //                    else {
        //                        let obj: SignUpSetupProfileVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SignUpSetupProfileVC") as! SignUpSetupProfileVC
        //                        obj.mainModelView.userId = (result?.data?.user?.id?.stringValue)!
        //                        obj.mainModelView.isComeLogin = true
        //                        self.theController.navigationController?.pushViewController(obj, animated: true)
        //                    }
        //                }
        //                else {
        //                    makeToast(strMessage: result?.message ?? "")
        //                }
        //            }
        //        }
        ApiManager.shared.MakeGetAPI(name: LOGIN, params: param as [String : Any], vc: self.theController) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let result = LoginModelClass(JSON: json.dictionaryObject!)
                if (result?.success)! {
                    let isProfileComplete = result?.data?.user?.isProfileComplete
                    let emailVerifiedAt = result?.data?.user?.emailVerifiedAt ?? ""
                    if emailVerifiedAt == "" {
                        makeToast(strMessage: getCommonString(key: "Please_verify_your_email_address_key"))
                    }
                    else if !(isProfileComplete ?? false) {
                        saveJSON(j: json, key: USER_DETAILS_KEY)
                        let obj: SignUpSetupProfileVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SignUpSetupProfileVC") as! SignUpSetupProfileVC
                        obj.mainModelView.userEmail = view?.txtEmail.text?.toTrim() ?? ""
                        obj.mainModelView.isComeLogin = true
                        self.theController.navigationController?.pushViewController(obj, animated: true)
                    }
                    else {
                        saveJSON(j: json, key: USER_DETAILS_KEY)
//                      let obj: TabbarVC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
//                        self.theController.present(obj, animated: true, completion: nil)
                        AppDelegate.shared?.sidemenu()
                        AppDelegate.shared?.apiCallForDynamicData()
                    }
                }
                else {
                    makeToast(strMessage: result?.message ?? "")
                }
            }
        }
    }
}
