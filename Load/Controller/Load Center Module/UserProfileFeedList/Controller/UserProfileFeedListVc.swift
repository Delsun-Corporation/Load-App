//
//  UserProfileFeedListVc.swift
//  Load
//
//  Created by Yash on 30/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class UserProfileFeedListVc: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: UserProfileFeedListView = { [unowned self] in
        return self.view as! UserProfileFeedListView
    }()
    
    lazy var mainModelView: UserProfileFeedListViewModel = {
        return UserProfileFeedListViewModel(theController: self)
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

extension UserProfileFeedListVc: MXViewControllerViewSource {
    func viewForMixToObserveContentOffsetChange() -> UIView {
        return self.mainView.tblFeedList
    }
}
