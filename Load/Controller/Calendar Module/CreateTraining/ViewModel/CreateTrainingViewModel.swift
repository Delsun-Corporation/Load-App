//
//  CreateTrainingViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 03/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol dismissCreateTrainingDelegate {
    func dismissCreateTraining()
}

class CreateTrainingViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:CreateTrainingVC!
    
    var isAutoOpen:Bool = false
    var selectedDateFromCalendar: String = ""
    
    var delegateCreateTraining: dismissCreateTrainingDelegate?
    
    //MARK:- Functions
    init(theController:CreateTrainingVC) {
        self.theController = theController
    }
    
    func setupUI() {
        if self.isAutoOpen {
            self.openTrainingLog()
        }
    }
    
    func openTrainingLog() {
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateTrainingLogVC") as! CreateTrainingLogVC
        self.theController.navigationController?.pushViewController(obj, animated: false)
    }
}
