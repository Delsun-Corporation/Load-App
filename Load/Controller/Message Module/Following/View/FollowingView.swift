//
//  FollowingView.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FollowingView: UIView {
  
    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: FollowingVC) {
        self.layoutIfNeeded()
        self.tableView.register(UINib(nibName: "FollowingCell", bundle: nil), forCellReuseIdentifier: "FollowingCell")
        self.tableView.register(UINib(nibName: "AddNewContactCell", bundle: nil), forCellReuseIdentifier: "AddNewContactCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
    }    
}
