//
//  CreateCardioTrainingProgramHeaderCell.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateCardioTrainingProgramHeaderCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(model: CardioPresetTrainingProgram) {
        self.setupFont()
        self.lblTitle.text = model.title!.capitalized + " training program"
        self.lblSubTitle.text = model.subtitle
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblTitle.setColor(color: .appthemeBlackColor)
        
        self.lblSubTitle.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblSubTitle.setColor(color: .appthemeBlackColor)
    }
}
