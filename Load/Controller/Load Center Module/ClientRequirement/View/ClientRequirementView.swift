//
//  ClientRequirementView.swift
//  Load
//
//  Created by Haresh Bhai on 14/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ClientRequirementView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: ClientRequirementVC) {
        self.layoutIfNeeded()
        self.tableView.register(UINib(nibName: "ClientRequirementCell", bundle: nil), forCellReuseIdentifier: "ClientRequirementCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
    }
}
