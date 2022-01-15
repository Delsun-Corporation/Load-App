//
//  UserProfileFollowListView.swift
//  Load
//
//  Created by Yash on 30/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class UserProfileFollowListView: UIView {

    //MARK:- Outlet
    @IBOutlet weak var tblFollowList: UITableView!
    
    //MARK:- SetupUI
    func setupUI(){
        
        self.tblFollowList.register(UINib(nibName: "UserProfileFollowListTblCell", bundle: nil), forCellReuseIdentifier: "UserProfileFollowListTblCell")
        self.tblFollowList.tableFooterView = UIView()
        
        self.tblFollowList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
    }

}
