//
//  CreateEventStepSecondDetailView.swift
//  Load
//
//  Created by Haresh Bhai on 25/12/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventStepSecondDetailView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var txtAbout: KMPlaceholderTextView!
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK:- Functions
    func setupUI(theController: CreateEventStepSecondDetailVC) {
        self.setupFont()
        self.txtAbout.delegate = theController
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 20, fontname: .HelveticaBold)
        self.lblAbout.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtAbout.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.btnNext.titleLabel?.font = themeFont(size: 17, fontname: .Helvetica)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblAbout.setColor(color: .appthemeBlackColorAlpha30)
        self.txtAbout.setColor(color: .appthemeBlackColor)
        self.btnNext.setColor(color: .appthemeWhiteColor)

        self.lblTitle.text = getCommonString(key: "Let’s_get_more_detailed_key")
        self.lblAbout.text = getCommonString(key: "Tell_guests_more_about_your_event_key")
        self.txtAbout.placeholder = getCommonString(key: "Enter_about_key")
        self.btnNext.setTitle(str: getCommonString(key: "Save_and_Continue_key"))
    }

}
