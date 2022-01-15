//
//  MessageMainVC.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class MessageMainView: UIView, CarbonTabSwipeNavigationDelegate, UITextFieldDelegate {

    //MARK:- @IBOutlet
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    
    var theController: MessageMainVC?
    
    //MARK:- Functions
    func setupUI(theController: MessageMainVC) {
        self.theController = theController
        self.txtSearch.delegate = self
        self.txtSearch.clearButtonMode = .always
        self.setupUICarbonTab(theController: theController)
    }
    
    //MARK: - CarbonTab Delegates
    func setupUICarbonTab(theController:MessageMainVC) {
        theController.mainModelView.items = ["Following", "Messages"]
        theController.mainModelView.carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: theController.mainModelView.items as [AnyObject], delegate: self)
        theController.mainModelView.carbonTabSwipeNavigation.insert(intoRootViewController: theController, andTargetView: self.viewMain)
        self.style(theController: theController)
    }
    
    func style(theController:MessageMainVC) {
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
            let vc = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "FollowingVC") as! FollowingVC
            return vc
        case 1 :
            let vc = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "MessagesVC") as! MessagesVC
            vc.mainModelView.delegate = self.theController
            return vc
        default:
            return UIViewController()
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.MESSAGE_SEARCH_NOTIFICATION.rawValue), object: nil, userInfo: dataDict)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let dataDict:[String: String] = ["data": ""]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.MESSAGE_SEARCH_NOTIFICATION.rawValue), object: nil, userInfo: dataDict)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    } 
}
