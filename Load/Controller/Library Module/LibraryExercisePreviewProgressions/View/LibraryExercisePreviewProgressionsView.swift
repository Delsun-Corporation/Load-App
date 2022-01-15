//
//  LibraryExercisePreviewProgressionsView.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LibraryExercisePreviewProgressionsView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var viewPager: ViewPager!    
    @IBOutlet weak var viewGraph: UIView!
    @IBOutlet weak var lblHighest: UILabel!
    @IBOutlet weak var lblLatest: UILabel!
    
    @IBOutlet weak var lblHighestValue: UILabel!
    @IBOutlet weak var lblLatestValue: UILabel!
    //MARK:- Functions
    func setupUI(theController: LibraryExercisePreviewProgressionsVC) {
        self.setupFont()
//        viewPager.dataSource = self
    }
    
    func showDetails(model: [GraphDetailsModelClass]?, theController: LibraryExercisePreviewProgressionsVC) {
        self.viewGraph.subviews.forEach({ $0.removeFromSuperview() })
        let view: LibraryChartView = LibraryChartView.instanceFromNib() as! LibraryChartView
        view.delegate = theController
        view.setupUI(model: model, selectedDate: theController.mainModelView.selectedDate)
        self.viewGraph.addSubview(view)
    }
    
    func setupFont() {
        self.lblHighest.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblLatest.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        self.lblHighest.setColor(color: .appthemeBlackColor)
        self.lblLatest.setColor(color: .appthemeBlackColor)
        
        self.lblHighest.text = getCommonString(key: "Highest_key")
        self.lblLatest.text = getCommonString(key: "Latest_key")
        
        [self.lblHighestValue,self.lblLatestValue].forEach { (lbl) in
            lbl?.textColor = UIColor.appthemeBlackColor
            lbl?.font = themeFont(size: 30, fontname: .ProximaNovaBold)
        }
    }
}

//MARK:- ViewPager
extension LibraryExercisePreviewProgressionsView: ViewPagerDataSource {
    func numberOfItems(viewPager:ViewPager) -> Int {
        return 3;
    }
    
    func viewAtIndex(viewPager:ViewPager, index:Int, view:UIView?) -> UIView {
        let view: LibraryChartView = LibraryChartView.instanceFromNib() as! LibraryChartView
//        view.setupUI()
        return view
    }
    
    func didSelectedItem(index: Int) {
        print("select index \(index)")
    }    
}
