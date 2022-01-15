//
//  SelectFormView.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SelectFormView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:SelectFormVC) {
        self.tableView.register(UINib(nibName: "SelectFormAutoSendCell", bundle: nil), forCellReuseIdentifier: "SelectFormAutoSendCell")
        self.tableView.register(UINib(nibName: "SelectFormQuesionsCell", bundle: nil), forCellReuseIdentifier: "SelectFormQuesionsCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
        self.tableView.reloadData()
    }
}
