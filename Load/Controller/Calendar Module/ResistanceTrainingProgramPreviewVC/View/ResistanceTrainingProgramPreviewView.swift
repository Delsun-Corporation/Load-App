//
//  ResistanceTrainingProgramPreviewView.swift
//  Load
//
//  Created by Haresh Bhai on 24/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ResistanceTrainingProgramPreviewView: UIView {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var txtStartDate: UITextField!
    
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var txtEndate: UITextField!
    
    @IBOutlet weak var lblFrequency: UILabel!
    @IBOutlet weak var txtFrequency: UITextField!
    @IBOutlet weak var lblFrequencySelected: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK: - Functions          
    func setupUI(theController:ResistanceTrainingProgramPreviewVC) {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblSubTitle.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblStartDate.font = themeFont(size: 14, fontname: .ProximaNovaBold)
        self.txtStartDate.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblEndDate.font = themeFont(size: 14, fontname: .ProximaNovaBold)
        self.txtEndate.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblFrequency.font = themeFont(size: 14, fontname: .ProximaNovaBold)
        self.txtFrequency.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblFrequencySelected.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblSubTitle.setColor(color: .appthemeBlackColor)
        self.lblStartDate.setColor(color: .appthemeBlackColor)
        self.txtStartDate.setColor(color: .appthemeBlackColor)
        self.lblEndDate.setColor(color: .appthemeBlackColor)
        self.txtEndate.setColor(color: .appthemeBlackColor)
        self.lblFrequency.setColor(color: .appthemeBlackColor)
        self.txtFrequency.setColor(color: .appthemeBlackColor)
        self.lblFrequencySelected.setColor(color: .appthemeBlackColor)
        
        self.btnSave.setColor(color: .appthemeWhiteColor)
        self.btnSave.setTitle(str: getCommonString(key: "Save_program_key"))
    }
}
