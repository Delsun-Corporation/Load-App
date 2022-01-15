//
//  CreateEventStepThreeVC.swift
//  Load
//
//  Created by Haresh Bhai on 16/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventStepThreeVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CreateEventStepThreeView = { [unowned self] in
        return self.view as! CreateEventStepThreeView
    }()
    
    lazy var mainModelView: CreateEventStepThreeViewModel = {
        return CreateEventStepThreeViewModel(theController: self)
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
    
    @IBAction func btnCurrencyClicked(_ sender: Any) {
        if self.mainView.txtCurrency.text?.toTrim() == "" {
            let model = GetAllData?.data?.currency?.first
            self.mainView.txtCurrency.text = model?.name
            self.mainModelView.currencyId = model?.id?.intValue ?? 0
        }
        self.mainView.txtCurrency.becomeFirstResponder()
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
}
