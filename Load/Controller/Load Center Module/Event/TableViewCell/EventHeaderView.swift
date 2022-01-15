//
//  EventHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 21/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventHeaderView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "EventHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventHeaderView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
    }
    
    func setupUI() {
        self.setupFont()
        self.setFrame()
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblTitle.text = getCommonString(key: "UPCOMING_EVENTS_key")
    }
}
