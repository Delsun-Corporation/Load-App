//
//  AutoTopUpBillingTitleCell.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AutoTopUpBillingTitleCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var imgRight: UIImageView!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
        // Configure the view for the selected state
    }
    
    func setupUI() {
        setupFont()
    }
    
    func setupFont() {
        self.lblTitle1.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTitle2.font = themeFont(size: 14, fontname: .ProximaNovaBold)
        
        self.lblTitle1.setColor(color: .appthemeBlackColor)
        self.lblTitle2.setColor(color: .appthemeBlackColor)
    }
}
