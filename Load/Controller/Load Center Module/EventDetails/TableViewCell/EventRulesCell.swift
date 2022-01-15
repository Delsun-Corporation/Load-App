//
//  EventRulesCell.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventRulesCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!

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
        self.lblTitle.text = "General rules"
        self.lblDescription.text = "General rules General rules General rules General rules General rules General rules General rules General rules"
    }
    
    func setupUI(title:String, description: String) {
        self.setupFont()
        self.lblTitle.text = title
        self.lblDescription.text = description
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 14, fontname: .ProximaNovaBold)
        self.lblDescription.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
       
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
    }
}
