//
//  CheckAvailibityView.swift
//  Load
//
//  Created by Haresh Bhai on 23/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CheckAvailibityView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnSelectDate: UIButton!
    
    //MARK:- Functions
    func setupUI(theController: CheckAvailibityVC) {
        self.layoutIfNeeded()
        self.setupFont()
        self.tableView.register(UINib(nibName: "MainCalenderCell", bundle: nil), forCellReuseIdentifier: "MainCalenderCell")
        
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
        self.tableView.reloadData()
    }
    
    func setupFont() {
        self.btnSelectDate.titleLabel?.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.btnSelectDate.setColor(color: .appthemeWhiteColor)
    }
}
