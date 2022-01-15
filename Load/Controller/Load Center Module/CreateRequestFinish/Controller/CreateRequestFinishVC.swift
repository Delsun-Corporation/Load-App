//
//  CreateRequestFinishVC.swift
//  Load
//
//  Created by Haresh Bhai on 24/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateRequestFinishVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CreateRequestFinishView = { [unowned self] in
        return self.view as! CreateRequestFinishView
    }()
    
    lazy var mainModelView: CreateRequestFinishViewModel = {
        return CreateRequestFinishViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        self.mainModelView.setupUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPublishClicked(_ sender: Any) {
        self.mainModelView.saveDetails()
    }
}
