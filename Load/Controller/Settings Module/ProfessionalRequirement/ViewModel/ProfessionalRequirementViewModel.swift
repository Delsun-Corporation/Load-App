//
//  ProfessionalRequirementViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 02/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ProfessionalRequirementDelegate: class {
    func ProfessionalRequirementFinish(text:String, isScreen:Int)
}

class ProfessionalRequirementViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:ProfessionalRequirementVC!
    var placeholder:String = ""
    var navigationHeader = ""
    var isScreen:Int = 0 //0 : requirement, 1: profession, 2: Introduction // 3: About
    var text = ""

    weak var delegate: ProfessionalRequirementDelegate?
    
    //MARK:- Functions
    init(theController:ProfessionalRequirementVC) {
        self.theController = theController
    }
    
    func setupUI() {
    }
}
