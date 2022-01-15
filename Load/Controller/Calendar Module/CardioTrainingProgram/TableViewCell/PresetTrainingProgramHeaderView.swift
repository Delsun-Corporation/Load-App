
//
//  PresetTrainingProgramHeader.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class PresetTrainingProgramHeaderView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PresetTrainingProgramHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PresetTrainingProgramHeaderView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 108)
    }
    
    func setupUI() {
        self.setFrame()
        self.setupFont()
    }
    
    func setupFont() {
        self.lblTitle1.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblTitle1.setColor(color: .appthemeBlackColor)
        
        self.lblTitle2.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblTitle2.setColor(color: .appthemeBlackColor)
    }
}
