//
//  AmenitiesCell.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AmenitiesCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle1: UILabel!
    @IBOutlet weak var lblTitle2: UILabel!
    @IBOutlet weak var viewBottom: NSLayoutConstraint!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(lblTitle1:String, lblTitle2:String) {
        self.setupFont()
        self.lblTitle1.text = lblTitle1
        self.lblTitle2.text = lblTitle2
    }
    
    func setupFont() {
        self.lblTitle1.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTitle2.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTitle1.setColor(color: .appthemeBlackColor)
        self.lblTitle2.setColor(color: .appthemeBlackColor)
    }
}
