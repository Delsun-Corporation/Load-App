//
//  ClientRequirementCell.swift
//  Load
//
//  Created by Haresh Bhai on 14/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ClientRequirementCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: MZSelectableLabel!

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
        let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: self.lblDescription.text!)
        attributedString.setColorForText(textForAttribute: "Load App Additional Terms of Service", withColor: UIColor.appthemeRedColor)
        attributedString.setColorForText(textForAttribute: "Booking Release and Waiver", withColor: UIColor.appthemeRedColor)
        attributedString.setColorForText(textForAttribute: "Cancellation Policy", withColor: UIColor.appthemeRedColor)
        self.lblDescription.attributedText = attributedString
        
        self.lblDescription.selectionHandler = { range, string in
            // Put up an alert with a message if it's not an URL
            
            let message = "You tapped \(string ?? "")"
            let alert = UIAlertView(title: "Hello", message: message, delegate: nil, cancelButtonTitle: "Dismiss", otherButtonTitles: "Done")
            alert.show()
        }
        
        if !self.lblDescription.isAutomaticForegroundColorDetectionEnabled {
            self.lblDescription.setSelectableRange(((self.lblDescription.attributedText?.string as NSString?)?.range(of: "Load App Additional Terms of Service"))!, hightlightedBackgroundColor: UIColor.appthemeRedColor)
            self.lblDescription.setSelectableRange(((self.lblDescription.attributedText?.string as NSString?)?.range(of: "Booking Release and Waiver"))!, hightlightedBackgroundColor: UIColor.appthemeRedColor)
            self.lblDescription.setSelectableRange(((self.lblDescription.attributedText?.string as NSString?)?.range(of: "Cancellation Policy"))!, hightlightedBackgroundColor: UIColor.appthemeRedColor)
        }
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 12, fontname: .Helvetica)
        self.lblDescription.font = themeFont(size: 10, fontname: .Helvetica)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appThemeDarkGrayColor)
    }
}
