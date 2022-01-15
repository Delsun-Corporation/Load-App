//
//  SelectLocationProgramView.swift
//  Load
//
//  Created by Yash on 16/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class SelectLocationProgramView: UIView {

    //MARK: - Outlet
    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblIndoor: UILabel!
    @IBOutlet weak var lblOutdoor: UILabel!
    
    //MARK: - SetupUI
    
    func setupUI(){
        
        lblQuestion.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        lblQuestion.textColor = .appthemeBlackColor
        
        [self.lblIndoor,self.lblOutdoor].forEach { (lbl) in
            lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            lbl?.textColor = .appthemeBlackColor
        }
        
        lblQuestion.text = getCommonString(key: "Where_would_you_be_running?_key")
        lblIndoor.text = getCommonString(key: "Indoor_key")
        lblOutdoor.text = getCommonString(key: "Outdoor_key")
    }
    
}
