//
//  CreateEventStepThreeView.swift
//  Load
//
//  Created by Haresh Bhai on 16/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventStepThreeView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblEventPrice: UILabel!
    @IBOutlet weak var txtEventPrice: UITextField!
    @IBOutlet weak var lblCurrency: UILabel!
    @IBOutlet weak var txtCurrency: UITextField!
    @IBOutlet weak var btnNext: UIButton!

    //MARK:- Functions
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblEventTitle.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblEventPrice.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtEventPrice.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblCurrency.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtCurrency.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.btnNext.titleLabel?.font = themeFont(size: 17, fontname: .Helvetica)
        
        self.lblEventTitle.setColor(color: .appthemeBlackColor)
        self.lblEventPrice.setColor(color: .appthemeBlackColorAlpha30)
        self.txtEventPrice.setColor(color: .appthemeBlackColor)
        self.lblCurrency.setColor(color: .appthemeBlackColorAlpha30)
        self.txtCurrency.setColor(color: .appthemeBlackColor)

        self.btnNext.setColor(color: .appthemeWhiteColor)
        
        self.lblEventTitle.text = getCommonString(key: "Set_up_your_pricing_key")
        self.lblEventPrice.text = getCommonString(key: "This_will_be_the_event_price_per_person_key")
        self.txtEventPrice.placeholder = getCommonString(key: "$0_key")
        self.lblCurrency.text = getCommonString(key: "Currency_key")
        self.txtCurrency.placeholder = getCommonString(key: "Currency_key")

        self.btnNext.setTitle(str: getCommonString(key: "Save_and_Continue_key"))
    }
}
