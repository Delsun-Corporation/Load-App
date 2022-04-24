//
//  UserReviewVC.swift
//  Load
//
//  Created by Haresh Bhai on 16/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class UserReviewVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: UserReviewView = { [unowned self] in
        return self.view as! UserReviewView
    }()
    
    lazy var mainModelView: UserReviewViewModel = {
        return UserReviewViewModel(theController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.mainView.setupUI(theController: self)
    }

}


extension UserReviewVC: MXViewControllerViewSource{
    func viewForMixToObserveContentOffsetChange() -> UIView {
        return self.mainView.tableView
    }
}
