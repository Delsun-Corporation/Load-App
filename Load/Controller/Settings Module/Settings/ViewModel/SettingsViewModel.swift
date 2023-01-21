//
//  SettingsViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 22/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SettingsViewModel {
    
    enum Menu: String {
        case name = "Name"
        case account = "Account"
        case loadCentre = "Load Centre"
        case training = "Training"
        case notifications = "Notifications"
        case helpAndSupport = "Help and Support"
        case privacyAndPolicy = "Privacy Policy"
        case referAndEarn = "Refer and Earn"
        case contactUs = "Contact Us"
        case changePassword = "Change Password"
        case logout = "Log out"
    }
    
    //MARK:- Variables
    weak var theController:SettingsVC!
    
    private (set) var titleArray: [Menu] = []
    
    lazy var isReferralProgramActivated = LoadRemoteConfig.startBooleanRemoteConfig("is_referral_feature_activated")
    
    //MARK:- Functions
    init(theController:SettingsVC) {
        self.theController = theController
        createTitleArray()
    }
    
    private func createTitleArray() {
        titleArray = [.name,
                      .account,
                      .loadCentre,
                      .training,
                      .notifications,
                      .helpAndSupport,
                      .privacyAndPolicy,
                      isReferralProgramActivated ? .referAndEarn : nil,
                      .contactUs,
                      .changePassword,
                      .logout].compactMap({ $0 })
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
