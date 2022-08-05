//
//  BikeSettingViewModel.swift
//  Load
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

protocol BikeSetttingSelectFinishDelegate {
    func BikeData(bikeWeight: CGFloat, bikeWheelDiameter: CGFloat, bikeFrontChainWheel: Int, rearFreeWheel: Int)
}


class BikeSettingViewModel{
    
    //MARK:- Variables
    fileprivate weak var theController:BikeSettingVc!

    var delegateBike: BikeSetttingSelectFinishDelegate?
    var isBikeWeight = false
    
    var bikeWeight: CGFloat = 0.0
    var bikeWheelDiameter: CGFloat = 0.0
    var bikeFrontChainWheel = 0
    var bikeRearFreeWheel = 0

    //MARK:- setupUI
    
    func setupUI(){
            
        if let vw = self.theController.view as? BikeSettingView{
            
            vw.txtBikeWeight.text = self.theController.setOneDigitWithFloor(value: self.bikeWeight)
            vw.txtBikeDiameter.text = self.theController.setOneDigitWithFloor(value: self.bikeWheelDiameter)
            vw.txtRearFreeWheel.text = "\(self.bikeRearFreeWheel)"
            vw.txtFrontChainWheel.text = "\(self.bikeFrontChainWheel)"
        }
        
    }
    
    //MARK:- Functions
    init(theController:BikeSettingVc) {
        self.theController = theController
    }
}
