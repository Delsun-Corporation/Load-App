//
//  ClientRequirementVC.swift
//  Load
//
//  Created by Haresh Bhai on 14/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ClientRequirementVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: ClientRequirementView = { [unowned self] in
        return self.view as! ClientRequirementView
    }()
    
    lazy var mainModelView: ClientRequirementViewModel = {
        return ClientRequirementViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
