//
//  ListingViewAllLoadCenterView.swift
//  Load
//
//  Created by iMac on 20/05/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class ListingViewAllLoadCenterView: UIView {

    //MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - SetupUI
    func setupUI(theController: ListingViewAllLoadCenterVc) {
         self.tableView.register(UINib(nibName: "ViewAllLoadCenterTblCell", bundle: nil), forCellReuseIdentifier: "ViewAllLoadCenterTblCell")
        
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
     }
}
