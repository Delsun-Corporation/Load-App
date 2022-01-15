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

class ProfileUserCell: UICollectionViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblVerified: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var viewRate: FloatRatingView!
    @IBOutlet weak var lblSession: UILabel!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupUI(model: NearestProfessionalProfile) {
        self.setupFont()
            self.setupRating(rate: Double(model.rate ?? "0") ?? 0)
        self.imgProfile.sd_setImage(with: model.userDetail?.photo!.toURL(), completed: nil)
        self.lblVerified.text = "Verified"
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

        self.lblVerified.font = themeFont(size: 7, fontname: .Helvetica)
        self.lblName.font = themeFont(size: 12, fontname: .Helvetica)
        self.lblSession.font = themeFont(size: 8, fontname: .Helvetica)

        self.lblVerified.setColor(color: .appthemeWhiteColor)
        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblSession.setColor(color: .appthemeRedColor)
    }   
}


extension ProfileUserCell: FloatRatingViewDelegate {
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
    }
}

