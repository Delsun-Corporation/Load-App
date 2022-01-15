//
//  SidemenuHeaderCell.swift
//  Load
//
//  Created by Haresh Bhai on 02/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage

class SidemenuHeaderCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblActive: UILabel!
    @IBOutlet weak var lblWallet: UILabel!
    @IBOutlet weak var lblPrice: UILabel!    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imgProfile.setCircle()
        self.imgProfile.layer.borderColor = UIColor.white.cgColor
        self.imgProfile.layer.borderWidth = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.setupFont()
        self.lblName.text = getUserDetail().data?.user?.name
        self.imgProfile.sd_setImage(with: getUserDetail().data?.user?.photo?.toURL(), completed: nil)
    }
    
    func setupFont() {
        self.lblName.font = themeFont(size: 15, fontname: .Regular)
        self.lblActive.font = themeFont(size: 13, fontname: .Regular)
        self.lblWallet.font = themeFont(size: 15, fontname: .Regular)
        self.lblPrice.font = themeFont(size: 20, fontname: .Regular)
        
        self.lblName.setColor(color: .appthemeWhiteColor)
        self.lblActive.setColor(color: .appthemeWhiteColor)
        self.lblWallet.setColor(color: .appthemeWhiteColor)
        self.lblPrice.setColor(color: .appthemeWhiteColor)
    }
    
}
