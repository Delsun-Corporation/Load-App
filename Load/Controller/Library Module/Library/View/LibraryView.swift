//
//  LibraryView.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class LibraryView: UIView, CarbonTabSwipeNavigationDelegate, UITextFieldDelegate {
    
    //MARK: - @IBOutlet
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var mainView: UIView!
    
    //MARK: - Variables
    var listArray: [LibraryExerciseModelClass] = [LibraryExerciseModelClass]()
    
    //MARK: - Functions
    func setupUI(theController:LibraryVC) {
        self.txtSearch.delegate = self
        self.txtSearch.clearButtonMode = .always
        txtSearch.autocorrectionType = .no
        setupUICarbonTab(theController: theController)
    }
    
    //MARK: - CarbonTab Delegates
    func setupUICarbonTab(theController:LibraryVC) {
        let titles = self.getAllLibraryType()
        theController.mainModelView.items = titles
        theController.mainModelView.carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: theController.mainModelView.items as [AnyObject], delegate: self)
        theController.mainModelView.carbonTabSwipeNavigation.insert(intoRootViewController: theController, andTargetView: self.mainView)
        self.style(theController: theController)
    }
    
    func style(theController:LibraryVC) {
        let vc = theController.mainModelView
        let width = UIScreen.main.bounds.width - 70
        vc.carbonTabSwipeNavigation.toolbarHeight.constant = 45
        let tabWidth = (width / CGFloat(3))
        
        let indicatorcolor: UIColor = UIColor.appthemeRedColor
        let color: UIColor = .white
        
        vc.carbonTabSwipeNavigation.toolbar.isTranslucent = false
        vc.carbonTabSwipeNavigation.toolbar.barTintColor = color
        vc.carbonTabSwipeNavigation.setIndicatorColor(indicatorcolor)
        for (index, _) in theController.mainModelView.items.enumerated() {
            if self.getAllLibraryType().count == (index + 1) {
                vc.carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(70, forSegmentAt: index)
            }
            else {
                vc.carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: index)
            }
        }
        
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowOffset = CGSize(width: 0, height: 2)
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowOpacity = 0.2
        vc.carbonTabSwipeNavigation.toolbar.layer.masksToBounds = false
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowRadius = 1
        if DEVICE_TYPE.IS_IPHONE_5 {
            vc.carbonTabSwipeNavigation.setNormalColor(UIColor.appthemeBlackColor, font:themeFont(size: 13, fontname: .ProximaNovaRegular))
            vc.carbonTabSwipeNavigation.setSelectedColor(UIColor.appthemeRedColor, font: themeFont(size: 13, fontname: .ProximaNovaBold))
        }
        else {
            vc.carbonTabSwipeNavigation.setNormalColor(UIColor.appthemeBlackColor, font:themeFont(size: 15, fontname: .ProximaNovaRegular))
            vc.carbonTabSwipeNavigation.setSelectedColor(UIColor.appthemeRedColor, font: themeFont(size: 15, fontname: .ProximaNovaBold))
        }
        
        vc.carbonTabSwipeNavigation.pagesScrollView?.decelerationRate = .normal
        vc.carbonTabSwipeNavigation.pagesScrollView?.isScrollEnabled = false
        vc.carbonTabSwipeNavigation.toolbar.shadowImage(forToolbarPosition: .bottom)
        vc.carbonTabSwipeNavigation.setCurrentTabIndex(0, withAnimation: true)
        vc.carbonTabSwipeNavigation.pagesScrollView?.decelerationRate = .normal        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        let vc = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExerciseListMainVC") as! LibraryExerciseListMainVC
        vc.mainModelView.category = GetAllData?.data?.category![Int(index)]
        vc.mainModelView.isFilter = self.txtSearch.text! != ""
        vc.mainModelView.searchText = self.txtSearch.text!
        return vc
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAt index: UInt) {
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }
    
    func getAllLibraryType() -> NSMutableArray {
        var array:[String] = [String]()
        let model = GetAllData?.data?.category ?? []
        for data in model {
            array.append(data.name!)
        }
        for (index, data) in array.enumerated() {
            if data.lowercased() == "favorite".lowercased() {
                array.remove(at: index)
                break
            }
        }
        let dataArray:NSMutableArray = NSMutableArray()
        for data in array {
            dataArray.add(data)
        }
        dataArray.add(UIImage(named: "ic_star_unselect")!)
        return dataArray
    }
    
    //MARK: - TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        print(txtAfterUpdate)
        
        let dataDict:[String: String] = ["data": txtAfterUpdate]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LIBRARY_LIST_SEARCH_NOTIFICATION.rawValue), object: nil, userInfo: dataDict)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let dataDict:[String: String] = ["data": ""]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LIBRARY_LIST_SEARCH_NOTIFICATION.rawValue), object: nil, userInfo: dataDict)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
