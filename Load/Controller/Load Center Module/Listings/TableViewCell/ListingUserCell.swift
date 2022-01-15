//
//  ListingUserCell.swift
//  Load
//
//  Created by Haresh Bhai on 20/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage
import FloatRatingView

class ListingUserCell: UICollectionViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgVerified: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewRate: FloatRatingView!
    @IBOutlet weak var lblSession: UILabel!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupUI(model: ProfessionalData) {
        self.setupFont()
        self.setupRating(rate: 0)
        self.imgProfile.sd_setImage(with: model.userDetail?.photo!.toURL(), completed: nil)
        self.lblName.text = model.userDetail?.name
        self.lblSession.text = "$0/session"
    }
    
    func setupRating(rate:Double) {
        viewRate.delegate = self
        viewRate.contentMode = UIView.ContentMode.scaleAspectFit
        viewRate.type = .wholeRatings
        viewRate.rating = rate
    }
  
    func setupFont() {
        self.imgProfile.roundCorners(corners: [.topLeft, .topRight], radius: 3)

        self.lblName.font = themeFont(size: 14, fontname: .ProximaNovaBold)
        self.lblSession.font = themeFont(size: 13, fontname: .ProximaNovaRegular)

        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblSession.setColor(color: .appthemeRedColor)
    }
}


extension ListingUserCell: FloatRatingViewDelegate {    
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
    }
}

