//
//  ProfessionalListViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ProfessionalListDelegate: class {
    func ProfessionalListFinish(id:Int, title:String, isScreenFor:PROFESSIONAL_LIST_TYPE)
}

class ProfessionalListViewModel {

    //MARK:- Variables
    fileprivate weak var theController:ProfessionalListVC!
    var selectedId:Int = 0
    var selectedTitle:String = ""
    var isScreenFor:PROFESSIONAL_LIST_TYPE = .TYPE
    weak var delegate:ProfessionalListDelegate?
    var navHeader = ""

    
    //MARK:- Functions
    init(theController:ProfessionalListVC) {
        self.theController = theController
    }
    
    func setupUI() {
        
    }
    
    func setupNavigationbar(title:String) {
        
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

extension ProfessionalListViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.btnBackClicked()
    }
    
    func CustomNavigationSave() {
        
    }

}

