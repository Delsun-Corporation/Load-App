//
//  BillingInformationVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension BillingInformationVC: UITableViewDelegate, UITableViewDataSource, BillingInformationDelegate {   
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.cardArray.count //+ 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mainModelView.cardArray.count == section {
            return 1
        }
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == self.mainModelView.cardArray.count {
            let cell: BillingInformationAddCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "BillingInformationAddCell") as! BillingInformationAddCell
            cell.selectionStyle = .none
            cell.delegate = self
            let color = self.mainModelView.isEmptyData() ? UIColor.appthemeGrayColor: UIColor.appthemeRedColor
            cell.btnAdd.setColor(color: color)
            cell.btnAdd.isUserInteractionEnabled = self.mainModelView.isEmptyData() ? false : true
            return cell
        }
        else {
            if indexPath.row == 0 || indexPath.row == 5 {
                let cell: BillingInformationHeaderCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "BillingInformationHeaderCell") as! BillingInformationHeaderCell
                cell.selectionStyle = .none
                cell.tag = indexPath.section
                cell.lblTitle.tag = indexPath.row
                cell.lblTitle.isHidden = false
                cell.setupUI(title: self.mainModelView.titleArray[indexPath.row])
                return cell
            }
            else if indexPath.row == 6 {
                let cell: BillingInformationTextCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "BillingInformationTextCell") as! BillingInformationTextCell
                cell.selectionStyle = .none
                cell.tag = indexPath.section
                cell.lblTitle.tag = indexPath.row
                cell.setupUI(title: self.mainModelView.titleArray[indexPath.row])
                return cell
            }
            else {
                let cell: BillingInformationCardCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "BillingInformationCardCell") as! BillingInformationCardCell
                cell.selectionStyle = .none
                if indexPath.row > 6 {
                    cell.lblRequired.isHidden = true
                }
                cell.delegate = self
                cell.tag = indexPath.section
                cell.txtValue.tag = indexPath.row
                cell.setupUI(title: self.mainModelView.titleArray[indexPath.row], text: self.mainModelView.cardArray[indexPath.section][indexPath.row], placeHolder: self.mainModelView.placeHolderArray[indexPath.row])
                return cell
            }
        }
    }
    
    func BillingInformationAddFinish() {
        self.mainModelView.cardArray.append(["" , "", "", "", "", "", "", "", "", "", "", ""])
        self.mainView.tableView.reloadData()
    }
    
    func BillingInformationTextFinish(text: String, row: Int, section: Int) {
        self.mainModelView.cardArray[section][row] = text
        print(self.mainModelView.cardArray)
        
        UIView.performWithoutAnimation {
            let content = self.mainView.tableView.contentOffset
            self.mainView.tableView.setContentOffset(content, animated: false)
        }

        if self.mainModelView.validateDetails() {
            self.mainView.btnSave.backgroundColor = UIColor.appthemeOffRedColor
            self.mainView.btnSave.isUserInteractionEnabled = true
        } else {
            
            self.mainView.btnSave.backgroundColor = UIColor.appthemeGrayColor
            self.mainView.btnSave.isUserInteractionEnabled = false
        }
        
    }
}
