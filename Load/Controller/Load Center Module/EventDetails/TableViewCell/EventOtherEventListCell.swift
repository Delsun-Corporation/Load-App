//
//  EventOtherEventListCell.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView

class EventOtherEventListCell: UICollectionViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblreviewCount: UILabel!
    @IBOutlet weak var rateView: FloatRatingView!

    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI(model: NearestEvents) {
        self.setupFont()
        self.imgProfile.sd_setImage(with: model.eventImage!.toURL(), completed: nil)
        self.lblTitle.text = model.title
        self.lblName.text = model.eventName
        self.lblPrice.text = "$\(model.eventPrice!) per person"
        self.lblreviewCount.text = "0"
        self.rateView.rating = 0
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 9, fontname: .ProximaNovaRegular)
        self.lblName.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblPrice.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lblreviewCount.font = themeFont(size: 6, fontname: .ProximaNovaRegular)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblPrice.setColor(color: .appthemeBlackColor)
        self.lblreviewCount.setColor(color: .appthemeBlackColor)
    }
}
