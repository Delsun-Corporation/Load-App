//
//  OTPVC.swift
//  Load
//
//  Created by David Christian on 13/07/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation

class OTPResetPasswordVC: UIViewController, AEOTPTextFieldDelegate {
    var otpTimer: Timer?
    var seconds = 60
    var email = ""
    
    //MARK:- Variables
    lazy var mainView: OTPResetPasswordView = { [unowned self] in
        return self.view as! OTPResetPasswordView
    }()
    
    lazy var mainModelView: OTPResetPasswordViewModel = {
        return OTPResetPasswordViewModel(theController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        mainView.txtOTP.otpDelegate = self
        mainView.txtOTP.configure()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        // ViewController going away. Kill the timer.
        otpTimer?.invalidate()
    }
    
    func startCountdown() {
        otpTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            self?.seconds -= 1
            if self?.seconds == 0 {
                print("Finish")
                self?.mainView.btnResendOTP.setTitle(str: "Resend OTP")
                self?.seconds = 60
                timer.invalidate()
            } else if let seconds = self?.seconds {
                UIView.performWithoutAnimation {
                    self?.mainView.btnResendOTP.setTitle("Resend OTP in \(seconds)s", for: .normal)
                    self?.mainView.btnResendOTP.layoutIfNeeded()
                }
                print(seconds)
            }
        }
    }
    
    @IBAction func btnActionResendCode(_ sender: Any) {
        if seconds == 60 {
            // Call API to send OTP
            self.mainModelView.apiCallResendOTP(email: email)
            startCountdown()
        }
    }
    
    func didUserFinishEnter(the code: String) {
        self.mainModelView.apiCallVerifyOTP(email: email, otp: code, completion: { response in
            if let responses = response {
                if (!responses) {
                    self.mainView.txtOTP.clearOTP()
                }
            }
        })
    }
}
