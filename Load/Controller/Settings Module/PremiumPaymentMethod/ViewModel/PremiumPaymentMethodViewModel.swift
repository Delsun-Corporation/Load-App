//
//  PremiumPaymentMethodViewModel.swift
//  Load
//
//  Created by Yash on 03/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON

class PremiumPaymentMethodViewModel {
  
    //MARK:- Variables
    fileprivate weak var theController:PremiumPaymentMethodVc!
    
    //MARK:- Functions
    init(theController:PremiumPaymentMethodVc) {
        self.theController = theController
    }
    
    var SelectedIndex:Int?
    var cardDetails: [CardDetails] = []
    var cardNewDetails: [CardModelClass] = []
    var defaultCard:String?
    var defaultCardID: Int?
    var accessToken: String = ""
    lazy var creditCardDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/yyyy"
        return dateFormatter
    }()

    //MARK: - SetupUI
    @objc func setupUI(){
        if newApiConfig {
            getCreditCardsList()
            let view = (self.theController.view as? PremiumPaymentMethodView)
            view?.tableView.reloadData()
            return
        }
        
        if cardDetails.count != 0 {
            for data in self.cardDetails {
                if data.isDefault?.boolValue ?? false {
                    self.defaultCard = data.id
                    self.defaultCardID = Int(data.id ?? "0") ?? 0
                }
                
                self.apiCallGetCreditCard(cardId: data.creditCardId ?? "")
            }
        }
        let view = (self.theController.view as? PremiumPaymentMethodView)
        view?.tableView.reloadData()
    }
    
    private func getCreditCardsList() {
        ApiManager.shared.MakeGetAPI(name: "setting/get-credit-card",
                                     params: [:],
                                     vc: theController) { [weak self] response, error in
            guard let self = self else {
                return
            }
            
            if let response = response {
                let json = JSON(response)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getArray(key: .data)
                    for datum in data {
                        guard let model = CardDetails(JSON: datum.dictionaryObject!) else {
                            continue
                        }
                        self.cardDetails.append(model)
                        
                    }
                    
                    if self.cardDetails.count != 0 {
                        for data in self.cardDetails where data.isDefault == true {
                            self.defaultCard = data.id
                            self.defaultCardID = Int(data.id ?? "0") ?? 0
                        }
                    }
                    let view = (self.theController.view as? PremiumPaymentMethodView)
                    view?.tableView.reloadData()
                } else {
                    makeToast(strMessage: error ?? "Something went wrong, please try again")
                }
                return
            }
            
            makeToast(strMessage: error ?? "Something went wrong, please try again")
        }
    }
    
    func updateDefaultPaymentMethod() {
        guard let defaultCard = defaultCard else {
            theController.navigationController?.popViewController(animated: true)
            return
        }
        print("Default Card Id to send: \(defaultCard)")
        let param = [
            "id": defaultCard
        ] as [String: Any]
        ApiManager.shared.MakePostAPI(name: "setting/update-default-payment",
                                      params: param,
                                      vc: theController) { [weak self] response, error in
            guard let self = self else {
                return
            }
            
            if let response = response {
                let json = JSON(response)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    self.theController.backButtonAction()
                } else {
                    makeToast(strMessage: json.getString(key: .message))
                }
                
                return
            }
            
            makeToast(strMessage: error ?? "Something went wrong, please try again")
        }
    }
    
    func convertDateToCreditCardDateInString(_ date: Date) -> String {
        creditCardDateFormatter.string(from: date)
    }

}

//MARK:- API calling

extension PremiumPaymentMethodViewModel {
    
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
                    let view = (self.theController.view as? PremiumPaymentMethodView)
                    view?.tableView.reloadData()
                }
            }
        })
    }

}
