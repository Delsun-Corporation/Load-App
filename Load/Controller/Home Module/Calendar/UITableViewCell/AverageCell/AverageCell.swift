//
//  AverageCell.swift
//  Load
//
//  Created by Haresh Bhai on 31/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AverageCell: UITableViewCell {

    @IBOutlet weak var lblThisWeek: UILabel!
    @IBOutlet weak var lblThisWeekKG: UILabel!
    @IBOutlet weak var lblThisWeekTime: UILabel!
    
    @IBOutlet weak var lblToday: UILabel!
    @IBOutlet weak var lblTodayKG: UILabel!
    @IBOutlet weak var lblTodayTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblThisWeek.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblThisWeekKG.font = themeFont(size: 30, fontname: .ProximaNovaBold)
        self.lblThisWeekTime.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        self.lblToday.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblTodayKG.font = themeFont(size: 30, fontname: .ProximaNovaBold)
        self.lblTodayTime.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        self.lblThisWeek.setColor(color: .appthemeBlackColor)
        self.lblThisWeekKG.setColor(color: .appthemeBlackColor)
        self.lblThisWeekTime.setColor(color: .appthemeBlackColor)
        self.lblToday.setColor(color: .appthemeBlackColor)
        self.lblTodayKG.setColor(color: .appthemeBlackColor)
        self.lblTodayTime.setColor(color: .appthemeBlackColor)

        self.lblThisWeek.text = getCommonString(key: "This_week_key")
        self.lblToday.text = getCommonString(key: "Today_key")
    }
}
