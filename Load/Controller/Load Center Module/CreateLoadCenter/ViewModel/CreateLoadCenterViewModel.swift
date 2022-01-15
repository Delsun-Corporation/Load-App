//
//  CreateLoadCenterViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 22/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateLoadCenterViewModel {

    //MARK:- Variables
    fileprivate weak var theController:CreateLoadCenterVC!
    
    init(theController:CreateLoadCenterVC) {
        self.theController = theController
    }
    
    //MARK:- Functions
    func setupUI() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeScreen(notification:)), name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_CENTER_CLOSE_CREATE_SCREEN.rawValue), object: nil)
    }
    
    @objc func closeScreen(notification: Notification) {
        self.theController.dismiss(animated: false, completion: nil)
    }
}
