//
//  TimeUnderTensionInfoTblCell.swift
//  Load
//
//  Created by Yash on 15/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class TimeUnderTensionInfoTblCell: UITableViewCell {

    //MARK: - Outlet
    
    @IBOutlet weak var lblIntensity: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblTempo: UILabel!
    
    //MARK: - View life cycle
    
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
        
        lblIntensity.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        lblDescription.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        lblTempo.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        [self.lblIntensity, self.lblDescription, self.lblTempo].forEach { (lbl) in
            lbl?.textColor = .appthemeBlackColor
        }
    }
    
    func setupUI(data:TimeUnderTensionList) {
        
        self.lblIntensity.text = data.intensity + " " + getCommonString(key: "Intensity_key")
        self.lblDescription.text = data.description
        self.lblTempo.text = getCommonString(key: "Recommended_tempo_key") + "  " + data.tempo
        
    }
    
}
