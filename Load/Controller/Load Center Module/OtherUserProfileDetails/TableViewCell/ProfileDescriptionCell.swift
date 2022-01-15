//
//  ProfileDescriptionCell.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfileDescriptionCell: UITableViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var bottomHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(model:[SpecializationDetails]) {
        self.lblDescription.text = self.getSpecializations(model: model)
        bottomHeight.constant = 31
    }
    
    func setupFont() {
        self.lblDescription.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblDescription.setColor(color: .appthemeBlackColor)
    }
    
    func getSpecializations(model:[SpecializationDetails]) -> String {
        var str:String = ""
        for data in model {
            str += (data.name! + ", ")
        }
        str = str.toTrim()
        return String(str.dropLast())
    }
}
