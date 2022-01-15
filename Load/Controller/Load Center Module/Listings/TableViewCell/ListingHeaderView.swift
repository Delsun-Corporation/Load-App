//
//  ListingHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ListingHeaderView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnViewAll: UIButton!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ListingHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ListingHeaderView
    }
    
    func setupUI() {
        self.setFrame()
        self.setupFont()
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 63)
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.btnViewAll.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.btnViewAll.setColor(color: .appthemeRedColor)
        self.btnViewAll.setTitle(str: getCommonString(key: "View_all_key"))
        self.lblTitle.text = "Resistance"
    }
}
