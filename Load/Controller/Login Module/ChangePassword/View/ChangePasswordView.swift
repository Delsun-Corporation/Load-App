//
//  ChangePasswordView.swift
//  Load
//
//  Created by David Christian on 07/07/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation

class ChangePasswordView: UIView {
    @IBOutlet var lblChangePassword: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var btnChangePassword: UIButton!
    
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        
        self.lblChangePassword.font = themeFont(size: 18, fontname: .Regular)
        self.txtEmail.font = themeFont(size: 13, fontname: .Regular)
        self.txtPassword.font = themeFont(size: 13, fontname: .Regular)
        self.txtConfirmPassword.font = themeFont(size: 13, fontname: .Regular)

        self.btnChangePassword.titleLabel?.font = themeFont(size: 17, fontname: .Regular)
        
        self.lblChangePassword.setColor(color: .appthemeWhiteColor)
        self.txtEmail.setColor(color: .appthemeBlackColor)
        self.txtPassword.setColor(color: .appthemeBlackColor)
        self.txtConfirmPassword.setColor(color: .appthemeBlackColor)

        self.btnChangePassword.setColor(color: .appthemeWhiteColor)
        
        
        self.lblChangePassword.text = getCommonString(key: "Change_Password_key")
        self.txtEmail.placeholder = getCommonString(key: "Email_Address_key")
        self.txtPassword.placeholder = getCommonString(key: "Password_key")
        self.txtConfirmPassword.placeholder = getCommonString(key: "Confirm_Password_key")

        self.btnChangePassword.setTitle(str: getCommonString(key: "Change_Password_Button_key"))

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
