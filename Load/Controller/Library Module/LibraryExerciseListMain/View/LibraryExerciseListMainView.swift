//
//  LibraryExerciseListMainView.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class LibraryExerciseListMainView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Functions
    func setupUI(theController: LibraryExerciseListMainVC) {
        self.tableView.register(UINib(nibName: "LibraryExerciseListMainCell", bundle: nil), forCellReuseIdentifier: "LibraryExerciseListMainCell")
        self.tableView.register(UINib(nibName: "LibraryFavoriteExerciseListMainCell", bundle: nil), forCellReuseIdentifier: "LibraryFavoriteExerciseListMainCell")
    }
}
