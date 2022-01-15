//
//  TopUpPaymentPopupView.swift
//  Load
//
//  Created by Yash on 07/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class TopUpPaymentPopupView: UIView {

    //MARK:- Outlet
    
    @IBOutlet weak var vwBackground: UIView!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblBalancePrice: UILabel!
    
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblPaymentMethodValue: UILabel!
    
    @IBOutlet weak var lblTopUpAmount: UILabel!
    @IBOutlet weak var txtTopUpAmount: UITextField!
    
    @IBOutlet weak var btnTopUp: UIButton!
    
    //MARK:- Setup Methods
    
    func setupUI(){
        self.setupFont()
        
        self.lblBalance.text = getCommonString(key: "Balance_key")
        self.lblPaymentMethod.text = getCommonString(key: "Payment_method_key")
        self.lblTopUpAmount.text = getCommonString(key: "Top_up_amount_key")
        
        self.btnTopUp.setTitle(getCommonString(key: "Top_up_key"), for: .normal)
    }
    
    func setupFont(){
        
        self.lblBalance.font = themeFont(size: 25, fontname: .ProximaNovaBold)
        self.lblBalance.textColor = UIColor.appthemeBlackColor
        
        self.lblBalancePrice.font = themeFont(size: 20, fontname: .ProximaNovaRegular)
        self.lblBalancePrice.textColor = UIColor.appthemeBlackColor
        
        [self.lblPaymentMethod,self.lblPaymentMethodValue,self.lblTopUpAmount].forEach { (lbl) in
            lbl?.textColor = UIColor.appthemeBlackColor
            lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        }
        
        self.txtTopUpAmount.textColor = UIColor.appthemeOffRedColor
        self.txtTopUpAmount.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.btnTopUp.titleLabel?.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.btnTopUp.setTitleColor(.white, for: .normal)
        self.btnTopUp.backgroundColor = .appthemeOffRedColor
        
        
    }
    
}
