//
//  AddExerciseFinishHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AddExerciseFinishHeaderView: UIView {
    
    // MARK: @IBOutlet
    @IBOutlet weak var lblRepetition: UILabel!    
    @IBOutlet weak var lblWeight: UILabel!
    
    // MARK: Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "AddExerciseFinishHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AddExerciseFinishHeaderView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
    }
    
    func setupUI() {
        self.setFrame()
        self.setupFont()
    }
    
    func setupFont() {
        self.lblRepetition.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblWeight.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        self.lblRepetition.setColor(color: .appthemeBlackColor)
        self.lblWeight.setColor(color: .appthemeBlackColor)
        
        self.lblRepetition.text = getCommonString(key: "Repetition_Max_key")
        self.lblWeight.text = getCommonString(key: "Weight_(kg)_key")
    }
}
