//
//  CreateRequestStepOneView.swift
//  Load
//
//  Created by Haresh Bhai on 22/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateRequestStepOneView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var lblStartTraining: UILabel!
    @IBOutlet weak var txtStartTraining: UITextField!
   
    @IBOutlet weak var txtDescription: KMPlaceholderTextView!
    
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK:- Functions
    func setupUI() {
        self.setupFont()
    }

    func setupFont() {
        self.lblStart.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtTitle.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblStartTraining.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtStartTraining.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.txtDescription.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.btnNext.titleLabel?.font = themeFont(size: 17, fontname: .Regular)

        self.lblStart.setColor(color: .appthemeBlackColor)
        self.lblTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.txtTitle.setColor(color: .appthemeBlackColor)
        self.lblStartTraining.setColor(color: .appthemeBlackColorAlpha30)
        self.txtStartTraining.setColor(color: .appthemeBlackColor)
        self.txtDescription.setColor(color: .appthemeBlackColor)
        self.btnNext.setColor(color: .appthemeWhiteColor)
        
        self.lblStart.text = getCommonString(key: "As_a_start_key")
        self.lblTitle.text = getCommonString(key: "Create_a_catchy_title for_your_Request_key")
        self.lblStartTraining.text = getCommonString(key: "When_would_you_like_to_start_your_training?_key")
        self.txtDescription.placeholder = getCommonString(key: "Tell_your_potential_coach_key")
        self.btnNext.setTitle(str: getCommonString(key: "Next_key"))        
    }
}
