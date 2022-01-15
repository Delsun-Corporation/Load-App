//
//  CredentialsAddCell.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol CredentialsDelegate: class {
    func CredentialsAddFinish()
    func CredentialsTextFinish(text:String, row:Int, section:Int)
    func CredentialsDeleteFinish(tag:Int)
}

class CredentialsAddCell: UITableViewCell {

    //MARK:- Variables
    weak var delegate:CredentialsDelegate?
    
    //MARK:- @IBOutlet
    @IBOutlet weak var btnAdd: UIButton!
    
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
        self.delegate?.CredentialsAddFinish()
    }
    
    func setupFont() {
        self.btnAdd.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)        
        self.btnAdd.setColor(color: .appthemeRedColor)
    }
}
