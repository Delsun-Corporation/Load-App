//
//  NotificationViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 10/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import KRPullLoader

class NotificationViewModel: KRPullLoadViewDelegate {

    //MARK:- Variables
    fileprivate weak var theController:NotificationVC!
    var notificationList:NotificationListModelClass?
    let refreshView = KRPullLoadView()
    let loadView = KRPullLoadView()
    
    init(theController:NotificationVC) {
        self.theController = theController
    }
    
    func setupUI() {
        refreshView.delegate = self
        loadView.delegate = self
        let view = (self.theController.view as? NotificationView)
        view?.tableView.addPullLoadableView(refreshView, type: .refresh)
        view?.tableView.addPullLoadableView(loadView, type: .loadMore)
        self.apiCallNotificationList(lastId: 0)
    }
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .refresh {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.apiCallNotificationList(lastId: 1, progress: false)
                    completionHandler()
                }
            default: break
            }
            return
        }
        
        if type == .loadMore {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    self.apiCallNotificationList(lastId: self.notificationList?.list?.last?.id?.intValue ?? 0, progress: false)
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
                completionHandler()
            }
        }
    }
    
    func apiCallNotificationList(lastId: Int, progress:Bool = true) {

        let param = [
            "last_id": lastId,
            "limit": 10
            ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: NOTIFICATION_LIST, params: param as [String : Any], progress: progress, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    if lastId == 0 {
                        self.notificationList = NotificationListModelClass(JSON: data.dictionaryObject!)
                    }
                    else {
                        let model = NotificationListModelClass(JSON: data.dictionaryObject!)
                        for data in model?.list ?? [] {
                            self.notificationList?.list?.append(data)
                        }
                    }
                    let view = (self.theController.view as? NotificationView)
                    view?.tableView.reloadData()
                }
                else {
//                    let message = json.getString(key: .message)
//                    makeToast(strMessage: message)
                }
            }
        })
    }
    
    func apiCallNotificationRead(id: String) {
        
        let param = ["":""] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakeGetAPI(name: NOTIFICATION_READ + "/" + id, params: param as [String : Any], progress: false, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        })
    }
}
