//
//  LoadCenterViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 19/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class LoadCenterViewModel {

    fileprivate weak var theController:LoadCenterVC!
    var items = NSArray()
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    init(theController:LoadCenterVC) {
        self.theController = theController
    }    
}
