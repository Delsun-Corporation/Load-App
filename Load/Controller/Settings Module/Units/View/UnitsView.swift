//
//  UnitsView.swift
//  Load
//
//  Created by iMac on 23/01/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class UnitsView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: UnitsVC) {
        self.tableView.register(UINib(nibName: "UnitListCell", bundle: nil), forCellReuseIdentifier: "UnitListCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
    }
}
