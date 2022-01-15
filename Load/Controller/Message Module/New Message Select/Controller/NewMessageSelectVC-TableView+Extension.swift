//
//  NewMessageSelectVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 29/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension NewMessageSelectVC :UITableViewDataSource, UITableViewDelegate {
    
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
        self.mainModelView.delegate?.NewMessageSelectDidFinish(name: model?.name ?? "" , id: model?.id?.stringValue ?? "")
        self.navigationController?.popViewController(animated: true)
    }
}
