//
//  CalendarTrainingLogSummaryView.swift
//  
//
//  Created by iMac on 17/03/20.
//

import UIKit
import GoogleMaps

class CalendarTrainingLogSummaryView: UIView {

    //MARK: - Outlet
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgProfileUpper: UIImageView!
    @IBOutlet weak var lblTitleNameUpper: UILabel!
    @IBOutlet weak var lblLocationNameUpper: UILabel!
    @IBOutlet weak var lblAvgPacekmUpper: UILabel!
    @IBOutlet weak var lblAvgPacekmValueUpper: UILabel!
    @IBOutlet weak var lblAvgSpeedkmPerHrUpper: UILabel!
    @IBOutlet weak var lblTotalDistancekmUpper: UILabel!
    @IBOutlet weak var lblTotalDistancekmValueUpper: UILabel!
    @IBOutlet weak var lblInclinationUpper: UILabel!
    
    @IBOutlet weak var vwMainTotalDuration: CustomView!
    @IBOutlet weak var vwDummayTotalDuration: CustomView!
    @IBOutlet weak var lblDummyTotalDuration: UILabel!
    @IBOutlet weak var lblDummyTotalDurationValue: UILabel!
    
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var vwUpperDetailsIndoor: UIView!
    @IBOutlet weak var lblTotalDuration: UILabel!
    @IBOutlet weak var lblTotalDurationValue: UILabel!
    @IBOutlet weak var vwDetailsBelowTotalDuration: UIView!
    @IBOutlet weak var heightOfVwDetailsBelowTotalDuration: NSLayoutConstraint!
    
    @IBOutlet weak var lblDayInterval: UILabel!
    @IBOutlet weak var constrainTopDummyDuration: NSLayoutConstraint!
    
    @IBOutlet weak var lblLocationName: UILabel!
    
    @IBOutlet weak var lblAvgPacekm: UILabel!
    @IBOutlet weak var lblAvgPacekmValue: UILabel!
    @IBOutlet weak var lblAvgSpeedkmPerHr: UILabel!
    
    @IBOutlet weak var lblTotalDistancekm: UILabel!
    @IBOutlet weak var lblTotalDistancekmValue: UILabel!
    @IBOutlet weak var lblInclination: UILabel!
    
    @IBOutlet weak var lblTrainingGoalValue: UILabel!
    @IBOutlet weak var vwSwimmingStyle: UIView!
    @IBOutlet weak var lblSwimmingStyleValue: UILabel!
    @IBOutlet weak var lblAverageHeartRateValue: UILabel!
    @IBOutlet weak var lblTargetHeartRateValue: UILabel!
    @IBOutlet weak var lblKcalValue: UILabel!
    @IBOutlet weak var lblIntensityValue: UILabel!
    @IBOutlet weak var lblRPEValue: UILabel!
    
    @IBOutlet weak var vwPower: UIView!
    @IBOutlet weak var vwRelativePower: UIView!
    @IBOutlet weak var lblPowerValue: UILabel!
    @IBOutlet weak var lblRelativePowerValue: UILabel!

    @IBOutlet weak var vwGradient: UIView!
    @IBOutlet weak var lblGradientValue: UILabel!
    
    @IBOutlet weak var vwAvgRPM: UIView!
    @IBOutlet weak var lblAvgRPMValue: UILabel!
    
    @IBOutlet weak var lblTrainingLog: UILabel!
    @IBOutlet weak var btnTrainingLogExpand: UIButton!
    @IBOutlet weak var btnArrowUpDown: UIButton!
    @IBOutlet weak var imgArrow: UIImageView!
    
    @IBOutlet weak var vwLaps: UIView!
    @IBOutlet weak var heightOfVwLaps: NSLayoutConstraint!
    @IBOutlet weak var lblLaps: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTblDataConstant: NSLayoutConstraint!
    
    @IBOutlet weak var txtvwComment: CustomTextview!
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var vwAvgSpeed: UIView!
    @IBOutlet weak var lblAvgSpeedValueTextBox: UILabel!
    
    @IBOutlet weak var vwInclination: UIView!
    @IBOutlet weak var lblInclinationValueAboveTextBox: UILabel!
    
    @IBOutlet weak var vwActiveDuration: UIView!
    @IBOutlet weak var btnActiveDuration: UIButton!
    @IBOutlet weak var lblActiveDurationValue: UILabel!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    
    @IBOutlet weak var vwTraininGoalShadow: CustomView!
    
    //MARK:- Functions
    func setupUI(theController: CalendarTrainingLogSummaryVc) {
        self.setupFont()
        
        self.txtvwComment.delegate = theController
        
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
        
        self.scrollView.delegate = theController
        
        self.tableView.register(UINib(nibName: "CardioSummaryHeadeTblCell", bundle: nil), forCellReuseIdentifier: "CardioSummaryHeadeTblCell")
        self.tableView.register(UINib(nibName: "DataDetailScreenCardioSummaryTblCell", bundle: nil), forCellReuseIdentifier: "DataDetailScreenCardioSummaryTblCell")
        
        self.tableView.reloadData()
    }
    
    func setupFont() {
        
        [lblTrainingGoalValue,lblAverageHeartRateValue,lblTargetHeartRateValue,lblKcalValue,lblIntensityValue,lblRPEValue,lblAvgRPMValue].forEach { (lbl) in
            
            lbl?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
            lbl?.setColor(color: .appthemeBlackColor)
        }
        [lblAvgPacekm,lblTotalDistancekm,lblAvgSpeedkmPerHr,lblInclination,lblLocationName,lblAvgPacekmUpper,lblTotalDistancekmUpper,lblAvgSpeedkmPerHrUpper,lblInclinationUpper,lblLocationNameUpper].forEach { (lbl) in
            
            lbl?.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
            lbl?.setColor(color: .white)
        }
        
        [lblAvgPacekmValue,lblTotalDistancekmValue,lblAvgPacekmValueUpper,lblTotalDistancekmValueUpper].forEach { (lbl) in
            
            lbl?.font = themeFont(size: 27, fontname: .ProximaNovaBold)
            lbl?.setColor(color: .white)
        }
        
        lblDayInterval.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        lblDayInterval.setColor(color: .white)
        
        lblTitleNameUpper.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        lblTitleNameUpper.setColor(color: .white)

        lblTotalDuration.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        lblTotalDuration.setColor(color: .appthemeBlackColor)
        lblDummyTotalDuration.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        lblDummyTotalDuration.setColor(color: .appthemeBlackColor)

        lblTotalDurationValue.font = themeFont(size: 30, fontname: .ProximaNovaBold)
        lblTotalDurationValue.setColor(color: .appthemeBlackColor)
        lblDummyTotalDurationValue.font = themeFont(size: 30, fontname: .ProximaNovaBold)
        lblDummyTotalDurationValue.setColor(color: .appthemeBlackColor)

        self.lblTrainingLog.text = getCommonString(key: "Training_Log_key")

        btnSave.setTitle(str: getCommonString(key: "Save_key"))
        btnSave.setTitleColor(UIColor.appthemeRedColor, for: .normal)
        btnSave.titleLabel?.font = themeFont(size: 14, fontname:.ProximaNovaRegular)
        
        txtvwComment.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 15, right: 12)
        
        imgProfileUpper.layer.masksToBounds = true
        imgProfileUpper.layer.cornerRadius = imgProfileUpper.layer.bounds.width/2
        
        self.lblLaps.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblLaps.setColor(color: .appthemeBlackColor)
        
        self.vwLaps.isHidden = true
        self.heightOfVwLaps.constant = 0

        self.vwTraininGoalShadow.shadowColors = .clear
    }
    
}
