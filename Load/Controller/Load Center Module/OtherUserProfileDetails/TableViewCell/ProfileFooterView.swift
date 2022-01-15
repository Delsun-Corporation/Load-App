//
//  ProfileFooterView.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfileFooterView: UIView {

    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ProfileFooterView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProfileFooterView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55)
    }
    
    func setupUI() {
        self.setFrame()
    }
}
