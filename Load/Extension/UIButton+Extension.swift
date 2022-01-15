//
//  UIButton+Extension.swift
//  JoeToGo
//
//  Created by Haresh on 22/03/19.
//  Copyright © 2019 Haresh. All rights reserved.
//

import Foundation
import UIKit

extension UIButton
{
    func setThemeButtonUI()
    {
        self.titleLabel?.font = themeFont(size: 16, fontname: .Regular)
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor.appthemeRedColor
        self.layer.borderColor = UIColor.red.cgColor
        self.layer.borderWidth = 1.0
        
    }
    
}
