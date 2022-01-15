//
//  SwitchAccountButtonView.swift
//  Load
//
//  Created by Haresh Bhai on 03/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol SwitchAccountDelegate: class {
    func SwitchAccountClicked(isOpen:Bool)
}

class SwitchAccountButtonView: UIView {

    @IBOutlet weak var lblFree: UILabel!
    @IBOutlet weak var lblSwitchAccount: UILabel!
    
    weak var delegate: SwitchAccountDelegate?
    var isOpen: Bool = false
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "SwitchAccountButtonView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SwitchAccountButtonView
    }
    
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblSwitchAccount.font = themeFont(size: 12, fontname: .Regular)
        self.lblFree.font = themeFont(size: 12, fontname: .Regular)
        self.lblFree.setColor(color: .appthemeWhiteColor)
        self.lblSwitchAccount.setColor(color: .appthemeWhiteColor)
        self.lblSwitchAccount.text = getCommonString(key: "Switch_account_key")
        
    }
    
    func showAccountType() {
        self.lblFree.text = SELECTED_ACCOUNT_TYPE
    }
    
    @IBAction func btnSwitchAccountClicked(_ sender: Any) {
        self.isOpen = !isOpen
        self.delegate?.SwitchAccountClicked(isOpen: self.isOpen)
    }
    
}
