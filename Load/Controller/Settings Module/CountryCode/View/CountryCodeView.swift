//
//  CountryCodeView.swift
//  Load
//
//  Created by Haresh Bhai on 25/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CountryCodeView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: CountryCodeVC) {
        self.tableView.register(UINib(nibName: "CountryCodeCell", bundle: nil), forCellReuseIdentifier: "CountryCodeCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
        self.txtSearch.delegate = theController 
    }
}
