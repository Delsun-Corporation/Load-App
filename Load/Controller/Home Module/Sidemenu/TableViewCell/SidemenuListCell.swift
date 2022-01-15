//
//  SidemenuListCell.swift
//  Load
//
//  Created by Haresh Bhai on 02/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SidemenuListCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
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
        self.lblTitle.font = themeFont(size: 15, fontname: .Regular)
        self.lblTitle.setColor(color: .appthemeBlackColor)
    }
}
