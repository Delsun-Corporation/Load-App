//
//  UserProfileFollowList + TableViewDelegate.swift
//  Load
//
//  Created by Yash on 30/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation

extension UserProfileFollowListVc: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileFollowListTblCell") as! UserProfileFollowListTblCell
        
        return cell
    }
    
    
}
