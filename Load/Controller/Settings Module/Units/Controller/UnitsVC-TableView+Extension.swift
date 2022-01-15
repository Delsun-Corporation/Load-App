//
//  UnitsVC-TableView+Extension.swift
//  Load
//
//  Created by iMac on 23/01/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

extension UnitsVC:UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mainModelView.profileDetails == nil {
            return 0
        }
        return self.mainModelView.profileDetails?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnitListCell") as! UnitListCell
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        let model = self.mainModelView.profileDetails?.data?[indexPath.row]
        cell.setupUI(model: model!, selectedId: self.mainModelView.selectedId)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mainModelView.selectedId = (GetAllData?.data?.professionalTypes![indexPath.row].id?.intValue)!
        self.mainModelView.selectedTitle = (GetAllData?.data?.professionalTypes![indexPath.row].name)!
        self.mainModelView.isUpdated = true
        UIView.performWithoutAnimation {
            self.mainView.tableView.reloadData()
        }
    }
}
