//
//  BikeSettingView.swift
//  Load
//
//  Created by iMac on 30/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class BikeSettingView: UIView {

    //MARK: - Outlet
    
    @IBOutlet weak var lblBikeWeight: UILabel!
    @IBOutlet weak var lblBikeWheelDiameter: UILabel!
    @IBOutlet weak var lblFrontChainWheel: UILabel!
    @IBOutlet weak var lblFreeWheelTitle: UILabel!
    
    @IBOutlet weak var txtBikeWeight: UITextField!
    @IBOutlet weak var txtBikeDiameter: UITextField!
    @IBOutlet weak var txtFrontChainWheel: UITextField!
    @IBOutlet weak var txtRearFreeWheel: UITextField!
    
    @IBOutlet weak var lblWeightUnit: UILabel!
    @IBOutlet weak var lblDiameterUnit: UILabel!
    @IBOutlet weak var lblChainWheelUnit: UILabel!
    @IBOutlet weak var lblFreeWheelUnit: UILabel!
    
    //MARK: - SetupUI
    
    func setupUI(controller: BikeSettingVc){
        self.setupFont(controller: controller)
    }
    
    func setupFont(controller: BikeSettingVc){
        
        [self.txtBikeWeight, self.txtBikeDiameter, self.txtFrontChainWheel, self.txtRearFreeWheel].forEach { (txt) in
            txt?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            txt?.delegate = controller
            txt?.placeholder = "00"
        }
        
        [self.lblWeightUnit, self.lblDiameterUnit, self.lblChainWheelUnit, self.lblFreeWheelUnit].forEach { (lbl) in
            lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        }
        
        [self.lblBikeWeight, self.lblBikeWheelDiameter, self.lblFrontChainWheel, self.lblFreeWheelTitle].forEach { (lbl) in
            lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        }
        
        self.lblBikeWeight.text = getCommonString(key: "Bike_weight_key")
        self.lblBikeWheelDiameter.text = getCommonString(key: "Bike_wheel_diameter_key")
        self.lblFrontChainWheel.text = getCommonString(key: "Front_chainwheel_key")
        self.lblFreeWheelTitle.text = getCommonString(key: "Rear_freewheel_key")
        
    }
    
}
