//
//  ProfessionalRequirementView.swift
//  Load
//
//  Created by Haresh Bhai on 02/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfessionalRequirementView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var txtTextView: KMPlaceholderTextView!
    @IBOutlet weak var lblCount: UILabel!
    
    //MARK:- Functions
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.txtTextView.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtTextView.placeholderColor = UIColor.appthemeBlackColorAlpha30
        self.txtTextView.setColor(color: .appthemeBlackColor)
        
        self.lblCount.font = themeFont(size: 11, fontname: .ProximaNovaThin)
        self.lblCount.textColor = .appthemeBlackColor
        
    }
}
