//
//  FollowingViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

var IS_SHOW_EDIT_FOLLOWERS:Bool = false

class FollowingViewModel {

    //MARK:- Variables
    fileprivate weak var theController:FollowingVC!
    var profileDetails:MessageUserList?
    
    init(theController:FollowingVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.apiCallMessagesUserList()
        NotificationCenter.default.addObserver(self, selector: #selector(searchRecords(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.MESSAGE_SEARCH_NOTIFICATION.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(editRecords(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.EDIT_FOLLOWERS_NOTIFICATION.rawValue), object: nil)        
    }
    
    @objc func searchRecords(notification: Notification) {
        if let text = notification.userInfo?["data"] as? String {
            self.apiCallMessagesUserList(search: text, isLoading: false)
        }
    }
    
    @objc func editRecords(notification: Notification) {
        if IS_SHOW_EDIT_FOLLOWERS {
            if self.profileDetails != nil {
                for (index, _) in (self.profileDetails?.list?.enumerated())! {
                    self.profileDetails?.list![index].isSelected = false
                }
            }
            
            let view = (self.theController.view as? FollowingView)
            view?.tableView.reloadData()
        }
        else {
            if self.profileDetails != nil {
                var userIds: [String] = []
                for (index, _) in (self.profileDetails?.list?.enumerated())! {
                    if self.profileDetails?.list![index].isSelected == true {
                        userIds.append((self.profileDetails?.list![index].id?.stringValue)!)
                    }
                }
                if userIds.count == 0 {
                    let view = (self.theController.view as? FollowingView)
                    view?.tableView.reloadData()
                    return
                }
                self.apiCallFollowUnfollowUser(userIds: userIds, isFollow: false, isLoading: false)
            }
        }
    }
    
    func apiCallMessagesUserList(search:String = "", isLoading:Bool = true) {
        let param = ["is_except_current_user": true, "search": search, "list": ["id", "name", "photo"]] as [String : Any]
        print(param)
        
        ApiManager.shared.MakePostAPI(name: MESSAGES_USER_LIST , params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.profileDetails = MessageUserList(JSON: data.dictionaryObject!)
                    let view = (self.theController.view as? FollowingView)
                    view?.tableView.reloadData()
                }
                else {
                    self.profileDetails = nil
                    let view = (self.theController.view as? FollowingView)
                    view?.tableView.reloadData()
                }
            }
        })
    }
    
    func apiCallFollowUnfollowUser(userIds:[String], isFollow:Bool,isLoading:Bool = true) {
        let param = ["is_follow":isFollow, "user_ids":userIds] as [String : Any]
        print(param)
        
        ApiManager.shared.MakePostAPI(name: FOLLOW_UNFOLLOW_USER, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    self.apiCallMessagesUserList(search: "", isLoading: false)
                }
                else {
                    
                }
            }
        })
    }
}
