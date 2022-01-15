//
//  NewMessageSelectViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 29/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol NewMessageSelectDelegate: class {
    func NewMessageSelectDidFinish(name: String, id: String)
}

class NewMessageSelectViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:NewMessageSelectVC!
    weak var delegate:NewMessageSelectDelegate?
    var profileDetails:MessageUserList?

    init(theController:NewMessageSelectVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.apiCallMessagesUserList(page: "1", isLoading: true)
    }
    
    func apiCallMessagesUserList(page:String = "", isLoading:Bool = true) {
        let param = ["is_current_user": false, "is_except_current_user": true, "page": page, "limit": "10", "list": ["id", "name", "photo"]] as [String : Any]
        print(param)
        
        ApiManager.shared.MakePostAPI(name: USER_LIST , params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.profileDetails = MessageUserList(JSON: data.dictionaryObject!)
                    let view = (self.theController.view as? NewMessageSelectView)
                    view?.tableView.reloadData()
                }
                else {
                    self.profileDetails = nil
                    let view = (self.theController.view as? NewMessageSelectView)
                    view?.tableView.reloadData()
                }
            }
        })
    }
}
