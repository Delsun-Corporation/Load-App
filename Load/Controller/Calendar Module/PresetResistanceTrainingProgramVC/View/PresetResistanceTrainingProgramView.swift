//
//  PresetResistanceTrainingProgramView.swift
//  Load
//
//  Created by Haresh Bhai on 24/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class PresetResistanceTrainingProgramView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:PresetResistanceTrainingProgramVC) {
        self.tableView.register(UINib(nibName: "PresetResistanceTrainingProgramCell", bundle: nil), forCellReuseIdentifier: "PresetResistanceTrainingProgramCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
    }
}
