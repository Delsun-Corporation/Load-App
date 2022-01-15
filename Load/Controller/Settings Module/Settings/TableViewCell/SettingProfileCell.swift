//
//  SettingProfileCell.swift
//  Load
//
//  Created by Haresh Bhai on 22/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage

class SettingProfileCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEditProfile: UILabel!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.setupFont()
        self.imgProfile.sd_setImage(with: getUserDetail().data?.user?.photo?.toURL(), completed: nil)
        self.lblName.text = getUserDetail().data?.user?.name
    }
    
    func setupFont() {
        self.imgProfile.setCircle()
        self.imgProfile.layer.borderColor = UIColor.appthemeOffRedColor.cgColor
        self.imgProfile.layer.borderWidth = 2
        
        self.lblName.font = themeFont(size: 20, fontname: .ProximaNovaRegular)
        self.lblEditProfile.font = themeFont(size: 13, fontname: .ProximaNovaRegular)

        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblEditProfile.setColor(color: .appthemeBlackColor)
    }
}
