//
//  UserProfileFollowListTblCell.swift
//  Load
//
//  Created by Yash on 30/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class UserProfileFollowListTblCell: UITableViewCell {

    //MARK:- Outlet
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblNation: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    
    //MARK:- View life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFont(){
        
        imgUser.setCircle()

        lblUserName.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        lblNation.font = themeFont(size: 11, fontname: .ProximaNovaThin)
        btnFollow.titleLabel?.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        
        self.lblUserName.textColor = .appthemeBlackColor
        self.lblNation.textColor = .appthemeBlackColor
        self.btnFollow.setColor(color: .appthemePinkColor)
    }
    
}
