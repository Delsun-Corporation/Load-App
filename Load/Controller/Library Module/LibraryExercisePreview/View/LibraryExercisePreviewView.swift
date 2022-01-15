//
//  LibraryExercisePreviewView.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class LibraryExercisePreviewView: UIView, CarbonTabSwipeNavigationDelegate {

    // MARK: @IBOutlet
    @IBOutlet weak var mainView: UIView!

    
    // MARK: Variables
    var libraryPreviewModel : LibraryListPreviewModelClass?
    var listComman: LibraryLogList?

    // MARK: Functions
    func setupUI(theController:LibraryExercisePreviewVC) {
        
    }
    
    // MARK: CarbonTab Delegates
    func setupUICarbonTab(theController:LibraryExercisePreviewVC) {
        
        theController.mainModelView.items = ["Details", "Records", "Progressions"]
        
        theController.mainModelView.carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: theController.mainModelView.items as [AnyObject], delegate: self)
        theController.mainModelView.carbonTabSwipeNavigation.insert(intoRootViewController: theController, andTargetView: self.mainView)
        self.style(theController: theController)
    }
    
    func style(theController:LibraryExercisePreviewVC) {
        let vc = theController.mainModelView
        let width = UIScreen.main.bounds.width
        vc.carbonTabSwipeNavigation.toolbarHeight.constant = 45
        let tabWidth = (width / CGFloat(vc.items.count))
        
        let indicatorcolor: UIColor = UIColor.appthemeRedColor
        let color: UIColor = .white
        
        vc.carbonTabSwipeNavigation.toolbar.isTranslucent = false
        vc.carbonTabSwipeNavigation.toolbar.barTintColor = color
        vc.carbonTabSwipeNavigation.setIndicatorColor(indicatorcolor)
        vc.carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: 0)
        vc.carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: 1)
        vc.carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: 2)
        
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowOffset = CGSize(width: 0, height: 2)
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowOpacity = 0.2
        vc.carbonTabSwipeNavigation.toolbar.layer.masksToBounds = false
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowRadius = 1
        vc.carbonTabSwipeNavigation.carbonTabSwipeScrollView.isScrollEnabled = false
        vc.carbonTabSwipeNavigation.setNormalColor(UIColor.appthemeBlackColor, font:themeFont(size: 15, fontname: .ProximaNovaRegular))
        vc.carbonTabSwipeNavigation.setSelectedColor(UIColor.appthemeRedColor, font: themeFont(size: 15, fontname: .ProximaNovaBold))
        vc.carbonTabSwipeNavigation.toolbar.shadowImage(forToolbarPosition: .bottom)
        vc.carbonTabSwipeNavigation.setCurrentTabIndex(0, withAnimation: true)
        vc.carbonTabSwipeNavigation.pagesScrollView?.decelerationRate = .normal
        vc.carbonTabSwipeNavigation.pagesScrollView?.isScrollEnabled = false
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            let vc = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExercisePreviewDetailsVC") as! LibraryExercisePreviewDetailsVC
            if self.libraryPreviewModel != nil {
                vc.mainModelView.libraryPreviewModel = self.libraryPreviewModel
            }
            else {
                //Default exercise
                vc.mainModelView.list = self.listComman
                vc.mainModelView.isDefaultExercise = true
//                vc.mainModelView.isLinkHide = true
            }
            return vc
        case 1 :
            let vc = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExercisePreviewRecordsVC") as! LibraryExercisePreviewRecordsVC
            if self.libraryPreviewModel != nil {
                vc.mainModelView.libraryPreviewModel = self.libraryPreviewModel
            }
            else {
                //default exercise
                vc.mainModelView.list = self.listComman
            }
            return vc
        case 2 :
            let vc = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExercisePreviewProgressionsVC") as! LibraryExercisePreviewProgressionsVC
            if self.libraryPreviewModel != nil {
                vc.mainModelView.libraryPreviewModel = self.libraryPreviewModel
            }
            else {
                //Default exercise
                vc.mainModelView.list = self.listComman
            }
            return vc
        default:
            let vc = UIViewController()
            return vc
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAt index: UInt) {
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }
}
