//
//  PhysicalActivityInfoTblCell.swift
//  Load
//
//  Created by Yash on 09/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class PhysicalActivityInfoTblCell: UITableViewCell {

    //MARK: - Outlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var vwLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblTitle.textColor = .appthemeBlackColor
        
        self.lblDescription.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblDescription.textColor = .appthemeBlackColor
        
        // Initialization code
    }

    func setupUI(model: UnitsData) {
        self.lblTitle.text = model.title
        self.lblDescription.text = model.description
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
