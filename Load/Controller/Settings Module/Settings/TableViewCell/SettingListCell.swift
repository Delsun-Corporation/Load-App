//
//  SettingListCell.swift
//  Load
//
//  Created by Haresh Bhai on 22/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SettingListCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblName: UILabel!    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgNext: UIImageView!
    @IBOutlet weak var imgLine: UIView!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(name: String, indexPath:IndexPath) {
        self.setupFont()
        self.lblName.text = name
        
        self.imgNext.isHidden = false
        self.lblType.isHidden = true
        self.imgLine.isHidden = false

        if indexPath.row == 1 {
            self.lblType.isHidden = false
            if let _accountId = getUserDetail()?.data?.user?.accountId {
                self.lblType.text = getAccountName(id: _accountId)
            }
            else if let _accountId = getUserDetail()?.data?.user?.accountIdStr {
                self.lblType.text = getAccountName(idStr: _accountId)
            }
        }
        else if indexPath.row == 3 {
            self.lblType.isHidden = false
            self.lblType.text = ""
        }
        else if indexPath.row == 8 {
            self.imgNext.isHidden = true
        }
        else if indexPath.row == 10 {
            self.imgNext.isHidden = true
            self.imgLine.isHidden = true
        }
    }
    
    func setupFont() {
        self.lblName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblType.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblType.setColor(color: .appthemeRedColor)
    }
}
