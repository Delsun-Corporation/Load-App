//
//  SelectFormVC.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SelectFormVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: SelectFormView = { [unowned self] in
        return self.view as! SelectFormView
        }()
    
    lazy var mainModelView: SelectFormViewModel = {
        return SelectFormViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Form_key"), color: .black)
        self.navigationController?.setWhiteColor()
        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
    }
    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.mainModelView.delegate?.SelectFormFinish(isAgree: self.mainModelView.isAgree, isAuto: self.mainModelView.isAuto, isSetCompulsory: self.mainModelView.isSetCompulsory)
        self.dismiss(animated: true, completion: nil)
    }    
}
