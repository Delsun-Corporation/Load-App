//
//  HeartRateView.swift
//  Load
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class HeartRateView: UIView {

    //MARK:- Outlet
    @IBOutlet weak var txtHRMaxValue: UITextField!
    @IBOutlet weak var txtHRRestValue: UITextField!
    
    @IBOutlet weak var lblHRMaxTitle: UILabel!
    @IBOutlet weak var lblHRRestTitle: UILabel!
    @IBOutlet var lblBpmUnit: [UILabel]!
    
    //MARK: - SetupUI
    
    func setupUI(theController: HeartRateVc){
        
        [self.txtHRMaxValue,self.txtHRRestValue].forEach { (txt) in
            txt?.delegate = theController
            txt?.placeholder = "00"
        }
        
        self.lblBpmUnit.forEach { (lbl) in
            lbl.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            lbl.textColor = .appthemeBlackColor
        }
        
        [self.lblHRRestTitle, self.lblHRMaxTitle].forEach { (lbl) in
            lbl.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        }
        
        self.lblHRMaxTitle.text = getCommonString(key: "HR_max_key")
        self.lblHRRestTitle.text = getCommonString(key: "HR_Rest_key")
        
    }
    
}
