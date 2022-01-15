//
//  SelectFormAutoSendCell.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SelectFormAutoSendCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    
    @IBOutlet weak var lblSetAsCompulsory: UILabel!
    @IBOutlet weak var lblCompulsoryDescription: UILabel!
    @IBOutlet weak var btnSwitchCompulsory: UIButton!
    
    //MARK:- Variables
    weak var delegate: SelectFormCellDelegate?

    //MARK:- Functions
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
        
        self.lblTitle.text = getCommonString(key: "Auto_send_key")
        self.lblDescription.text = getCommonString(key: "Auto_send_description_msg")
        
        self.lblSetAsCompulsory.text = getCommonString(key: "Set_as_compulsary_key")
        self.lblCompulsoryDescription.text = getCommonString(key: "Set_compulsory_description_key")
        
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblDescription.font = themeFont(size: 11, fontname: .ProximaNovaThin)
        
        self.lblSetAsCompulsory.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblCompulsoryDescription.font = themeFont(size: 11, fontname: .ProximaNovaThin)
        
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
        
        self.lblSetAsCompulsory.setColor(color: .appthemeBlackColor)
        self.lblCompulsoryDescription.setColor(color: .appthemeBlackColor)
        
    }

    //MARK: - IBAction method
    
    @IBAction func btnSwitchClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.SelectFormAutoSendFinish(isAuto: sender.isSelected)
    }
    
    @IBAction func btnSwitchCompulsoryTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.SelectFromSetAsCompulsory(isAuto: sender.isSelected)
    }
    
}
