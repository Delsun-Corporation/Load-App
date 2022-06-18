//
//  AccountVC.swift
//  Load
//
//  Created by Haresh Bhai on 26/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AccountVC: UIViewController {
    
    @IBOutlet weak var snoozeToggleButton: UIButton!

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
    
    func dismiss() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        mainModelView.saveButtonAction()
    }
    
    @IBAction func btnUpgradeClicked(_ sender: Any) {
        self.mainModelView.showActionSheet()
    }
    
    @IBAction func btnSnoozeClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        mainModelView.isSnoozeSelected = sender.isSelected
        self.mainView.viewDate.isHidden = sender.isSelected ? false : true
        self.mainView.lblDescription.isHidden = sender.isSelected ? true : false
        if !sender.isSelected {
            self.mainModelView.apiCallForUpdateAccountSnooze(isSnooze: sender.isSelected, startDate:"", endDate:"")
        }
    }
    
    @IBAction func btnStartDateClicked(_ sender: Any) {
        self.mainView.txtStartDate.becomeFirstResponder()
    }
    
    @IBAction func btnEndDateClicked(_ sender: Any) {
        if self.mainView.txtStartDate.text == "" {
            return
        }
        self.mainView.txtEndDate.becomeFirstResponder()
    }
}
