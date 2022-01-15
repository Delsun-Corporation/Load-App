//
//  LoadCenterSettingsViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 30/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LoadCenterSettingsViewModel: CustomNavigationWithSaveButtonDelegate {

    //MARK:- Variables
    fileprivate weak var theController:LoadCenterSettingsVC!
    
    //MARK:- Functions
    init(theController:LoadCenterSettingsVC) {
        self.theController = theController
    }
    
    func setupUI() {

    }
    
    func setupNavigationbar(title:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationController?.setColor()
        self.theController.navigationItem.hidesBackButton = true

        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.btnback.isHidden = false
            vwnav.btnback.setImage(UIImage(named: "Back"), for: .normal)
            vwnav.btnSave.isHidden = true
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: CGFloat(hightOfView), width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height)
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 16, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            
            vwnav.tag = 102
            vwnav.delegate = self
            self.theController.navigationController?.view.addSubview(vwnav)
        }
    }
}

extension LoadCenterSettingsViewModel: CustomNavigationDelegate{
    
    func CustomNavigationClose() {
        self.theController.btnBackClicked()
    }
    
    func CustomNavigationSave() {
        
    }

}
