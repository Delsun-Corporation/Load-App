//
//  BillingInformationViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol BillingInformationVCDelegate: class {
    func BillingInformationReload(isUpdated:Bool)
}

class BillingInformationViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:BillingInformationVC!
    let titleArray: [String] = ["BILLING INFORMATION", "Credit card number", "Cardholder name", "Expiry date", "CVV", "PAYMENT ADDRESS", "This is the address that is specifically associated with your payment methods", "Address", "Country", "City", "State / Province / Region", "Zip / Postal Code", ""]
    let placeHolderArray: [String] = ["" , "0000 0000 0000 0000", "cardholder name", "mm / yyyy", "000", "", "", "Address", "Country", "City", "State / Province / Region", "000000", ""]

    var cardArray: [[String]] = [["", "", "", "", "", "", "", "", "", "", "", ""]]
    var accessToken: String = ""
    var isUpdated: Bool = false
    weak var delegate:BillingInformationVCDelegate?
    
    //MARK:- Functions
    init(theController:BillingInformationVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.apiCallOAuth2Token()
    }
    
    func isEmptyData() -> Bool {
        var isEmpty:Bool = false
        for data in self.cardArray {
//            print(data)
            for (index, dataValue) in data.enumerated() {
//                print(index)
                if dataValue.toTrim() == "" && index != 0 && index != 5 && index != 6  {
                    isEmpty = true
                }
            }
        }
        return isEmpty
    }
    
    func validateDetails() -> Bool {
        
        for data in self.cardArray {
            for (index, dataValue) in data.enumerated() {
                if dataValue.toTrim() == "" && index != 0 && index != 5 && index != 6  {
                    if index == 1 {
//                        makeToast(strMessage: "Please enter card number")
                        return false
                    }
                    else if index == 2 {
//                        makeToast(strMessage: "Please enter full name")
                        return false
                    }
                    else if index == 3 {
//                        makeToast(strMessage: "Please enter expiry date")
                        return false
                    }
                    else if index == 4 {
//                        makeToast(strMessage: "Please enter CVV")
                        return false
                    }
                    else if index == 7 {
//                        makeToast(strMessage: "Please enter address")
                        return false
                    }
                    else if index == 8 {
//                        makeToast(strMessage: "Please enter country")
                        return false
                    }
                    else if index == 9 {
//                        makeToast(strMessage: "Please enter city")
                        return false
                    }
                    else if index == 10 {
//                        makeToast(strMessage: "Please enter state")
                        return false
                    }
                    else if index == 11 {
//                        makeToast(strMessage: "Please enter zip code")
                        return false
                    }
                    return false
                }
                else {
                    if index == 2 {
                        let array = dataValue.toTrim().components(separatedBy: " ")
                        if array.count == 1 {
//                            makeToast(strMessage: "Please enter full name")
                            return false
                        }
                    }
                    else if index == 3 {
                        let array = dataValue.toTrim().components(separatedBy: "/")
                        
                        print("Array : \(array)")
                        print("Array count : \(array.count)")
                        
                        if array.count == 0 {
//                            makeToast(strMessage: "Please enter valid expiry date")
                            return false
                        }
                        else {
                            if array[0] > "31" {
//                                makeToast(strMessage: "Please enter valid month")
                                return false
                            }
                            
                            if array.count == 2 {
                                if array[1] < Date().year {
    //                                makeToast(strMessage: "Please enter valid year")
                                    return false
                                }
                            }
                        }
                    }
                    else if index == 4 {
                        if dataValue.toTrim().count != 3 {
//                            makeToast(strMessage: "Please enter valid CVV")
                            return false
                        }
                    }
                }
            }
        }
        return true
//        self.saveCard()
    }
    
    func saveCard() {
        for data in self.cardArray {
            let name =  data[2].toTrim().components(separatedBy: " ")
            let expiryDate =  data[3].toTrim().components(separatedBy: "/")

            let number = data[1].replace(target: " ", withString: "")
            let firstName = name[0]
            let lastName = name[1]
            let expireMonth = expiryDate[0]
            let expireYear = expiryDate[1]
            let type = self.validateCardType(testCard: number)
            let line1 = data[7]
            let countryCode = data[8]
            let city = data[9]
            let state = data[10]
            let postalCode = data[11]
            let phone = ""
            
            self.apiCallSaveCreditCard(number: number, type: type, expireMonth: expireMonth, expireYear: expireYear, firstName: firstName, lastName: lastName, line1: line1, city: city, countryCode: countryCode, postalCode: postalCode, state: state, phone: phone)
        }
    }
    
    func apiCallOAuth2Token(progress:Bool = true) {
        
        let param = [
            "grant_type": "client_credentials"
            ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePayPalPostAPI(name: PAYPAL_OAUTH2_TOKEN, params: param as [String : Any], progress: progress, vc: self.theController, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let token_type = json.getString(key: .token_type)
                let access_token = json.getString(key: .access_token)
                self.accessToken = token_type + " " + access_token
                print(self.accessToken)
            }
        })
    }
    
    func apiCallSaveCreditCard(number:String, type:String, expireMonth:String, expireYear:String, firstName:String, lastName:String, line1:String, city:String, countryCode:String, postalCode:String, state:String, phone:String) {
        var param = [
            "number": number,
            "type": type,
            "expire_month": expireMonth,
            "expire_year": expireYear,
            "first_name": firstName,
            "last_name": lastName,
            "billing_address": [
                "line1": line1,
                "city": city,
                "country_code": countryCode,
                "postal_code": postalCode,
                "state": state
//                "phone": phone
            ]
            ] as [String : Any]
        
        if type == "" {
            param.removeValue(forKey: "type")
        }
        print(JSON(param))
        
        ApiManager.shared.MakePayPalPostSaveCardAPI(name: PAYPAL_CREDIT_CARDS, params: param as [String : Any], progress: true, vc: self.theController, Authorization: self.accessToken, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let details = json.getArray(key: .details)
                if details.count != 0 {
                    let field = details[0].getString(key: .field)
                    makeToast(strMessage: "Please enter valid " + field)
                    return
                }
                let id = json.getString(key: .id)
                print(id)
                self.apiCallAddBillingInformation(id: [id])
            }
        })
    }
    
    func apiCallAddBillingInformation(id: [String], progress:Bool = true) {
        let array: NSMutableArray = NSMutableArray()
        for data in id {
            let dict: NSDictionary = ["user_id": getUserDetail()?.data?.user?.id?.stringValue ?? "", "credit_card_id": data, "is_default": false]
            array.add(dict)
        }
        let param = ["cards_information": array] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: ADD_BILLING_INFORMATION, params: param as [String : Any], progress: progress, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    self.isUpdated = true
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_UPDATE_ADDED_BANK_CARD_RELOAD.rawValue), object: nil, userInfo: nil)

                    self.cardArray = [["", "", "", "", "", "", "", "", "", "", "", ""]]
                    let view = (self.theController.view as? BillingInformationView)
                    view?.tableView.reloadData()
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        })
    }
    
    func validateCardType(testCard: String) -> String {
        
        let regVisa = "^4[0-9]{12}(?:[0-9]{3})?$"
        let regMaster = "^5[1-5][0-9]{14}$"
        let regExpress = "^3[47][0-9]{13}$"
        let regDiners = "^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
        let regDiscover = "^6(?:011|5[0-9]{2})[0-9]{12}$"
        let regJCB = "^(?:2131|1800|35\\d{3})\\d{11}$"
        
        let regVisaTest = NSPredicate(format: "SELF MATCHES %@", regVisa)
        let regMasterTest = NSPredicate(format: "SELF MATCHES %@", regMaster)
        let regExpressTest = NSPredicate(format: "SELF MATCHES %@", regExpress)
        let regDinersTest = NSPredicate(format: "SELF MATCHES %@", regDiners)
        let regDiscoverTest = NSPredicate(format: "SELF MATCHES %@", regDiscover)
        let regJCBTest = NSPredicate(format: "SELF MATCHES %@", regJCB)
        
        
        if regVisaTest.evaluate(with: testCard){
            return "visa"
        }
        else if regMasterTest.evaluate(with: testCard){
            return "mastercard"
        }
            
        else if regExpressTest.evaluate(with: testCard){
            return "amex"
        }
            
        else if regDinersTest.evaluate(with: testCard){
            return "dinersclub"
        }
            
        else if regDiscoverTest.evaluate(with: testCard){
            return "discover"
        }
            
        else if regJCBTest.evaluate(with: testCard){
            return "jcb"
        }
        
        return ""
        
    }
}

//MARK:- Navigationbar setup

extension BillingInformationViewModel {
    
    func setupNavigationbar(title:String) {
        
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = false
            vwnav.btnSave.isHidden = true

            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: CGFloat(hightOfView), width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height)
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 16, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            
            vwnav.lblTitle.textColor = .black
            
            vwnav.tag = 102
            vwnav.delegate = self
            
            self.theController.navigationController?.view.addSubview(vwnav)
            
        }
    }

}

//MARK: - navigation delegate
extension BillingInformationViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.delegate?.BillingInformationReload(isUpdated: self.isUpdated)
        self.theController.backButtonAction()
    }
    
    func CustomNavigationSave() {

    }
    
}
