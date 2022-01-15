//
//  SignUpVC.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: SignUpView = { [unowned self] in
        return self.view as! SignUpView
    }()
    
    lazy var mainModelView: SignUpViewModel = {
        return SignUpViewModel(theController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnAgreeClicked(_ sender: UIButton) {        
        self.mainModelView.isAccepted = !self.mainModelView.isAccepted
        let image = self.mainModelView.isAccepted ? "ic_check_box_select" : "ic_check_box_unselect"
        sender.setImage(UIImage(named: image), for: .normal)
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        self.mainModelView.ValidateDetails()
    }
    
    @IBAction func btnSignInClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
