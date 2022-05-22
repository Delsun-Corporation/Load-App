//
//  ListingViewAllLoadCenterViewModel.swift
//  Load
//
//  Created by iMac on 20/05/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON
import AlamofireSwiftyJSON
import Alamofire

class ListingViewAllLoadCenterViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:ListingViewAllLoadCenterVc!

    init(theController:ListingViewAllLoadCenterVc) {
        self.theController = theController
    }
    
    var specializationID = 0
    var arrayProfessionalList = [ProfessionalList]()
    var selectedFromController = checkComeFromViewAll.fromLisitng
    
    //For Saved use
    var selectedViewAllForName = ""
    
    func setupUI(){
        
        if selectedFromController == .fromLisitng{
            self.apiCallDataListFromListing()
            self.theController.btnBookmark.isHidden = false
        }else{
            self.apiCallDataListFromSaved()
            self.theController.btnBookmark.isHidden = true
        }
        
    }
}

//MARK: - API calling

extension ListingViewAllLoadCenterViewModel{
    
     func apiCallDataListFromListing(isLoading:Bool = true) {
         guard let userId = getUserDetail()?.data?.user?.id?.intValue else {
             return
         }
         
         let param = [
            "specialization_id": self.specializationID,
               "relation": [
                   "user_detail"
               ],
            "expect_user_ids" : [userId],
               "user_detail_list" : [ "id", "name", "photo" ],
               "list": [
                   "id",
                   "user_id",
                   "profession",
                   "introduction",
                   "specialization_ids",
                   "rate"
               ]
            ] as [String : Any]
        
        print(param)
        
        ApiManager.shared.MakePostAPI(name: PROFESSIONAL_USER_LIST, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? ListingViewAllLoadCenterView)
                let success = json.getBool(key: .success)
                if success {
                    
                    self.arrayProfessionalList = []

                    let model = ProfessionUserListModel(JSON: json.dictionaryObject!)
                    self.arrayProfessionalList = model?.data ?? []
                    view?.tableView.reloadData()
                }
                else {
                    self.arrayProfessionalList = []
                    view?.tableView.reloadData()
                }
            }
        })
    }
    
    func apiCallAddAndRemoveFromBookmark(index:Int,professtionalID: String, status: Bool, isLoading:Bool = false) {
        
        let param = [
            "professional_id": professtionalID,
            "is_create" : status
            ] as [String : Any]
        
        print(param)
        
        ApiManager.shared.MakePostAPI(name: ADD_REMOVE_BOOKMARK, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? ListingViewAllLoadCenterView)
                let success = json.getBool(key: .success)
                
                if success {
                    
                    if self.selectedFromController == .fromLisitng{
                        self.arrayProfessionalList[index].isBookmarked = status
                    }else{
                        
                        if status == false{
                            self.arrayProfessionalList.remove(at: index)
                         
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_BOOKMARK_PAGE_REFRESH.rawValue), object: nil)

                        }
                    }
                }
                else {
                    
                }
                view?.tableView.reloadData()
            }
        })
    }
    

    func apiCallShowMessages(toID:String, isLoading:Bool = true) {
        let param = ["from_id": getUserDetail()?.data?.user?.id?.stringValue ?? "", "to_id":toID] as [String : Any]
        print(param)
        
        ApiManager.shared.MakePostAPI(name: GET_CONVERSATION_DETAIL_CUSTOM, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                //                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let model = ConversationData(JSON: data.dictionaryObject!)
                    let obj: ChatVC = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
                    obj.mainModelView.chatDetails = model
                    obj.mainModelView.conversationId = model?.id?.stringValue ?? ""
                    obj.hidesBottomBarWhenPushed = true
                    self.theController.navigationController?.pushViewController(obj, animated: true)
                }
                else {
                    
                }
            }
        })
    }
    
    func apiCallDataListFromSaved(isLoading:Bool = true) {
      
        let param = [
                "name": selectedViewAllForName,
                "relation": [
                    "event_detail",
                    "professional_detail.user_detail",
                    "professional_detail"
                ],
                "list": [
                    "id",
                    "event_id",
                    "professional_id"
                ],
                "event_detail_list": [
                    "id",
                    "title",
                    "event_name",
                    "event_image"
                ],
                "professional_detail_list": [
                    "id",
                    "user_id",
                    "profession",
                    "introduction",
                    "specialization_ids",
                    "rate"
                ],
                "professional_detail.user_detail_list": [
                    "id",
                    "name",
                    "photo"
                ]
            
            ] as [String : Any]
        
        print(param)
        
        ApiManager.shared.MakePostAPI(name: BOOKMARK_LIST_VIEW_ALL, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? ListingViewAllLoadCenterView)
                let success = json.getBool(key: .success)
                if success {
                    
                    let model = ProfessionUserListModel(JSON: json.dictionaryObject!)
                    self.arrayProfessionalList = model?.data ?? []
                    view?.tableView.reloadData()
                }
                else {
                    self.arrayProfessionalList = []
                    view?.tableView.reloadData()
                }
            }
        })
    }
    
}
