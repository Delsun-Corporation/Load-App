//
//  EmergencyViewModel.swift
//  Load
//
//  Created by iMac on 08/01/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class EmergencyViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:EmergencyVC!
    
    init(theController:EmergencyVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.apiCallGetEmergencyContactDetails()
    }
    
    func apiCallGetEmergencyContactDetails() {
        let param = ["":""] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakeGetAPI(name: GET_EMERGENCY_CONTACT_DETAILS, params: param as [String : Any], progress: true, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let contact1 = data.getString(key: .contact1)
                    let contact2 = data.getString(key: .contact2)
                    let view = (self.theController.view as? EmergencyView)
                    view?.txtContact1.text = contact1
                    view?.txtContact2.text = contact2
                }
                else {
//                    let message = json.getString(key: .message)
//                    makeToast(strMessage: message)
                }
            }
        })
    }
    
    func apiCallSaveEmergencyContactDetails(contact1:String, contact2:String) {
            let param = ["contact_1":contact1, "contact_2":contact2] as [String : Any]
            print(JSON(param))
            
            ApiManager.shared.MakePostAPI(name: SAVE_CONTACT_NUMBER, params: param as [String : Any], progress: true, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
                if response != nil {
                    let json = JSON(response!)
                    print(json)
                    let success = json.getBool(key: .success)
                    if success {
                        let data = json.getDictionary(key: .data)
                        let contact1 = data.getString(key: .contact1)
                        let contact2 = data.getString(key: .contact2)
                        let view = (self.theController.view as? EmergencyView)
                        view?.txtContact1.text = contact1
                        view?.txtContact2.text = contact2
                    }
                    else {
    //                    let message = json.getString(key: .message)
    //                    makeToast(strMessage: message)
                    }
                }
            })
        }
}
