//
//  UnitsVC.swift
//  Load
//
//  Created by iMac on 23/01/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class UnitsVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: UnitsView = { [unowned self] in
        return self.view as! UnitsView
        }()
    
    lazy var mainModelView: UnitsViewModel = {
        return UnitsViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Unit_Measurement_key"), color:UIColor.black)
        self.navigationController?.setWhiteColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        if self.mainModelView.isUpdated {
            self.mainModelView.delegate?.UnitsFinish(id: self.mainModelView.selectedId, title: self.mainModelView.selectedTitle)
        }
    }
}
