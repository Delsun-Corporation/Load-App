//
//  TimeUnderTensionInfoViewModel.swift
//  Load
//
//  Created by Yash on 15/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation

class TimeUnderTensionInfoViewModel {
    
    //MARK:- Variables

    fileprivate weak var theController:TimeUnderTensionInfoVC!

    var arrayTimeUnderTensionList = [TimeUnderTensionList]()

    //MARK:- Functions
    init(theController:TimeUnderTensionInfoVC) {
        self.theController = theController
    }
}
