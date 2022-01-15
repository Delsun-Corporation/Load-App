//
//  OtherUserProfileUpperViewModel.swift
//  Load
//
//  Created by Yash on 24/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON

class OtherUserProfileUpperViewModel {
    //MARK:- Variable assign
    fileprivate weak var theController:OtherUserProfileUpperVc!
    
    init(theController:OtherUserProfileUpperVc?) {
        self.theController = theController
    }
    
    var profileDetails: OtherUserDetailsModelClass?
    var isFollow:Bool = false

    //MARK:- SetupUI
    func setupUI(){
        self.showProfileDetails(model: profileDetails!)
    }
    
    //MARK:- Profile details fill up
    
    func showProfileDetails(model:OtherUserDetailsModelClass) {

        let view = (self.theController.view as? OtherUserProfileUpperView)
        view?.imgProfile.sd_setImage(with: model.userDetail?.photo?.toURL(), completed: nil)
        view?.lblDescription.text = model.userDetail?.goal
        view?.lblLanguage.text = getLanguages(model: model.languagesSpokenDetails!)
        view?.lbllocation.text = model.userDetail?.countryDetail?.name
        
        self.isFollow = model.isFollowing ?? false
        let title = self.isFollow ? "Unfollow" : "Follow"
        
        if self.isFollow {
            //remove shadow
            view?.vwFollowUnfollow.shadowColors = .clear
        } else {
            view?.vwFollowUnfollow.setShadowToView()
        }
        
        view?.btnFollow.setTitleColor(self.isFollow ? .appthemeBlackColor : .appthemeOffRedColor, for: .normal)
        view?.btnFollow.setTitle(str: title)
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

//MARK:- API Calling

extension OtherUserProfileUpperViewModel {
    
    //Add and Remove follow

    func apiCallFollowUnfollowUser(userId:String, isFollow:Bool,isLoading:Bool = true) {
        let param = ["is_follow":isFollow, "user_id":userId] as [String : Any]
        print(param)
        
        ApiManager.shared.MakePostAPI(name: FOLLOW_UNFOLLOW_USER, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
     
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
    
}
