//
//  EventDetailsHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView

class EventDetailsHeaderView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var rateView: FloatRatingView!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "EventDetailsHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventDetailsHeaderView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
    }
    
    func setupUI() {
        self.setFrame()
    }
    
    func setupFont(size: Float = 16) {
        self.lblTitle.font = themeFont(size: size, fontname: .ProximaNovaBold)
        self.lblTitle.setColor(color: .appthemeBlackColor)
    }
}
