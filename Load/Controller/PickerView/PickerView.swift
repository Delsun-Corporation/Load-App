//
//  PickerView.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class PickerView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var imgLeft: NSLayoutConstraint!
    @IBOutlet weak var imgWidth: NSLayoutConstraint!
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "PickerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PickerView
    }
    
    func setupUI(isShowImage:Bool = false) {
        self.setupFont()
        self.setFrame()
        if !isShowImage {
            self.hideImage()
        }
    }
    
    func setupFont() {
        self.lblText.font = themeFont(size: 21, fontname: .Regular)
//            UIFont.systemFont(ofSize: 23)//themeFont(size: 14, fontname: .Helvetica)
        self.lblText.setColor(color: .appthemeOffRedColor)
    }
    
    func hideImage() {
        self.imgLeft.constant = 0
        self.imgWidth.constant = 0
    }
    
    func setFrame(width:CGFloat = UIScreen.main.bounds.width) {
        self.frame = CGRect(x: 0, y: 0, width: width, height: 30)
    }    
}
