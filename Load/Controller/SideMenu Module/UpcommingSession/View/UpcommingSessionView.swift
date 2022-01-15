//
//  UpcommingSessionView.swift
//  Load
//
//  Created by Haresh Bhai on 12/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class UpcommingSessionView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: UpcommingSessionVC) {
        self.setupTableView(theController: theController)
    }
    
    func setupTableView(theController: UpcommingSessionVC) {
        self.tableView.register(UINib(nibName: "UpcommingSessionCell", bundle: nil), forCellReuseIdentifier: "UpcommingSessionCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
    }

}
