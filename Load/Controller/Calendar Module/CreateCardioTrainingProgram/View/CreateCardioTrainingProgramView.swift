//
//  CreateCardioTrainingProgramView.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateCardioTrainingProgramView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:CreateCardioTrainingProgramVC) {
        self.layoutIfNeeded()
        self.tableView.register(UINib(nibName: "CreateCardioTrainingProgramHeaderCell", bundle: nil), forCellReuseIdentifier: "CreateCardioTrainingProgramHeaderCell")
        self.tableView.register(UINib(nibName: "CreateCardioTrainingProgramTextFieldCell", bundle: nil), forCellReuseIdentifier: "CreateCardioTrainingProgramTextFieldCell")
        self.tableView.register(UINib(nibName: "SelectDayHeaderCell", bundle: nil), forCellReuseIdentifier: "SelectDayHeaderCell")
        self.tableView.register(UINib(nibName: "CreateCardioTrainingProgramDayCell", bundle: nil), forCellReuseIdentifier: "CreateCardioTrainingProgramDayCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
    }
}
