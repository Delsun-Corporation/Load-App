//
//  ProfessionalListCell.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class UnitListCell: UITableViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var imgCheckMark: UIImageView!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
        // Configure the view for the selected state
    }
    
    func setupUI(model: UnitsData, selectedId:Int) {
        self.setupFont()
        self.lblTitle.text = model.name
        self.lblSubTitle.text = model.description
        self.imgCheckMark.isHidden = selectedId != model.id
    }   
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblSubTitle.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblSubTitle.setColor(color: .appthemeBlackColor)
    }
}
