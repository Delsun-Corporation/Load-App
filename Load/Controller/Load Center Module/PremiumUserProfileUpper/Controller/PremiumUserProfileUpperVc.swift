//
//  PremiumUserProfileUpperVc.swift
//  Load
//
//  Created by Yash on 29/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class PremiumUserProfileUpperVc: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: PremiumUserProfileUpperView = { [unowned self] in
        return self.view as! PremiumUserProfileUpperView
    }()
    
    lazy var mainModelView: PremiumUserProfileUpperViewModel = {
        return PremiumUserProfileUpperViewModel(theController: self)
    }()

    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.setupUI()
        self.mainModelView.setupUI()

        // Do any additional setup after loading the view.
    }

}


//MARK:- Button action
extension PremiumUserProfileUpperVc {
    
    @IBAction func btnFollowClicked(_ sender: UIButton) {
        self.mainModelView.isFollow = !self.mainModelView.isFollow
        let title = self.mainModelView.isFollow ? "Unfollow" : "Follow"
        mainView.btnFollow.setTitleColor(self.mainModelView.isFollow ? .appthemeBlackColor : .appthemeOffRedColor, for: .normal)
        sender.setTitle(str: title)
        if self.mainModelView.isFollow {
            //remove shadow
            self.mainView.vwFollow.shadowColors = .clear
        } else {
            self.mainView.vwFollow.setShadowToView()
        }
        self.mainModelView.apiCallFollowUnfollowUser(userId: self.mainModelView.profileDetails?.userId?.stringValue ?? "", isFollow: self.mainModelView.isFollow, isLoading: false)
    }
    
}


//MARK:- MXScrollview delegate

extension PremiumUserProfileUpperVc: MXViewControllerViewSource {
    func headerViewForMixObserveContentOffsetChange() -> UIView? {
        return self.mainView.scrollView
    }
}
