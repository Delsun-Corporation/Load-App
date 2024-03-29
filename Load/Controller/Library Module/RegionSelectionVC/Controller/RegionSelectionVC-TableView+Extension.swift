//
//  FilterSpecializ-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 26/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension RegionSelectionVC: UITableViewDelegate, UITableViewDataSource, RegionSelectionDelegate {
    
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.filterArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.mainModelView.isHeaderHide ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.mainModelView.isHeaderHide ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = RegionSelectionHeaderView.instanceFromNib() as! RegionSelectionHeaderView
        view.setupUI()
        view.lblTitle.text = self.mainModelView.filterArray[section].title
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = ProfileFooterView.instanceFromNib() as? ProfileFooterView
        view?.setupUI()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.mainModelView.isHeaderHide {
            return 58
        }
        return 45//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.mainModelView.isHeaderHide {
            return 58
        }
        return 45 //UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mainModelView.category == "Power" {
            return (self.mainModelView.filterArray[section].activity?.count)! + 1
        }
        else {
            return (self.mainModelView.filterArray[section].activity?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RegionSelectionCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "RegionSelectionCell") as! RegionSelectionCell
        cell.selectionStyle = .none
        cell.tag = indexPath.section
        print("This is cell tag \(cell.tag)")
        cell.viewLine.isHidden = !self.mainModelView.isHeaderHide
        cell.delegate = self
        if self.mainModelView.category == "Power" {
            if indexPath.row == 0 {
                cell.index = -1
                cell.lblTitle.text = "Select All"
                var isSelectAllAlreadySelected = true
                for region in self.mainModelView.filterArray[indexPath.section].activity! {
                    let id = region.id?.intValue
                    if !self.mainModelView.selectedArray.contains((id)!) {
                        isSelectAllAlreadySelected = false
                        break
                    }
                }
                cell.showDefaults(isShow: isSelectAllAlreadySelected)
            }
            else {
                cell.index = indexPath.row - 1
                if self.isMultiple(array: self.mainModelView.filterArray[indexPath.section].activity ?? [], name: (self.mainModelView.filterArray[indexPath.section].activity![indexPath.row - 1].name ?? "")) {
                    cell.lblTitle.text = (self.mainModelView.filterArray[indexPath.section].activity![indexPath.row - 1].name ?? "") + " (" + (self.mainModelView.filterArray[indexPath.section].activity![indexPath.row - 1].type ?? "") + ")"
                }
                else {
                    cell.lblTitle.text = self.mainModelView.filterArray[indexPath.section].activity![indexPath.row - 1].name
                }
                let id = self.mainModelView.filterArray[indexPath.section].activity![indexPath.row - 1].id?.intValue
                if self.mainModelView.selectedArray.contains((id)!) {
                    cell.showDefaults(isShow: true)
                }
                else {
                    cell.showDefaults(isShow: false)
                }
            }
            
            return cell
        }
        else {
            cell.index = indexPath.row
            if self.isMultiple(array: self.mainModelView.filterArray[indexPath.section].activity ?? [], name: (self.mainModelView.filterArray[indexPath.section].activity![indexPath.row].name ?? "")) {
                cell.lblTitle.text = (self.mainModelView.filterArray[indexPath.section].activity![indexPath.row].name ?? "") + " (" + (self.mainModelView.filterArray[indexPath.section].activity![indexPath.row].type ?? "") + ")"
            }
            else {
                cell.lblTitle.text = self.mainModelView.filterArray[indexPath.section].activity![indexPath.row].name
            }
            let id = self.mainModelView.filterArray[indexPath.section].activity![indexPath.row].id?.intValue
            if self.mainModelView.selectedArray.contains((id)!) {
                cell.showDefaults(isShow: true)
            }
            else {
                cell.showDefaults(isShow: false)
            }
            return cell
        }
        
        
    }
    
    func isMultiple(array: [Regions], name: String) -> Bool {
        let filter = array.filter { (model) -> Bool in
            return model.name == name
        }
        return filter.count == 1 ? false : true
    }
    
    func RegionSelectionDidFinish(section: Int, index: Int) {
        
        let id = self.mainModelView.filterArray[section].activity![index].id?.intValue
        let name = self.mainModelView.filterArray[section].activity![index].name
        
        print("Region Vc selected array : \(self.mainModelView.selectedArray)")
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
        
        print("Region Vc selected array after: \(self.mainModelView.selectedArray)")
        
        self.mainModelView.delegate?.RegionSelectionSelectedDidFinish(ids: self.mainModelView.selectedArray, subIds: self.mainModelView.selectedSubBodyPartIdArray, names: self.mainModelView.selectedNameArray, currentIndex: 3)
        
    }
    
    func SelectAll(isSelected: Bool, section: Int) {
        for data in self.mainModelView.filterArray[section].activity ?? [] {
            if let id = data.id?.intValue, let name = data.name {
                if isSelected {
                    self.mainModelView.selectedArray.append(id)
                    self.mainModelView.selectedNameArray.append(name)
                }
                else {
                    self.mainModelView.selectedArray.removeAll(where: {
                        $0 == id
                    })
                    self.mainModelView.selectedNameArray.removeAll(where: {
                        $0 == name
                    })
                }
            }
        }
        self.mainView.tableView.reloadData()
        self.mainModelView.delegate?.RegionSelectionSelectedDidFinish(ids: self.mainModelView.selectedArray, subIds: self.mainModelView.selectedSubBodyPartIdArray, names: self.mainModelView.selectedNameArray, currentIndex: 3)
    }
}


