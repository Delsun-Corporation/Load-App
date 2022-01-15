//
//  NotificationCell.swift
//  Load
//
//  Created by Haresh Bhai on 10/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var viewRead: CustomView!
    @IBOutlet weak var lblTitleLeft: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(model: NotificationList) {
        self.setupFont()
        self.lblTitle.text = model.title
        self.lblDescription.text = model.id?.stringValue//model.message ?? ""
        if model.readAt != nil {
            self.showRead(isShow: false)
        }
        else {
            self.showRead()
        }
    }
    
    func showRead(isShow:Bool = true) {
        self.lblTitleLeft.constant = isShow ? 30 : 20
        self.viewRead.isHidden = isShow ? false : true
        self.lblTitle.setColor(color: isShow ? .appthemeBlackColor : .appThemeDarkGrayColor)
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 13, fontname: .HelveticaBold)
        self.lblDescription.font = themeFont(size: 12, fontname: .Helvetica)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appThemeDarkGrayColor)
    }
}
