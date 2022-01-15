//
//  CalendarTrainingLogResistanceSummaryView.swift
//  Load
//
//  Created by iMac on 20/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CalendarTrainingLogResistanceSummaryView: UIView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblCompletedVolume: UILabel!
    @IBOutlet weak var lblCompletedVolumeValue: UILabel!
    
    @IBOutlet weak var lblTargetVolume: UILabel!
    @IBOutlet weak var lblTargetVolumeValue: UILabel!
    
    @IBOutlet weak var vwMainTotalDuration: CustomView!
    @IBOutlet weak var lblTotalDuration: UILabel!
    @IBOutlet weak var lblTotalDurationValue: UILabel!
    
    @IBOutlet weak var constrainTopDummyDuration: NSLayoutConstraint!
    @IBOutlet weak var vwDummyTotalDuration: CustomView!
    @IBOutlet weak var lblDummyTotalDuration: UILabel!
    @IBOutlet weak var lblDummyTotalDurationValue: UILabel!
    
    @IBOutlet weak var lblTrainingGoalValue: UILabel!
    @IBOutlet weak var lblIntensityValue: UILabel!
    @IBOutlet weak var lblRPEValue: UILabel!
    @IBOutlet weak var lblTotalVolumeValue: UILabel!
    @IBOutlet weak var lblAvgWeightLiftedValue: UILabel!
    
    @IBOutlet weak var btnTrainingLogExpand: UIButton!
    @IBOutlet weak var btnArrowUpDown: UIButton!
    @IBOutlet weak var lblExercise: UILabel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTblDataConstant: NSLayoutConstraint!
    
    @IBOutlet weak var txtvwComment: CustomTextview!
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!

    //MARK:- Functions
    func setupUI(theController: CalendarTrainingLogResistanceSummaryVc) {
        self.setupFont()
        
        self.txtvwComment.delegate = theController

        self.tableView.delegate = theController
        self.tableView.dataSource = theController
        
        self.tableView.register(UINib(nibName: "ResistanceSummaryHeaderCell", bundle: nil), forCellReuseIdentifier: "ResistanceSummaryHeaderCell")
        self.tableView.register(UINib(nibName: "ResistanceSummaryExerciseCell", bundle: nil), forCellReuseIdentifier: "ResistanceSummaryExerciseCell")
        
        self.tableView.reloadData()
    }
    
    func setupFont() {
        
        [lblTrainingGoalValue,lblIntensityValue,lblRPEValue,lblTotalVolumeValue,lblAvgWeightLiftedValue].forEach { (lbl) in
            
            lbl?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
            lbl?.setColor(color: .appthemeBlackColor)
        }
        
        [lblCompletedVolume,lblTargetVolume].forEach { (lbl) in
            
            lbl?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
            lbl?.setColor(color: .white)
        }

        [lblCompletedVolumeValue,lblTargetVolumeValue].forEach { (lbl) in
            lbl?.font = themeFont(size: 27, fontname: .ProximaNovaBold)
        }
        
        self.lblExercise.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblExercise.setColor(color: .appthemeBlackColor)

        lblTotalDuration.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        lblTotalDuration.setColor(color: .appthemeBlackColor)
        
        lblDummyTotalDuration.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        lblDummyTotalDuration.setColor(color: .appthemeBlackColor)

        lblTitle.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        lblTitle.setColor(color: .white)

        lblDate.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        lblDate.setColor(color: .white)
        
        lblTotalDurationValue.font = themeFont(size: 30, fontname: .ProximaNovaBold)
        lblTotalDurationValue.setColor(color: .appthemeBlackColor)
        lblDummyTotalDurationValue.font = themeFont(size: 30, fontname: .ProximaNovaBold)
        lblDummyTotalDurationValue.setColor(color: .appthemeBlackColor)

        btnSave.setTitle(str: getCommonString(key: "Save_key"))
        btnSave.setTitleColor(UIColor.appthemeRedColor, for: .normal)
        btnSave.titleLabel?.font = themeFont(size: 14, fontname:.ProximaNovaRegular)
        
        imgUser.layer.masksToBounds = true
        imgUser.layer.cornerRadius = imgUser.layer.bounds.width/2
        
        txtvwComment.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 15, right: 12)
        self.txtvwComment.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblPlaceholder.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        
        self.lblCompletedVolume.text = getCommonString(key: "COMPLETED_VOLUME_key")
        self.lblTargetVolume.text = getCommonString(key: "TARGETED_VOLUME_key")
        self.lblTotalDuration.text = getCommonString(key: "TOTAL_DURATION_key")
        
    }

}
