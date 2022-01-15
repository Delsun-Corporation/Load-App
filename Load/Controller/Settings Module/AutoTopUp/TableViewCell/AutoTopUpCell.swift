//
//  ProfessionalLoadCenterAutoAcceptCell.swift
//  Load
//
//  Created by Haresh Bhai on 04/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol AutoTopUpDelegate: class {
    func AutoTopUpFinish(isSelected:Bool)
}

class AutoTopUpCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    
    //MARK:- Variables
    weak var delegate:AutoTopUpDelegate?

    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(indexPath: IndexPath, title: String) {
        self.setupFont()
        self.tag = indexPath.section
        self.lblTitle.text = title
        self.lblDescription.text = getCommonString(key: "AutoTopUp_key")
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblDescription.font = themeFont(size: 11, fontname: .ProximaNovaRegular)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
    }
    
    //MARK:- @IBAction
    @IBAction func btnSwitchClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.AutoTopUpFinish(isSelected: sender.isSelected)
    }
}
