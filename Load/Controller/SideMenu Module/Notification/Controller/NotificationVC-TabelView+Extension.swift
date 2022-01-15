//
//  NotificationVC-TabelView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 10/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension NotificationVC :UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.notificationList == nil ? 0 : self.mainModelView.notificationList?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.selectionStyle = .none
        let model = self.mainModelView.notificationList?.list?[indexPath.row]
        cell.setupUI(model: model!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.mainModelView.notificationList?.list?[indexPath.row]
        self.mainModelView.apiCallNotificationRead(id: model?.id?.stringValue ?? "")
        model?.readAt = "read"
        self.mainModelView.notificationList?.list?[indexPath.row] = model!
        self.mainView.tableView.reloadRows(at: [indexPath], with: .none)
    }
}
