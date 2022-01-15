//
//  CountDownVC.swift
//  Load
//
//  Created by Haresh Bhai on 21/12/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CountDownVC: UIViewController {

    lazy var mainView: CountDownView = {[unowned self] in
        return self.view as! CountDownView
    }()
    
    lazy var mainModelView: CountDownViewModel = {
        return CountDownViewModel(theController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        // Do any additional setup after loading the view.
    }
    

}
