//
//  ChartTotalWorkoutView.swift
//  Load
//
//  Created by Haresh Bhai on 01/10/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ChartTotalWorkoutView: UIView {
   
    //MARK:- @IBOutlet
    @IBOutlet weak var viewMaim: UIView!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ChartTotalWorkoutView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ChartTotalWorkoutView
    }
    
    func setupUI(x:CGFloat, y:CGFloat) {
        self.setFrame(x: x, y: y)
        self.setupFont()
        
        self.viewMaim.backgroundColor = UIColor.white
        self.tag = 1200
        self.viewMaim.layer.borderColor = UIColor.appthemeRedColor.cgColor
        self.viewMaim.layer.borderWidth = 2
    }
    
    func setFrame(x:CGFloat, y:CGFloat) {
        self.frame = CGRect(x: x, y: y, width: 180, height: 65)
    }
    
    func setupFont() {
//        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
//        self.btnViewAll.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
//
//        self.lblTitle.setColor(color: .appthemeBlackColor)
//        self.btnViewAll.setColor(color: .appthemeRedColor)
//        self.btnViewAll.setTitle(str: getCommonString(key: "View_all_key"))
//        self.lblTitle.text = "Resistance"
    }
}
