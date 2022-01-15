//
//  SidemenuVC.swift
//  Load
//
//  Created by Haresh Bhai on 02/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SidemenuVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: SidemenuView = { [unowned self] in
        return self.view as! SidemenuView
    }()
    
    lazy var mainModelView: SidemenuViewModel = {
        return SidemenuViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setColor()
        self.mainView.setupUI(theDelegate: self)
        //self.mainModelView.setupData()
    }
}
