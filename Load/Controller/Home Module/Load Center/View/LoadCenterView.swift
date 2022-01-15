//
//  LoadCenterView.swift
//  Load
//
//  Created by Haresh Bhai on 19/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class LoadCenterView: UIView, CarbonTabSwipeNavigationDelegate, UITextFieldDelegate {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblFilter: UILabel!
    
    //MARK: - Variables
    var listArray: [LibraryExerciseModelClass] = [LibraryExerciseModelClass]()
    
    //MARK: - Functions
    func setupUI(theController:LoadCenterVC) {
        self.txtSearch.delegate = self
        self.txtSearch.clearButtonMode = .always
        self.setupFont()
        setupUICarbonTab(theController: theController)
    }
    
    func setupFont() {
        self.txtSearch.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lblFilter.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        self.txtSearch.setColor(color: .appthemeBlackColor)
        self.lblFilter.setColor(color: .appthemeRedColor)
    }
    
    //MARK: - CarbonTab Delegates
    func setupUICarbonTab(theController:LoadCenterVC) {
        theController.mainModelView.items = ["Feeds", "Listings", "Events"]
        theController.mainModelView.carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: theController.mainModelView.items as [AnyObject], delegate: self)
        theController.mainModelView.carbonTabSwipeNavigation.insert(intoRootViewController: theController, andTargetView: self.mainView)
        self.style(theController: theController)
    }
    
    func style(theController:LoadCenterVC) {
        let vc = theController.mainModelView
        let width = UIScreen.main.bounds.width
        vc.carbonTabSwipeNavigation.toolbarHeight.constant = 45
        let tabWidth = (width / CGFloat(theController.mainModelView.items.count))
        
        let indicatorcolor: UIColor = UIColor.appthemeRedColor
        let color: UIColor = .white
        
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
        vc.carbonTabSwipeNavigation.setNormalColor(UIColor.appthemeBlackColor , font:themeFont(size: 15, fontname: .ProximaNovaRegular))
        vc.carbonTabSwipeNavigation.setSelectedColor(UIColor.appthemeRedColor, font: themeFont(size: 15, fontname: .ProximaNovaBold))
        vc.carbonTabSwipeNavigation.toolbar.shadowImage(forToolbarPosition: .bottom)
        vc.carbonTabSwipeNavigation.setCurrentTabIndex(0, withAnimation: true)
        vc.carbonTabSwipeNavigation.pagesScrollView?.decelerationRate = .normal
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            let vc = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "FeedsVC") as! FeedsVC
            return vc
        case 1 :
            let vc = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "ListingsVC") as! ListingsVC
            return vc
        case 2 :
            let vc = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "EventVC") as! EventVC
            return vc
        default:
            let vc = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "EventVC") as! EventVC
            return vc
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAt index: UInt) {
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }
    
    //MARK: - TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        print(txtAfterUpdate)
        
        let dataDict:[String: String] = ["data": txtAfterUpdate]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_SEARCH_NOTIFICATION.rawValue), object: nil, userInfo: dataDict)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let dataDict:[String: String] = ["data": ""]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_SEARCH_NOTIFICATION.rawValue), object: nil, userInfo: dataDict)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
