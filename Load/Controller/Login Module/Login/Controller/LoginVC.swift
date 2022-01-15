//
//  LoginVC.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: LoginView = { [unowned self] in
        return self.view as! LoginView
    }()
    
    lazy var mainModelView: LoginViewModel = {
        return LoginViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- @IBAction
    @IBAction func btnSignInClicked(_ sender: Any) {
        self.mainModelView.ValidateDetails()
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        let obj: ResetPasswordVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "ResetPasswordVC") as! ResetPasswordVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        let obj: SignUpVC = AppStoryboard.Main.instance.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
