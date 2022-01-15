//
//  RegionSelectionViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 26/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class TypesOfTrainingSelectionViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:TypesOfTrainingSelectionVC!
    var filterArray:[TrainingTypes] = [TrainingTypes]()
    var selectedArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    
    weak var delegate:TypesOfTrainingSelectedDelegate?
    
    init(theController:TypesOfTrainingSelectionVC) {
        self.theController = theController
    }
}
