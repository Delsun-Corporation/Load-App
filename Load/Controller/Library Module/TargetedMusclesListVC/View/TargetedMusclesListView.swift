//
//  TargetedMusclesListView.swift
//  Load
//
//  Created by Christopher Kevin on 29/08/22.
//  Copyright © 2022 Haresh Bhai. All rights reserved.
//

import UIKit

class TargetedMusclesListView: UIView {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    
    func setupUI(theController: TargetedMusclesListVC) {
        tableView.register(UINib(nibName: "TargetedMusclesListCell", bundle: nil), forCellReuseIdentifier: "TargetedMusclesListCell")
        
        tableView.delegate = theController
        tableView.dataSource = theController
        tableView.separatorStyle = .singleLine
        
        editBtn.isHidden = true
    }
}
