//
//  SignUpView.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SignUpView: UIView {
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var lblAgree: UILabel!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSignIn: UIButton!
    
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        
        self.lblSignUp.font = themeFont(size: 18, fontname: .Regular)
        self.txtEmail.font = themeFont(size: 13, fontname: .Regular)
        self.txtPassword.font = themeFont(size: 13, fontname: .Regular)
        self.txtConfirmPassword.font = themeFont(size: 13, fontname: .Regular)
        self.lblAgree.font = themeFont(size: 9, fontname: .Helvetica)
        self.lblTerms.font = themeFont(size: 9, fontname: .Helvetica)

        self.btnSignUp.titleLabel?.font = themeFont(size: 17, fontname: .Regular)
        self.btnSignIn.titleLabel?.font = themeFont(size: 13, fontname: .Regular)
        
        self.lblSignUp.setColor(color: .appthemeWhiteColor)
        self.txtEmail.setColor(color: .appthemeBlackColor)
        self.txtPassword.setColor(color: .appthemeBlackColor)
        self.txtConfirmPassword.setColor(color: .appthemeBlackColor)

        self.lblAgree.setColor(color: .appthemeLightGrayColor)
        self.lblTerms.setColor(color: .appthemeBlackColor)
        self.btnSignUp.setColor(color: .appthemeWhiteColor)
        self.btnSignIn.setColor(color: .appthemeWhiteColor)
        
        
        self.lblSignUp.text = getCommonString(key: "SIGN_UP_key")
        self.txtEmail.placeholder = getCommonString(key: "Email_Address_key")
        self.txtPassword.placeholder = getCommonString(key: "Password_key")
        self.txtConfirmPassword.placeholder = getCommonString(key: "Confirm_Password_key")
        
        self.lblAgree.text = getCommonString(key: "I_agree_to_Load’s_key")
        self.lblTerms.text = getCommonString(key: "Terms_&_Agreements_key")

        self.btnSignUp.setTitle(str: getCommonString(key: "Sign_up_key"))
        self.btnSignIn.setTitle(str: getCommonString(key: "I_already_have_a_Load_account._Sign_in_key"))

        if #available(iOS 12.0, *) {
            self.txtPassword.textContentType = .newPassword
            self.txtConfirmPassword.textContentType = .newPassword
        } else {
            // Fallback on earlier versions
            self.txtPassword.textContentType = .init(rawValue: "")
            self.txtConfirmPassword.textContentType = .init(rawValue: "")
        }
        
    }
}
