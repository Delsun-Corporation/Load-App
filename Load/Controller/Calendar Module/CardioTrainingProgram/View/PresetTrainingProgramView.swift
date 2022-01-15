//
//  PresetTrainingProgramView.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class PresetTrainingProgramView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:PresetTrainingProgramVC) {
        self.tableView.register(UINib(nibName: "PresetTrainingProgramCell", bundle: nil), forCellReuseIdentifier: "PresetTrainingProgramCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
    }
}
