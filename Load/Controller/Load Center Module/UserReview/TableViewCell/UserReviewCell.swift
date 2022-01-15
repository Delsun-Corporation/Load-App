//
//  UserReviewCell.swift
//  Load
//
//  Created by Haresh Bhai on 16/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class UserReviewCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblComment: TTTAttributedLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
//        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.width / 2
//        self.imgProfile.layer.masksToBounds = true
//        self.imgProfile.clipsToBounds = true
        self.imgProfile.setCircle()
        
        self.lblName.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblDate.font = themeFont(size: 11, fontname: .ProximaNovaThin)
        self.lblComment.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        
        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColor)
        self.lblComment.setColor(color: .appthemeBlackColor)
    }
}
