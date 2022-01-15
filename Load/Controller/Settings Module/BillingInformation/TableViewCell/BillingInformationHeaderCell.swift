//
//  BillingInformationHeaderCell.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class BillingInformationHeaderCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        // Initialization codeZ
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(title:String) {
        self.lblTitle.text = title
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeBlackColorAlpha30)
    }
}
