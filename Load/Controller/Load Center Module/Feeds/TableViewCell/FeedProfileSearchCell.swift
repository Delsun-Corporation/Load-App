//
//  FeedProfileSearchCell.swift
//  Load
//
//  Created by Haresh Bhai on 21/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView

class FeedProfileSearchCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblReviewCount: UILabel!
    @IBOutlet weak var rateView: FloatRatingView!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(model: LoadCenterFeedList) {
        self.setupFont()
        self.imgProfile.sd_setImage(with: model.photo?.toURL(), completed: nil)
        self.lblName.text = model.name
        self.lblLocation.text = model.countryDetail?.name
        self.rateView.rating = 0
        self.rateView.isUserInteractionEnabled = false
        self.lblPrice.text = "$" + (model.profileDetail?.rate)!
    }
    
    
    func setupFont() {
        self.lblName.font = themeFont(size: 12, fontname: .HelveticaBold)
        self.lblLocation.font = themeFont(size: 9, fontname: .Helvetica)
        self.lblReviewCount.font = themeFont(size: 10, fontname: .HelveticaBold)
        self.lblPrice.font = themeFont(size: 15, fontname: .Helvetica)
        
        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblLocation.setColor(color: .appthemeBlackColorAlpha30)
        self.lblReviewCount.setColor(color: .appthemeBlackColor)
        self.lblPrice.setColor(color: .appthemeBlackColor)
        self.imgProfile.setCircle()
    }
}
