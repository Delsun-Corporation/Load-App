//
//  ProfessionalActivityViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfessionalActivityViewModel {

    //MARK:- Variables
    fileprivate weak var theController:ProfessionalActivityVC!
    var filterArray:[FilterActivityModelClass] = [FilterActivityModelClass]()
    var selectedArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    weak var delegate:FilterActivitySelectedDelegate?
    
    //MARK:- Functions
    init(theController:ProfessionalActivityVC) {
        self.theController = theController
    }
}
