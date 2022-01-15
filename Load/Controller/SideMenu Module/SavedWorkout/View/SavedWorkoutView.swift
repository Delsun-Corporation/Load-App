//
//  SavedWorkoutView.swift
//  Load
//
//  Created by Haresh Bhai on 10/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SavedWorkoutView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: SavedWorkoutVC) {
        self.setupTableView(theController: theController)
    }
    
    func setupTableView(theController: SavedWorkoutVC) {
        self.tableView.register(UINib(nibName: "SavedWorkoutCell", bundle: nil), forCellReuseIdentifier: "SavedWorkoutCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
    }
}
