//
//  ResetPasswordView.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ResetPasswordView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblResetPassword: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnRetrievePassword: UIButton!
    
    //MARK:- Functions
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.txtEmail.font = themeFont(size: 13, fontname: .Regular)
        self.lblResetPassword.font = themeFont(size: 18, fontname: .Regular)
        self.btnRetrievePassword.titleLabel?.font = themeFont(size: 17, fontname: .Regular)
        
        self.lblResetPassword.setColor(color: .appthemeWhiteColor)
        self.txtEmail.setColor(color: .appthemeBlackColor)
        self.btnRetrievePassword.setColor(color: .appthemeWhiteColor)
        
        self.lblResetPassword.text = getCommonString(key: "RESET_PASSWORD_key")
        self.txtEmail.placeholder = getCommonString(key: "Email_Address_key")
        self.btnRetrievePassword.setTitle(str: getCommonString(key: "Retrieve_Password_key"))
    }
}
