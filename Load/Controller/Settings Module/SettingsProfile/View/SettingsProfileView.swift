//
//  SettingsProfileView.swift
//  Load
//
//  Created by Haresh Bhai on 22/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage

class SettingsProfileView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: CustomImageView!
    @IBOutlet weak var lblChangeProfile: UILabel!
    @IBOutlet weak var lblNameTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblFacebook: UILabel!
    @IBOutlet weak var txtFacebook: UITextField!
    
    @IBOutlet weak var lblMemberSinceTitle: UILabel!
    @IBOutlet weak var lblMemberSince: UILabel!

    @IBOutlet weak var lblAccountTypeTitle: UILabel!
    @IBOutlet weak var lblAccountType: UILabel!
    
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var imgEmail: UIImageView!
    @IBOutlet weak var imgFacebook: UIImageView!
      
    @IBOutlet weak var btnCountryCode: UIButton!
    @IBOutlet weak var btnLocation: UIButton!
    
    //MARK:- Functions
    func setupUI(theController: SettingsProfileVC) {
        self.layoutIfNeeded()
        self.setupFont()
        imgFacebook.isHidden = true
    }
    
    func setupFont() {
        self.imgProfile.setCircle()
        
        self.lblChangeProfile.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lblNameTitle.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtFirstName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtLastName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblDOB.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtDOB.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblLocation.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtLocation.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblPhone.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtCode.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtMobile.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblEmail.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtEmail.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblFacebook.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtFacebook.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblMemberSinceTitle.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblMemberSince.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        self.lblMemberSinceTitle.setColor(color: .appthemeBlackColor)
        self.lblMemberSince.setColor(color: .appthemeBlackColor)
        self.lblChangeProfile.setColor(color: .appthemeBlackColor)
        self.lblNameTitle.setColor(color: .appthemeWhiteColor)
        self.lblName.setColor(color: .appthemeBlackColor)
        self.txtFirstName.setColor(color: .appthemeBlackColor)
        self.txtLastName.setColor(color: .appthemeBlackColor)
        self.lblDOB.setColor(color: .appthemeBlackColor)
        self.txtDOB.setColor(color: UIColor.black.withAlphaComponent(0.5))
        self.lblLocation.setColor(color: .appthemeBlackColor)
        self.txtLocation.setColor(color: .appthemeBlackColor)
        self.lblPhone.setColor(color: .appthemeBlackColor)
        self.txtCode.setColor(color: .appthemeBlackColor)
        self.txtMobile.setColor(color: .appthemeBlackColor)
        self.lblEmail.setColor(color: .appthemeBlackColor)
        self.txtEmail.setColor(color: .appthemeBlackColor)
        self.lblFacebook.setColor(color: .appthemeBlackColor)
        self.txtFacebook.setColor(color: .appthemeBlackColor)
    }
}
