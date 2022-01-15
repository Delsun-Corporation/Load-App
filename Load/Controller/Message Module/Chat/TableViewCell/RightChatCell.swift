//
//  RightChatCell.swift
//  Load
//
//  Created by Haresh Bhai on 29/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class RightChatCell: UITableViewCell {

    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
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
        self.lblMessage.font = themeFont(size: 12, fontname: .Helvetica)
        self.lblDate.font = themeFont(size: 8, fontname: .Helvetica)
        
        self.lblMessage.setColor(color: .appthemeWhiteColor)
        self.lblDate.setColor(color: .appthemeWhiteColor)
    }
}
