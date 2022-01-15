//
//  MultiSelectionVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 14/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension MultiSelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MultiSelectionCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "MultiSelectionCell") as! MultiSelectionCell
        if self.mainModelView.data.count == indexPath.row + 1{
            cell.vwLine.isHidden = true
        }else{
            cell.vwLine.isHidden = false
        }
        cell.setupUI(index: indexPath, data: self.mainModelView.data[indexPath.row], theController: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mainModelView.data[indexPath.row].isSelected = !self.mainModelView.data[indexPath.row].isSelected
        self.mainView.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
