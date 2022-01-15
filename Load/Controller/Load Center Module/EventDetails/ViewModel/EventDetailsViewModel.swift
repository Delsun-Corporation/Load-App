//
//  EventDetailsViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventDetailsViewModel {

    //MARK:- Variables
    fileprivate weak var theController:EventDetailsVC!
    let headerArray: [String] = ["", "", "Details", "Amenities", "Event Review", "Rules and policy", "Other event around the area"]
    var eventId:String = ""
    var eventDetails:EventDetailsModelClass?
    var isAmenitiesLoadMore:Bool = false
    
    init(theController:EventDetailsVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.apiCallLoadCenterEventShow()
    }
    
    func apiCallLoadCenterEventShow() {
        let param = ["": ""] as [String : Any]
        ApiManager.shared.MakeGetAPI(name: LOAD_CENTER_EVENT_SHOW + "/" + eventId, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.eventDetails = EventDetailsModelClass(JSON: data.dictionaryObject!)

                    if (self.eventDetails?.amenitiesAvailable?.count) ?? 0 <= 4 {
                        self.isAmenitiesLoadMore = true
                    }
                    let view = (self.theController.view as? EventDetailsView)
                    
                    let formattedString = NSMutableAttributedString()
                    formattedString
                        .bold("$\(self.eventDetails?.eventPrice?.stringValue ?? "") /", font: themeFont(size: 20, fontname: .ProximaNovaBold))
                        .normal12(" person", font: themeFont(size: 17, fontname: .ProximaNovaRegular))
                    view?.lblPrice.attributedText = formattedString
                    
//                    view?.lblPrice.text = "$\(self.eventDetails?.eventPrice?.stringValue ?? "") / person"
                    view?.tableView.delegate = self.theController
                    view?.tableView.dataSource = self.theController
                    view?.tableView.reloadData()
                    
                    view?.btnBookmark.isSelected = self.eventDetails?.isBookmarked ?? false
                    
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    func apiCallAddAndRemoveFromBookmark(eventId: String, status: Bool, isLoading:Bool = true) {
      
        let param = [
                "event_id": eventId,
                "is_create" : status
            ] as [String : Any]
        
        print(param)
        
        ApiManager.shared.MakePostAPI(name: ADD_REMOVE_BOOKMARK, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? EventDetailsView)
                let success = json.getBool(key: .success)
                if success {
                    view?.btnBookmark.isSelected = status
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_EVENT_PAGE_REFRESH.rawValue), object: nil)
                }
                else {
                    view?.btnBookmark.isSelected = !status
                }
            }
        })
    }
}
