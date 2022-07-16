//
//  OTPView.swift
//  Load
//
//  Created by David Christian on 13/07/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation

class OTPResetPasswordView: UIView {
    @IBOutlet weak var lblInputOTP: UILabel!
    @IBOutlet var btnResendOTP: UIButton!
    @IBOutlet weak var txtOTP: AEOTPTextField!
    
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblInputOTP.font = themeFont(size: 18, fontname: .Regular)
        
        self.txtOTP.otpFont = themeFont(size: 17, fontname: .Regular)
        self.txtOTP.otpTextColor = .appthemePinkColor
        self.txtOTP.otpFilledBorderWidth = 0
        
        self.btnResendOTP.setColor(color: .appthemeWhiteColor)
        self.btnResendOTP.titleLabel?.font = themeFont(size: 15, fontname: .Regular)
        
        self.lblInputOTP.text = getCommonString(key: "Input_Otp_key")
    }
}
