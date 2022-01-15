//
//  AutoTopUpView.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AutoTopUpView: UIView {
   
    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:AutoTopUpVC) {
        self.tableView.register(UINib(nibName: "AutoTopUpCell", bundle: nil), forCellReuseIdentifier: "AutoTopUpCell")
        self.tableView.register(UINib(nibName: "AutoTopUpTextCell", bundle: nil), forCellReuseIdentifier: "AutoTopUpTextCell")
        self.tableView.register(UINib(nibName: "SelectFormQuesionsCell", bundle: nil), forCellReuseIdentifier: "SelectFormQuesionsCell")
        self.tableView.register(UINib(nibName: "AutoTopUpBillingTitleCell", bundle: nil), forCellReuseIdentifier: "AutoTopUpBillingTitleCell")
        self.tableView.register(UINib(nibName: "AutoTopUpBillingCardCell", bundle: nil), forCellReuseIdentifier: "AutoTopUpBillingCardCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
        self.tableView.reloadData()
    }
}
