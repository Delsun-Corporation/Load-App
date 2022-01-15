//
//  NewMessageSelectView.swift
//  Load
//
//  Created by Haresh Bhai on 29/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class NewMessageSelectView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: NewMessageSelectVC) {
        self.layoutIfNeeded()
        self.setupTableView(theController: theController)
    }
    
    func setupTableView(theController: NewMessageSelectVC) {
        self.tableView.register(UINib(nibName: "FollowingCell", bundle: nil), forCellReuseIdentifier: "FollowingCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
    }
}
