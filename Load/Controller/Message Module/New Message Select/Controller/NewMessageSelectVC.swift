//
//  NewMessageSelectVC.swift
//  Load
//
//  Created by Haresh Bhai on 29/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class NewMessageSelectVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: NewMessageSelectView = { [unowned self] in
        return self.view as! NewMessageSelectView
    }()
    
    lazy var mainModelView: NewMessageSelectViewModel = {
        return NewMessageSelectViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.setColor()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }    
}
