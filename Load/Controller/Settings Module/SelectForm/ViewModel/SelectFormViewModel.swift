//
//  SelectFormViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol SelectFormDelegate: class {
    func SelectFormFinish(isAgree: Bool?, isAuto: Bool?)
}

class SelectFormViewModel {

    //MARK:- Variables
    fileprivate weak var theController:SelectFormVC!
    
    var isAgree: Bool?
    var isAuto: Bool?
    var isSetCompulsory: Bool?
    
    weak var delegate: SelectFormDelegate?
    
    //MARK:- Functions
    init(theController:SelectFormVC) {
        self.theController = theController
    }
    
    func setupUI() {

    }
}
