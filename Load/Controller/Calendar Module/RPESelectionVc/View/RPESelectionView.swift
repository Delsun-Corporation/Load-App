//
//  RPMSelectionView.swift
//  Load
//
//  Created by iMac on 25/04/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import RangeSeekSlider

class RPESelectionView: UIView {
    
    
    @IBOutlet weak var lblWorkoutCompleted: UILabel!
    @IBOutlet weak var lblTestingSession: UILabel!
    
    @IBOutlet weak var tblRPMDetails: UITableView!
    @IBOutlet weak var customSlider: UISlider!
    @IBOutlet weak var leadingSliderConstant: NSLayoutConstraint!
    @IBOutlet weak var trailingSliderConstant: NSLayoutConstraint!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var sliderValue: RangeSeekSlider!
    
    //MARK: - SetupUI
    func setupUI(theController: RPESelectionVc){
        
        lblWorkoutCompleted.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        lblTestingSession.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        lblWorkoutCompleted.textColor = UIColor.appthemeBlackColor
        lblTestingSession.textColor = UIColor.appthemeBlackColor
        
        tblRPMDetails.register(UINib(nibName: "RPETblCell", bundle: nil), forCellReuseIdentifier: "RPETblCell")
        tblRPMDetails.tableFooterView = UIView()
        
        tblRPMDetails.delegate = theController
        tblRPMDetails.dataSource = theController
        
        btnSave.setColor(color: UIColor.white)
        btnSave.setTitle(str: getCommonString(key: "Save_key"))
        btnSave.titleLabel?.font = themeFont(size: 23, fontname: .ProximaNovaBold)

    }
    
    //MARK: - SetSlider data
    /*
    func setupSlider(){
        
        customSlider.isContinuous = true
        customSlider.minimumValue = 1
        customSlider.value = 1
        customSlider.maximumValue = 10
        customSlider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
        customSlider.setThumbImage(UIImage(named: "slider_thumb"), for: .highlighted)
        
        if DEVICE_TYPE.IS_IPHONE_6{
            [leadingSliderConstant,trailingSliderConstant].forEach { (constrain) in
                constrain?.constant = 19
            }
        }
        
    }
    */
    func setupSlider(theController:RPESelectionVc){
        sliderValue.minValue = 1
        sliderValue.maxValue = 10
        sliderValue.selectedMaxValue = 1
        sliderValue.hideLabels = true
        sliderValue.disableRange = true
        sliderValue.enableStep = true
        sliderValue.step = 1
//        sliderValue.lineHeight = 0
        sliderValue.handleImage = UIImage(named: "slider_thumb")
        sliderValue.delegate = theController
    }
    
}
