//
//  ScheduleManagementTblCell.swift
//  Load
//
//  Created by Yash on 17/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class ScheduleManagementTblCell: UITableViewCell {

    //MARK:- outlet
    
    @IBOutlet weak var lblAdvanceVAlue: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var imgCheckMark: UIImageView!
    
    //MARK:- View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - SetupFont
    
    func setupUI(data:ProfessionalScheduleAdvanceBooking?) {
        
        self.lblAdvanceVAlue.text = data?.description ?? ""
        
        if data?.selected == 0 {
            self.lblAdvanceVAlue.textColor = .appthemeBlackColor
            self.imgCheckMark.isHidden = true
        } else {
            self.lblAdvanceVAlue.textColor = .appthemeOffRedColor
            self.imgCheckMark.isHidden = false
        }
        
    }
    
    func setupFont(){
//        self.lblAdvanceVAlue.textColor = UIColor.appthemeBlackColor
        self.lblAdvanceVAlue.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
    }
}
