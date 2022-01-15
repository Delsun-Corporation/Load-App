//
//  CredentialsAddCell.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol BillingInformationDelegate: class {
    func BillingInformationAddFinish()
    func BillingInformationTextFinish(text:String, row:Int, section:Int)
}

class BillingInformationAddCell: UITableViewCell {

    //MARK:- @IBOutlet
    @IBOutlet weak var btnAdd: UIButton!
    
    //MARK:- Variables
    weak var delegate:BillingInformationDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //MARK:- @IBAction
    @IBAction func btnAddClicked(_ sender: Any) {
        self.delegate?.BillingInformationAddFinish()
    }
    
    func setupFont() {
        self.btnAdd.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.btnAdd.setColor(color: .appthemeRedColor)
    }
}
