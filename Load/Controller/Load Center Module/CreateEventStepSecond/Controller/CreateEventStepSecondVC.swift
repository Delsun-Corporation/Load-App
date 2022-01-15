//
//  CreateEventStepSecondVC.swift
//  Load
//
//  Created by Haresh Bhai on 26/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventStepSecondVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CreateEventStepSecondView = { [unowned self] in
        return self.view as! CreateEventStepSecondView
    }()
    
    lazy var mainModelView: CreateEventStepSecondViewModel = {
        return CreateEventStepSecondViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewWithTag = self.navigationController!.view.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI()
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
}
