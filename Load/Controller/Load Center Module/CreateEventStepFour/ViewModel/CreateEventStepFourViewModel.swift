//
//  CreateEventStepFourViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 16/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreLocation

class CreateEventStepFourViewModel {

    //MARK:- Variables
    fileprivate weak var theController:CreateEventStepFourVC!
    
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
    var eventPrice:Int = 10
    
    //Step Three
    var txtDescription: String = ""
    var amenitiesArray:[[Any]] = [[Any]]()
    
    var txtEventPrice: String = ""
    var txtCurrency: String = ""
    var currencyId: Int = 0

    var CancellationRulesId: Int = 0

    init(theController:CreateEventStepFourVC) {
        self.theController = theController
    }
    
    let pickerView = UIPickerView()
    
    //MARK:- Functions
    func setupUI() {
        let view = (self.theController.view as? CreateEventStepFourView)
        pickerView.delegate = theController
        pickerView.backgroundColor = UIColor.white
        view?.txtCancellationPolicy.inputView = pickerView
    }
    
    func validateDetails() {
        let view = (self.theController.view as? CreateEventStepFourView)
        if view?.txtCancellationPolicy.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_cancellation_policy_key"))
        }
        else if view?.txtGeneralRules.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_general_rules_key"))
        }
        else {
            print(self.amenitiesArray)
            let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateEventStepFiveVC") as! CreateEventStepFiveVC
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
            obj.mainModelView.amenitiesArray = self.amenitiesArray
            obj.mainModelView.txtEventPrice = self.txtEventPrice
            obj.mainModelView.txtCurrency = self.txtCurrency
            obj.mainModelView.currencyId = self.currencyId
            obj.mainModelView.GeneralRules = (view?.txtGeneralRules.text)!
            obj.mainModelView.CancellationRulesType = (view?.txtCancellationPolicy.text)!
            obj.mainModelView.CancellationRules = (view?.lblCancellationPolicySubTitle.text)!
            obj.mainModelView.CancellationRulesId = self.CancellationRulesId
            obj.mainModelView.eventType = self.eventType
            obj.mainModelView.selectedPublicType = self.selectedPublicType
            obj.mainModelView.maxGuest = self.maxGuest
            self.theController.navigationController?.pushViewController(obj, animated: true)
        }
    }
}
