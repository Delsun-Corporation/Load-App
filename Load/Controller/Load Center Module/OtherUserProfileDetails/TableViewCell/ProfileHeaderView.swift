//
//  ProfileHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 01/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func ProfileHeaderDidFinish(index:Int)
}

class ProfileHeaderView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSelect: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!
    
    //MARK:- Variables
    weak var delegate:ProfileHeaderDelegate?
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ProfileHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProfileHeaderView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55)
    }
    
    func setupUI(title:String) {
        self.setFrame()
        self.lblTitle.text = title
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblTitle.setColor(color: .appthemeBlackColor)
    }
    
    @IBAction func btnSelectClicked(_ sender: UIButton) {
        self.delegate?.ProfileHeaderDidFinish(index: sender.tag)
    }
}
