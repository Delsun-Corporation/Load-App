//
//  UITableViewCell + Extension.swift
//  Load
//
//  Created by iMac on 08/04/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation


extension UITableViewCell{
    
    func oneDigitAfterDecimal(value : CGFloat) -> String{
//        return String(format: "%.1f", value)
        
        let multiplier = pow(10.0, 1.0)
        let rounded = round(Double(value) * multiplier) / multiplier
        return "\(rounded)"

    }
    
    func setOneDigitWithFloorInCGFLoat(value: CGFloat) -> CGFloat{
         return (floor((value*10)) / 10)
    }

    func drawGradientColor(colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }

        let size = CGSize(width: UIScreen.main.bounds.size.width, height: 4.0)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }
}

