//
//  ClientRequirementVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 14/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension ClientRequirementVC:UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- TableView Delegates    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ClientRequirementCell") as! ClientRequirementCell
        cell.selectionStyle = .none
        cell.lblTitle.text = self.mainModelView.headerArray[indexPath.row]
        cell.lblDescription.text = self.mainModelView.headerDataArray[indexPath.row]
        cell.setupUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

