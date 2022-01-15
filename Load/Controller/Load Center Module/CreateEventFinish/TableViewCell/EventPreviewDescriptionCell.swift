//
//  EventDescriptionCell.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventPreviewDescriptionCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblHostedBy: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPricePerson: UILabel!

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

    func setupUI(title: String, pricePerson: String, description:String) {
        self.setupFont()
        self.lblTitle.text = title.capitalized
        self.lblPricePerson.text = "$" + pricePerson + " per person"
        self.imgProfile.sd_setImage(with: getUserDetail().data?.user?.photo?.toURL(), completed: nil)
        self.lblName.text = getUserDetail().data?.user?.name
        self.lblLocation.text = "Singapore"
        self.lblDescription.text = description
    }
    
    func setupFont() {
        self.imgProfile.setCircle()
        
        self.lblTitle.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblPricePerson.font = themeFont(size: 12, fontname: .ProximaNovaBold)

        self.lblHostedBy.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblName.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblLocation.font = themeFont(size: 12, fontname: .ProximaNovaThin)
        self.lblDescription.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblPricePerson.setColor(color: .appthemeRedColor)

        self.lblHostedBy.setColor(color: .appthemeBlackColor)
        self.lblName.setColor(color: .appthemeRedColor)
        self.lblLocation.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
        
        self.lblHostedBy.text = getCommonString(key: "Hosted_by_key")
    }
}
