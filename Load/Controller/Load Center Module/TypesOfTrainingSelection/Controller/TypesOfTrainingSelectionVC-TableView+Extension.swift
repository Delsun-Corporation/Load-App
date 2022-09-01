//
//  FilterSpecializ-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 26/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension TypesOfTrainingSelectionVC: UITableViewDelegate, UITableViewDataSource, RegionSelectionDelegate {
    func SelectAll(isSelected: Bool, section: Int) {
        
    }
    
    //MARK:- TableView
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.filterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RegionSelectionCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "RegionSelectionCell") as! RegionSelectionCell
        cell.selectionStyle = .none
        cell.tag = indexPath.section
        cell.index = indexPath.row
        cell.delegate = self
        
        cell.lblTitle.text = self.mainModelView.filterArray[indexPath.row].name
        let id = self.mainModelView.filterArray[indexPath.row].id?.intValue
        if self.mainModelView.selectedArray.contains((id)!) {
            cell.showDefaults(isShow: true)
        }
        else {
            cell.showDefaults(isShow: false)
        }
        return cell
    }
    
    func isMultiple(array: [TrainingTypes], name: String) -> Bool {
        let filter = array.filter { (model) -> Bool in
            return model.name == name
        }
        return filter.count == 1 ? false : true
    }
    
    func RegionSelectionDidFinish(section: Int, index: Int) {
        let id = self.mainModelView.filterArray[index].id?.intValue
        let name = self.mainModelView.filterArray[index].name
        self.mainModelView.selectedArray.removeAll()
        self.mainModelView.selectedNameArray.removeAll()
        if self.mainModelView.selectedArray.contains((id)!) {
            var indexId:Int = 0
            for (index, data) in self.mainModelView.selectedArray.enumerated() {
                if data == id {
                    indexId = index
                }
            }
            self.mainModelView.selectedArray.remove(at: indexId)
            if (self.mainModelView.selectedNameArray.count) > indexId {
                self.mainModelView.selectedNameArray.remove(at: indexId)
            }
        }
        else {
            self.mainModelView.selectedArray.append(id!)
            self.mainModelView.selectedNameArray.append(name!)
        }
        self.mainView.tableView.reloadData()
    }
}


