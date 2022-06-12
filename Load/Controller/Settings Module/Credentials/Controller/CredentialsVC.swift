//
//  CredentialsVC.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CredentialsVC: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    
    //MARK:- Variables
    lazy var mainView: CredentialsView = { [unowned self] in
        return self.view as! CredentialsView
        }()
    
    lazy var mainModelView: CredentialsViewModel = {
        return CredentialsViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Credentials_key"), color: .black)
        self.navigationController?.setWhiteColor()
        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
        saveButton.isHidden = true
    }
    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
}
