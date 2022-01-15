//
//  CountDownView.swift
//  Load
//
//  Created by Haresh Bhai on 21/12/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CountDownView: UIView {

    @IBOutlet weak var lblReady: UILabel!
    @IBOutlet weak var sliderArea: UIView!
    @IBOutlet weak var lblCount: GradientLabel!
    @IBOutlet weak var countdownTimer: SRCountdownTimer!

    func setupUI(theController:CountDownVC) {
        self.layoutIfNeeded()
        self.countdownTimer.layoutIfNeeded()
        self.setupFont()
    }
    
    func setupFont() {
        self.lblReady.font = themeFont(size: 25, fontname: .ProximaNovaRegular)
        self.lblCount.font = themeFont(size: 100, fontname: .ProximaNovaBold)
        
        self.lblReady.setColor(color: .appthemeRedColor)
        self.lblCount.gradientColors = [
            UIColor(red:0.45, green:0.19, blue:0.6, alpha:1).cgColor,
            UIColor(red:0.78, green:0.2, blue:0.2, alpha:0.88).cgColor
        ]
    }
}
