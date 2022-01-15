//
//  IntroductionCell.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ProfileReloadDelegate: class {
    func DescriptionReload()
    func CredentialsReload()
}

class IntroductionCell: UITableViewCell {
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var btnReadMore: UIButton!
    
    @IBOutlet weak var btnReadMoreHeight: NSLayoutConstraint!
    @IBOutlet weak var btnReadMoreBottom: NSLayoutConstraint!

    weak var delegate:ProfileReloadDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setLines(setValue:Int, calculatedLines:Int) {
        lblDescription.numberOfLines = setValue
        if setValue != 4 || calculatedLines <= 4 {
            self.hideReadMore()
        }
    }
    
    func hideReadMore() {
        self.btnReadMore.isHidden = true
        self.btnReadMoreBottom.constant = 16
        self.btnReadMoreHeight.constant = 0
    }
    
    func setupFont() {
        self.lblDescription.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.btnReadMore.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)

        self.lblDescription.setColor(color: .appthemeBlackColor)
        self.btnReadMore.setColor(color: .appthemeRedColor)
    }
    
    @IBAction func btnReadMoreClicked(_ sender: UIButton) {
        if sender.tag == 0 {
            self.delegate?.DescriptionReload()
        }
        else if sender.tag == 2 {
            self.delegate?.CredentialsReload()
        }
    }
}
