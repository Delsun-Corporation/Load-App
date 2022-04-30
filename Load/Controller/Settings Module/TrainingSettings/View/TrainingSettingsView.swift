//
//  TrainingSettingsView.swift
//  Load
//
//  Created by Haresh Bhai on 30/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class TrainingSettingsView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewTopHeight: NSLayoutConstraint!
    
    //MARK:- Functions
    func setupUI(theController: TrainingSettingsVC) {
        self.tableView.register(UINib(nibName: "TrainingSettingsCell", bundle: nil), forCellReuseIdentifier: "TrainingSettingsCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
        tableViewTopHeight.constant = 20
    }
}
