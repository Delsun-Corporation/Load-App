//
//  ChangePasswordVC.swift
//  Load
//
//  Created by David Christian on 07/07/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import Foundation

class ChangePasswordVC: UIViewController {
    var email = ""
    var isFromOTP = false
    //MARK:- Variables
    lazy var mainView: ChangePasswordView = { [unowned self] in
        return self.view as! ChangePasswordView
    }()
    
    lazy var mainModelView: ChangePasswordViewModel = {
        return ChangePasswordViewModel(theController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        self.mainView.txtEmail.text = email
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        self.mainModelView.ValidateDetails(isFromOTP: isFromOTP)
    }
}
