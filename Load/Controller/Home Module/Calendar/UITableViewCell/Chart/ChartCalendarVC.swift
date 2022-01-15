//
//  ChartCalendarVC.swift
//  Load
//
//  Created by Haresh Bhai on 31/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ChartCalendarVC: UIViewController {
    
    @IBOutlet weak var lblDaily: UILabel!
    @IBOutlet weak var lblWeekly: UILabel!
    @IBOutlet weak var lblMonthly: UILabel!
    @IBOutlet weak var lblYearly: UILabel!
    @IBOutlet weak var lblType: UILabel!    
    @IBOutlet weak var imgUp: UIImageView!
    @IBOutlet weak var viewPager: ViewPager!
    
    var isResistance:Bool = true
    var selectedType:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.setupUI()
    }
    
    func setupUI() {
        self.setupFont()
        self.lblType.text = self.isResistance ? TRAINING_LOG_STATUS.RESISTANCE.rawValue.lowercased().capitalized : TRAINING_LOG_STATUS.CARDIO.rawValue.lowercased().capitalized
        self.imgUp.image = self.isResistance ? UIImage(named: "ic_dropdown_red_up") : UIImage(named: "ic_dropdown_red_down")
        DispatchQueue.main.async {
            self.viewPager.layoutIfNeeded()
            self.viewPager.dataSource = self
            self.viewPager.pageControl.hidesForSinglePage = true
        }
    }
    
    func setupFont() {
        self.makeFont()
        self.lblDaily.font = themeFont(size: 14, fontname: .ProximaNovaBold)

        self.lblDaily.setColor(color: .appthemeRedColor)
        self.lblWeekly.setColor(color: .appthemeBlackColor)
        self.lblMonthly.setColor(color: .appthemeBlackColor)
        self.lblYearly.setColor(color: .appthemeBlackColor)
        
        self.lblDaily.text = getCommonString(key: "Daily_key")
        self.lblWeekly.text = getCommonString(key: "Weekly_key")
        self.lblMonthly.text = getCommonString(key: "Monthly_key")
        self.lblYearly.text = getCommonString(key: "Yearly_key")
    }
    
    func makeFont() {
        self.lblDaily.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblWeekly.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblMonthly.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblYearly.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
    }
    
    @IBAction func btnTypeClicked(_ sender: Any) {
        self.isResistance = !self.isResistance
        self.lblType.text = self.isResistance ? TRAINING_LOG_STATUS.RESISTANCE.rawValue.lowercased().capitalized : TRAINING_LOG_STATUS.CARDIO.rawValue.lowercased().capitalized
        self.imgUp.image = self.isResistance ? UIImage(named: "ic_dropdown_red_up") : UIImage(named: "ic_dropdown_red_down")
    }
    
    @IBAction func btnDailyClicked(_ sender: Any) {
        self.selectedType = 0
        self.viewPager.reloadData()
        self.lblDaily.setColor(color: .appthemeRedColor)
        self.lblWeekly.setColor(color: .appthemeBlackColor)
        self.lblMonthly.setColor(color: .appthemeBlackColor)
        self.lblYearly.setColor(color: .appthemeBlackColor)
        self.makeFont()
        self.lblDaily.font = themeFont(size: 14, fontname: .ProximaNovaBold)
    }
    
    @IBAction func btnWeeklyClicked(_ sender: Any) {
        self.selectedType = 1
        self.viewPager.reloadData()
        self.lblDaily.setColor(color: .appthemeBlackColor)
        self.lblWeekly.setColor(color: .appthemeRedColor)
        self.lblMonthly.setColor(color: .appthemeBlackColor)
        self.lblYearly.setColor(color: .appthemeBlackColor)
        self.makeFont()
        self.lblWeekly.font = themeFont(size: 14, fontname: .ProximaNovaBold)
    }
    
    @IBAction func btnmonthlyClicked(_ sender: Any) {
        self.selectedType = 2
        self.viewPager.reloadData()
        self.lblDaily.setColor(color: .appthemeBlackColor)
        self.lblWeekly.setColor(color: .appthemeBlackColor)
        self.lblMonthly.setColor(color: .appthemeRedColor)
        self.lblYearly.setColor(color: .appthemeBlackColor)
        self.makeFont()
        self.lblMonthly.font = themeFont(size: 14, fontname: .ProximaNovaBold)
    }
    
    @IBAction func btnYearlyClicked(_ sender: Any) {
        self.selectedType = 3
        self.viewPager.reloadData()
        self.lblDaily.setColor(color: .appthemeBlackColor)
        self.lblWeekly.setColor(color: .appthemeBlackColor)
        self.lblMonthly.setColor(color: .appthemeBlackColor)
        self.lblYearly.setColor(color: .appthemeRedColor)
        self.makeFont()
        self.lblYearly.font = themeFont(size: 14, fontname: .ProximaNovaBold)
    }    
}

extension ChartCalendarVC:ViewPagerDataSource{
    func numberOfItems(viewPager:ViewPager) -> Int {
        return 1;
    }    
    
    func viewAtIndex(viewPager:ViewPager, index:Int, view:UIView?) -> UIView {        
        let view: ChartView = ChartView.instanceFromNib() as! ChartView
        view.typeValue = self.selectedType
        if self.selectedType == 1 {
            view.dateValue = Date().monthName
        }
        else {
            view.dateValue = ""
        }
        view.newChart()
        return view
    }
    
    func didSelectedItem(index: Int) {
//        print("select index \(index)")
    }
}
