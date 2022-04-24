//
//  UserProfileFollowListVc.swift
//  Load
//
//  Created by Yash on 30/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class UserProfileFollowListVc: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: UserProfileFollowListView = { [unowned self] in
        return self.view as! UserProfileFollowListView
    }()
    
    lazy var mainModelView: UserProfileFollowListViewModel = {
        return UserProfileFollowListViewModel(theController: self)
    }()

    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.setupUI()
        self.mainModelView.setupUI()

        // Do any additional setup after loading the view.
    }

}

//MARK:- MXScrollview delegate

extension UserProfileFollowListVc: MXViewControllerViewSource {
    func viewForMixToObserveContentOffsetChange() -> UIView {
        return self.mainView.tblFollowList
    }
}
