//
//  SessionVC.swift
//  Load
//
//  Created by Haresh Bhai on 12/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SessionVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: SessionView = { [unowned self] in
        return self.view as! SessionView
    }()
    
    lazy var mainModelView: SessionViewModel = {
        return SessionViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.setClearColor()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Sessions_key"), color:UIColor.black)
        IS_CHAT_SCREEN = true
        self.mainView.setupUI(theController: self)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
