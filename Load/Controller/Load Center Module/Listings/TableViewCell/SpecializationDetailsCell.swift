//
//  SpecializationDetailsCell.swift
//  Load
//
//  Created by Haresh Bhai on 24/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SpecializationDetailsCell: UICollectionViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: CustomButton!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        // Initialization code
    }
    
    func setupFont() {
        self.lblTitle.titleLabel?.font = themeFont(size: 13, fontname: .ProximaNovaRegular)    
        self.lblTitle.setColor(color: .appthemeWhiteColor)
    }
}
