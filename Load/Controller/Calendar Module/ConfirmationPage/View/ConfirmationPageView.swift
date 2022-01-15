//
//  ConfirmationPageView.swift
//  Load
//
//  Created by iMac on 03/06/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class ConfirmationPageView: UIView {

    @IBOutlet weak var lblActivityName: UILabel!
    @IBOutlet weak var lblTotalDuration: UILabel!
    @IBOutlet weak var txtTotalDuration: UITextField!
    @IBOutlet weak var lblTotalDistance: UILabel!
    @IBOutlet weak var txtTotalDistance: UITextField!
    @IBOutlet weak var lblAvgSpeed: UILabel!
    @IBOutlet weak var txtAvgSpeed: UITextField!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblTotalDistanceUnit: UILabel!
    @IBOutlet weak var vwAvgSpeed: UIView!
    @IBOutlet weak var lblAvgSpeedUnit: UILabel!
    @IBOutlet weak var vwAvgPace: UIView!
    @IBOutlet weak var lblAvgPaceUnit: UILabel!
    @IBOutlet weak var lblAvgPace: UILabel!
    @IBOutlet weak var txtAvgPace: UITextField!
    
    func setupUI(theController:ConfirmationPageVc){
        
        lblActivityName.textColor = UIColor.appthemeBlackColor
        lblActivityName.font = themeFont(size: 11, fontname: .ProximaNovaThin)
        
        [lblTotalDuration,lblTotalDistance,lblAvgSpeed,lblAvgPace].forEach { (lbl) in
            lbl?.textColor = UIColor.appthemeBlackColorAlpha30
            lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        }
        
        [txtTotalDistance,txtAvgSpeed,txtTotalDuration,txtAvgPace].forEach { (txt) in
            txt?.textColor = UIColor.appthemeBlackColor
            txt?.delegate = theController
            txt?.font = themeFont(size: 15, fontname: .Helvetica)
        }
        
        txtTotalDuration.textColor = UIColor.appthemeBlackColor
        txtTotalDuration.delegate = theController
        
        txtAvgPace.textColor = UIColor.appthemeBlackColor
        txtAvgPace.delegate = theController
        
        [lblTotalDistanceUnit,lblAvgPaceUnit,lblAvgSpeedUnit].forEach { (lbl) in
            lbl?.textColor = UIColor.appthemeBlackColor
            lbl?.font = themeFont(size: 15, fontname: .Helvetica)
        }
        
//        [lblTotalDurationColon].forEach { (lbl) in
//            lbl?.textColor = UIColor.appthemeBlackColor
//            lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
//        }
        
        btnNext.setColor(color: UIColor.white)
        btnNext.setTitle(str: getCommonString(key: "Next_key"))
        btnNext.titleLabel?.font = themeFont(size: 23, fontname: .ProximaNovaBold)
    }
}
