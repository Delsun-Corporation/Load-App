//
//  NotificationView.swift
//  Load
//
//  Created by Haresh Bhai on 10/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: NotificationVC) {
        self.setupTableView(theController: theController)
    }
    
    func setupTableView(theController: NotificationVC) {
        self.tableView.register(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
    }
}
