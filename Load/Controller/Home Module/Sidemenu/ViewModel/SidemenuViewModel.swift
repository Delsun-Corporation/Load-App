//
//  SidemenuViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 02/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol SideMenuViewModelDelegate: AnyObject {
    func refreshData()
}

class SidemenuViewModel: SideMenuViewModelDelegate {

    //MARK:- Variables
    fileprivate weak var theController:SidemenuVC!
    let titleArray: [String] = ["Notifications", "Sessions", "Archivements", "Saved Workout", "Emergency", "Request"]

    //MARK:- Functions
    init(theController:SidemenuVC) {
        self.theController = theController
    }
    
    func refreshData() {
        theController.mainView.tableView.reloadData()
    }
}
