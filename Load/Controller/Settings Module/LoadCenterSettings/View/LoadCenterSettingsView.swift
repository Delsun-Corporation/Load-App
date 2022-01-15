//
//  LoadCenterSettingsView.swift
//  Load
//
//  Created by Haresh Bhai on 30/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LoadCenterSettingsView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblPremium: UILabel!
    @IBOutlet weak var lblProfesional: UILabel!

    //MARK:- Functions
    func setupUI(theController: LoadCenterSettingsVC) {
        self.setupFont()
    }

    func setupFont() {
        self.lblPremium.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblProfesional.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblPremium.setColor(color: .appthemeBlackColor)
        self.lblProfesional.setColor(color: .appthemeBlackColor)
        
        self.lblPremium.text = getCommonString(key: "Premium_key")
        self.lblProfesional.text = getCommonString(key: "Professional_key")
    }
}
