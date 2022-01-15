//
//  PremiumView.swift
//  Load
//
//  Created by Haresh Bhai on 05/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class PremiumView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:PremiumVC) {
        self.tableView.register(UINib(nibName: "PremiumCell", bundle: nil), forCellReuseIdentifier: "PremiumCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
        self.tableView.reloadData()
    }
}
