//
//  ProfileFooterView.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CredentialsFooterView: UIView {

    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CredentialsFooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CredentialsFooterView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 14)
    }
    
    func setupUI() {
        self.setFrame()
    }
}
