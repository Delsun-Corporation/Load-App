//
//  ViewNav.swift
//  PizzaApp
//
//  Created by Jaydeep on 20/12/18.
//  Copyright © 2018 Jaydeep. All rights reserved.
//

import UIKit

protocol CustomNavigationBackDelegate: class {
    func CustomNavigationBack()
}

class ViewNavWhite: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var btnBackCenter: NSLayoutConstraint!
    @IBOutlet weak var imgCenter: NSLayoutConstraint!
    //MARK:- Variables
    weak var delegate:CustomNavigationBackDelegate?
    
    override func awakeFromNib() {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            btnBackCenter.constant = topPadding == 20 ? 0 : 15
            imgCenter.constant = topPadding == 20 ? 0 : 15
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewNavWhite", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ViewNavWhite
    }
    
    func showImage(url:String) {
        self.setupFont()
        self.imgProfile.sd_setImage(with: url.toURL(), completed: nil)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.delegate?.CustomNavigationBack()
    }
    
    func setupFont() {
        self.imgProfile.setCircle()
        self.lblName.font = themeFont(size: 14, fontname: .ProximaNovaBold)
        self.lblType.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        
        self.lblName.setColor(color: .appthemeBlackColor)
        self.lblType.setColor(color: .appthemeBlackColor)
    }
}
