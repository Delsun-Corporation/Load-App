//
//  CustomView.swift
//  Liber
//
//  Created by Haresh Bhai on 22/09/18.
//  Copyright © 2018 Haresh Bhai. All rights reserved.
//

import UIKit

@IBDesignable class CustomView: UIView {
    /// The corner radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow color of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowColors: UIColor = UIColor.black {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow offset of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0.0, height: 2) {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow radius of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowRadius: CGFloat = 4.0 {
        didSet {
            self.updateProperties()
        }
    }
    /// The shadow opacity of the `ShadowView`, inspectable in Interface Builder
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            self.updateProperties()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.updateProperties()
        }
    }
    
    @IBInspectable var borderColors: UIColor = UIColor.clear {
        didSet {
            self.updateProperties()
        }
    }
    
    /**
     Masks the layer to it's bounds and updates the layer properties and shadow path.
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.updateProperties()
        self.updateShadowPath()
    }
    
    /**
     Updates all layer properties according to the public properties of the `ShadowView`.
     */
    fileprivate func updateProperties() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.shadowColor = self.shadowColors.cgColor
        self.layer.shadowOffset = self.shadowOffset
        self.layer.shadowRadius = self.shadowRadius
        self.layer.shadowOpacity = self.shadowOpacity
        self.layer.borderColor = self.borderColors.cgColor
        self.layer.borderWidth = self.borderWidth
    }
    
    /**
     Updates the bezier path of the shadow to be the same as the layer's bounds, taking the layer's corner radius into account.
     */
    fileprivate func updateShadowPath() {
        self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
    }
    
    /**
     Updates the shadow path everytime the views frame changes.
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateShadowPath()
    }
}
