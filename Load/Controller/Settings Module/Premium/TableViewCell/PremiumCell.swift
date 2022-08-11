 //
//  ProfessionalLoadCenterCell.swift
//  Load
//
//  Created by Haresh Bhai on 31/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol PremiumCellDelegate: class {
    func PremiumCellButton(section:Int, row:Int)
    func PremiumCellTextField(text:String, Id:Int, section:Int, row:Int)
}

class PremiumCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCell: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var viewLine: UIView!
    
    //MARK:- Variables
    weak var delegate:PremiumCellDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI(indexPath: IndexPath, title: [String], value: String? = nil) {
        self.tag = indexPath.section
        self.txtValue.tag = indexPath.row
        self.btnCell.tag = indexPath.row
        self.setupFont()
        self.txtValue.text = value ?? ""
        self.txtValue.delegate = self
        self.txtValue.placeholder = "Select"
        
        if title.count == 0 || indexPath.row == (title.count - 1) {
            self.viewLine.isHidden = true
        }else{
            self.viewLine.isHidden = false
        }
        
        self.lblTitle.text = title[indexPath.row]
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 1, 2:
                self.setView(btnCell: true, imgArrow: true, txtValue: true)
            default:
                self.setView(btnCell: true, imgArrow: true, txtValue: false)
            }
        }
        else  if indexPath.section == 1 {
            self.setView(btnCell: true, imgArrow: true, txtValue: false)
        }
    }
    
    func setView(btnCell: Bool, imgArrow: Bool, txtValue: Bool) {
        self.btnCell.isHidden = !btnCell
        self.imgArrow.isHidden = !imgArrow
        self.txtValue.isHidden = !txtValue
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtValue.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.txtValue.setColor(color: .appthemeBlackColorAlpha30)
    }    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text?.toTrim() == "" {
            self.txtValue.text = GetAllData?.data?.languages?.first?.name ?? ""
            self.delegate?.PremiumCellTextField(text: self.txtValue.text!, Id:  GetAllData?.data?.languages?.first?.id?.intValue ?? 0, section: self.tag, row: self.btnCell.tag)
        }
        
        return true
    }
    
    //MARK:- @IBAction
    @IBAction func btnCellClicked(_ sender: UIButton) {
        self.delegate?.PremiumCellButton(section: self.tag, row: sender.tag)
    }
}
