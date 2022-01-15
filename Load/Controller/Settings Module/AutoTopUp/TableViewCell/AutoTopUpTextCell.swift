//
//  ProfessionalLoadCenterCell.swift
//  Load
//
//  Created by Haresh Bhai on 31/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol AutoTopUpTextDelegate: class {
    func AutoTopUpTextTextField(text:String, section:Int, row:Int)
}

class AutoTopUpTextCell: UITableViewCell, UITextFieldDelegate {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtValue: UITextField!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var lblDollar: UILabel!
    @IBOutlet weak var constrainWidthOfTxt: NSLayoutConstraint!
    
    //MARK:- Variables
    weak var delegate:AutoTopUpTextDelegate?

    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupUI(indexPath: IndexPath, title: String, text:String, placeHolder:String) {
        self.tag = indexPath.section
        self.txtValue.tag = indexPath.row
        self.setupFont()
        self.txtValue.delegate = self
        self.txtValue.placeholder = placeHolder
        self.txtValue.text = text
        self.lblTitle.text = title
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtValue.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.txtValue.textColor = .appthemeBlackColor
    }
    
    //MARK: - TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        print(txtAfterUpdate)
        self.delegate?.AutoTopUpTextTextField(text: txtAfterUpdate, section: self.tag, row: self.txtValue.tag)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.setAsNumericKeyboard(delegate: self,isUseHyphen:false)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.tag == 1 {
            if isBackButtonClickable() == false {
                makeToast(strMessage: "Please enter valid amount")
                return
            }
        } else {
            if isBackButtonClickable() == false {
                makeToast(strMessage: "Please enter valid amount")
                return
            }
        }

        self.delegate?.AutoTopUpTextTextField(text: textField.text ?? "", section: self.tag, row: self.txtValue.tag)
    }
    
    func isBackButtonClickable() -> Bool{
        
        if self.txtValue.text?.toTrim().contains(".") ?? false {
            
            if let data = self.txtValue.text?.toTrim().split(separator: "."){
                
                if data.count == 2 {
                    let firstData = data[0]
                    let secondData = data[1]
                    
                    if Int(firstData) == 0 && Int(secondData) == 0{
                        return false
                    }

                } else if data.count == 1{
                    let firstData = data[0]
                    if Int(firstData) == 0{
                        return false
                    }
                }
                
            }
            
        } else {
            
            if Int(self.txtValue.text?.toTrim() ?? "0") == 0  {
                return false
            }
            
        }
        
        return true
    }
}

//MARK:- numerice keyboard

extension AutoTopUpTextCell: NumericKeyboardDelegate {

    func numericKeyPressed(key: Int) {
        
        print("Tag:\(self.txtValue.tag)")
        
        if self.txtValue.tag == 1 {

            self.constrainWidthOfTxt.constant = CGFloat((self.txtValue.text?.count ?? 0) * 10)

            if self.txtValue.text?.contains(".") ?? false{

                self.constrainWidthOfTxt.constant = CGFloat((self.txtValue.text?.count ?? 0) * 10) - 10

                let data = self.txtValue.text?.split(separator: ".")
                if (data?.count ?? 0) == 2 {
                    if (data?[1].count ?? 0) > 2 {
                        self.txtValue.text?.removeLast()
                        self.constrainWidthOfTxt.constant = CGFloat((self.txtValue.text?.count ?? 0) * 10) - 10
                        
                        return
                    }
                }
            }

        } else {
            
            self.constrainWidthOfTxt.constant = CGFloat((self.txtValue.text?.count ?? 0) * 10)

            if self.txtValue.text?.contains(".") ?? false{
                
                self.constrainWidthOfTxt.constant = CGFloat((self.txtValue.text?.count ?? 0) * 10) - 10

                let data = self.txtValue.text?.split(separator: ".")
                if (data?.count ?? 0) == 2 {
                    if (data?[1].count ?? 0) > 2 {
                        self.txtValue.text?.removeLast()
                        self.constrainWidthOfTxt.constant = CGFloat((self.txtValue.text?.count ?? 0) * 10) - 10
                        return
                    }
                }
            }
            
        }
        
    }

    func numericBackspacePressed() {
        if self.txtValue.tag == 1 {
            if self.txtValue.text?.count == 0 {
                self.constrainWidthOfTxt.constant = 45
            }
        } else {
            if self.txtValue.text?.count == 0 {
                self.constrainWidthOfTxt.constant = 45
            }
        }
    }

    func numericSymbolPressed(symbol: String) {
    }

}

