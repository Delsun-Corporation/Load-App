//
//  CreateEventFinishVC.swift
//  Load
//
//  Created by Haresh Bhai on 28/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventFinishVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CreateEventFinishView = { [unowned self] in
        return self.view as! CreateEventFinishView
    }()
    
    lazy var mainModelView: CreateEventFinishViewModel = {
        return CreateEventFinishViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPublishClicked(_ sender: Any) {
        self.mainModelView.saveDetails()
    }
}
