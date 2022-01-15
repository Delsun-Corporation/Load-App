//
//  FeedsVC.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit


class FeedsVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: FeedsView = { [unowned self] in
        return self.view as! FeedsView
    }()
    
    lazy var mainModelView: FeedsViewModel = {
        return FeedsViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupUI()
        SELECTED_LOADCENTER_TAB = 0
    }
}
