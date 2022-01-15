//
//  PremiumPermissionViewModel.swift
//  Load
//
//  Created by Yash on 13/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

protocol PremiumPermissionDelegate {
    func selectedPermissionForPremium(viewMyProfile:String, viewMyFeed: String)
}


import Foundation

class PremiumPermissionViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController: PremiumPermissionVc!
    var delegatePermission: PremiumPermissionDelegate?

    //MARK:- Functions
    init(theController:PremiumPermissionVc) {
        self.theController = theController
    }
    
    let pickerViewPremiumProfile = UIPickerView()
    let pickerViewMyFeed = UIPickerView()
    
    var navigationHeader = ""
    
    var selectedViewMyProfile = ""
    var selectedViewMyFeed = ""
    
    //MARK:- SetupUI
    
    func setupUI(){
        
        [self.pickerViewPremiumProfile, self.pickerViewMyFeed].forEach { (picker) in
            picker.delegate = self.theController
            picker.dataSource = self.theController
            picker.backgroundColor = UIColor.white
        }
        
        if let view = self.theController.view as? PremiumPermissionView {
            view.txtPremiumProfileAnswer.inputView = pickerViewPremiumProfile
            view.txtFeedViewAnswer.inputView = pickerViewMyFeed
            
            view.txtPremiumProfileAnswer.text = selectedViewMyProfile
            view.txtFeedViewAnswer.text = selectedViewMyFeed
        }

    }
    
    
    // MARK: - Set navigation bar
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


extension PremiumPermissionViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.passData()
        self.theController.backButtonAction()
    }
    
    func CustomNavigationSave() {
    
    }

}
