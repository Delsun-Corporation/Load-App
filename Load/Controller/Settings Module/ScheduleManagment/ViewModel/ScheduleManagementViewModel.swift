//
//  ScheduleManagementViewModel.swift
//  Load
//
//  Created by Yash on 14/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ScheduleManagementDelegate: class {
    func ProfessionalAutoAcceptFinish(isSelected:Bool)
    func ProfessionalAdvanceBookingFinish(isSelected:Bool)
}


class ScheduleManagementViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:ScheduleManagmentVc!
    
    //MARK:- Functions
    init(theController:ScheduleManagmentVc) {
        self.theController = theController
    }
    
    var array = [JSON]()
    
    func setupArray(){
        
        var dict = JSON()
        dict["name"] = "2 weeks advanced booking"
        dict["selected"] = 0
        self.array.append(dict)
        
        dict = JSON()
        dict["name"] = "1 month  advanced booking"
        dict["selected"] = 0
        self.array.append(dict)
        
        dict = JSON()
        dict["name"] = "3 months advanced booking"
        dict["selected"] = 0
        self.array.append(dict)
        
        dict = JSON()
        dict["name"] = "6 months advanced booking"
        dict["selected"] = 0
        self.array.append(dict)
        
    }

    //MARK: - Setup navigation delegate
    
    func setupNavigationbar(title:String) {
        
        setupArray()
        
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = false
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
            
            vwnav.lblTitle.textColor = .black
            
            vwnav.tag = 102
            vwnav.delegate = self
            
            self.theController.navigationController?.view.addSubview(vwnav)
            
        }
    }
    
}

//MARK: - Navigation delegate
extension ScheduleManagementViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.backButtonAction()
    }
    
    func CustomNavigationSave() {
        
    }

}
