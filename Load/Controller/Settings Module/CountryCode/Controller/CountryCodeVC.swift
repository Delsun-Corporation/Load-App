//
//  CountryCodeVC.swift
//  Load
//
//  Created by Haresh Bhai on 25/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class CountryCodeVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CountryCodeView = { [unowned self] in
        return self.view as! CountryCodeView
    }()
    
    lazy var mainModelView: CountryCodeViewModel = {
        return CountryCodeViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    //MARK:- Functions
    @objc func dismissScreen() {
        self.dismiss(animated: false, completion: nil)
    }
}
