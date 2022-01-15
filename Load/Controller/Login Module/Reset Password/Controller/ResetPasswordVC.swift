//
//  ResetPasswordVC.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ResetPasswordVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: ResetPasswordView = { [unowned self] in
        return self.view as! ResetPasswordView
    }()
    
    lazy var mainModelView: ResetPasswordViewModel = {
        return ResetPasswordViewModel(theController: self)
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
    @IBAction func btnRetrivePasswordClicked(_ sender: Any) {
        self.mainModelView.ValidateDetails()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }    
}
