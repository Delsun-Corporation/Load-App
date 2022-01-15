//
//  PremiumPaymentMethodView.swift
//  Load
//
//  Created by Yash on 03/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class PremiumPaymentMethodView: UIView {

    //MARK:- Outlet
    @IBOutlet weak var lblCardName: UILabel!
    @IBOutlet weak var lblWalletOrCardNumber: UILabel!
    
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var lblBalanceValue: UILabel!
    
    @IBOutlet weak var btnTopUp: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var vwFooter: UIView!
    @IBOutlet weak var btnAddCard: UIButton!
   
    //MARK:-  SetupUI
    func setupUI(){
        
        [self.lblCardName,self.lblBalance].forEach { (lbl) in
            lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            lbl?.textColor = .appthemeBlackColor
        }
        
        [self.lblWalletOrCardNumber,self.lblBalanceValue].forEach { (lbl) in
            lbl?.font = themeFont(size: 25, fontname: .ProximaNovaBold)
            lbl?.textColor = .appthemeBlackColor
        }
        
        self.btnTopUp.setTitle(str: getCommonString(key: "Top_up_key").capitalized)
        self.btnTopUp.setTitleColor(UIColor.appthemePinkColor, for: .normal)
        
        self.tableView.tableHeaderView = UIView()
//        self.tableView.tableFooterView = self.vwFooter

        self.tableView.register(UINib(nibName: "AutoTopUpBillingTitleCell", bundle: nil), forCellReuseIdentifier: "AutoTopUpBillingTitleCell")
        self.tableView.register(UINib(nibName: "AutoTopUpBillingCardCell", bundle: nil), forCellReuseIdentifier: "AutoTopUpBillingCardCell")
        
    }
    
}
