//
//  TimeUnderTensionInfo + TableViewDelegate.swift
//  Load
//
//  Created by Yash on 15/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation

extension TimeUnderTensionInfoVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.arrayTimeUnderTensionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TimeUnderTensionInfoTblCell") as! TimeUnderTensionInfoTblCell
        cell.setupUI(data: self.mainModelView.arrayTimeUnderTensionList[indexPath.row])
        return cell
    }
    
}
