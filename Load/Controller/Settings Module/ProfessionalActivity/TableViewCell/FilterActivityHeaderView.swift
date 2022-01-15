//
//  FilterSpecializationHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FilterActivityHeaderView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "FilterActivityHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FilterActivityHeaderView
    }
    
    func setupUI() {
        self.setFrame()
        self.setupFont()
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 18, fontname: .ProximaNovaBold)
        self.lblTitle.setColor(color: .appthemeBlackColor)
    }
}
