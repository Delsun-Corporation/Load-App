//
//  UserReviewView.swift
//  Load
//
//  Created by Haresh Bhai on 16/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class UserReviewView: UIView {

    @IBOutlet weak var tableView: UITableView!    
    weak var delegate:ProfileViewDelegate?
    
    func setupUI(theController: UserReviewVC) {
        self.tableView.layoutIfNeeded()
        self.tableView.register(UINib(nibName: "UserReviewCell", bundle: nil), forCellReuseIdentifier: "UserReviewCell")
        
        //In mainProfile controller add bottom button so need to add space from bottom 75
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
        self.tableView.reloadData {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.delegate?.ProfileViewDidFinish(height: self.tableView.contentSize.height)
            }
        }
    }
}
