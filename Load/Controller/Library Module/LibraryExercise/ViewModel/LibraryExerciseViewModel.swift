//
//  LibraryExerciseViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class LibraryExerciseViewModel {

    //MARK:- Variables
    fileprivate weak var theController:LibraryExerciseVC!
    var items = NSArray()
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    weak var delegate: AddExerciseDelegate?
    
    init(theController:LibraryExerciseVC) {
        self.theController = theController
    }    
}
