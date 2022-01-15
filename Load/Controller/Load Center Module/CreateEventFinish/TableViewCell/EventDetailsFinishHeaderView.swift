//
//  EventDetailsHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventDetailsFinishHeaderView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "EventDetailsFinishHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! EventDetailsFinishHeaderView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80)
    }
    
    func setupUI() {
        self.setFrame()
    }
    
    func setupFont(size: Float = 16) {
        self.lblTitle.font = themeFont(size: size, fontname: .ProximaNovaBold)
        self.lblTitle.setColor(color: .appthemeBlackColor)
    }
}
