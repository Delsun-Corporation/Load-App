//
//  SessionView.swift
//  Load
//
//  Created by Haresh Bhai on 12/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class SessionView: UIView, CarbonTabSwipeNavigationDelegate {

    //MARK:- @IBOutlet
    @IBOutlet weak var viewMain: UIView!
    
    var theController: SessionVC?
    
    //MARK:- Functions
    func setupUI(theController: SessionVC) {
        self.theController = theController
        self.setupUICarbonTab(theController: theController)
    }
    
    //MARK: - CarbonTab Delegates
    func setupUICarbonTab(theController:SessionVC) {
        theController.mainModelView.items = ["Upcomming", "Completed"]
        theController.mainModelView.carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: theController.mainModelView.items as [AnyObject], delegate: self)
        theController.mainModelView.carbonTabSwipeNavigation.insert(intoRootViewController: theController, andTargetView: self.viewMain)
        self.style(theController: theController)
    }
    
    func style(theController:SessionVC) {
        let vc = theController.mainModelView
        let width = UIScreen.main.bounds.width
        vc.carbonTabSwipeNavigation.toolbarHeight.constant = 45
        let tabWidth = (width / CGFloat(theController.mainModelView.items.count))
        
        let indicatorcolor: UIColor = UIColor.appthemeRedColor
        let color: UIColor = .appthemeWhiteColor
        
        vc.carbonTabSwipeNavigation.toolbar.isTranslucent = false
        vc.carbonTabSwipeNavigation.toolbar.barTintColor = color
        vc.carbonTabSwipeNavigation.setIndicatorColor(indicatorcolor)
        for (index, _) in theController.mainModelView.items.enumerated() {
            vc.carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: index)
        }
        
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowOffset = CGSize(width: 0, height: 2)
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowOpacity = 0.2
        vc.carbonTabSwipeNavigation.toolbar.layer.masksToBounds = false
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowRadius = 1
        vc.carbonTabSwipeNavigation.setNormalColor(UIColor.darkGray, font:themeFont(size: 15, fontname: .ProximaNovaRegular))
        vc.carbonTabSwipeNavigation.setSelectedColor(UIColor.appthemeRedColor, font: themeFont(size: 15, fontname: .ProximaNovaBold))
        vc.carbonTabSwipeNavigation.toolbar.shadowImage(forToolbarPosition: .bottom)
        vc.carbonTabSwipeNavigation.setCurrentTabIndex(0, withAnimation: true)
        vc.carbonTabSwipeNavigation.pagesScrollView?.decelerationRate = .normal
        //        vc.carbonTabSwipeNavigation.pagesScrollView?.isScrollEnabled = false
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            let vc = AppStoryboard.SideMenu.instance.instantiateViewController(withIdentifier: "UpcommingSessionVC") as! UpcommingSessionVC
            return vc
        case 1 :
            let vc = AppStoryboard.SideMenu.instance.instantiateViewController(withIdentifier: "CompletedSessionVC") as! CompletedSessionVC
            return vc
        default:
            return UIViewController()
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAt index: UInt) {
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }
}
