//
//  AcademicCredentialsCell.swift
//  Load
//
//  Created by Haresh Bhai on 10/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CredentialsCell: UITableViewCell, UITextFieldDelegate {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!    
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var btnDelete: UIButton!
    
    //MARK:- Variables
    weak var delegate:CredentialsDelegate?

    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(title:String, text:String) {
        self.btnDelete.isHidden = self.txtValue.tag != 0
        self.txtValue.delegate = self
        self.lblTitle.text = title
        self.txtValue.placeholder = "Enter " + title
        self.txtValue.text = text
        self.setupFont()
    }
    
    //MARK: - TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        print(txtAfterUpdate)
        self.delegate?.CredentialsTextFinish(text: txtAfterUpdate, row: self.txtValue.tag, section: self.tag)
        return true
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtValue.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.txtValue.setColor(color: .appthemeBlackColor)
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
        self.delegate?.CredentialsDeleteFinish(tag: self.tag)
    }
}
