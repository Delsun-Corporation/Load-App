//
//  LoadCenterSettingsVC.swift
//  Load
//
//  Created by Haresh Bhai on 30/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LoadCenterSettingsVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: LoadCenterSettingsView = { [unowned self] in
        return self.view as! LoadCenterSettingsView
    }()
    
    lazy var mainModelView: LoadCenterSettingsViewModel = {
        return LoadCenterSettingsViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setColor()
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Load_Center_key"))

//        setUpNavigationBarTitle(strTitle: getCommonString(key: "Load_Center_key"))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    //MARK:- @IBAction
     func btnBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPremiumClicked(_ sender: Any) {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "PremiumVC") as! PremiumVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnProfessionalClicked(_ sender: Any) {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalLoadCenterVC") as! ProfessionalLoadCenterVC
        self.navigationController?.pushViewController(obj, animated: true)
    }
}
