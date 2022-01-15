//
//  MessageMainVC.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class MessageMainVC: UIViewController, OpenMessagesDelegate, ChangeBadgeCarbonkitDelegate {
   
    //MARK:- Variables
    lazy var mainView: MessageMainView = { [unowned self] in
        return self.view as! MessageMainView
    }()
    
    lazy var mainModelView: MessageMainViewModel = {
        return MessageMainViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.setColor()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Message_key"))
        self.mainView.setupUI(theController: self)
    }
    
    @IBAction func btnAddMessageClicked(_ sender: Any) {
        let obj: NewMessageVC = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "NewMessageVC") as! NewMessageVC
        obj.mainModelView.delegate = self
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnEditClicked(_ sender: UIButton) {
        IS_SHOW_EDIT_FOLLOWERS = !IS_SHOW_EDIT_FOLLOWERS
        if IS_SHOW_EDIT_FOLLOWERS {
            sender.setTitle(str: "Delete")
            sender.frame = CGRect(x: -10, y: 0, width: 20, height: 30)
            sender.setImage(nil, for: .normal)
        }
        else {
            sender.setTitle(str: "")
            sender.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
            sender.setImage(UIImage(named: "ic_edit"), for: .normal)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.EDIT_FOLLOWERS_NOTIFICATION.rawValue), object: nil)
    }
    
    func OpenMessagesDidFinish() {
        self.mainModelView.carbonTabSwipeNavigation.setCurrentTabIndex(1, withAnimation: true)
    }
    
    func ChangeBadge(badgeValue: String) {
        self.mainModelView.showBadge(index: 1, badgeValue: badgeValue)
    }    
}
