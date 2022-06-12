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
extension BikeSettingViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        
        if let vw = self.theController.view as? BikeSettingView{
            
            let bikeWeightFloat = self.theController.setOneDigitWithFloorInCGFLoat(value: (vw.txtBikeWeight.text ?? "").toFloat())
            let bikeWheelDiameterFloat = self.theController.setOneDigitWithFloorInCGFLoat(value: (vw.txtBikeDiameter.text ?? "").toFloat())
            
            self.delegateBike?.BikeData(bikeWeight: bikeWeightFloat, bikeWheelDiameter: bikeWheelDiameterFloat, bikeFrontChainWheel: Int(vw.txtFrontChainWheel.text ?? "") ?? 0, rearFreeWheel: Int(vw.txtRearFreeWheel.text ?? "") ?? 0)
        }
        self.theController.backButtonAction()
    }
    
    func CustomNavigationSave() {
//        self.saveDetails()
    }

}
