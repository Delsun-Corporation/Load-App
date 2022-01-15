//
//  ViewNavMedium.swift
//  Load
//
//  Created by iMac on 24/10/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

protocol CustomNavigationWithSaveButtonDelegate: class {
    func CustomNavigationClose()
    func CustomNavigationSave()
}


class ViewNavMedium: UIView {

    //MARK: - Outlet
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK:- Variables
    weak var delegate:CustomNavigationWithSaveButtonDelegate?
    
    override func awakeFromNib() {
        lblTitle.textColor = UIColor.white
        btnSave.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top
//            topClose.constant = topPadding! + 15
        }
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ViewNavMedium", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ViewNavMedium
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.delegate?.CustomNavigationClose()
    }

    @IBAction func btnSaveClicked(_ sender: UIButton) {
        self.delegate?.CustomNavigationSave()
    }
    
}
