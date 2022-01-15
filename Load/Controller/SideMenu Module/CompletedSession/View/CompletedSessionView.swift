//
//  CompletedSessionView.swift
//  Load
//
//  Created by Haresh Bhai on 12/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CompletedSessionView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: CompletedSessionVC) {
        self.setupTableView(theController: theController)
    }
    
    func setupTableView(theController: CompletedSessionVC) {
        self.tableView.register(UINib(nibName: "CompletedSessionCell", bundle: nil), forCellReuseIdentifier: "CompletedSessionCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
    }

}
