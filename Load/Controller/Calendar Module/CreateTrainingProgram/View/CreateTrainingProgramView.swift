//
//  CreateTrainingProgramView.swift
//  Load
//
//  Created by Haresh Bhai on 14/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateTrainingProgramView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblResistanceTitle: UILabel!
    @IBOutlet weak var lblCardioTitle: UILabel!
    @IBOutlet weak var lblEditResistance: UILabel!
    @IBOutlet weak var lblEditCardio: UILabel!
    @IBOutlet weak var lblDeleteResistance: UILabel!
    @IBOutlet weak var lblDeleteCardio: UILabel!

    @IBOutlet weak var vwResistance: UIView!
    @IBOutlet weak var vwCardio: UIView!
    @IBOutlet weak var vwEditResistance: UIView!
    @IBOutlet weak var vwEditCardio: UIView!
    @IBOutlet weak var vwDeleteResistance: UIView!
    @IBOutlet weak var vwDeleteCardio: UIView!
    
    //MARK:- Functions
    func setupUI(theController:CreateTrainingProgramVC) {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
//        self.lblResistanceTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
//        self.lblCardioTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        self.lblTitle.setColor(color: .appthemeBlackColor)
//        self.lblResistanceTitle.setColor(color: .appthemeBlackColor)
//        self.lblCardioTitle.setColor(color: .appthemeBlackColor)
        
//        self.lblTitle.text = getCommonString(key: "Select_type_of_program_you_want_to_create_key")
        self.lblResistanceTitle.text = getCommonString(key: "Resistance_key")
        self.lblCardioTitle.text = getCommonString(key: "Cardio_key")
        self.lblEditResistance.text = getCommonString(key: "Edit_Resistance_Program_key")
        self.lblEditCardio.text = getCommonString(key: "Edit_Cardio_Program_key")
        self.lblDeleteResistance.text = getCommonString(key: "Delete_Resistance_Program_key")
        self.lblDeleteCardio.text = getCommonString(key: "Delete_Cardio_Program_key")

        [self.lblResistanceTitle,self.lblCardioTitle,self.lblEditResistance,self.lblEditCardio,self.lblDeleteResistance,self.lblDeleteCardio].forEach { (lbl) in
            lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            lbl?.setColor(color: .appthemeBlackColor)
        }
        
        [self.vwCardio,self.vwResistance,self.vwEditCardio,self.vwEditResistance,self.vwDeleteCardio,self.vwDeleteResistance].forEach { (vw) in
            vw?.isHidden = true
        }
        
    }
}
