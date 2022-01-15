//
//  AutoTopUpVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension AutoTopUpVC: UITableViewDelegate, UITableViewDataSource, AutoTopUpDelegate, AutoTopUpTextDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 40
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AutoTopUpHeaderView.instanceFromNib() as! AutoTopUpHeaderView
        view.setupUI(title: self.mainModelView.headerArray[section])
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.mainModelView.titleArray[section].count
        } else {
         
            if !self.mainModelView.isAutoTopup {
                return 1
            }
            return self.mainModelView.titleArray[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = self.mainModelView.titleArray[indexPath.section][indexPath.row]
        let text = self.mainModelView.textArray[indexPath.section][indexPath.row]
        let placeHolde = self.mainModelView.placeHolderArray[indexPath.section][indexPath.row]
        
        if indexPath.section == 0 {
            
            let cell: AutoTopUpTextCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "AutoTopUpTextCell") as! AutoTopUpTextCell
            cell.delegate = self
            cell.selectionStyle = .none
            cell.tag = indexPath.section
            cell.txtValue.tag = indexPath.row
            cell.txtValue.isUserInteractionEnabled = false
            cell.lblDollar.isHidden = true
            cell.constrainWidthOfTxt.constant = CGFloat(DEVICE_TYPE.SCREEN_WIDTH - 150)
            cell.setupUI(indexPath: indexPath, title: title, text: text, placeHolder: placeHolde)
            return cell

        } else {
            if indexPath.row == 0 {
                let cell: AutoTopUpCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "AutoTopUpCell") as! AutoTopUpCell
                cell.delegate = self
                cell.selectionStyle = .none
                cell.tag = indexPath.section
                cell.btnSwitch.tag = indexPath.row
                cell.btnSwitch.isSelected = self.mainModelView.isAutoTopup
                cell.setupUI(indexPath: indexPath, title: title)
                return cell
            }
            else {
                let cell: AutoTopUpTextCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "AutoTopUpTextCell") as! AutoTopUpTextCell
                cell.delegate = self
                cell.selectionStyle = .none
                cell.tag = indexPath.section
                cell.txtValue.tag = indexPath.row
                cell.txtValue.isUserInteractionEnabled = true
                cell.lblDollar.isHidden = false
                cell.setupUI(indexPath: indexPath, title: title, text: text, placeHolder: placeHolde)
                return cell
            }
        }
    }
    
    func AutoTopUpFinish(isSelected: Bool) {
        self.mainModelView.isAutoTopup = isSelected
        self.mainView.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .automatic)
    }
    
    func AutoTopUpTextTextField(text: String, section: Int, row: Int) {
        
        if section == 1 {
            if row == 1{
                self.mainModelView.autoTopupAmount = text
                self.mainModelView.textArray[1][1] = text
            } else if row == 2{
                self.mainModelView.minimumBalance = text
                self.mainModelView.textArray[1][2] = text
            }
        }
    }
}
