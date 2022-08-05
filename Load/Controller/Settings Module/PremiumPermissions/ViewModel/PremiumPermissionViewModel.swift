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
}
