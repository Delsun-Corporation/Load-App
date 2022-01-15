//
//  ViewNav.swift
//  PizzaApp
//
//  Created by Jaydeep on 20/12/18.
//  Copyright © 2018 Jaydeep. All rights reserved.
//

import UIKit

protocol CustomNavigationDelegate: class {
    func CustomNavigationClose()
}

class ViewNav: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var topClose: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var leadingConstraintLabelConstant: NSLayoutConstraint!
    
    //MARK:- Variables
    weak var delegate:CustomNavigationDelegate?
    
    override func awakeFromNib() {
        lblTitle.textColor = UIColor.white
        lblTitle.font = themeFont(size: 30, fontname: .Medium)
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
            topClose.constant = topPadding! + 15
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewNav", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ViewNav
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.delegate?.CustomNavigationClose()
    }
}
