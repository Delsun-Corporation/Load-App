//
//  FilterSpecializationViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventTypeSelectionViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:EventTypeSelectionVC!
    var typeArray:[EventTypesModel] = []
    var filterArray:[EventTypeModelClass] = []
    var selectedArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    weak var delegate:EventTypeSelectedDelegate?

    init(theController:EventTypeSelectionVC) {
        self.theController = theController
    }
}
