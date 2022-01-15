//
//  CreateTrainingLogView.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class CreateTrainingLogView: UIView, CarbonTabSwipeNavigationDelegate {

    //MARK:- @IBOutlet
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblCreateTrainingLog: UILabel!
    @IBOutlet weak var collectionViewHeader: UICollectionView!
    
    //MARK:- Variables
    var previewData: TrainingLogModelClass?
    var previewDataResistance: TrainingLogResistanceModelClass?
    var isEditCardio: Bool = false
    var isEditResistance: Bool = false
    var selectedDateFromCalendar: String = ""

    //MARK:- Functions
    func setupUI(theController:CreateTrainingLogVC, isEditCardio:Bool, isEditResistance:Bool, previewData: TrainingLogModelClass?, previewDataResistance: TrainingLogResistanceModelClass?,selectedDateFromCalendar:String) {
        self.setupFont()
        self.isEditCardio = isEditCardio
        self.isEditResistance = isEditResistance
        self.previewData = previewData
        self.previewDataResistance = previewDataResistance
        self.selectedDateFromCalendar = selectedDateFromCalendar

        theController.mainModelView.items = [UIImage(named: "ic_cardio_button") as Any, UIImage(named: "ic_resistance_button") as Any]

        theController.mainModelView.carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: theController.mainModelView.items as [AnyObject], delegate: self)
        theController.mainModelView.carbonTabSwipeNavigation.insert(intoRootViewController: theController, andTargetView: self.mainView)
        self.style(theController: theController)
    }
    
    func setupFont() {
        self.lblCreateTrainingLog.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblCreateTrainingLog.setColor(color: .appthemeBlackColor)
        self.lblCreateTrainingLog.text = getCommonString(key: "CREATE_TRAINING_LOG_key")
        
        self.collectionViewHeader.register(UINib(nibName: "HeaderCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HeaderCollectionCell")
        
    }
    
    func style(theController:CreateTrainingLogVC) {
        let vc = theController.mainModelView
        let width = UIScreen.main.bounds.width
        vc.carbonTabSwipeNavigation.toolbarHeight.constant = 47
        let tabWidth = (width / CGFloat(vc.items.count))
        
        let indicatorcolor: UIColor = UIColor.appthemeRedColor
        let color: UIColor = .white
        
        vc.carbonTabSwipeNavigation.toolbar.isTranslucent = false
        vc.carbonTabSwipeNavigation.toolbar.barTintColor = color
        vc.carbonTabSwipeNavigation.setIndicatorColor(indicatorcolor)
        vc.carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: 0)
        vc.carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: 1)
//        vc.carbonTabSwipeNavigation.toolbar.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        vc.carbonTabSwipeNavigation.toolbar.layer.shadowOffset = CGSize(width: 0, height: 2)
//        vc.carbonTabSwipeNavigation.toolbar.layer.shadowOpacity = 0.0
//        vc.carbonTabSwipeNavigation.toolbar.layer.masksToBounds = false
        vc.carbonTabSwipeNavigation.toolbar.layer.shadowRadius = 0.0
        vc.carbonTabSwipeNavigation.carbonTabSwipeScrollView.isScrollEnabled = false
        vc.carbonTabSwipeNavigation.setNormalColor(UIColor.darkGray, font:themeFont(size: 15, fontname: .ProximaNovaThin))
        vc.carbonTabSwipeNavigation.setSelectedColor(UIColor.appthemeRedColor, font: themeFont(size: 15, fontname: .ProximaNovaRegular))
        vc.carbonTabSwipeNavigation.toolbar.shadowImage(forToolbarPosition: .bottom)
        vc.carbonTabSwipeNavigation.setCurrentTabIndex(UInt(vc.tabIndex), withAnimation: true)
        vc.carbonTabSwipeNavigation.currentTabIndex = UInt(vc.tabIndex)
        vc.carbonTabSwipeNavigation.pagesScrollView?.decelerationRate = .normal
        vc.carbonTabSwipeNavigation.pagesScrollView?.isScrollEnabled = false
        self.layoutIfNeeded()
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            let vc = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CardioTrainingLogVC") as! CardioTrainingLogVC
            vc.mainModelView.isEdit = self.isEditCardio
            vc.mainModelView.selectedDateFromCalendar = self.selectedDateFromCalendar
            vc.mainModelView.previewData = self.previewData
            return vc
        case 1 :
            let vc = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "ResistanceTrainingLogVC") as! ResistanceTrainingLogVC
            vc.mainModelView.isEdit = self.isEditResistance
            vc.mainModelView.selectedDateFromCalendar = self.selectedDateFromCalendar
            vc.mainModelView.previewData = self.previewDataResistance
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
