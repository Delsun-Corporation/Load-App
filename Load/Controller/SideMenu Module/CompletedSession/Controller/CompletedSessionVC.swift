//
//  CompletedSessionVC.swift
//  Load
//
//  Created by Haresh Bhai on 12/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CompletedSessionVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CompletedSessionView = { [unowned self] in
        return self.view as! CompletedSessionView
    }()
    
    lazy var mainModelView: CompletedSessionViewModel = {
        return CompletedSessionViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.mainView.setupUI(theController: self)
    }
}
