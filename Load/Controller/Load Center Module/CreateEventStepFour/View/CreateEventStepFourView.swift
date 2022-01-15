//
//  CreateEventStepFourView.swift
//  Load
//
//  Created by Haresh Bhai on 16/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventStepFourView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblCancellationPolicy: UILabel!
    @IBOutlet weak var txtCancellationPolicy: UITextField!
    @IBOutlet weak var lblCancellationPolicySubTitle: UILabel!
    @IBOutlet weak var lblGeneralRules: UILabel!
    @IBOutlet weak var txtGeneralRules: KMPlaceholderTextView!
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK:- Functions
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblEventTitle.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblCancellationPolicy.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtCancellationPolicy.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblCancellationPolicySubTitle.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblGeneralRules.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtGeneralRules.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.btnNext.titleLabel?.font = themeFont(size: 17, fontname: .Helvetica)
        
        self.lblEventTitle.setColor(color: .appthemeBlackColor)
        self.lblCancellationPolicy.setColor(color: .appthemeBlackColorAlpha30)
        self.txtCancellationPolicy.setColor(color: .appthemeBlackColor)
        self.lblCancellationPolicySubTitle.setColor(color: .appthemeBlackColor)
        self.lblGeneralRules.setColor(color: .appthemeBlackColorAlpha30)
        self.txtGeneralRules.setColor(color: .appthemeBlackColor)
        self.btnNext.setColor(color: .appthemeWhiteColor)
        
        self.lblEventTitle.text = getCommonString(key: "Now_set_some_ground_rules_key")
        self.lblCancellationPolicy.text = getCommonString(key: "Select_the_event's_cancellation_policy_key")
        self.txtCancellationPolicy.placeholder = getCommonString(key: "Select_event_key")
        self.lblCancellationPolicySubTitle.text = ""//getCommonString(key: "50%_refund-with_5_days_cancellation_prior_to_event_key")
        self.lblGeneralRules.text = getCommonString(key: "General_rules_key")
        self.txtGeneralRules.placeholder = getCommonString(key: "eg._Please_come_in_workout_attire_and_wear_sport_shoes_key")
        
        self.btnNext.setTitle(str: getCommonString(key: "Save_and_Continue_key"))
    }
}
