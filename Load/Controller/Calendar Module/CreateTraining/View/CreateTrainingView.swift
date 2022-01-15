//
//  CreateTrainingView.swift
//  Load
//
//  Created by Haresh Bhai on 03/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateTrainingView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTrainingProgram: UILabel!
    @IBOutlet weak var lblTrainingLog: UILabel!

    //MARK:- Functions
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblTrainingProgram.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblTrainingLog.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        
        self.lblTrainingProgram.setColor(color: .appthemeRedColor)
        self.lblTrainingLog.setColor(color: .appthemeRedColor)
        
        self.lblTrainingProgram.text = getCommonString(key: "Training_Program_key")
        self.lblTrainingLog.text = getCommonString(key: "Training_Log_key")
    }
}
