  //
//  MessagesCell.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage

class MessagesCell: UITableViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var viewCount: CustomView!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(model: ConversationData) {
        self.setupFont()
        let id = getUserDetail().data?.user?.id
        let name = id == model.fromId ? model.toName : model.fromName
        self.lblName.text = name
        self.lblDescription.text = model.lastMessage
        self.viewCount.isHidden = id?.stringValue == model.fromId?.stringValue
        self.lblCount.text = model.unreadCount!.stringValue.toTrim()
        if model.unreadCount == 0 && id != model.fromId {
            self.viewCount.isHidden = true
        }
        let image = id == model.fromId ? model.toPhoto : model.fromPhoto
        self.imgProfile.sd_setImage(with: (SERVER_URL + image!).toURL(), completed: nil)
        self.lblDate.text = convertDateFormater(model.createdAt ?? "", format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", dateFormat: "HH:mm a")        
    }
    
    func setupFont() {        
        self.imgProfile.setCircle()
        
        self.lblCount.font = themeFont(size: 9, fontname: .Helvetica)
        self.lblName.font = themeFont(size: 14, fontname: .HelveticaBold)
        self.lblDescription.font = themeFont(size: 12, fontname: .Helvetica)
        self.lblDate.font = themeFont(size: 11, fontname: .Helvetica)
        
        self.lblCount.setColor(color: .appthemeWhiteColor)
        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColor)
    }
}
