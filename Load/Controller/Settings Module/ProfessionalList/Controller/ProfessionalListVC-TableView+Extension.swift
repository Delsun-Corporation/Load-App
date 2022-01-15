//
//  ProfessionalListVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension ProfessionalListVC:UITableViewDataSource, UITableViewDelegate {
    //MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mainModelView.isScreenFor == .TYPE {
            return GetAllData?.data?.professionalTypes?.count ?? 0
        }
        else if self.mainModelView.isScreenFor == .CANCELLATION {
            return GetAllData?.data?.cancellationPolicy?.count ?? 0
        }
        else {
            return GetAllData?.data?.paymentOptions?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessionalListCell") as!ProfessionalListCell
        cell.tag = indexPath.row
        cell.selectionStyle = .none
        if self.mainModelView.isScreenFor == .TYPE {
            let model = GetAllData?.data?.professionalTypes![indexPath.row]
            cell.setupUIProfessionalTypes(model: model!, selectedId: self.mainModelView.selectedId)
        }
        else if self.mainModelView.isScreenFor == .CANCELLATION {
            let model = GetAllData?.data?.cancellationPolicy![indexPath.row]
            cell.setupUI(model: model!, selectedId: self.mainModelView.selectedId)
        }
        else {
            let model = GetAllData?.data?.paymentOptions![indexPath.row]
            cell.setupUIPaymentOptions(model: model!, selectedId: self.mainModelView.selectedId)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.mainModelView.isScreenFor == .TYPE {
            self.mainModelView.selectedId = (GetAllData?.data?.professionalTypes![indexPath.row].id?.intValue)!
            self.mainModelView.selectedTitle = (GetAllData?.data?.professionalTypes![indexPath.row].name)!
        }
        else if self.mainModelView.isScreenFor == .CANCELLATION {
            self.mainModelView.selectedId = (GetAllData?.data?.cancellationPolicy![indexPath.row].id?.intValue)!
            self.mainModelView.selectedTitle = (GetAllData?.data?.cancellationPolicy![indexPath.row].name)!
        }
        else {
            self.mainModelView.selectedId = (GetAllData?.data?.paymentOptions![indexPath.row].id?.intValue)!
            self.mainModelView.selectedTitle = (GetAllData?.data?.paymentOptions![indexPath.row].name)!
        }
        UIView.performWithoutAnimation {
            self.mainView.tableView.reloadData()
        }
    }
}
