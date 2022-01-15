//
//  PremiumUserProfileUpperView.swift
//  Load
//
//  Created by Yash on 29/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class PremiumUserProfileUpperView: UIView {

    //MARK:- Outlet
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgUserProfile: CustomImageView!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var imgUserOnlineOffline: CustomImageView!
    @IBOutlet weak var vwFollow: CustomView!
    @IBOutlet weak var btnFollow: UIButton!
    
    //MARK:- SetupUI
    func setupUI(){
        self.setupFont()
        
    }
    
    //MARK:- SetupFont
    func setupFont(){
        
        self.imgUserProfile.setCircle()
        self.lblActivity.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblLocation.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblLocation.setColor(color: .appthemeWhiteColor)
        self.lblActivity.setColor(color: .appthemeWhiteColor)
        self.btnFollow.setColor(color: .appthemeRedColor)
        self.btnFollow.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        vwFollow.setShadowToView()
        
    }
}
