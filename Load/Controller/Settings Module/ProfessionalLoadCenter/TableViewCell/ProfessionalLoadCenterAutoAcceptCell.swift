//
//  ProfessionalLoadCenterAutoAcceptCell.swift
//  Load
//
//  Created by Haresh Bhai on 04/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

//protocol ProfessionalAutoAcceptDelegate: class {
//    func ProfessionalAutoAcceptFinish(isSelected:Bool)
//}

class ProfessionalLoadCenterAutoAcceptCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    
    //MARK:- Variables
//    weak var delegate:ProfessionalAutoAcceptDelegate?

    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupUI(indexPath: IndexPath, title: [String]) {
        self.setupFont()
        self.tag = indexPath.section
        self.lblTitle.text = title[indexPath.row]
//        self.lblDescription.text = getCommonString(key: "Auto_accept_description_key")
        
        let newString = NSMutableAttributedString()
        newString.append(getCommonString(key: "Auto_accept_description_key").withBoldText(text: getCommonString(key: "Auto_accept_key")))
        newString.append(getCommonString(key: "Auto_accept_description_2_key").withBoldText(text: getCommonString(key: "Auto_accept_key")))
        
        self.lblDescription.attributedText = newString
            
    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }

    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblDescription.font = themeFont(size: 11, fontname: .ProximaNovaRegular)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
    }
    
    //MARK:- @IBAction
    @IBAction func btnSwitchClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
//        self.delegate?.ProfessionalAutoAcceptFinish(isSelected: sender.isSelected)
    }
}
