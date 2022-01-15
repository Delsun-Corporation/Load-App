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
    var accessToken: String = ""

    //MARK: - SetupUI
    
    @objc func setupUI(){
        
        if cardDetails.count != 0 {
            for data in self.cardDetails {
                if data.isDefault?.boolValue ?? false {
                    self.defaultCard = data.creditCardId ?? ""
                }
                
                self.apiCallGetCreditCard(cardId: data.creditCardId ?? "")
            }
        }
        let view = (self.theController.view as? PremiumPaymentMethodView)
        view?.tableView.reloadData()
    }
    
    //MARK: - Setup navigation bar
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
extension PremiumPaymentMethodViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.backButtonAction()
    }
    
    func CustomNavigationSave() {

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
