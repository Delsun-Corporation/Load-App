//
//  EventDescriptionCell.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventDescriptionCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblHostedBy: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(model:EventDetailsModelClass) {
        self.setupFont()
        self.imgProfile.sd_setImage(with: model.userDetail?.photo!.toURL(), completed: nil)
        self.lblName.text = model.userDetail?.name
        self.lblLocation.text = "Singapore"
        self.lblDescription.text = model.description
    }

    func setupUI(name:String, description:String) {
        self.setupFont()
        self.imgProfile.sd_setImage(with: getUserDetail().data?.user?.photo?.toURL(), completed: nil)
        self.lblName.text = name
        self.lblLocation.text = "Singapore"
        self.lblDescription.text = description
    }
    
    func setupFont() {
        self.imgProfile.setCircle()
        
        self.lblHostedBy.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblName.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblLocation.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        self.lblDescription.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblHostedBy.setColor(color: .appthemeBlackColor)
        self.lblName.setColor(color: .appthemeRedColor)
        self.lblLocation.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
        
        self.lblHostedBy.text = getCommonString(key: "Hosted_by_key")
    }
}
