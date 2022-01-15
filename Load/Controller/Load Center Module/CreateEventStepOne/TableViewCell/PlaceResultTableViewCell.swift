//
//  CreateEventStepOneVC.swift
//  Load
//
//  Created by Haresh Bhai on 26/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import GooglePlacePicker

class PlaceResultTableViewCell: UITableViewCell {

    @IBOutlet weak var lblSecondaryText: UILabel!
    @IBOutlet weak var lblPrimaryText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTheData(theData:GMSAutocompletePrediction) {
        let types = theData.types
        print(types)
        lblPrimaryText.attributedText = theData.attributedPrimaryText
        lblSecondaryText.attributedText = theData.attributedSecondaryText
    }
}
