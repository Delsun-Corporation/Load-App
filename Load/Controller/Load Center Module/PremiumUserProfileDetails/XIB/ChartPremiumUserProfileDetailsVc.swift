//
//  ChartPremiumUserProfileDetailsVc.swift
//  Load
//
//  Created by Yash on 02/07/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class ChartPremiumUserProfileDetailsVc: UIViewController {

    @IBOutlet weak var viewPager: ViewPager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }

    func setupUI() {
        DispatchQueue.main.async {
            self.viewPager.layoutIfNeeded()
            self.viewPager.dataSource = self
            self.viewPager.pageControl.hidesForSinglePage = true
        }
    }

}


extension ChartPremiumUserProfileDetailsVc:ViewPagerDataSource{
    func numberOfItems(viewPager:ViewPager) -> Int {
        return 1;
    }
    
    func viewAtIndex(viewPager:ViewPager, index:Int, view:UIView?) -> UIView {
        let view: ChartView = ChartView.instanceFromNib() as! ChartView
//        view.typeValue = self.selectedType
//        if self.selectedType == 1 {
            view.dateValue = Date().monthName
//        }
//        else {
//            view.dateValue = ""
//        }
        view.newChart()
        return view
    }
    
    func didSelectedItem(index: Int) {
//        print("select index \(index)")
    }
}
