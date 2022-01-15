//
//  RPMTblCell.swift
//  Load
//
//  Created by iMac on 27/04/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class RPETblCell: UITableViewCell {

    //MARK: - Outlet
    
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblTextData: UILabel!
    
    //MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lblNumber.font = themeFont(size: 20, fontname: .ProximaNovaRegular)
        lblTextData.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        lblNumber.textColor = UIColor.appthemeBlackColor
        lblTextData.textColor = UIColor.appthemeBlackColor
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
