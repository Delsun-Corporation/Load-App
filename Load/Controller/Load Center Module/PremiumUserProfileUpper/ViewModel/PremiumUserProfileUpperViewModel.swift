//
//  PremiumUserProfileUpperViewModel.swift
//  Load
//
//  Created by Yash on 29/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON

class PremiumUserProfileUpperViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:PremiumUserProfileUpperVc!

    init(theController:PremiumUserProfileUpperVc) {
        self.theController = theController
    }
    
    var profileDetails: OtherUserDetailsModelClass?
    var isFollow:Bool = false


    //MARK:- setupUI
    func setupUI(){
        self.showProfileDetails(model: profileDetails!)
    }
    
    //MARK:- Profile details fill up
    
    func showProfileDetails(model:OtherUserDetailsModelClass) {

        let view = (self.theController.view as? PremiumUserProfileUpperView)
        view?.imgUserProfile.sd_setImage(with: model.userDetail?.photo?.toURL(), completed: nil)
        view?.lblLocation.text = model.userDetail?.countryDetail?.name
        
        self.isFollow = model.isFollowing ?? false
        let title = self.isFollow ? "Unfollow" : "Follow"
        
        if self.isFollow {
            //remove shadow
            view?.vwFollow.shadowColors = .clear
        } else {
            view?.vwFollow.setShadowToView()
        }
        
        view?.btnFollow.setTitleColor(self.isFollow ? .appthemeBlackColor : .appthemeOffRedColor, for: .normal)
        view?.btnFollow.setTitle(str: title)
    }

}


//MARK:- API Calling

extension PremiumUserProfileUpperViewModel {
    
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
}
