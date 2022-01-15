//
//  ListingsViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListingsViewModel {

    //MARK:- Variables
    fileprivate weak var theController:ListingsVC!
    var listingArray: ListingModelClass?

    init(theController:ListingsVC) {
        self.theController = theController
    }
    
    func setupUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(searchRecords(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_CENTER_SEARCH_NOTIFICATION.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(filterRecords(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_CENTER_FILTER_NOTIFICATION.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(apiReferesh), name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_CENTER_REQUEST_LIST_UPDATE.rawValue), object: nil)
    }
    
    @objc func searchRecords(notification: Notification) {
        if let text = notification.userInfo?["data"] as? String {
            if SELECTED_LOADCENTER_TAB == 1 {
                self.apiCallLibraryList(status: LOAD_CENTER_TYPE.LISTING.rawValue, search: text, isLoading: false)
            }
        }
    }
    
    @objc func filterRecords(notification: Notification) {
        self.apiCallLibraryList(status: LOAD_CENTER_TYPE.LISTING.rawValue, search: "", isLoading: false)
    }
    
    @objc func apiReferesh(){
        self.apiCallLibraryList(status: LOAD_CENTER_TYPE.LISTING.rawValue,isLoading: false)
    }
    
    func apiCallLibraryList(status: String, search: String = "", isLoading: Bool = true) {
        
        var specialization_ids: [Int] = [Int]()
        var country_ids: String = ""
        var gender = ""
        var language_ids: String = ""
        
        if FILTER_MODEL != nil {
            specialization_ids = FILTER_MODEL?.Specialization ?? []
            country_ids = FILTER_MODEL?.Location ?? ""
            gender = FILTER_MODEL?.Gender ?? ""
            language_ids = FILTER_MODEL?.Language ?? ""
        }
        
        var param = [
            "status": status,
            "search": search,
            "search_from": ["introduction", "academic_and_certifications", "experience_and_achievements", "terms_of_service"],
            "relation": [
                "user_detail"
            ],
            "specialization_ids" : specialization_ids,
            "country_ids": [country_ids],
            "gender": gender,
            "language_ids": [language_ids],
            "user_detail_list": [
                "id",
                "name",
                "email",
                "photo",
                "country_id" ]
            ] as [String : Any]
        
        if search == "" {
            param.removeValue(forKey: "search")
            param.removeValue(forKey: "search_from")
        }
        
        if FILTER_MODEL == nil {
            param.removeValue(forKey: "specialization_ids")
            param.removeValue(forKey: "country_ids")
            param.removeValue(forKey: "gender")
            param.removeValue(forKey: "language_ids")
        }
        else {
            if specialization_ids.count == 0 {
                param.removeValue(forKey: "specialization_ids")
            }
            if country_ids == "" {
                param.removeValue(forKey: "country_ids")
            }
            if gender == "" {
                param.removeValue(forKey: "gender")
            }
            if language_ids == "" {
                param.removeValue(forKey: "language_ids")
            }
        }
        print(param)
        
        ApiManager.shared.MakePostAPI(name: LOAD_CENTER_LIST, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? ListingsView)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.listingArray = ListingModelClass(JSON: data.dictionaryObject!)
                    view?.tableView.delegate = self.theController
                    view?.tableView.dataSource = self.theController
                    view?.tableView.reloadData()
                }
                else {
                    self.listingArray = nil
                    view?.tableView.reloadData()
                }
            }
        })
    }
}
