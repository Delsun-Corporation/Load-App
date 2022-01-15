//
//  OtherUserProfileViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit
import SwiftyJSON

class OtherUserProfileViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:OtherUserProfileVC!
    var items = NSArray()
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var userId:String = ""
    var profileDetails: OtherUserDetailsModelClass?
    var isFollow:Bool = false
    
    init(theController:OtherUserProfileVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.apiCallProfessionalProfileShow(userId: self.userId, isLoading: true)
    }
    
    func apiCallProfessionalProfileShow(userId:String = "", isLoading:Bool = true) {
        let param = [:] as [String : Any]
        print(param)
        
        ApiManager.shared.MakeGetAPI(name: PROFESSIONAL_PROFILE_SHOW + "/" + userId, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.profileDetails = OtherUserDetailsModelClass(JSON: data.dictionaryObject!)
                    
                    self.showProfileDetails(model: self.profileDetails!)
                    
                    if self.profileDetails?.userDetail?.accountDetails?.code.lowercased() == "Free".lowercased() || self.profileDetails?.userDetail?.accountDetails?.code.lowercased() == "Premium".lowercased()  {
                        
                        self.theController.userAccountType = .free
                        
                    } else {
                        self.theController.userAccountType = .professional
                    }
                    self.theController.navigationToOtherUserProfileDetail()
                }
                else {
                    
                }
            }
        })
    }
    
    func apiCallShowMessages(isLoading:Bool = true) {
        let param = ["from_id": getUserDetail().data?.user?.id?.stringValue ?? "", "to_id":self.profileDetails?.userId?.stringValue ?? ""] as [String : Any]
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
    
    func showProfileDetails(model:OtherUserDetailsModelClass) {

        self.theController.setUpNavigationBarTitle(strTitle: (model.userDetail?.name)!, fontSize: 19, fontType: .HelveticaBold, isShadow: false)

        if let view = (self.theController.view as? OtherUserProfileView) {
            view.btnBookmark.isSelected = model.isBookmarked
        }
    }
    
    func apiCallAddAndRemoveFromBookmark(professtionalID: String, status: Bool, isLoading:Bool = true) {
      
        let param = [
                "professional_id": professtionalID,
                "is_create" : status
            ] as [String : Any]
        
        print(param)
        
        ApiManager.shared.MakePostAPI(name: ADD_REMOVE_BOOKMARK, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let view = (self.theController.view as? OtherUserProfileView)
                let success = json.getBool(key: .success)
                if success {
                    view?.btnBookmark.isSelected = status
                }
                else {
                    view?.btnBookmark.isSelected = !status
//                    view?.tableView.reloadData()
                }
            }
        })
    }

    
    func getLanguages(model: [LanguagesSpokenDetails]) -> String {
        var str:String = ""
        for data in model {
            str += (data.name! + ", ")
        }
        str = str.toTrim()
        return String(str.dropLast())
    }
}
