//
//  CompletedSession-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 12/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit


extension CompletedSessionVC :UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedSessionCell") as! CompletedSessionCell
        cell.selectionStyle = .none
        cell.setupUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
