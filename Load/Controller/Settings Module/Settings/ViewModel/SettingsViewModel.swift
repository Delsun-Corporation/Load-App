//
//  SettingsViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 22/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SettingsViewModel {

    //MARK:- Variables
    fileprivate weak var theController:SettingsVC!
    let titleArray: [String] = ["Name", "Account", "Load Centre", "Training", "Notifications", "Help and Support", "Privacy Policy", "Refer and Earn", "Contact us", "Log out"]

    //MARK:- Functions
    init(theController:SettingsVC) {
        self.theController = theController
    }
    
    func setupNavigationbar(title:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationController?.setColor()
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.btnback.isHidden = true
            vwnav.btnSave.isHidden = true
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: CGFloat(hightOfView), width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height)
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 16, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            
            vwnav.tag = 10222
//            vwnav.delegate = self
            self.theController.navigationController?.view.addSubview(vwnav)
            self.theController.navigationController?.setColor()

        }
    }

}
