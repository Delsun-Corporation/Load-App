//
//  TimeUnderTensionInfoViewModel.swift
//  Load
//
//  Created by Yash on 15/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation

class TimeUnderTensionInfoViewModel {
    
    //MARK:- Variables

    fileprivate weak var theController:TimeUnderTensionInfoVC!

    var arrayTimeUnderTensionList = [TimeUnderTensionList]()

    //MARK:- Functions
    init(theController:TimeUnderTensionInfoVC) {
        self.theController = theController
    }
    
    //MARK: - Setup navigation bar
    func setupNavigationbar(title:String) {
        
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = true
            vwnav.btnSave.isHidden = false
            vwnav.btnSave.setImage(UIImage(named: "ic_close_switch_screen_red"), for: .normal)
            vwnav.btnSave.setTitle(str: "")

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
            
            vwnav.lblTitle.textColor = .black
            
            vwnav.tag = 102
            vwnav.delegate = self
            
            self.theController.navigationController?.view.addSubview(vwnav)
            
        }
    }

}

//MARK: - navigation delegate
extension TimeUnderTensionInfoViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
    }
    
    func CustomNavigationSave() {
        self.theController.dismiss(animated: true, completion: nil)
    }
    
}
