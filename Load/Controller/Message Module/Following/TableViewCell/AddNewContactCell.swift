//
//  AddNewContactCell.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AddNewContactCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblAdd: UILabel!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFont() {        
        self.lblAdd.font = themeFont(size: 13, fontname: .Helvetica)
        self.lblAdd.setColor(color: .appthemeRedColor)
    }
}
