//
//  EventAmenitiesHeaderCell.swift
//  Load
//
//  Created by Haresh Bhai on 26/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventAmenitiesHeaderCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!

    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 20, fontname: .HelveticaBold)
        self.lblSubTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblSubTitle.setColor(color: .appthemeBlackColorAlpha30)
        
        self.lblTitle.text = getCommonString(key: "What_would_you_provide_key")
        self.lblSubTitle.text = getCommonString(key: "What_are_the_amenities_available_key")
    }
}
