//
//  NotificationVC.swift
//  Load
//
//  Created by Haresh Bhai on 10/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class NotificationVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: NotificationView = { [unowned self] in
        return self.view as! NotificationView
    }()
    
    lazy var mainModelView: NotificationViewModel = {
        return NotificationViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.setWhiteColor()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Notifications_key"), color:UIColor.black)
        IS_CHAT_SCREEN = true
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
