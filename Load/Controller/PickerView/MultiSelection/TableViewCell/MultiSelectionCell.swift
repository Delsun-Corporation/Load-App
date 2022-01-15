//
//  MultiSelectionCell.swift
//  Load
//
//  Created by Haresh Bhai on 14/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class MultiSelectionCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgSelect: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vwLine: UIView!
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(index: IndexPath, data: MultiSelectionDataEntry, theController: MultiSelectionVC) {
        self.selectionStyle = .none
        self.setupFont()
        self.tag = index.row
        self.lblTitle.text = data.title
        self.imgSelect.image = data.isSelected ? UIImage(named: "ic_round_check_box_select") : nil
        self.lblTitle.textColor = data.isSelected ? UIColor.appthemeOffRedColor : UIColor.appthemeBlackColor
    }
    
    func setupFont() {
     
    }
    
}
