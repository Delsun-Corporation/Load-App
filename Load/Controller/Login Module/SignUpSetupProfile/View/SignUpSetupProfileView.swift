//
//  SignUpSetupProfileView.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SignUpSetupProfileView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblCreateAccount: UILabel!
    @IBOutlet weak var imgProfile: CustomImageView!
    @IBOutlet weak var lblProfile: UILabel!
    
    @IBOutlet weak var txtFullName: CustomTextField!
    @IBOutlet weak var txtDOB: CustomTextField!
    
    @IBOutlet weak var txtSex: CustomTextField!
    @IBOutlet weak var txtHeight: CustomTextField!
    @IBOutlet weak var txtWeight: CustomTextField!
    
    @IBOutlet weak var viewFirstName: CustomView!
    @IBOutlet weak var viewDOB: CustomView!
    @IBOutlet weak var viewSex: CustomView!
    @IBOutlet weak var viewHeight: CustomView!
    @IBOutlet weak var viewWeight: CustomView!
    
    @IBOutlet weak var viewDOBDropDown: UIView!
    @IBOutlet weak var viewSexDropDown: UIView!
    
    @IBOutlet weak var imgDOBDropDown: UIImageView!
    @IBOutlet weak var imgSexDropDown: UIImageView!


    @IBOutlet weak var viewNext: UIView!
    
    @IBOutlet weak var btnSex: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK:- Functions
    func setupUI() {
        imgProfile.cornerRadius = 50
        imgProfile.clipsToBounds = true
        self.btnNext.isUserInteractionEnabled = false
        self.setupFont()
    }
    
    func setupFont() {
        self.lblCreateAccount.font = themeFont(size: 18, fontname: .Regular)
        self.lblProfile.font = themeFont(size: 18, fontname: .Regular)
        self.txtFullName.font = themeFont(size: 13, fontname: .Regular)
        self.txtDOB.font = themeFont(size: 13, fontname: .Regular)
        self.txtSex.font = themeFont(size: 13, fontname: .Regular)
        self.txtHeight.font = themeFont(size: 13, fontname: .Regular)
        self.txtWeight.font = themeFont(size: 13, fontname: .Regular)
        self.btnNext.titleLabel?.font = themeFont(size: 17, fontname: .Regular)
        
        self.lblCreateAccount.setColor(color: .appthemeWhiteColor)
        self.lblProfile.setColor(color: .appthemeWhiteColor)
        self.txtFullName.setColor(color: .appthemeBlackColor)
        self.txtDOB.setColor(color: .appthemeBlackColor)
        self.txtSex.setColor(color: .appthemeBlackColor)
        self.txtHeight.setColor(color: .appthemeBlackColor)
        self.txtWeight.setColor(color: .appthemeBlackColor)
        self.btnNext.setColor(color: .appthemeWhiteColor)
        
        self.lblCreateAccount.text = getCommonString(key: "Create_Account_key")
        self.lblProfile.text = getCommonString(key: "Profile_key")
        self.txtFullName.placeholder = getCommonString(key: "Enter_your_full_name_key")
        self.txtDOB.placeholder = getCommonString(key: "Date_of_Birth_key")
        self.txtSex.placeholder = getCommonString(key: "Sex_key")
        self.txtHeight.placeholder = getCommonString(key: "Height_key")
        self.txtWeight.placeholder = getCommonString(key: "Weight_key")
        self.btnNext.setTitle(str: getCommonString(key: "Next_key"))
    }
}
