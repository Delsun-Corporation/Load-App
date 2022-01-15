//
//  ListingsView.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ListingsView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI() {
        self.tableView.register(UINib(nibName: "CoachNeededCell", bundle: nil), forCellReuseIdentifier: "CoachNeededCell")
        self.tableView.register(UINib(nibName: "ListingUserListCell", bundle: nil), forCellReuseIdentifier: "ListingUserListCell")       
    }
}
