//
//  ProfessionalListView.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfessionalListView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: ProfessionalListVC) {
        self.tableView.register(UINib(nibName: "ProfessionalListCell", bundle: nil), forCellReuseIdentifier: "ProfessionalListCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
    }
}
