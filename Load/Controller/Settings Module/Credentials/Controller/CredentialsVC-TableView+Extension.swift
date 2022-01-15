//
//  AcademicCredentialsVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol CredentialsArrayDelegate: class {
    func CredentialsArrayFinish(array:NSMutableArray)
}

extension CredentialsVC: UITableViewDelegate, UITableViewDataSource, CredentialsDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.textArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.mainModelView.textArray.count == section {
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = CredentialsFooterView.instanceFromNib() as? CredentialsFooterView
        view?.setupUI()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mainModelView.textArray.count == section {
            return 1
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.mainModelView.textArray.count == indexPath.section {
            let cell: CredentialsAddCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "CredentialsAddCell") as! CredentialsAddCell
            cell.selectionStyle = .none
            cell.delegate = self
            let color = self.mainModelView.isEmptyData() ? UIColor.appthemeGrayColor: UIColor.appthemeRedColor
            cell.btnAdd.setColor(color: color)
            cell.btnAdd.isUserInteractionEnabled = self.mainModelView.isEmptyData() ? false : true
            return cell
        }
        else {
            let cell: CredentialsCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "CredentialsCell") as! CredentialsCell
            cell.selectionStyle = .none
            cell.txtValue.tag = indexPath.row
            cell.tag = indexPath.section
            cell.delegate = self
            cell.setupUI(title: self.mainModelView.titleArray[indexPath.row], text: self.mainModelView.textArray[indexPath.section][indexPath.row])
            return cell
        }
    }
    
    func CredentialsAddFinish() {
        var isEmpty:Bool = false
        for data in self.mainModelView.textArray {
            if data[0].toTrim() == "" {
                isEmpty = true
            }
            if data[1].toTrim() == "" {
                isEmpty = true
            }
        }
        if isEmpty {
            makeToast(strMessage: getCommonString(key: "Please_fill_all_details_key"))
        }
        else {
            self.mainModelView.textArray.append(["", ""])
            self.mainView.tableView.reloadData()
        }
    }
    
    func CredentialsTextFinish(text: String, row: Int, section: Int) {
        self.mainModelView.textArray[section][row] = text
        self.mainView.tableView.reloadSections([self.mainModelView.textArray.count], with: .none)
    }
    
    func CredentialsDeleteFinish(tag: Int) {
        if self.mainModelView.textArray.count == 1 {
            return
        }
        self.mainModelView.textArray.remove(at: tag)
        self.mainView.tableView.reloadData()
    }
}
