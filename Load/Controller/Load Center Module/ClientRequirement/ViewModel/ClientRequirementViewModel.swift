//
//  ClientRequirementViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 14/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ClientRequirementViewModel {

    //MARK:- Variables
    fileprivate weak var theController:ClientRequirementVC!
    let headerArray: [String] = ["Age Requirements", "Form Requirements", "Terms of Service"]
    let headerDataArray: [String] = ["Client ages 13 and up can attend.\nClient ages 13 and below require a company of a guardian.", "Upon confirmation, client are required to complete:\nForm 1\nForm 2\nForm 3", "When you book, you agree to the Load App Additional Terms of Service, Booking Release and Waiver, and Cancellation Policy"]

    init(theController:ClientRequirementVC) {
        self.theController = theController
    }
    
    func setupUI() {
        
    }
}
