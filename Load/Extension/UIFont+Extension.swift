//
//  UIFont+Extension.swift
//  JoeToGo
//
//  Created by Haresh on 22/03/19.
//  Copyright © 2019 Haresh. All rights reserved.
//

import Foundation
import UIKit

enum themeFonts : String
{
    case Medium = "SFUIText-Medium"
    case Light = "SFUIText-Light"
    case Regular = "SFUIText-Regular"
    case SemiboldItalic = "SFUIText-SemiboldItalic"
    case Heavy = "SFUIText-Heavy"
    case RegularItalic = "SFUIText-RegularItalic"
    case Bold = "SFUIText-Bold"
    case MediumItalic = "SFUIText-MediumItalic"
    case BoldItalic = "SFUIText-BoldItalic"
    case Semibold = "SFUIText-Semibold"
    case LightItalic = "SFUIText-LightItalic"
    case HeavyItalic = "SFUIText-HeavyItalic"
    case Helvetica = "Helvetica"
    case HelveticaBold = "Helvetica-Bold"
    case ProximaNovaRegular = "ProximaNova-Regular"
    case ProximaNovaBold = "ProximaNova-Bold"
    case ProximaNovaThin = "ProximaNova-Thin"
}

func themeFont(size : Float,fontname : themeFonts) -> UIFont {
    if UIScreen.main.bounds.width <= 320 {
        return UIFont(name: fontname.rawValue, size: CGFloat(size)-2)! //CGFloat(size) - 2.0)
    }
    else {
        return UIFont(name: fontname.rawValue, size: CGFloat(size))!
    }
    
}
