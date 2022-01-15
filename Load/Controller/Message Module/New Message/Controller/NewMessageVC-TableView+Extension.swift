//
//  NewMessageVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 27/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension NewMessageVC :UITableViewDataSource, UITableViewDelegate {

    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.profileDetails?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowingCell") as! FollowingCell
        cell.selectionStyle = .none
        let model = self.mainModelView.profileDetails?.list![indexPath.row]
        cell.setupUI(model: model!)
        cell.lblDate.isHidden = true
        cell.selectionStyle = .none
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.mainModelView.profileDetails?.list![indexPath.row]
        if !self.mainModelView.ids.contains(model!.id!.stringValue) {
            self.mainModelView.names.add(model!.name!)
            self.mainModelView.ids.add(model!.id!.stringValue)
        }
        self.mainView.txtName.reloadData()
        self.mainModelView.profileDetails = nil
        self.mainView.tableView.reloadData()
        self.mainView.tableView.isHidden = true
    }
}
