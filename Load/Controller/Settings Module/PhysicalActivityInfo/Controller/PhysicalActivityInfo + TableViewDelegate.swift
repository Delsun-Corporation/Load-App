//
//  PhysicalActivityInfo + TableViewDelegate.swift
//  Load
//
//  Created by Yash on 09/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation

extension PhysicalActivityInfoVc: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.profileDetails?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhysicalActivityInfoTblCell") as! PhysicalActivityInfoTblCell
        
        if let model = self.mainModelView.profileDetails?.data?[indexPath.row]{
            cell.setupUI(model: model)
        }
        
        if indexPath.row == (self.mainModelView.profileDetails?.data?.count ?? 0) - 1{
            cell.vwLine.isHidden = true
        }else{
            cell.vwLine.isHidden = false
        }

        return cell
    }
    
}
