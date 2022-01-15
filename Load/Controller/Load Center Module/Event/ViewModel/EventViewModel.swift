//
//  EventViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class EventViewModel {

    //MARK:- Variables
    fileprivate weak var theController:EventVC!
    var eventArray: EventModelClass?
    
    init(theController:EventVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.apiCallLibraryList(status: LOAD_CENTER_TYPE.EVENT.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(searchRecords(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_CENTER_SEARCH_NOTIFICATION.rawValue), object: nil)
    }
    
    @objc func searchRecords(notification: Notification) {
        if let text = notification.userInfo?["data"] as? String {
            if SELECTED_LOADCENTER_TAB == 2 {
                self.apiCallLibraryList(status: LOAD_CENTER_TYPE.EVENT.rawValue, search: text, isLoading: false)
            }
        }
    }
    
     func apiCallLibraryList(status: String, search:String = "", isLoading:Bool = true) {
      
        var param = [
            "status": status,
            "search": search,
            "search_from": ["title" ,"event_name", "event_price", "location", "description" ],
            "relation": [ "user_detail"],
            "user_detail_list": [ "id", "name", "email", "is_active", "account_id", "user_type"]
            ] as [String : Any]
        
        if search == "" {
            param.removeValue(forKey: "search")
            param.removeValue(forKey: "search_from")
        }
        print(param)
        
        ApiManager.shared.MakePostAPI(name: LOAD_CENTER_LIST, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? EventView)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.eventArray = EventModelClass(JSON: data.dictionaryObject!)
                    view?.tableView.reloadData()
                }
                else {
                    self.eventArray = nil
                    view?.tableView.reloadData()
                }
            }
        })
    }
    

    func apiCallAddAndRemoveFromBookmark(index: Int ,eventId: String, status: Bool, isLoading:Bool = true) {
      
        let param = [
                "event_id": eventId,
                "is_create" : status
            ] as [String : Any]
        
        print(param)
        
        ApiManager.shared.MakePostAPI(name: ADD_REMOVE_BOOKMARK, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? EventView)
                let success = json.getBool(key: .success)
                if success {
                    self.eventArray?.upcomingEvent?[index].isBookmarked = status
                    view?.tableView.reloadData()
                }
                else {
                    view?.tableView.reloadData()
                }
            }
        })
    }

}
