//
//  SettingsView.swift
//  Load
//
//  Created by Haresh Bhai on 22/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SettingsView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
        
    //MARK:- Functions
    func setupUI(theController: SettingsVC) {
        self.layoutIfNeeded()
        self.tableView.register(UINib(nibName: "SettingProfileCell", bundle: nil), forCellReuseIdentifier: "SettingProfileCell")
        self.tableView.register(UINib(nibName: "SettingListCell", bundle: nil), forCellReuseIdentifier: "SettingListCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
    }
}
