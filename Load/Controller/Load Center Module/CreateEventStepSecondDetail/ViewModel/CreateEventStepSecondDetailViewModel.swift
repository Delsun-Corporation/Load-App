//
//  CreateEventStepSecondDetailViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 25/12/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class CreateEventStepSecondDetailViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:CreateEventStepSecondDetailVC!
    var txtDescription:String = ""
    
    //Step One
    var eventType:String = ""
    var selectedPublicType:Int?
    var maxGuest:String = ""
    
    //Step Two
    var txtEventName: String = ""
    var selectedDate:Date?
    var selectedTime:Date?
    var txtTimeArlier: String = ""
    var eventTime:Int = 0
    var selectedCoordinate : CLLocationCoordinate2D?
    var selectedAddress : String = ""
    
    init(theController:CreateEventStepSecondDetailVC) {
        self.theController = theController
    }
    
    func validateDetails() {
        if self.txtDescription == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_description_key"))
        }
        else {
            let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateEventStepSecondVC") as! CreateEventStepSecondVC
            obj.mainModelView.eventType = self.eventType
            obj.mainModelView.selectedPublicType = self.selectedPublicType
            obj.mainModelView.maxGuest = self.maxGuest
            obj.mainModelView.txtEventName = self.txtEventName
            obj.mainModelView.selectedDate = self.selectedDate
            obj.mainModelView.selectedTime = self.selectedTime
            obj.mainModelView.txtTimeArlier = self.txtTimeArlier
            obj.mainModelView.eventTime = self.eventTime
            obj.mainModelView.selectedCoordinate = self.selectedCoordinate
            obj.mainModelView.selectedAddress = self.selectedAddress
            obj.mainModelView.txtDescription = self.txtDescription
            obj.mainModelView.eventType = self.eventType
            obj.mainModelView.selectedPublicType = self.selectedPublicType
            obj.mainModelView.maxGuest = self.maxGuest
            self.theController.navigationController?.pushViewController(obj, animated: true)
        }
    }
}
