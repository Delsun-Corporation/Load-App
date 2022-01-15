//
//  EventPremiumCollectionCell.swift
//  Load
//
//  Created by Yash on 02/07/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView

class EventPremiumCollectionCell: UICollectionViewCell {
    
    //MARK:- Outlet

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var vwBottomDetail: CustomView!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var vwRatting: FloatRatingView!
    
    //MARK:- View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imgProfile.clipsToBounds = false
        self.imgProfile.layer.cornerRadius = 10
        self.imgProfile.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        self.vwBottomDetail.setShadowToView()
        self.vwBottomDetail.cornerRadius = 10
        
        // Initialization code
    }

}
