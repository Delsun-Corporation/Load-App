//
//  CreateResistanceTrainingProgramView.swift
//  Load
//
//  Created by Haresh Bhai on 24/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateResistanceTrainingProgramView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:CreateResistanceTrainingProgramVC) {
        self.tableView.register(UINib(nibName: "CreateResistanceTrainingProgramHeaderCell", bundle: nil), forCellReuseIdentifier: "CreateResistanceTrainingProgramHeaderCell")
        self.tableView.register(UINib(nibName: "CreateResistanceTrainingProgramTextFieldCell", bundle: nil), forCellReuseIdentifier: "CreateResistanceTrainingProgramTextFieldCell")
        self.tableView.register(UINib(nibName: "SelectDayHeaderCell", bundle: nil), forCellReuseIdentifier: "SelectDayHeaderCell")
        self.tableView.register(UINib(nibName: "CreateResistanceTrainingProgramDayCell", bundle: nil), forCellReuseIdentifier: "CreateResistanceTrainingProgramDayCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
    }
}
