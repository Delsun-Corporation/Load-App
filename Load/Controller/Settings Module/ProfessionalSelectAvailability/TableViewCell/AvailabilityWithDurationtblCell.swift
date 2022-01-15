//
//  AvailabilityWithDurationtblCell.swift
//  Load
//
//  Created by Yash on 21/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

protocol AvailibilityDurationCellDelegate {
    func selectedDayInCustom(section:Int, row: Int)
}

import UIKit

class AvailabilityWithDurationtblCell: UITableViewCell {

    //MARK:- Outlet
    
    @IBOutlet weak var vwDayNameAndCheckmark: UIView!
    @IBOutlet weak var vwDuration: UIView!
    @IBOutlet weak var lblDayName: UILabel!
    @IBOutlet weak var vwLine: UIView!
    @IBOutlet weak var heightOfConstraintvwNameAndCheckmark: NSLayoutConstraint!
    @IBOutlet weak var imgCheckmark: UIImageView!
    @IBOutlet weak var btnDaySelect: UIButton!
    @IBOutlet weak var heightConstraintVwDuration: NSLayoutConstraint!
    @IBOutlet weak var txtOpeningHours: UITextField!
    @IBOutlet weak var txtBreak: UITextField!
    
    var sectionTag = 0
    var delegateAvailibility : AvailibilityDurationCellDelegate?
    
    //MARK:- View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//MARK:- Button action

extension AvailabilityWithDurationtblCell {
    
    @IBAction func btnDaySelectedTapped(_ sender: UIButton) {
        if self.sectionTag == 4 {
            self.delegateAvailibility?.selectedDayInCustom(section: sectionTag, row: sender.tag)
        }
    }
    
}

//MARK: - TextField delegate

extension AvailabilityWithDurationtblCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
}
