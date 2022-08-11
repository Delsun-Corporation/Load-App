//
//  PremiumVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 05/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension PremiumVC: UITableViewDelegate, UITableViewDataSource, PremiumCellDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.headerArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PremiumHeaderView.instanceFromNib() as! PremiumHeaderView
        view.setupUI(title: self.mainModelView.headerArray[section])
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.titleArray[section].count
    }
    
    func getActivitiesLabel() -> String {
        let label = mainModelView.selectedNameArray.joined(separator: ", ")
        return label
    }
    
    func getLanguageLabel() -> String {
        let label = mainModelView.languages.joined(separator: ", ")
        return label
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PremiumCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "PremiumCell") as! PremiumCell
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.delegate = self
        
        var cellValue: String? = nil
        switch indexPath {
        case IndexPath(row: 1, section: 0):
            cellValue = getActivitiesLabel()
        case IndexPath(row: 2, section: 0):
            cellValue = getLanguageLabel()
        default:
            break
        }
        
        cell.setupUI(
            indexPath: indexPath,
            title: self.mainModelView.titleArray[indexPath.section],
            value: cellValue
        )
        return cell
    }
    
    func PremiumCellButton(section: Int, row: Int) {
        
        if section == 0 {
            if row == 0 {
                self.mainModelView.btnAbountMeClicked(titleHeader: self.mainModelView.titleArray[section][row])
            }
            else if row == 1 {
                self.mainModelView.btnActivityClicked()
            }
            else if row == 2 {
                self.mainModelView.btnLanguageClicked(titleHeader: self.mainModelView.titleArray[section][row])
            }
            else if row == 3 {
                self.mainModelView.btnPermissionClicked(titleHeader: self.mainModelView.titleArray[section][row])
            }
        }
        else if section == 1 {
            if row == 0 {
                self.mainModelView.btnPremiumPaymentMethodClicked()
//                self.mainModelView.btnBillingInformationClicked()
            }
            else {
                self.mainModelView.btnAutoTopUpClicked()
            }
        }
    }
    
    func PremiumCellTextField(text:String, Id: Int, section: Int, row: Int) {
//        self.mainModelView.languagesId = Id
//        self.mainModelView.languages = text
    }
    
    func resetNavigationBar(){
        
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
            self.navigationController?.setWhiteColor()
            self.navigationController?.addShadow()
        }
    }
}

extension PremiumVC: MultiSelectionDelegate {
    func dismissPopupScreen() {
        //
    }
    
    func MultiSelectionDidFinish(selectedData: [MultiSelectionDataEntry]) {
        self.mainModelView.languagesId = selectedData.compactMap { Int($0.id) }
        self.mainModelView.languages = selectedData.compactMap { $0.title }
        mainView.tableView.reloadData()
    }

}
