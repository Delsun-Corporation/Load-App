//
//  OtherUserProfileDetailsView.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ProfileViewDelegate: class {
    func ProfileViewDidFinish(height: CGFloat)
}

class OtherUserProfileDetailsView: UIView {

    @IBOutlet weak var tableView: UITableView!
    weak var delegate:ProfileViewDelegate?
    
    func setupUI(theController: OtherUserProfileDetailsVC) {
        self.layoutIfNeeded()
        self.tableView.register(UINib(nibName: "IntroductionCell", bundle: nil), forCellReuseIdentifier: "IntroductionCell")
        self.tableView.register(UINib(nibName: "ProfileDescriptionCell", bundle: nil), forCellReuseIdentifier: "ProfileDescriptionCell")
        self.tableView.register(UINib(nibName: "ProfileUserListCell", bundle: nil), forCellReuseIdentifier: "ProfileUserListCell")

        self.tableView.delegate = theController
        self.tableView.dataSource = theController
        
        //In mainProfile controller add bottom button so need to add space from bottom 70
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
    }
}
