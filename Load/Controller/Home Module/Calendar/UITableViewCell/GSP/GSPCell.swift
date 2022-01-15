//
//  GSPCell.swift
//  Load
//
//  Created by Haresh Bhai on 31/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class GSPCell: UITableViewCell {
    
    @IBOutlet weak var lblG: UILabel!
    @IBOutlet weak var lblS: UILabel!
    @IBOutlet weak var lblP: UILabel!
    
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
        self.lblG.font = themeFont(size: 16, fontname: .Regular)
        self.lblS.font = themeFont(size: 16, fontname: .Regular)
        self.lblP.font = themeFont(size: 16, fontname: .Regular)
        
        self.lblG.setColor(color: .appthemeWhiteColor)
        self.lblS.setColor(color: .appthemeWhiteColor)
        self.lblP.setColor(color: .appthemeWhiteColor)
        
        self.lblG.text = getCommonString(key: "G_key")
        self.lblS.text = getCommonString(key: "S_key")
        self.lblP.text = getCommonString(key: "P_key")
    }    
}
