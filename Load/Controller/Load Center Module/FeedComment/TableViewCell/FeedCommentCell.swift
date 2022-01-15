//
//  FeedCommentCell.swift
//  Load
//
//  Created by Haresh Bhai on 21/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FeedCommentCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
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
    
    func setupUI(model: FeedCommentListList) {
        self.setupFont()
        self.lblName.text = model.userDetail?.name
        self.imgProfile.sd_setImage(with: model.userDetail?.photo?.toURL(), placeholderImage: UIImage(named: "ic_menu_splash_holder"), options: .highPriority, completed: nil)
        self.lblDate.text = convertDateFormater(model.createdAt!, format: "yyyy-MM-dd HH:mm:ss", dateFormat: "MMM dd, yyyy")
        self.lblComment.text = model.comment
    }
    
    func setupFont() {
        self.imgProfile.setCircle()
        
        self.lblName.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblDate.font = themeFont(size: 9, fontname: .ProximaNovaRegular)
        self.lblComment.font = themeFont(size: 12, fontname: .ProximaNovaRegular)

        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColorAlpha50)
        self.lblComment.setColor(color: .appthemeBlackColor)
    }
}
