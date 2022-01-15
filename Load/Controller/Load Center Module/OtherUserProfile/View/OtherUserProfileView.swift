//
//  OtherUserProfileView.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit
import FloatRatingView

class OtherUserProfileView: UIView, UIScrollViewDelegate {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainViewTop: NSLayoutConstraint!
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var rateViewProcuct: FloatRatingView!
    @IBOutlet weak var btnBookmark: UIButton!
    
    var theController:OtherUserProfileVC?
    
    //MARK:- Functions
    func setupUI(theController:OtherUserProfileVC) {
        self.setupFont()
        self.layoutIfNeeded()
        self.scrollView.layoutIfNeeded()
        self.scrollView.bounces = false
        self.theController = theController
        self.scrollView.delegate = theController
        var topPadding: CGFloat = 20
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = (window?.safeAreaInsets.top)!
        }
        self.mainViewTop.constant = -(topPadding + 44)
    }
    
    //MARK: - CarbonTab Delegates
    
//    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
//        switch index {
//        case 0:
//            let vc = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "OtherUserProfileDetailsVC") as! OtherUserProfileDetailsVC
//            vc.mainView.delegate = self
//            vc.mainModelView.profileDetails = self.theController?.mainModelView.profileDetails
//            return vc
//        case 1 :
//            let vc = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "UserReviewVC") as! UserReviewVC
//            vc.mainView.delegate = self
//            return vc
//        default:
//            return UIViewController()
//        }
//    }
    
    
    func setupFont() {
//        self.lblName.text = "Sport physiologist"
//        self.rateView.rating = 5
//        self.imgProfile.setCircle()
//
//        self.lblName.font = themeFont(size: 16, fontname: .ProximaNovaBold)
//        self.lblLanguage.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
//        self.lbllocation.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
//        self.lblDescription.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
//        self.btnMessage.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
//        self.btnFollow.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblPrice.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblReviewCount.font = themeFont(size: 10, fontname: .ProximaNovaBold)

//        self.lblName.setColor(color: .appthemeWhiteColor)
//        self.lblLanguage.setColor(color: .appthemeWhiteColor)
//        self.lbllocation.setColor(color: .appthemeWhiteColor)
//        self.lblDescription.setColor(color: .appthemeWhiteColor)
//
//        self.btnMessage.setColor(color: .appthemeRedColor)
//        self.btnFollow.setColor(color: .appthemeRedColor)
        self.lblPrice.setColor(color: .appthemeBlackColor)
        self.lblReviewCount.setColor(color: .appthemeBlackColor)

//        self.btnMessage.setTitle(str: getCommonString(key: "Message_key"))
        
    }
}
