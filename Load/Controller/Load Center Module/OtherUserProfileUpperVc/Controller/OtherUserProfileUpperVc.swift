//
//  OtherUserProfileUpperVc.swift
//  Load
//
//  Created by Yash on 24/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit
import MXScroll

class OtherUserProfileUpperVc: UIViewController {

    //MARK:- Variable
    lazy var mainView: OtherUserProfileUpperView = { [unowned self] in
        return self.view as! OtherUserProfileUpperView
    }()
    
    lazy var mainModelView: OtherUserProfileUpperViewModel = {[weak self] in
        return OtherUserProfileUpperViewModel(theController: self)
    }()

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.setupFont()
        self.mainModelView.setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }
//        self.navigationController?.navigationBar.isTranslucent = false
        self.removeNavigationShadow()
    }

}

//MARK:- Button action
extension OtherUserProfileUpperVc {
    
    @IBAction func btnMessageClicked(_ sender: UIButton) {
        self.mainModelView.apiCallShowMessages()
    }
    
    @IBAction func btnFollowClicked(_ sender: UIButton) {
        self.mainModelView.isFollow = !self.mainModelView.isFollow
        let title = self.mainModelView.isFollow ? "Unfollow" : "Follow"
        mainView.btnFollow.setTitleColor(self.mainModelView.isFollow ? .appthemeBlackColor : .appthemeOffRedColor, for: .normal)
        sender.setTitle(str: title)
        if self.mainModelView.isFollow {
            //remove shadow
            self.mainView.vwFollowUnfollow.shadowColors = .clear
        } else {
            self.mainView.vwFollowUnfollow.setShadowToView()
        }
        self.mainModelView.apiCallFollowUnfollowUser(userId: self.mainModelView.profileDetails?.userId?.stringValue ?? "", isFollow: self.mainModelView.isFollow, isLoading: false)
    }
    
}


//MARK:- MXScrollview delegate

extension OtherUserProfileUpperVc: MXViewControllerViewSource {
    func headerViewForMixObserveContentOffsetChange() -> UIView? {
        return self.mainView.mainScrollView
    }
}
