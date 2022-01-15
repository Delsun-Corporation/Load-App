//
//  SavedWorkoutCell.swift
//  Load
//
//  Created by Haresh Bhai on 10/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SavedWorkoutCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(model: SaveWorkoutList?) {
        self.setupFont()
        self.lblTitle.text = model?.workoutName ?? ""
        self.lblDescription.text = model?.notes ?? ""
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 13, fontname: .HelveticaBold)
        self.lblDescription.font = themeFont(size: 12, fontname: .Helvetica)
        
        self.lblTitle.setColor(color: .appthemeRedColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
    }
}
