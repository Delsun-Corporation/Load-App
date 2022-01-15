//
//  ProfessionalRequirementViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 02/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ProfessionalRequirementDelegate: class {
    func ProfessionalRequirementFinish(text:String, isScreen:Int)
}

class ProfessionalRequirementViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:ProfessionalRequirementVC!
    var placeholder:String = ""
    var navigationHeader = ""
    var isScreen:Int = 0 //0 : requirement, 1: profession, 2: Introduction // 3: About
    var text = ""

    weak var delegate: ProfessionalRequirementDelegate?
    
    //MARK:- Functions
    init(theController:ProfessionalRequirementVC) {
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
            
            vwnav.tag = 1002
            vwnav.delegate = self
            
            self.theController.navigationController?.view.addSubview(vwnav)
            
        }
    }

}

extension ProfessionalRequirementViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.btnBackClicked()
    }
    
    func CustomNavigationSave() {
    }


}
