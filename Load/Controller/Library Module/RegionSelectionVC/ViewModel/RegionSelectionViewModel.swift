//
//  RegionSelectionViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 26/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class RegionSelectionViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:RegionSelectionVC!
    var filterArray:[RegionSelectionModelClass] = [RegionSelectionModelClass]()
    var selectedArray:[Int] = [Int]()
    var selectedSubBodyPartIdArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    var selectedId:NSNumber?
    var isHeaderHide:Bool = false
    
    var selectedFrontArray: [Int] = [Int]()
    var selectedFrontSubBodyPartIdArray:[Int] = [Int]()
    var selectedFrontNameArray: [String] = [String]()
    
    var selectedBackArray: [Int] = [Int]()
    var selectedBackSubBodyPartIdArray:[Int] = [Int]()
    var selectedBackNameArray: [String] = [String]()
    var category: String = ""
    
    var sortedRegionSelectionModel = RegionSelectionModelClass()
    
    weak var delegate:RegionSelectionSelectedDelegate?
    
    init(theController:RegionSelectionVC) {
        self.theController = theController
    }
}
