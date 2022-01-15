//
//  CreateEventFinishViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 28/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class CreateEventFinishViewModel {

    //MARK:- Variables
    fileprivate weak var theController:CreateEventFinishVC!
//    let headerArray: [String] = ["", "", "Details", "Amenities", "Event Review", "Rules and policy", "Other event around the area"]
    let headerArray: [String] = ["Preview", "", "Details", "Amenities", "Rules and policy"]

    var eventId:String = ""
    var isAmenitiesLoadMore:Bool = false   
    
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

    //Step Three
    var txtDescription: String = ""
    var amenitiesArray:[[Any]] = [[Any]]()
    
    //Step Four
    var GeneralRules: String = ""
    var CancellationRulesType: String = ""
    var CancellationRules: String = ""

    var txtEventPrice: String = ""
    var txtCurrency: String = ""
    var currencyId: Int = 0
    
    var CancellationRulesId: Int = 0
    var images: UIImage?
    
   
    
    init(theController:CreateEventFinishVC) {
        self.theController = theController
    }
    
    func saveDetails() {
        let date = selectedDate?.toString(dateFormat: "yyyy-MM-dd")
        let time = selectedTime?.toString(dateFormat: "HH:mm:ss")
        let finalDate = self.theController.stringTodate(Formatter: "yyyy-MM-dd HH:mm:ss", strDate: "\(date!) \(time!)")
        let visibleTo = self.selectedPublicType == 0 ? VISIBLE_TO.INVITATION_ONLY.rawValue : VISIBLE_TO.PUBLIC.rawValue
        
        self.apiCallLibraryList(status: LOAD_CENTER_TYPE.EVENT.rawValue, userId: (getUserDetail().data?.user?.id?.stringValue)!, title: self.eventType, visibleTo: visibleTo, eventName: self.txtEventName, eventPrice: self.txtEventPrice, dateTime: finalDate.iso8601, location: self.selectedAddress, duration: self.eventTime, maxGuests: self.maxGuest, earlierTime: self.txtTimeArlier, lat: String(self.selectedCoordinate!.latitude), long: String(self.selectedCoordinate!.longitude), amenitiesAvailable: self.amenitiesArray, description: self.txtDescription, currencyId: self.currencyId, cancellationPolicyId: self.CancellationRulesId, generalRules: self.GeneralRules)
    }
    
    func jsonToString(json: AnyObject) -> String? {
        do {
            print(json)
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString ?? "defaultvalue")
            return convertedString ?? nil
        } catch let myJSONError {
            print(myJSONError)
            return nil
        }
    }    
    
    func apiCallLibraryList(status: String, userId: String, title:String, visibleTo:String, eventName:String, eventPrice:String, dateTime:String, location:String, duration:Int, maxGuests:String, earlierTime:String, lat:String, long: String, amenitiesAvailable:[[Any]], description:String, currencyId:Int, cancellationPolicyId:Int, generalRules:String) {
//        let locationMap: NSDictionary = ["lat":lat, "long":long]
        let image = self.images
        let amenities = NSMutableArray()
        for data in amenitiesAvailable {
            let str: String = data[0] as! String
            let value = data[1] as! Bool
            let amenitiesData: NSDictionary = ["name":str, "data":value]
            amenities.add(amenitiesData)
        }
        print(amenities)
        let param = [
            "status": status,
            "user_id": userId,
            "event_type_ids": title,
            "visible_to": visibleTo,
            "event_name": eventName,
            "event_price": "\(eventPrice)",
            "date_time" : dateTime,
            "location": location,
            "latitude": lat,
            "longitude": long,
            "duration": "\(duration)",
            "max_guests": maxGuests,
            "earlier_time": earlierTime,
//            "location_map": jsonToString(json: locationMap as AnyObject)!,
            "amenities_available": jsonToString(json: amenities as AnyObject)!,
            "description": description,
            "currency_id": "\(currencyId)",
            "cancellation_policy_id": "\(cancellationPolicyId)",
            "general_rules": generalRules
            ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePostWithImageAPI(name: LOAD_CENTER_CREAT, params: param as [String : Any], images: [image!], imageName: "event_image", vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    self.theController.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_CLOSE_CREATE_SCREEN.rawValue), object: nil)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_EVENT_PAGE_REFRESH.rawValue), object: nil)
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        })
    }
}
