//
//  RegionSelectionMainView.swift
//  Load
//
//  Created by iMac on 31/01/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class RegionSelectionMainView: UIView, CarbonTabSwipeNavigationDelegate {

    @IBOutlet weak var lblPrimaryMusculer: UILabel!
    @IBOutlet weak var lblSecondaryMuscule: UILabel!
    
    @IBOutlet weak var imgMainFront: UIImageView!
    @IBOutlet weak var imgMainBack: UIImageView!
    @IBOutlet weak var viewImage: UIView!

    @IBOutlet weak var mainView: UIView!
    
    var innerVc = RegionSelectionMainVc()
    var arr_corbonVC = [UIViewController]()
    
    //MARK:-  SetupUI
    
    func setupUI(){
        
        self.imgMainFront.sd_setImage(with: GetAllData?.data?.defaultBodyPartImageUrlFront?.toURL(), completed: nil)
        self.imgMainBack.sd_setImage(with: GetAllData?.data?.defaultBodyPartImageUrlBack?.toURL(), completed: nil)
        
        self.lblPrimaryMusculer.text = getCommonString(key: "Primary_Muscle_key")
        self.lblSecondaryMuscule.text = getCommonString(key: "Secondary_Muscle_key")
        
        self.lblPrimaryMusculer.font = themeFont(size: 11, fontname: .ProximaNovaBold)
        self.lblSecondaryMuscule.font = themeFont(size: 11, fontname: .ProximaNovaBold)
        
        self.lblPrimaryMusculer.textColor = UIColor(red: 198/255, green: 96/255, blue: 174/255, alpha: 1.0)
        self.lblSecondaryMuscule.textColor = UIColor(red: 228/255, green: 186/255, blue: 218/255, alpha: 1.0)
        
    }
    
    //MARK: - CarbonTab Delegates
    
    func setupUICarbonTab(theController:RegionSelectionMainVc) {
        self.innerVc = theController
        let titles = ["FRONT","BACK"] as NSArray
        theController.mainModelView.items = titles
        theController.mainModelView.carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: theController.mainModelView.items as [AnyObject], delegate: self)
        theController.mainModelView.carbonTabSwipeNavigation.insert(intoRootViewController: theController, andTargetView: self.mainView)
        self.style(theController: theController)
    }

    func style(theController:RegionSelectionMainVc) {
        let vc = theController.mainModelView
        
        let width = UIScreen.main.bounds.width
        vc.carbonTabSwipeNavigation.toolbarHeight.constant = 50
        let tabWidth = (width / CGFloat(2))
        
        let indicatorcolor: UIColor = UIColor.appthemeRedColor
        let color: UIColor = .white
        
        vc.carbonTabSwipeNavigation.toolbar.isTranslucent = false
        vc.carbonTabSwipeNavigation.toolbar.barTintColor = color
        vc.carbonTabSwipeNavigation.setIndicatorColor(indicatorcolor)
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowOffset = CGSize(width: 0, height: 2)
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowOpacity = 0.2
        vc.carbonTabSwipeNavigation.toolbar.layer.masksToBounds = false
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowRadius = 1
        
        vc.carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: 0)
        vc.carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: 1)
        
        if DEVICE_TYPE.IS_IPHONE_5 {
            vc.carbonTabSwipeNavigation.setNormalColor(UIColor.appthemeBlackColor, font:themeFont(size: 13, fontname: .ProximaNovaRegular))
            vc.carbonTabSwipeNavigation.setSelectedColor(UIColor.appthemeRedColor, font: themeFont(size: 13, fontname: .ProximaNovaBold))
        }
        else {
            vc.carbonTabSwipeNavigation.setNormalColor(UIColor.appthemeBlackColor, font:themeFont(size: 15, fontname: .ProximaNovaRegular))
            vc.carbonTabSwipeNavigation.setSelectedColor(UIColor.appthemeRedColor, font: themeFont(size: 15, fontname: .ProximaNovaBold))
        }
       
        vc.carbonTabSwipeNavigation.toolbar.shadowImage(forToolbarPosition: .bottom)
        vc.carbonTabSwipeNavigation.setCurrentTabIndex(0, withAnimation: true)
        vc.carbonTabSwipeNavigation.pagesScrollView?.decelerationRate = .normal
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        
        let obj: RegionSelectionVC = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "RegionSelectionVC") as! RegionSelectionVC
        obj.mainModelView.isHeaderHide = true
        
        obj.mainModelView.sortedRegionSelectionModel = innerVc.mainModelView.passSortedArray(index: Int(index))
        
        if Int(index) == 0{
            obj.mainModelView.selectedArray = innerVc.mainModelView.selectedArray
            obj.mainModelView.selectedNameArray = innerVc.mainModelView.selectedNameArray
        }
        
        obj.mainModelView.delegate = innerVc
        obj.mainModelView.selectedId = innerVc.mainModelView.selectedId
        obj.mainModelView.category = innerVc.strTitle
        obj.mainModelView.selectedSubBodyPartIdArray = innerVc.mainModelView.selectedSubBodyPartIdArray
        obj.currentIndex = Int(index)
        arr_corbonVC.append(obj)
        return obj
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAt index: UInt) {
        print(carbonTabSwipeNavigation.viewControllers ?? "nil")
        
        print("innerVc.mainModelView.selectedArray : \(innerVc.mainModelView.selectedArray)")
        
        if let vc = arr_corbonVC[Int(index)] as? RegionSelectionVC{
            vc.mainModelView.selectedArray = uniqueElementsFrom(array: innerVc.mainModelView.selectedArray)
            vc.mainModelView.selectedNameArray = uniqueElementsFrom(array: innerVc.mainModelView.selectedNameArray)
        }
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }

}
