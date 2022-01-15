//
//  ProfessionalLoadCenterView.swift
//  Load
//
//  Created by Haresh Bhai on 31/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfessionalLoadCenterView: UIView {

    //MARK:-  @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: ProfessionalLoadCenterVC) {
        self.tableView.register(UINib(nibName: "ProfessionalLoadCenterCell", bundle: nil), forCellReuseIdentifier: "ProfessionalLoadCenterCell")
//        self.tableView.register(UINib(nibName: "ProfessionalLoadCenterAutoAcceptCell", bundle: nil), forCellReuseIdentifier: "ProfessionalLoadCenterAutoAcceptCell")
        
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
//        tableView.contentInset = UIEdgeInsets.zero

        var frame = CGRect.zero
        frame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: frame)
        tableView.tableFooterView = UIView(frame: frame)

    }
}
