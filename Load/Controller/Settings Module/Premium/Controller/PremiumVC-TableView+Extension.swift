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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PremiumCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "PremiumCell") as! PremiumCell
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        cell.delegate = self
        if self.mainModelView.languagesId != nil {
            cell.languagesId = self.mainModelView.languagesId
            cell.languages = self.mainModelView.languages
        }
        cell.setupUI(indexPath: indexPath, title: self.mainModelView.titleArray[indexPath.section])        
        return cell
    }
    
    func PremiumCellButton(section: Int, row: Int) {
        
        print("Title Name:\(self.mainModelView.titleArray[section][row])")
        
        if section == 0 {
            if row == 0 {
                self.mainModelView.btnAbountMeClicked(titleHeader: self.mainModelView.titleArray[section][row])
            }
            else if row == 1 {
                self.mainModelView.btnActivityClicked()
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
        if self.mainModelView.languagesId != Id {
            self.btnSave.isHidden = true
            resetNavigationBar()
            
//            resetNavigationBar(btnSaveShow: false)
            
//            if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
//                vwnav.btnSave.isHidden = false
//            }
        }
        self.mainModelView.languagesId = Id
        self.mainModelView.languages = text
    }
    
    func resetNavigationBar(){
        
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
            self.navigationController?.setWhiteColor()
            self.navigationController?.addShadow()
        }
    }
}


