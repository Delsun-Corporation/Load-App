
//
//  LoginView.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LoginView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblSignIn: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    //MARK:- Functions
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblSignIn.font = themeFont(size: 18, fontname: .Regular)
        self.txtEmail.font = themeFont(size: 13, fontname: .Regular)
        self.txtPassword.font = themeFont(size: 13, fontname: .Regular)
        self.btnSignIn.titleLabel?.font = themeFont(size: 17, fontname: .Regular)
        self.btnForgotPassword.titleLabel?.font = themeFont(size: 13, fontname: .Regular)
        self.btnSignUp.titleLabel?.font = themeFont(size: 13, fontname: .Regular)
        
        self.lblSignIn.setColor(color: .appthemeWhiteColor)
        self.txtEmail.setColor(color: .appthemeBlackColor)
        self.txtPassword.setColor(color: .appthemeBlackColor)
        self.btnSignIn.setColor(color: .appthemeWhiteColor)
        self.btnForgotPassword.setColor(color: .appthemeWhiteColor)
        self.btnSignUp.setColor(color: .appthemeWhiteColor)
        
        self.lblSignIn.text = getCommonString(key: "SIGN_IN_key")
        self.txtEmail.placeholder = getCommonString(key: "Email_Address_key")
        self.txtPassword.placeholder = getCommonString(key: "Password_key")
        self.btnSignIn.setTitle(str: getCommonString(key: "Sign_in_key"))
        self.btnForgotPassword.setTitle(str: getCommonString(key: "Forgot_your_password?_key"))
        self.btnSignUp.setTitle(str: getCommonString(key: " I_don’t_have_Load_account._Sign_Up_key"))
    }
}
