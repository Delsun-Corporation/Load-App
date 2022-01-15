//
//  UpcommingSessionVC.swift
//  Load
//
//  Created by Haresh Bhai on 12/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class UpcommingSessionVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: UpcommingSessionView = { [unowned self] in
        return self.view as! UpcommingSessionView
    }()
    
    lazy var mainModelView: UpcommingSessionViewModel = {
        return UpcommingSessionViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.mainView.setupUI(theController: self)
    }  
}
