//
//  SelectTrainingProgramView.swift
//  Load
//
//  Created by Haresh Bhai on 14/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SelectTrainingProgramView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubResistanceTitle: UILabel!
    @IBOutlet weak var lblResistanceTitle: UILabel!
    @IBOutlet weak var lblCardioTitle: UILabel!
    @IBOutlet weak var lblSubCardioTitle: UILabel!
    @IBOutlet weak var vwPreset: UIView!
    @IBOutlet weak var vwCustomize: UIView!
    @IBOutlet weak var constraintSubCardioHeight: NSLayoutConstraint!
    @IBOutlet weak var btnPreset: UIButton!
    @IBOutlet weak var btnCustomise: UIButton!
    @IBOutlet weak var imgPreset: UIImageView!
    @IBOutlet weak var imgPresetArrow: UIImageView!
    @IBOutlet weak var imgCustom: UIImageView!
    @IBOutlet weak var imgCustomArrow: UIImageView!
    
    //MARK:- Functions
    func setupUI(theController:SelectTrainingProgramVC) {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblResistanceTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblSubResistanceTitle.font = themeFont(size: 11, fontname: .ProximaNovaThin)
        self.lblCardioTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblSubCardioTitle.font = themeFont(size: 11, fontname: .ProximaNovaThin)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblResistanceTitle.setColor(color: .appthemeBlackColor)
        self.lblSubResistanceTitle.setColor(color: .appthemeBlackColor)
        self.lblCardioTitle.setColor(color: .appthemeBlackColor)
        self.lblSubCardioTitle.setColor(color: .appthemeBlackColor)
        
//        self.lblTitle.text = getCommonString(key: "Select_mode_for_your_program_key")
        self.lblResistanceTitle.text = getCommonString(key: "Preset_key")
        self.lblSubResistanceTitle.text = getCommonString(key: "Select_one_of_presets_on_the_list_key")
        self.lblCardioTitle.text = getCommonString(key: "Customise_key")
        self.lblSubCardioTitle.text = getCommonString(key: "Customise_your_own_training_program_key")
        
        self.vwPreset.isHidden = true
        self.vwCustomize.isHidden = true
    }
}
