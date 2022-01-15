//
//  FollowingVC.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FollowingVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: FollowingView = { [unowned self] in
        return self.view as! FollowingView
    }()
    
    lazy var mainModelView: FollowingViewModel = {
        return FollowingViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.mainView.setupUI(theController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupUI()
    }
}
