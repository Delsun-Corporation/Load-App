//
//  UIView + Extension.swift
//  JoeToGo
//
// Created by Haresh on 25/01/19.
//  Copyright © 2019 Haresh. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask        
    }
    
    func roundCornersFrame(corners: UIRectCorner, radius: CGFloat, width:CGFloat) {
        let frame = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: width, height: bounds.height)
        let path = UIBezierPath(roundedRect: frame, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func flash(numberOfFlashes: Float) {
       let flash = CABasicAnimation(keyPath: "opacity")
       flash.duration = 0.2
       flash.fromValue = 1
       flash.toValue = 0.1
       flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
       flash.autoreverses = true
       flash.repeatCount = numberOfFlashes
       layer.add(flash, forKey: nil)
   }


}

extension CustomView{
    
    func setShadowToView(){
        
        self.cornerRadius  = 0
        self.shadowColors = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        self.shadowOffset = CGSize(width: 0, height: 6)
        self.shadowRadius = 3
        self.shadowOpacity = 0.9
        self.borderWidth = 1
    }
    
}
