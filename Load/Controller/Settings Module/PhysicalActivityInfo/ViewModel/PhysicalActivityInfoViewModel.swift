//
//  PhysicalActivityInfoViewModel.swift
//  Load
//
//  Created by Yash on 09/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireSwiftyJSON

class PhysicalActivityInfoViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:PhysicalActivityInfoVc!
    var profileDetails: PhysicalActivityModelClass?

    //MARK:- Functions
    init(theController:PhysicalActivityInfoVc) {
        self.theController = theController
    }
    
    //MARK: - SetupUI
    func setupUI(){
        
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
            
            vwnav.frame = CGRect(x: 0, y: CGFloat(hightOfView), width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: 61)
            
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
extension PhysicalActivityInfoViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
    }
    
    func CustomNavigationSave() {
        self.theController.dismiss(animated: true, completion: nil)
        //        self.validateDetails()
    }
    
}
