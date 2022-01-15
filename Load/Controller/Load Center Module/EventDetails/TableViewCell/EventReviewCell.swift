//
//  EventReviewCell.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventReviewCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblComment: UILabel!
    
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
        self.imgProfile.sd_setImage(with: TEST_IMAGE_URL.toURL(), completed: nil)
        self.lblComment.text = "I’m a sport physiologist with 5 years experience, focusing in strength and conditioning for atheletes. I’m an national Kendo athelete myself, and that makes me easier to relate to my client reaching their potential. My style of coaching is quite unorthodoxt …. "
    }
    
    func setupFont() {
        self.imgProfile.setCircle()
        self.lblName.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblLocation.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lblComment.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblLocation.setColor(color: .appthemeBlackColor)
        self.lblComment.setColor(color: .appthemeBlackColor)
    }
}
