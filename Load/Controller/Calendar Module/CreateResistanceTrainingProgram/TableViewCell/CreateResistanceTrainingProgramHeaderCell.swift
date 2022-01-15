//
//  CreateCardioTrainingProgramHeaderCell.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateResistanceTrainingProgramHeaderCell: UITableViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!

    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(model: ResistancePresetTrainingProgram) {
        self.setupFont()
        self.lblTitle.text = model.title!.capitalized
        self.lblSubTitle.text = model.subtitle
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblSubTitle.font = themeFont(size: 13, fontname: .ProximaNovaRegular)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblSubTitle.setColor(color: .appThemeDarkGrayColor)
    }
}
