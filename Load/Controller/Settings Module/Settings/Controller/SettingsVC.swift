//
//  SettingsVC.swift
//  Load
//
//  Created by Haresh Bhai on 22/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

var IS_OPEN_RACETIME:Bool = false

class SettingsVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: SettingsView = { [unowned self] in
        return self.view as! SettingsView
    }()
    
    lazy var mainModelView: SettingsViewModel = {
        return SettingsViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.setUpNavigationBarTitle(strTitle: getCommonString(key: "Settings_key").lowercased().capitalized, fontType: .ProximaNovaBold)
        self.mainView.setupUI(theController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setColor()
        self.mainView.tableView.reloadData()
        if IS_OPEN_RACETIME {
            self.moveTraining()
        }
        
//        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Settings_key").lowercased().capitalized)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(10222) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func moveTraining() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "TrainingSettingsVC") as! TrainingSettingsVC
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: false)
    }
}
