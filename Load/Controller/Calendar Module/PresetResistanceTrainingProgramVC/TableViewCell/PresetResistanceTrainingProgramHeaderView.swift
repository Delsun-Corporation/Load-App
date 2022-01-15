
//
//  PresetTrainingProgramHeader.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class PresetResistanceTrainingProgramHeaderView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PresetResistanceTrainingProgramHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PresetResistanceTrainingProgramHeaderView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 68)
    }
    
    func setupUI() {
        self.setFrame()
        self.setupFont()
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblTitle.setColor(color: .appthemeBlackColor)
    }
}
