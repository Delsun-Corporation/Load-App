//
//  MultiSelectionView.swift
//  Load
//
//  Created by Haresh Bhai on 14/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class MultiSelectionView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: MultiSelectionVC) {
        self.tableView.register(UINib(nibName: "MultiSelectionCell", bundle: nil), forCellReuseIdentifier: "MultiSelectionCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
        self.tableView.tableFooterView = UIView()
    }
}
