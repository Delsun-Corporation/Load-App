//
//  AccountVC.swift
//  Load
//
//  Created by Haresh Bhai on 26/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: AccountView = { [unowned self] in
        return self.view as! AccountView
    }()
    
    lazy var mainModelView: AccountViewModel = {
        return AccountViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Account_key"))
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUpgradeClicked(_ sender: Any) {
        self.mainModelView.showActionSheet()
    }
    
    @IBAction func btnSnoozeClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.mainView.viewDate.isHidden = sender.isSelected ? false : true
        self.mainView.lblDescription.isHidden = sender.isSelected ? true : false
        if !sender.isSelected {
            self.mainModelView.setUpNavigationBarRightButton(isRightButtonHidden: true)
            self.mainModelView.apiCallForUpdateAccountSnooze(isSnooze: sender.isSelected, startDate:"", endDate:"")
        }
        else {
            self.mainModelView.setUpNavigationBarRightButton(isRightButtonHidden: false)
        }
    }
    
    @IBAction func btnStartDateClicked(_ sender: Any) {
        self.mainView.txtStartDate.becomeFirstResponder()
        self.mainModelView.setUpNavigationBarRightButton(isRightButtonHidden: false)
    }
    
    @IBAction func btnEndDateClicked(_ sender: Any) {
        if self.mainView.txtStartDate.text == "" {
            return
        }
        self.mainModelView.setUpNavigationBarRightButton(isRightButtonHidden: false)
        self.mainView.txtEndDate.becomeFirstResponder()
    }
}
