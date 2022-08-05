//
//  AutoTopUpVC.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AutoTopUpVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: AutoTopUpView = { [unowned self] in
        return self.view as! AutoTopUpView
        }()
    
    lazy var mainModelView: AutoTopUpViewModel = {
        return AutoTopUpViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Auto_top_up_key"), color:UIColor.black)
        self.navigationController?.setWhiteColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.mainModelView.delegate?.AutoTopUpFinish(isAutoTopup: self.mainModelView.isAutoTopup, autoTopupAmount: self.mainModelView.autoTopupAmount, minimumBalance: self.mainModelView.minimumBalance)
        self.navigationController?.popViewController(animated: true)
    }
}
