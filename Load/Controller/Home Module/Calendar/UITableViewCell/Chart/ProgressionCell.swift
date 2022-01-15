//
//  ProgressionCell.swift
//  Load
//
//  Created by Haresh Bhai on 31/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit

class ProgressionCell: UITableViewCell, CarbonTabSwipeNavigationDelegate {
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var pager: UIPageControl!
    
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var items = NSArray()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewMain.layoutIfNeeded()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(theController: CalendarVC) {
        items = ["Progression","Performance"]
        DispatchQueue.main.async {
            self.carbonTabSwipeNavigation = CarbonTabSwipeNavigation.init(items: self.items as? [Any], delegate: self)
//            self.carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: self.items as? [Any], delegate: self)
            self.carbonTabSwipeNavigation.insert(intoRootViewController: theController, andTargetView: self.viewMain)
            self.style()
        }
    }
    
    func style() {
        let width = UIScreen.main.bounds.width
        carbonTabSwipeNavigation.toolbarHeight.constant = 45
        let tabWidth = (width / CGFloat(items.count))
        
        let indicatorcolor: UIColor = UIColor.appthemeRedColor
        let color: UIColor = .white
        
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.toolbar.barTintColor = color
        carbonTabSwipeNavigation.setIndicatorColor(indicatorcolor)
        carbonTabSwipeNavigation.carbonSegmentedControl!.indicatorWidth = 100
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: 0)
        carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(tabWidth, forSegmentAt: 1)
        carbonTabSwipeNavigation.toolbar.layer.shadowColor = UIColor.appthemeGrayColor.cgColor//(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        carbonTabSwipeNavigation.toolbar.layer.shadowOffset = CGSize(width: 0, height: 2)
        carbonTabSwipeNavigation.toolbar.layer.shadowOpacity = 0.7
        carbonTabSwipeNavigation.toolbar.layer.masksToBounds = false
        carbonTabSwipeNavigation.toolbar.layer.shadowRadius = 1.0
        carbonTabSwipeNavigation.carbonTabSwipeScrollView.isScrollEnabled = false
        carbonTabSwipeNavigation.setNormalColor(UIColor.appthemeBlackColor, font:themeFont(size: 15, fontname: .ProximaNovaRegular))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.appthemeRedColor, font: themeFont(size: 15, fontname: .ProximaNovaBold))
        carbonTabSwipeNavigation.toolbar.shadowImage(forToolbarPosition: .bottom)
        carbonTabSwipeNavigation.setCurrentTabIndex(0, withAnimation: true)
        carbonTabSwipeNavigation.pagesScrollView?.decelerationRate = .normal
        carbonTabSwipeNavigation.pagesScrollView?.isScrollEnabled = false
    }
      
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        switch index {
        case 0:
            let vc = ChartCalendarVC(nibName: "ChartCalendarVC", bundle: nil)
            return vc
        case 1 :
            let vc = ChartCalendarVC(nibName: "ChartCalendarVC", bundle: nil)
            return vc
        default:
            let vc = ChartCalendarVC(nibName: "ChartCalendarVC", bundle: nil)
            return vc
        }
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, willMoveAt index: UInt) {
        self.pager.currentPage = Int(index)
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {

    }
}
