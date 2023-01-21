//
//  LibraryExerciseView.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class LibraryExerciseView: UIView, CarbonTabSwipeNavigationDelegate, AddLibraryExerciseDelegate, UITextFieldDelegate {
    

    //MARK:- @IBOutlet
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var txtSearch: UITextField!

    //MARK:- Variables
    var listArray: [LibraryListModelClass] = [LibraryListModelClass]()
    var listFavoriteArray: [LibraryFavoriteListModelClass] = [LibraryFavoriteListModelClass]()

    //MARK:- Functions
    func setupUI(theController:LibraryExerciseVC) {
        self.txtSearch.delegate = self
        self.txtSearch.clearButtonMode = .always
        self.setupUICarbonTab(theController: theController)
    }
    
    //MARK:- CarbonTab Delegates
    func setupUICarbonTab(theController:LibraryExerciseVC) {
        theController.mainModelView.items = self.getAllLibraryType() as NSArray

        theController.mainModelView.carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: theController.mainModelView.items as [AnyObject], delegate: self)
        theController.mainModelView.carbonTabSwipeNavigation.insert(intoRootViewController: theController, andTargetView: self.mainView)
        self.style(theController: theController)
    }
    
    func style(theController:LibraryExerciseVC) {
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
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowOpacity = 0.0
        vc.carbonTabSwipeNavigation.toolbar.layer.masksToBounds = false
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowRadius = 0.0
        vc.carbonTabSwipeNavigation.carbonTabSwipeScrollView.isScrollEnabled = false
        vc.carbonTabSwipeNavigation.setNormalColor(UIColor.appthemeBlackColor, font:themeFont(size: 15, fontname: .ProximaNovaRegular))
        vc.carbonTabSwipeNavigation.setSelectedColor(UIColor.appthemeRedColor, font: themeFont(size: 15, fontname: .ProximaNovaBold))
        vc.carbonTabSwipeNavigation.toolbar.shadowImage(forToolbarPosition: .bottom)
        vc.carbonTabSwipeNavigation.setCurrentTabIndex(0, withAnimation: true)
        vc.carbonTabSwipeNavigation.pagesScrollView?.decelerationRate = .normal
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        let vc = AppStoryboard.Library.instance.instantiateViewController(withIdentifier: "LibraryExerciseListVC") as! LibraryExerciseListVC
        vc.mainModelView.delegate = self
        vc.mainModelView.index = Int(index)
        vc.mainModelView.bodyParts = GetAllData?.data?.getSortedCategory()[Int(index)]
        vc.mainModelView.isFilter = self.txtSearch.text! != ""
        vc.mainModelView.searchText = self.txtSearch.text!
        return vc
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAt index: UInt) {
        
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }
    
    func AddLibraryExerciseDidFinish(listArray: LibraryListModelClass) {
        
        var isAdded:Bool = false
        for (index, data) in self.listArray.enumerated() {
            if data.index == listArray.index {
                self.listArray[index] = listArray
                isAdded = true
            }
        }
        if !isAdded {
            self.listArray.append(listArray)
        }
    }
    
    
    func AddLibraryExerciseFavoriteDidFininsh(favoriteArray: LibraryFavoriteListModelClass) {
       
        var isAdded:Bool = false
        for (index, data) in self.listFavoriteArray.enumerated() {
            if data.index == favoriteArray.index {
                self.listFavoriteArray[index] = favoriteArray
                isAdded = true
            }
        }
        if !isAdded {
            self.listFavoriteArray.append(favoriteArray)
        }
    }

    
    func getAllLibraryType() -> NSMutableArray {
        var array:[String] = [String]()
        let model = GetAllData?.data?.getSortedCategory() ?? []
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LIBRARY_EXERCISE_LIST_SEARCH_NOTIFICATION.rawValue), object: nil, userInfo: dataDict)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        let dataDict:[String: String] = ["data": ""]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LIBRARY_EXERCISE_LIST_SEARCH_NOTIFICATION.rawValue), object: nil, userInfo: dataDict)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
