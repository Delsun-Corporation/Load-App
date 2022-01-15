//
//  TrainingLogCell.swift
//  Load
//
//  Created by Haresh Bhai on 30/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class TrainingLogCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
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
        self.lblTitle.font = themeFont(size: 12, fontname: .Helvetica)
        self.lblName.font = themeFont(size: 12, fontname: .Helvetica)
        
        self.lblTitle.setColor(color: .appthemeLightGrayColor)
        self.lblName.setColor(color: .appthemeBlackColor)
    }
}
