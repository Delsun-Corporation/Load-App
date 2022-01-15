//
//  ProfessionalActivityVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension EquipmentSelectionVC: UITableViewDelegate, UITableViewDataSource, EquipmentSelectDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.filterArray.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.mainModelView.filterArray[section].activity?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EquipmentSelectionCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "EquipmentSelectionCell") as! EquipmentSelectionCell
        cell.selectionStyle = .none
        cell.tag = indexPath.section
        cell.index = indexPath.row
        cell.delegate = self
        cell.selectedArray = self.mainModelView.selectedArray
        cell.lblTitle.text = self.mainModelView.filterArray[indexPath.section].activity![indexPath.row].name
        let id = self.mainModelView.filterArray[indexPath.section].activity![indexPath.row].id?.intValue
        if self.mainModelView.selectedArray.contains((id)!) {
            cell.showDefaults(isShow: true)
        }
        else {
            cell.showDefaults(isShow: false)
        }
        cell.viewLine.isHidden = false
        return cell
    }
    
    func EquipmentSelectDidFinish(section: Int, index: Int) {
        let id = self.mainModelView.filterArray[section].activity![index].id?.intValue
        let name = self.mainModelView.filterArray[section].activity![index].name
        
        if self.mainModelView.selectedArray.contains((id)!) {
            var indexId:Int = 0
            for (index, data) in self.mainModelView.selectedArray.enumerated() {
                if data == id {
                    indexId = index
                }
            }
            self.mainModelView.selectedArray.remove(at: indexId)
            self.mainModelView.selectedNameArray.remove(at: indexId)
        }
        else {
            self.mainModelView.selectedArray.append(id!)
            self.mainModelView.selectedNameArray.append(name!)
        }
        self.mainView.tableView.reloadData()
    }
}


