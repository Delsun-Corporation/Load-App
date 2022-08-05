//
//  ProfessionalListViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ProfessionalListDelegate: class {
    func ProfessionalListFinish(id:Int, title:String, isScreenFor:PROFESSIONAL_LIST_TYPE)
}

class ProfessionalListViewModel {

    //MARK:- Variables
    fileprivate weak var theController:ProfessionalListVC!
    var selectedId:Int = 0
    var selectedTitle:String = ""
    var isScreenFor:PROFESSIONAL_LIST_TYPE = .TYPE
    weak var delegate:ProfessionalListDelegate?
    var navHeader = ""

    
    //MARK:- Functions
    init(theController:ProfessionalListVC) {
        self.theController = theController
    }
    
    func setupUI() {
        
    }
}

