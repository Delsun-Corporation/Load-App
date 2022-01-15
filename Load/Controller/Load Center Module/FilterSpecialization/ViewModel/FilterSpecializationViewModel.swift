//
//  FilterSpecializationViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FilterSpecializationViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:FilterSpecializationVC!
    var filterArray:[FilterSpecializationsModelClass] = [FilterSpecializationsModelClass]()
    var selectedArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    var isHideheader:Bool = false
    weak var delegate:FilterSpecializationSelectedDelegate?

    init(theController:FilterSpecializationVC) {
        self.theController = theController
    }
}
