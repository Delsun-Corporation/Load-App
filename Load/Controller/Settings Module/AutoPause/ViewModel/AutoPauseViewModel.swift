//
//  AutoPauseViewModel.swift
//  Load
//
//  Created by iMac on 25/08/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

class AutoPauseViewModel{
    
    //MARK: - Variable
    fileprivate weak var theController:AutoPauseVc!
    
    init(theController:AutoPauseVc) {
        self.theController = theController
    }

    var isRunAutoPause = false
    var isCycleAutoPause = false

}
