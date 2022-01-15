//
//  CountryCodeCell.swift
//  Load
//
//  Created by Haresh Bhai on 25/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CountryCodeCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var lblCode: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}
