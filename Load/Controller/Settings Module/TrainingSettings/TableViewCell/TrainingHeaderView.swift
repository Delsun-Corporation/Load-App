//
//  TrainingHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 30/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class TrainingHeaderView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "TrainingHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TrainingHeaderView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55)
    }
    
    func setupUI(title:String) {
        self.setFrame()
        self.setupFont()
        self.lblTitle.text = title
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTitle.setColor(color: .appthemeBlackColorAlpha30)
    }
}
