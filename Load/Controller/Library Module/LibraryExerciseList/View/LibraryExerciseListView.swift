//
//  LibraryExerciseListView.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class LibraryExerciseListView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: LibraryExerciseListVC) {
        self.tableView.register(UINib(nibName: "LibraryExerciseListCell", bundle: nil), forCellReuseIdentifier: "LibraryExerciseListCell")   
    }
}
