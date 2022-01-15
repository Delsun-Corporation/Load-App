//
//  OtherUserProfileUpperView.swift
//  Load
//
//  Created by Yash on 24/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView

class OtherUserProfileUpperView: UIView {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lbllocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnMessage: UIButton!
    @IBOutlet weak var rateView: FloatRatingView!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var vwMessage: CustomView!
    @IBOutlet weak var vwFollowUnfollow: CustomView!
    
    
    
    func setupFont(){
        
        self.lblName.text = "Sport physiologist"
        self.rateView.rating = 5
        self.imgProfile.setCircle()
        
        self.lblName.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblLanguage.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lbllocation.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblDescription.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.btnMessage.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.btnFollow.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblName.setColor(color: .appthemeWhiteColor)
        self.lblLanguage.setColor(color: .appthemeWhiteColor)
        self.lbllocation.setColor(color: .appthemeWhiteColor)
        self.lblDescription.setColor(color: .appthemeWhiteColor)
        self.btnMessage.setColor(color: .appthemeRedColor)
        self.btnFollow.setColor(color: .appthemeRedColor)
        self.btnMessage.setTitle(str: getCommonString(key: "Message_key"))

        
        [self.vwFollowUnfollow,self.vwMessage].forEach { (vw) in
            vw?.setShadowToView()
        }
    }
    
    
}
