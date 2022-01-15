//
//  SessionViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 12/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class SessionViewModel {

    //MARK:- Variables
    fileprivate weak var theController:SessionVC!
    var items = NSArray()
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    init(theController:SessionVC) {
        self.theController = theController
    }
    
    func setupUI() {
        
    }

}
