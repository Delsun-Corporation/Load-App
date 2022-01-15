//
//  ProfessionalActivityViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EquipmentSelectionViewModel {

    //MARK:- Variables
    fileprivate weak var theController:EquipmentSelectionVC!
    var filterArray:[EquipmentsModelClass] = [EquipmentsModelClass]()
    var selectedArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    weak var delegate:EquipmenSelectedDelegate?
    
    //MARK:- Functions
    init(theController:EquipmentSelectionVC) {
        self.theController = theController
    }
}
