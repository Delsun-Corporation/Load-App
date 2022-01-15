//
//  RaceTimeView.swift
//  Load
//
//  Created by Haresh Bhai on 05/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class RaceTimeView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblDistanceTitle: UILabel!
    @IBOutlet weak var txtDistance: UITextField!
    
    @IBOutlet weak var lblTimeTitle: UILabel!
    @IBOutlet weak var txtTime: UITextField!
    
    //MARK:- Functions
    func setupUI(theController:RaceTimeVC) {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblDistanceTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtDistance.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTimeTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtTime.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        self.lblDistanceTitle.setColor(color: .appthemeBlackColor)
        self.txtDistance.setColor(color: .appthemeBlackColor)
        self.lblTimeTitle.setColor(color: .appthemeBlackColor)
        self.txtTime.setColor(color: .appthemeBlackColor)
        
        self.lblDistanceTitle.text = getCommonString(key: "Select_distance_key")
        self.lblTimeTitle.text = getCommonString(key: "Time_key")
    }
}
