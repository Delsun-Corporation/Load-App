//
//  EventAmenitiesCell.swift
//  Load
//
//  Created by Haresh Bhai on 26/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class EventAmenitiesCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblAmenities: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    
    //MARK:- Variables
    weak var delegate:EventListDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btnSwitch.isSelected = true
        self.setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    
    func setupUI(str: String, indexPath: IndexPath) {
        self.lblAmenities.text = str
        self.tag = indexPath.row
    }
    
    func setupFont() {
        self.lblAmenities.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblAmenities.setColor(color: .appthemeBlackColor)
    }
    
    //MARK:- @IBAction
    @IBAction func btnSwitchClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.EventAmentiesDidFinish(tag: self.tag, isOn: sender.isSelected)
    }
}
