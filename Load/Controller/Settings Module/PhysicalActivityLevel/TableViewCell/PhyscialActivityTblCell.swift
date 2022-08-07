//
//  PhyscialActivityTblCell.swift
//  Load
//
//  Created by iMac on 20/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class PhyscialActivityTblCell: UITableViewCell {

    //MARK: - SetupUI
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgRightBlank: UIImageView!
    @IBOutlet weak var vwLine: UIView!
    
    
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
        lblName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        lblName.textColor = .appthemeBlackColor
    }
    
    func setupUI(model: UnitsData) {
        self.lblName.text = model.title
        imgRightBlank.image = model.isSelected ? UIImage(named: "ic_lap_completed") : nil
    }
    
}
