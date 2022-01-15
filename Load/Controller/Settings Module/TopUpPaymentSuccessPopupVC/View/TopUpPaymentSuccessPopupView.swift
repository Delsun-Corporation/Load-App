//
//  TopUpPaymentSuccessPopupView.swift
//  Load
//
//  Created by Yash on 08/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class TopUpPaymentSuccessPopupView: UIView {

    //MARK:- Outlet
    
    @IBOutlet weak var vwBack: UIView!
    @IBOutlet weak var imgSuccessFailure: UIImageView!
    @IBOutlet weak var lblSuccessFailMsg: UILabel!
    @IBOutlet weak var lblPaidValue: UILabel!
    
    @IBOutlet weak var lblDateTime: UILabel!
    @IBOutlet weak var lblDateTimeValue: UILabel!
    
    @IBOutlet weak var lblCurrentBalance: UILabel!
    @IBOutlet weak var lblCurrentBalanceValue: UILabel!
    
    @IBOutlet weak var btnDone: UIButton!
    
    //MARK:- SetupUI
    
    func setupUI(){
        self.setFont()
        
        self.lblDateTime.text = getCommonString(key: "Date_and_time_key")
        self.lblCurrentBalance.text = getCommonString(key: "Current_balance_key")
        
        self.btnDone.setTitle(getCommonString(key: "Done_key"), for: .normal)
    }
    
    func setFont(){
        self.lblSuccessFailMsg.font = themeFont(size: 20, fontname: .ProximaNovaRegular)
        self.lblPaidValue.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        
        self.lblSuccessFailMsg.textColor = .appthemeBlackColor
        self.lblPaidValue.textColor = .appthemeBlackColor
        
        [self.lblDateTime,self.lblDateTimeValue,self.lblCurrentBalance,self.lblCurrentBalanceValue].forEach { (lbl) in
            lbl?.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
            lbl?.textColor = .appthemeBlackColor
        }
        
        self.btnDone.setTitleColor(UIColor.appthemeOffRedColor, for: .normal)
        self.btnDone.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaBold)
        
    }
    
}
