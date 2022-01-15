//
//  LibraryViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class LibraryViewModel {

    //MARK:- Variables
    fileprivate weak var theController:LibraryVC!
    var items = NSArray()
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()

    init(theController:LibraryVC) {
        self.theController = theController
    }
}
