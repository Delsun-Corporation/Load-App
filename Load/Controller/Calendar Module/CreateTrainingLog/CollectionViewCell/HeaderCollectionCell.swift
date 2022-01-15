//
//  HeaderCollectionCell.swift
//  Load
//
//  Created by iMac on 05/02/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class HeaderCollectionCell: UICollectionViewCell {

    //MARK: - Outlet
    
    @IBOutlet weak var btnImageWithTitle: UIButton!
    
    //MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        btnImageWithTitle.setTitleColor(UIColor.appthemeBlackColor, for: .normal)
        btnImageWithTitle.setTitleColor(UIColor.appthemeRedColor, for: .selected)
        
        // Initialization code
    }

}
