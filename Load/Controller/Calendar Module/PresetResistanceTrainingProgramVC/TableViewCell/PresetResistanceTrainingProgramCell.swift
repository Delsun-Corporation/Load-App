//
//  PresetTrainingProgramCell.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class PresetResistanceTrainingProgramCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(model: ResistancePresetTrainingProgram) {
        self.lblTitle.text = model.title
        self.setupFont()
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblTitle.setColor(color: .appthemeBlackColor)
    }
}
