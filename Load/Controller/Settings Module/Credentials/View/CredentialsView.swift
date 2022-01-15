//
//  CredentialsView.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CredentialsView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:CredentialsVC) {
        self.tableView.register(UINib(nibName: "CredentialsCell", bundle: nil), forCellReuseIdentifier: "CredentialsCell")
        self.tableView.register(UINib(nibName: "CredentialsAddCell", bundle: nil), forCellReuseIdentifier: "CredentialsAddCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
        self.tableView.reloadData()
    }
}
