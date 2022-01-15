//
//  CreateEventStepFourVC.swift
//  Load
//
//  Created by Haresh Bhai on 16/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventStepFourVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CreateEventStepFourView = { [unowned self] in
        return self.view as! CreateEventStepFourView
    }()
    
    lazy var mainModelView: CreateEventStepFourViewModel = {
        return CreateEventStepFourViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        self.mainModelView.setupUI()
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCamcellationPolicylicked(_ sender: Any) {
        if self.mainView.txtCancellationPolicy.text?.toTrim() == "" {
            let model = GetAllData?.data?.cancellationPolicy?.first
            self.mainView.txtCancellationPolicy.text = model?.name
            self.mainView.lblCancellationPolicySubTitle.text = model?.description
            self.mainModelView.CancellationRulesId = model?.id?.intValue ?? 0
        }
        self.mainView.txtCancellationPolicy.becomeFirstResponder()
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
}
