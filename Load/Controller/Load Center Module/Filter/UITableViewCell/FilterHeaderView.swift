//
//  FilterHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 26/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FilterHeaderView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Variables
    var section:Int = 0

    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "FilterHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FilterHeaderView
    }
    
    func setupUI() {
        self.setFrame()
        self.setupFont()
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 42)
    }
    
    func setupFont() {
        var fontSize:Float = 12
        if self.section == 6 || self.section == 7 {
            fontSize = 15
        }
        self.lblTitle.font = themeFont(size: fontSize, fontname: .ProximaNovaRegular)
        self.lblTitle.setColor(color: .appthemeBlackColor)        
    }
}
