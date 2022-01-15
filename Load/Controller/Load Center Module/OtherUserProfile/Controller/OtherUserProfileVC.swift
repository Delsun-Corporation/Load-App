//
//  OtherUserProfileVC.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import MXScroll

class OtherUserProfileVC: UIViewController,UIScrollViewDelegate {
   
    @IBOutlet weak var contentView: UIView!
    
    //MARK:- Variables
    lazy var mainView: OtherUserProfileView = { [unowned self] in
        return self.view as! OtherUserProfileView
    }()
    
    lazy var mainModelView: OtherUserProfileViewModel = {
        return OtherUserProfileViewModel(theController: self)
    }()
    
    var userAccountType = OPPOSITE_USER_ACCOUNT_TYPE.free
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainModelView.setupUI()
//        self.mainView.scrollView.delegate = self
//        self.mainView.setupUI(theController: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }
        
        forSetNavigationbar()

//        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: UIColor.clear)
//        if DEVICE_TYPE.IS_IPHONE_X_MAX {
//            let navigationBarHeight: CGFloat = (self.navigationController?.navigationBar.frame.height)!
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "ic_background_profiles")?.resizeImage(targetSize: CGSize(width: UIScreen.main.bounds.width, height: 300), customHeight: navigationBarHeight + 10), for: .default)
//        }
//        else if DEVICE_TYPE.IS_IPHONE_6P {
//            let navigationBarHeight: CGFloat = (self.navigationController?.navigationBar.frame.height)!
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "ic_background_profiles")?.resizeImage(targetSize: CGSize(width: UIScreen.main.bounds.width, height: 300), customHeight: navigationBarHeight + 10), for: .default)
//        }
//        else {
//            self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "ic_background_profile"), for: .default)
//        }
//        self.navigationController?.navigationBar.isTranslucent = false
//        self.removeNavigationShadow()
    }
    
    func forSetNavigationbar(){
        let navigationBarHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 66
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Topheader")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)

        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    }
    
    //MARK:- @IBAction
    
    @IBAction func btnCheckAvailibilityClicked(_ sender: Any) {
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CheckAvailibityVC") as! CheckAvailibityVC
        obj.mainModelView.profileDetails = self.mainModelView.profileDetails 
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnBookmarkTapped(_ sender: UIButton){
        
        self.mainView.btnBookmark.isSelected = !self.mainView.btnBookmark.isSelected
        self.mainModelView.apiCallAddAndRemoveFromBookmark(professtionalID: String(Int(self.mainModelView.profileDetails?.id ?? 0)), status: self.mainView.btnBookmark.isSelected, isLoading: true)
    }
    
}

//MARK: - Setup of MXScroll

extension OtherUserProfileVC {
    
    func navigationToOtherUserProfileDetail() {
       
        var segment = MSSegmentControl()
        var mx = MXViewController<MSSegmentControl>()
        
        if self.userAccountType == .professional {
           
            //Upper header content
            let objUpperVc = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "OtherUserProfileUpperVc") as! OtherUserProfileUpperVc
            objUpperVc.mainModelView.profileDetails = self.mainModelView.profileDetails
            
            //Tab bar content
            let objProfile = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "OtherUserProfileDetailsVC") as! OtherUserProfileDetailsVC
            objProfile.mainModelView.profileDetails = self.mainModelView.profileDetails

            //
            let objReview = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "UserReviewVC") as! UserReviewVC
            segment = MSSegmentControl(sectionTitles: ["Profile", "(10) Review"])
            setupSegment(segmentView: segment)
            
            mx = MXViewController<MSSegmentControl>.init(headerViewController: objUpperVc, segmentControllers: [objProfile, objReview], segmentView: segment)
        } else {
            
            segment = MSSegmentControl(sectionTitles: ["Profile", "Feeds", "Followers"])
            setupSegment(segmentView: segment)
            
            //Upper header content
            let objPremiumUpperVc = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "PremiumUserProfileUpperVc") as! PremiumUserProfileUpperVc
            objPremiumUpperVc.mainModelView.profileDetails = self.mainModelView.profileDetails
            
            //Tab bar content
            let objProfile = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "PremiumUserProfileDetailsVc") as! PremiumUserProfileDetailsVc
//            objProfile.mainModelView.profileDetails = self.mainModelView.profileDetails
            
            //
            let objFeeds = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "UserProfileFeedListVc") as! UserProfileFeedListVc
//            objFeeds.mainModelView.profileDetails = self.mainModelView.profileDetails

            //
            let objFollowers = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "UserProfileFollowListVc") as! UserProfileFollowListVc
//            objFollowers.mainModelView.profileDetails = self.mainModelView.profileDetails
            
            mx = MXViewController<MSSegmentControl>.init(headerViewController: objPremiumUpperVc, segmentControllers: [objProfile, objFeeds, objFollowers], segmentView: segment)

        }
        
        mx.headerViewOffsetHeight = 0
        mx.shouldScrollToBottomAtFirstTime = false
        mx.showsHorizontalScrollIndicator = false
        mx.showsVerticalScrollIndicator = false
        mx.segmentViewHeight = 45
        
        addChild(mx)
        contentView.addSubview(mx.view)
        mx.view.frame = contentView.bounds
        mx.didMove(toParent: self)

    }
    
    func setupSegment(segmentView: MSSegmentControl) {
        
        segmentView.borderType = .none
        segmentView.backgroundColor = UIColor(red: 244/255 , green: 244/255, blue: 244/255, alpha: 1.0)
        segmentView.selectionIndicatorColor = UIColor.appthemeOffRedColor
        segmentView.selectionIndicatorHeight = 2
        
        segmentView.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appthemeOffRedColor, NSAttributedString.Key.font: themeFont(size: 15, fontname: .ProximaNovaRegular)]
        segmentView.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.appthemeBlackColor, NSAttributedString.Key.font: themeFont(size: 15, fontname: .ProximaNovaRegular)]
        
        segmentView.segmentWidthStyle = .fixed
        segmentView.selectionStyle = .fullWidth
        segmentView.selectedSegmentIndex = 0
        segmentView.segmentStart = .left
        
    }

}
