//
//  PhysicalActivity_TableView.swift
//  Load
//
//  Created by iMac on 20/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

extension PhysicalActivityLevelVc: UITableViewDataSource,UITableViewDelegate{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.profileDetails?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhyscialActivityTblCell") as! PhyscialActivityTblCell
        
        if let data = self.mainModelView.profileDetails?.data?[indexPath.row]{
//            cell.setupUI(model: data, selectedId: self.mainModelView.selectedPhysicalActivityId)
        }
        
        if indexPath.row == (self.mainModelView.profileDetails?.data?.count ?? 0) - 1{
            cell.vwLine.isHidden = true
        }else{
            cell.vwLine.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        for i in 0..<(self.mainModelView.profileDetails?.data?.count ?? 0){
//            if let dictData = self.mainModelView.profileDetails?.data?[i]{
//                dictData.isSelected = 0
//                self.mainModelView.profileDetails?.data?[i] = dictData
//            }
//        }
//        
//        self.mainModelView.profileDetails?.data?[indexPath.row].isSelected = 1
//        self.mainModelView.selectedPhysicalActivityId = Int(self.mainModelView.profileDetails?.data?[indexPath.row].id ?? 0)
//        self.mainModelView.isUpdated = true
//        
//        tableView.reloadData()
        
    }
    
}
