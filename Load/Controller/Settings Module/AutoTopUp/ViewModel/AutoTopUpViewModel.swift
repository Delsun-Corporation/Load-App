//
//  AutoTopUpViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol AutoTopUpVCDelegate: AnyObject {
    func AutoTopUpFinish(isAutoTopup: Bool?, autoTopupAmount: String?, minimumBalance:String?)
}

class AutoTopUpViewModel {
  
    //MARK:- Variables
    fileprivate weak var theController: AutoTopUpVC!

    let headerArray: [String] = ["",""]
    let titleArray: [[String]] = [[getCommonString(key: "Payment_Method_key")],[getCommonString(key: "Auto_top_up_key") ,getCommonString(key: "Top-up_amount_key") , getCommonString(key: "Minimum_balance_key")]]
    var textArray: [[String]] = [["Mastercard 1234"],[ "","",""]]
    let placeHolderArray: [[String]] = [[""],[ "", "00.00", "00.00"]]

    var isAgree: Bool?
    var SelectedIndex:Int?
    var cardDetails: [CardDetails] = []
    var cardNewDetails: [CardModelClass] = []
    var defaultCard:String?
    var accessToken: String = ""
    var isAutoTopup: Bool = false
    var autoTopupAmount: String?
    var minimumBalance: String?
    weak var delegate: AutoTopUpVCDelegate?
    
    //MARK:- Functions
    init(theController:AutoTopUpVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.textArray[1][1] = autoTopupAmount ?? ""
        self.textArray[1][2] = minimumBalance ?? ""
        
        //TODO:- Remove from TopUp screen and move to PaymentMethod
        /*
        if cardDetails.count != 0 {
            for data in self.cardDetails {
                if data.isDefault?.boolValue ?? false {
                    self.defaultCard = data.creditCardId ?? ""
                }
                self.apiCallGetCreditCard(cardId: data.creditCardId ?? "")
            }
        }*/
        let view = (self.theController.view as? AutoTopUpView)
        view?.tableView.reloadData()
    }
    
    func apiCallGetCreditCard(cardId:String) {
        let param = ["": ""]
        print(JSON(param))
        
        ApiManager.shared.MakePayPalGetCardAPI(name: PAYPAL_GET_CARD + cardId, params: param as [String : Any], progress: true, vc: self.theController, Authorization: self.accessToken, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let model = CardModelClass(JSON: json.dictionaryObject!)
                self.cardNewDetails.append(model!)
                if self.cardDetails.count == self.cardNewDetails.count {
                    let view = (self.theController.view as? AutoTopUpView)
                    view?.tableView.reloadData()
                }
            }
        })
    }
}
