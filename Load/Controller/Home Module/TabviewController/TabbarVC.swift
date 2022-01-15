//
//  TabbarVC.swift
//  Load
//
//  Created by Haresh Bhai on 29/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class TabbarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: themeFont(size: 9, fontname: .Helvetica)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: themeFont(size: 9, fontname: .Helvetica)], for: .selected)

    }
}
