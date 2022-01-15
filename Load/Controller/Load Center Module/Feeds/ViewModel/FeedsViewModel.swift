//
//  FeedsViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import KRPullLoader

class FeedsViewModel: KRPullLoadViewDelegate {

    //MARK:- Variables
    fileprivate weak var theController:FeedsVC!
    var feedDetails: TrainingLogFeedModelClass?
    var feedSearchDetails: LoadCenterFeedSearchList?
    let refreshView = KRPullLoadView()

    //MARK:- Functions
    init(theController:FeedsVC) {
        self.theController = theController
    }
    
    func setupUI() {
        refreshView.delegate = self
        let view = (self.theController.view as? FeedsView)
        view?.tableView.addPullLoadableView(refreshView, type: .refresh)
        self.apiCallTrainingLogList(status: LOAD_CENTER_TYPE.FEED.rawValue)
        NotificationCenter.default.addObserver(self, selector: #selector(searchRecords(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_CENTER_SEARCH_NOTIFICATION.rawValue), object: nil)
        
    }
    
    @objc func searchRecords(notification: Notification) {
        if let text = notification.userInfo?["data"] as? String {
            if SELECTED_LOADCENTER_TAB == 0 {
                let view = (self.theController.view as? FeedsView)
                view?.showFeeds(isShow: text == "")
                self.apiCallLoadCenterFeedSearchList(search: text, isLoading: false)
            }
        }
    }
    
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .refresh {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.apiCallTrainingLogList(status: LOAD_CENTER_TYPE.FEED.rawValue, isLoading: false)
                    completionHandler()
                }
            default: break
            }
            return
        }
        
        
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case .pulling(_, _):
            break
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = ""
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                //                self.getNotifications(page: 1, progress: false)
                completionHandler()
            }
        }
    }
    
    func apiCallTrainingLogList(status: String, isLoading:Bool = true) {
        let param = [
            "status": status,
            "is_complete": true,
            "user_detail_list" : [ "id" , "name", "photo"],
            "relation": [ "user_detail", "training_goal", "training_activity", "liked_detail"],
            "liked_detail_list" : ["feed_id", "user_ids"],
            "training_goal_list": [ "id" , "name"]
            ] as [String : Any]
        
        ApiManager.shared.MakePostAPI(name: LOAD_CENTER_LIST, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? FeedsView)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.feedDetails = TrainingLogFeedModelClass(JSON: data.dictionaryObject!)
                    view?.tableView.delegate = self.theController
                    view?.tableView.dataSource = self.theController
                    view?.tableView.reloadData()
                }
                else {
                    self.feedDetails = nil
                    view?.tableView.reloadData()
                }
            }
        }
    }
    
    func apiCallLoadCenterFeedSearchList(search:String = "", isLoading:Bool = true) {
        let param = [
            "search": search,
            "list": ["id","name","photo","country_id"],
            "relation": ["profile_detail","country_detail"],
            "profile_detail_list": ["id","user_id","rate"],
            "training_goal_list": ["id","name"],
            "country_detail_list": ["id", "name" ]
            ] as [String : Any]
        
        ApiManager.shared.MakePostAPI(name: LOAD_CENTER_FEED_SEARCH_LIST, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? FeedsView)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.feedSearchDetails = LoadCenterFeedSearchList(JSON: data.dictionaryObject!)
                    view?.tableViewSearch.delegate = self.theController
                    view?.tableViewSearch.dataSource = self.theController
                    view?.tableViewSearch.reloadData()
                }
                else {
                    self.feedSearchDetails = nil
                    view?.tableViewSearch.delegate = self.theController
                    view?.tableViewSearch.dataSource = self.theController
                    view?.tableViewSearch.reloadData()
                }
            }
        }
    }
    
    func apiCallFeedLike(feedId: Int) {
        let param = [
            "feed_id": feedId
            ] as [String : Any]
        
        ApiManager.shared.MakePostAPI(name: FEED_LIKE, params: param as [String : Any], progress: false, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
            }
        }
    }
}
