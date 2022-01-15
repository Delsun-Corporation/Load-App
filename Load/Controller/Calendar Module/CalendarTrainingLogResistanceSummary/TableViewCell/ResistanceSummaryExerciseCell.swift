//
//  ResistanceSummaryExerciseCell.swift
//  Load
//
//  Created by iMac on 20/05/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class ResistanceSummaryExerciseCell: UITableViewCell {

    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtReps: UITextField!
    @IBOutlet weak var txtRest: UITextField!
    @IBOutlet weak var vwUnderline: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.txtWeight.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtReps.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtRest.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.txtWeight.setColor(color: .appthemeBlackColor)
        self.txtReps.setColor(color: .appthemeBlackColor)
        self.txtRest.setColor(color: .appthemeBlackColor)
    }
    
    func setupData(data:DataExercise?){
        
        self.txtWeight.text = data?.weight
        self.txtRest.text = data?.rest
        
        if data?.reps != "" {
            self.txtReps.text = data?.reps
        }else{
            self.txtReps.text = data?.rest
        }
    }

}
