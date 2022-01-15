//
//  CreateLoadCenterView.swift
//  Load
//
//  Created by Haresh Bhai on 22/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateLoadCenterView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblRequests: UILabel!
    @IBOutlet weak var lblEvent: UILabel!
    
    //MARK:- Functions
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblRequests.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblEvent.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        
        self.lblRequests.setColor(color: .appthemeRedColor)
        self.lblEvent.setColor(color: .appthemeRedColor)
        
        self.lblRequests.text = getCommonString(key: "Requests_key")
        self.lblEvent.text = getCommonString(key: "Event_key")
    }
}
