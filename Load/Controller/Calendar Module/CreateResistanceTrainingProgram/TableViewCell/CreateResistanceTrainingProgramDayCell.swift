//
//  MultiSelectionCell.swift
//  Load
//
//  Created by Haresh Bhai on 14/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol CreateResistanceTrainingProgramDayDelegate: class {
    func CreateResistanceTrainingProgramDayCellFinish(tag:Int)
}

class CreateResistanceTrainingProgramDayCell: UITableViewCell {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var viewLine: UIView!
    
    //MARK:- Variables
    weak var delegate:CreateResistanceTrainingProgramDayDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI(title:String, isSelected:Bool) {
        self.setupFont()
        self.lblTitle.text = title
        self.imgSelected.isHidden = !isSelected
        self.lblTitle.textColor = isSelected ? UIColor.appthemeRedColor : UIColor.appthemeBlackColor
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblTitle.setColor(color: .appthemeBlackColor)
    }
    
    //MARK:- @IBAction
    @IBAction func btnCellClicked(_ sender: Any) {
        self.delegate?.CreateResistanceTrainingProgramDayCellFinish(tag: self.tag)
    }
}
