//
//  SelectFormVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension SelectFormVC: UITableViewDelegate, UITableViewDataSource, SelectFormCellDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: SelectFormAutoSendCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "SelectFormAutoSendCell") as! SelectFormAutoSendCell
            cell.selectionStyle = .none
            if let _isAuto = self.mainModelView.isAuto {
                cell.btnSwitch.isSelected = _isAuto
            }
            if let _isCompulatory = self.mainModelView.isSetCompulsory {
                cell.btnSwitchCompulsory.isSelected = _isCompulatory
            }
            cell.delegate = self
            cell.setupUI()
            return cell
        }
        else {
            let cell: SelectFormQuesionsCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "SelectFormQuesionsCell") as! SelectFormQuesionsCell
            cell.selectionStyle = .none
            if let _isAgree = self.mainModelView.isAgree {
                cell.changeButton(isTrue: _isAgree)
            }
            cell.delegate = self
            cell.setupUI()
            return cell
        }
    }
        
    func SelectFormQuesionsFinish(isAgree: Bool) {
        self.mainModelView.isAgree = isAgree
    }
    
    func SelectFormAutoSendFinish(isAuto: Bool) {
        self.mainModelView.isAuto = isAuto
    }
    
    func SelectFromSetAsCompulsory(isAuto: Bool) {
        self.mainModelView.isSetCompulsory = isAuto
    }
}
