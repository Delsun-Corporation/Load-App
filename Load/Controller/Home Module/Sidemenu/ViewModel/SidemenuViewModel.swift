//
//  SidemenuViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 02/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SidemenuViewModel {

    //MARK:- Variables
    fileprivate weak var theController:SidemenuVC!
    let titleArray: [String] = ["Notifications", "Sessions", "Archivements", "Saved Workout", "Emergency", "Request"]

    //MARK:- Functions
    init(theController:SidemenuVC) {
        self.theController = theController
    }
}
