//
//  UITextField + Extension.swift
//  Load
//
//  Created by Haresh Bhai on 22/03/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import Foundation
import UIKit

extension CustomTextField
{
    func setThemeTextFieldUI()
    {
        self.clipsToBounds = true
        self.cornerRadius = self.bounds.height/2
        self.font = themeFont(size: 16, fontname: .Regular)
        self.textColor = UIColor.black
        self.tintColor = UIColor.appthemeRedColor
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.appthemeRedColor.cgColor
        self.layer.borderWidth  = 1.0
    }
    
}
