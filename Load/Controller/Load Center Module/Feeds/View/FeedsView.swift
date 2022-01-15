//
//  FeedsView.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FeedsView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewSearch: UITableView!
    
    //MARK:- Functions
    func setupUI() {
        self.showFeeds()
        self.tableView.register(UINib(nibName: "CardioFeedsCell", bundle: nil), forCellReuseIdentifier: "CardioFeedsCell")
        self.tableViewSearch.register(UINib(nibName: "FeedProfileSearchCell", bundle: nil), forCellReuseIdentifier: "FeedProfileSearchCell")
    }
    
    func showFeeds(isShow:Bool = true) {
        self.tableView.isHidden = !isShow
        self.tableViewSearch.isHidden = isShow
    }
}
