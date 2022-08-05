//
//  ScheduleManagementViewModel.swift
//  Load
//
//  Created by Yash on 14/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ScheduleManagementDelegate: class {
    func ProfessionalAutoAcceptFinish(isSelected:Bool)
    func ProfessionalAdvanceBookingFinish(isSelected:Bool)
}


class ScheduleManagementViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:ScheduleManagmentVc!
    weak var delegate: ScheduleManagementPageDelegate?
    
    //MARK:- Functions
    init(theController:ScheduleManagmentVc) {
        self.theController = theController
    }
    
    var allowAdvanceBooking: Bool = false
    var timeInAdvanceId: Int?
    var isAutoAccept: Bool = false
    
}
