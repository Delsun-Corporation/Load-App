//
//  UserProfileFeedListView.swift
//  Load
//
//  Created by Yash on 30/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class UserProfileFeedListView: UIView {

    //MARK:- Outlet
    @IBOutlet weak var tblFeedList: UITableView!
    
    //MARK:- SetupUI
    func setupUI(){
        
        self.tblFeedList.register(UINib(nibName: "CardioFeedsCell", bundle: nil), forCellReuseIdentifier: "CardioFeedsCell")
        self.tblFeedList.tableFooterView = UIView()
        
        self.tblFeedList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
    }

}
