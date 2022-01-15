//
//  OtherUserProfileDetailsVC.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import MXScroll

class OtherUserProfileDetailsVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: OtherUserProfileDetailsView = { [unowned self] in
        return self.view as! OtherUserProfileDetailsView
    }()
    
    lazy var mainModelView: OtherUserProfileDetailsViewModel = {
        return OtherUserProfileDetailsViewModel(theController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        if self.mainModelView.isLoaded == true {
//            self.mainView.delegate?.ProfileViewDidFinish(height: self.mainView.tableView.contentSize.height + 150)
//        }
    }
    
}

extension OtherUserProfileDetailsVC: MXViewControllerViewSource{
    func viewForMixToObserveContentOffsetChange() -> UIView {
        return self.mainView.tableView
    }
}
