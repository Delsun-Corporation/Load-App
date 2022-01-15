//
//  FilterSpecializationVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension FilterSpecializationVC: UITableViewDelegate, UITableViewDataSource, FilterSpecializationSelectDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.filterArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.mainModelView.isHideheader ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return self.mainModelView.isHideheader ? 0 : 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = FilterSpecializationHeaderView.instanceFromNib() as! FilterSpecializationHeaderView
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
        return self.mainModelView.isHideheader ? 58 : 45 //UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.mainModelView.isHideheader ? 58 : 45 //UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.mainModelView.filterArray[section].specializations?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterSpecializationCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "FilterSpecializationCell") as! FilterSpecializationCell
        cell.selectionStyle = .none
        cell.tag = indexPath.section
        cell.index = indexPath.row
        cell.delegate = self
        cell.viewBottom.isHidden = self.mainModelView.isHideheader ? false : true
        cell.lblTitle.text = self.mainModelView.filterArray[indexPath.section].specializations![indexPath.row].name
        let id = self.mainModelView.filterArray[indexPath.section].specializations![indexPath.row].id?.intValue
        if self.mainModelView.selectedArray.contains((id)!) {
            cell.showDefaults(isShow: true)
        }
        else {
            cell.showDefaults(isShow: false)
        }
        return cell
    }
    
    func FilterSpecializationSelectDidFinish(section: Int, index: Int) {
        let id = self.mainModelView.filterArray[section].specializations![index].id?.intValue
        let name = self.mainModelView.filterArray[section].specializations![index].name

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
    }
}


