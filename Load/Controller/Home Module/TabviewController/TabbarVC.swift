//
//  TabbarVC.swift
//  Load
//
//  Created by Haresh Bhai on 29/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {
    
    lazy var isLoadCenterTabActivated = LoadRemoteConfig.startBooleanRemoteConfig("is_load_center_tab_activated")
    lazy var isMessageTabActivated = LoadRemoteConfig.startBooleanRemoteConfig("is_message_tab_activated")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: themeFont(size: 9, fontname: .Helvetica)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: themeFont(size: 9, fontname: .Helvetica)], for: .selected)
        
        if !isLoadCenterTabActivated {
            viewControllers?.remove(at: 3)
        }
        
        if !isMessageTabActivated {
            viewControllers?.remove(at: 2)
        }

    }
}
