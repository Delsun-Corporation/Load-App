//
//  TrainingPreviewView.swift
//  Load
//
//  Created by Haresh Bhai on 07/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class TrainingPreviewView: UIView {

    @IBOutlet weak var imgOfStartWorkout: UIImageView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgActivity: UIImageView!    
    @IBOutlet weak var lblWhen: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblNotesTitle: UILabel!
    
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var lblTrainingGoalTitle: UILabel!
    @IBOutlet weak var lblTrainingGoal: UILabel!
    @IBOutlet weak var lblIntensityTitle: UILabel!
    @IBOutlet weak var lblIntensity: UILabel!
    @IBOutlet weak var lblTargetHRTitle: UILabel!
    @IBOutlet weak var lblTargetHR: UILabel!
    
    @IBOutlet weak var lblLaps: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var imgSpeed: UIImageView!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblRest: UILabel!
    
    @IBOutlet weak var vwCompleteWorkout: CustomView!
//    @IBOutlet weak var vwRepeatWorkout: CustomView!
    @IBOutlet weak var vwEndWorkout: CustomView!
    @IBOutlet weak var vwStartWorkout: CustomView!

    @IBOutlet weak var btnCompleteWorkout: UIButton!
    @IBOutlet weak var btnEndWorkout: UIButton!
    @IBOutlet weak var btnStartWorkout: UIButton!
    
    @IBOutlet weak var btnShowUnit: UIButton!
    @IBOutlet weak var vwUnit: UIView!
    @IBOutlet weak var lblDistanceUnit: UILabel!
    @IBOutlet weak var lblSpeedUnit: UILabel!
    @IBOutlet weak var lblRestUnit: UILabel!
    @IBOutlet weak var vwDistanceUnit: UIView!
    @IBOutlet weak var vwSpeedUnit: UIView!
    @IBOutlet weak var vwRestUnit: UIView!
    @IBOutlet weak var lblPercentageUnit: UILabel!
    @IBOutlet weak var vwPercentageUnit: UIView!
    @IBOutlet weak var heightUnitvw: NSLayoutConstraint!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    @IBOutlet weak var vwMainBottom: UIView!
    @IBOutlet weak var ConstratintBottomViewHeigh: NSLayoutConstraint!
    
    //Exercise
    
    @IBOutlet weak var viewPercentage: UIView!
    @IBOutlet weak var leftViewPercentage: NSLayoutConstraint!
    @IBOutlet weak var rightViewPercentage: NSLayoutConstraint!
    @IBOutlet weak var viewRPM: UIView!
    
    func setupUI(theController:TrainingPreviewVC) {
        self.setupFont()
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.width / 2
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.clipsToBounds = true
        self.tableView.register(UINib(nibName: "TrainingPreviewCell", bundle: nil), forCellReuseIdentifier: "TrainingPreviewCell")
        self.tableView.isScrollEnabled = false
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
    }
    
    func setupFont() {
        self.lblWhen.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblDate.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblNotesTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNotes.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        self.lblTrainingGoalTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTrainingGoal.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblIntensityTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblIntensity.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTargetHRTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTargetHR.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblLaps.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblDistance.font = themeFont(size: 12, fontname: .Helvetica)
        self.lblSpeed.font = themeFont(size: 12, fontname: .Helvetica)
        self.lblPercentage.font = themeFont(size: 12, fontname: .Helvetica)
        self.lblRest.font = themeFont(size: 12, fontname: .Helvetica)
        
        self.btnEndWorkout.titleLabel?.font = themeFont(size: 14, fontname: .Helvetica)
        self.btnStartWorkout.titleLabel?.font = themeFont(size: 14, fontname: .Helvetica)
        
        self.lblWhen.setColor(color: .appthemeBlackColor)
        self.lblIntensity.setColor(color: .appthemeBlackColor)
        self.lblNotesTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.lblNotes.setColor(color: .appthemeBlackColor)
        self.lblTrainingGoal.setColor(color: .appthemeBlackColor)
        self.lblTargetHR.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColor)

        self.lblIntensityTitle.setColor(color: .appthemeBlackColor)
        self.lblTrainingGoalTitle.setColor(color: .appthemeBlackColor)
        self.lblTargetHRTitle.setColor(color: .appthemeBlackColor)
     
        self.lblLaps.setColor(color: .appthemeBlackColor)
        self.lblDistance.setColor(color: .appthemeBlackColor)
        self.lblSpeed.setColor(color: .appthemeBlackColor)
        self.lblPercentage.setColor(color: .appthemeBlackColor)
        self.lblRest.setColor(color: .appthemeBlackColor)
        self.btnEndWorkout.setColor(color: .appthemeRedColor)
        self.btnStartWorkout.setColor(color: .appthemeWhiteColor)
        self.btnStartWorkout.backgroundColor = UIColor.appthemeOffRedColor
        
        self.lblWhen.text = getCommonString(key: "When_key")
        self.lblIntensityTitle.text = getCommonString(key: "Intensity_key")
        self.lblNotesTitle.text = getCommonString(key: "Notes_key")
        self.lblTrainingGoalTitle.text = getCommonString(key: "Training_Goal_key")
        self.lblTargetHRTitle.text = getCommonString(key: "Target_HR_key")
        
        //Change btnEndWorkout to btnComplete if more button added
        self.btnCompleteWorkout.setTitle(str: getCommonString(key: "Complete_key"))
        self.btnStartWorkout.setTitle(str: getCommonString(key: "Start_key"))
        self.btnEndWorkout.setTitle(str: getCommonString(key: "End_key"))
        
        self.lblSpeedUnit.text = "min/km"
        
        self.heightUnitvw.constant = 0
        self.vwUnit.isHidden = true
 
//        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 102, right: 0)
        
        [self.vwStartWorkout,self.vwEndWorkout,self.vwCompleteWorkout].forEach { (btn) in
            btn?.alpha = 0
        }
        self.vwMainBottom.isUserInteractionEnabled = false
    }
    
    func isSetAlphaOrNOt(isSet:Bool){
        
        if isSet{
            [self.vwStartWorkout,self.vwEndWorkout,self.vwCompleteWorkout].forEach { (vw) in
                vw?.alpha = 1.0
            }
            
            self.vwMainBottom.isUserInteractionEnabled = true
            
        }else{
            [self.vwStartWorkout,self.vwEndWorkout,self.vwCompleteWorkout].forEach { (vw) in
                vw?.alpha = 0.0
            }
            self.vwMainBottom.isUserInteractionEnabled = false
        }
    }
}
