//
//  CreateEventStepThreeViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 16/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreLocation

class CreateEventStepThreeViewModel {

    //MARK:- Variables
    fileprivate weak var theController:CreateEventStepThreeVC!

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
    var currencyId: Int = 0

    init(theController:CreateEventStepThreeVC) {
        self.theController = theController
    }
    
    let pickerView = UIPickerView()

    //MARK:- Functions
    func setupUI() {
        let view = (self.theController.view as? CreateEventStepThreeView)
        pickerView.delegate = theController
        pickerView.backgroundColor = UIColor.white
        view?.txtCurrency.inputView = pickerView
    }
    
    func validateDetails() {
        let view = (self.theController.view as? CreateEventStepThreeView)
        if view?.txtEventPrice.text?.toTrim() == "" || view?.txtEventPrice.text?.toTrim() == "0" {
            makeToast(strMessage: getCommonString(key: "Please_enter_price_key"))
        }
        else if view?.txtCurrency.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_currency_key"))
        }
        else {
            print(self.amenitiesArray)
            let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateEventStepFourVC") as! CreateEventStepFourVC
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
            obj.mainModelView.txtEventPrice = (view?.txtEventPrice.text?.toTrim())!
            obj.mainModelView.txtCurrency = (view?.txtCurrency.text?.toTrim())!
            obj.mainModelView.currencyId = self.currencyId
            obj.mainModelView.eventType = self.eventType
            obj.mainModelView.selectedPublicType = self.selectedPublicType
            obj.mainModelView.maxGuest = self.maxGuest
            self.theController.navigationController?.pushViewController(obj, animated: true)
        }
    }
}

