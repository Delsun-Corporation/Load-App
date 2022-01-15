//
//  IntroductionPremiumCell.swift
//  Load
//
//  Created by Yash on 01/07/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class IntroductionPremiumCell: UITableViewCell {

    //MARK:- Outlet
    
    @IBOutlet weak var lblValue: UILabel!
    
    //MARK:- View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFont(){
        
        lblValue.textColor = .appthemeBlackColor
        lblValue.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
    }
    
    
}
