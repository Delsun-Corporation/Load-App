//
//  CalendarVC.swift
//  Load
//
//  Created by Haresh Bhai on 29/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CalendarVC: UIViewController {
    
    @IBOutlet weak var btnAdd: UIButton!
    
    //MARK:- Variables
    lazy var mainView: CalendarView = { [unowned self] in
        return self.view as! CalendarView
    }()
    
    lazy var mainModelView: CalendarViewModel = {
        return CalendarViewModel(theController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setColor()
        self.mainView.setupUI(theDelegate: self)
        self.mainModelView.setupData()
        
    }
  
    @IBAction func btnSideMenuClicked(_ sender: Any) {
        SJSwiftSideMenuController.toggleLeftSideMenu()
    }
    
    @IBAction func btnPreviousClicked(_ sender: Any) {
        self.mainModelView.selectedDate = ""
        self.mainModelView.isReloaded = [false, false, false, false, false, false]
        self.mainModelView.lastSelectedSection = 0
        self.mainModelView.currentShowMonth = self.mainModelView.currentShowMonth.getPreviousMonth()!
        self.mainModelView.setupData()
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.mainModelView.selectedDate = ""
        self.mainModelView.isReloaded = [false, false, false, false, false, false]
        self.mainModelView.lastSelectedSection = 0
        self.mainModelView.currentShowMonth = self.mainModelView.currentShowMonth.getNextMonth()!
        self.mainModelView.setupData()
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        
        if self.mainModelView.isOpenSwitch {
            self.mainModelView.SwitchAccountClicked(isOpen: false)
            self.mainModelView.viewSwitchAccount?.isOpen = false
        }
        else {
            self.mainModelView.openCreateTraining()
        }
    }
    
    func tableReload(){
        self.mainView.tableView.reloadData()
    }
}
