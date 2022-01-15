//
//  LogPreviewView.swift
//  Load
//
//  Created by Haresh Bhai on 07/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LogPreviewView: UIView {

    @IBOutlet weak var imgOfStartWorkout: UIImageView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgActivity: UIImageView!    
    @IBOutlet weak var lblWhen: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    @IBOutlet weak var lblTrainingGoalTitle: UILabel!
    @IBOutlet weak var lblTrainingGoal: UILabel!
    @IBOutlet weak var lblIntensityTitle: UILabel!
    @IBOutlet weak var lblIntensity: UILabel!
    @IBOutlet weak var lblTargetHRTitle: UILabel!
    @IBOutlet weak var lblTargetHR: UILabel!
    
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblRPM: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblRest: UILabel!
    @IBOutlet weak var lblLvl: UILabel!
    @IBOutlet weak var vwLvl: UIView!
    @IBOutlet weak var viewRPM: UIView!
    @IBOutlet weak var lblLapsTitle: UILabel!

    @IBOutlet weak var btnShowUnit: UIButton!
    @IBOutlet weak var vwUnit: UIView!
    
    @IBOutlet weak var btnSaveAsTemplete: CustomButton!
    @IBOutlet weak var btnCompleteWorkout: UIButton!
    @IBOutlet weak var btnStartWorkout: UIButton!
    @IBOutlet weak var btnEndWorkout: UIButton!
    @IBOutlet weak var btnRepeatWorkout: UIButton!
    
    @IBOutlet weak var vwMainBottom: UIView!
    @IBOutlet weak var vwCompleteWorkout: CustomView!
    @IBOutlet weak var vwRepeatWorkout: CustomView!
    @IBOutlet weak var vwEndWorkout: CustomView!
    @IBOutlet weak var vwStartWorkout: CustomView!
    
    @IBOutlet weak var lblDurationUnit: UILabel!
    @IBOutlet weak var lblSpeedUnit: UILabel!
    @IBOutlet weak var lblRestUnit: UILabel!
    @IBOutlet weak var vwDurationUnit: UIView!
    @IBOutlet weak var vwSpeedUnit: UIView!
    @IBOutlet weak var vwRestUnit: UIView!
    @IBOutlet weak var vwLvlUnit: UIView!
    @IBOutlet weak var vwRPMUnit: UIView!
    @IBOutlet weak var vwPercentageUnit: UIView!
    @IBOutlet weak var heightUnitvw: NSLayoutConstraint!
    
    @IBOutlet weak var vwCyclingOutdoorPercentage: UIView!
    @IBOutlet weak var lblCyclingOutdoorPercentage: UILabel!
    @IBOutlet weak var vwCyclingOutdoorPercentageUnit: UIView!
    
    @IBOutlet weak var vwStackViewHeader: UIStackView!
    @IBOutlet weak var vwStackViewUnit: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var heightOfVwBottom: NSLayoutConstraint!
    @IBOutlet weak var topOfStackView: NSLayoutConstraint!
    
    @IBOutlet weak var constraintBottomofStackView: NSLayoutConstraint!
    @IBOutlet weak var ConstratintBottomViewHeigh: NSLayoutConstraint!
    
    //Exercise
    
    @IBOutlet weak var viewPercentage: UIView!
//    @IBOutlet weak var leftViewPercentage: NSLayoutConstraint!
//    @IBOutlet weak var rightViewPercentage: NSLayoutConstraint!
    
    func setupUI() {
        self.setupFont()
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.width / 2
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.clipsToBounds = true
        self.tableView.register(UINib(nibName: "LogPreviewCell", bundle: nil), forCellReuseIdentifier: "LogPreviewCell")
        self.tableView.isScrollEnabled = false
    }
    
    func setupFont() {
        self.lblWhen.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblDate.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblSubTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTrainingGoalTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTrainingGoal.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblIntensityTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblIntensity.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTargetHRTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTargetHR.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblLapsTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblSpeed.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblPercentage.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblRPM.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblDuration.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblRest.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        
        self.btnSaveAsTemplete.titleLabel?.font = themeFont(size: 10, fontname: .Helvetica)
        self.btnCompleteWorkout.titleLabel?.font = themeFont(size: 14, fontname: .Helvetica)
        self.btnStartWorkout.titleLabel?.font = themeFont(size: 14, fontname: .Helvetica)
        self.btnEndWorkout.titleLabel?.font = themeFont(size: 14, fontname: .Helvetica)
        
        self.lblWhen.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColor)
        self.lblName.setColor(color: .appthemeBlackColorAlpha30)
        self.lblTrainingGoal.setColor(color: .appthemeBlackColor)
        self.lblIntensity.setColor(color: .appthemeBlackColor)
        self.lblTargetHR.setColor(color: .appthemeBlackColor)
        
        self.lblIntensityTitle.setColor(color: .appthemeBlackColor)
        self.lblTrainingGoalTitle.setColor(color: .appthemeBlackColor)
        self.lblTargetHRTitle.setColor(color: .appthemeBlackColor)
     
        self.lblLapsTitle.setColor(color: .appthemeBlackColor)
        self.lblSpeed.setColor(color: .appthemeBlackColor)
        self.lblPercentage.setColor(color: .appthemeBlackColor)
        self.lblRPM.setColor(color: .appthemeBlackColor)
        self.lblDuration.setColor(color: .appthemeBlackColor)
        self.lblRest.setColor(color: .appthemeBlackColor)
        self.btnSaveAsTemplete.setColor(color: .appthemeRedColor)
        self.btnCompleteWorkout.setColor(color: .appthemeRedColor)
        self.btnEndWorkout.setColor(color: .appthemeRedColor)
        self.btnStartWorkout.setColor(color: .appthemeWhiteColor)
        
        self.lblWhen.text = getCommonString(key: "When_key")
        self.lblIntensity.text = getCommonString(key: "Intensity_key")
        self.lblName.text = getCommonString(key: "Notes_key")
        self.lblTrainingGoal.text = getCommonString(key: "Training_Goal_key")
        self.lblTargetHR.text = getCommonString(key: "Target_HR_key")
        
        self.btnSaveAsTemplete.setTitle(str: getCommonString(key: "Save_as_template_key"))
        self.btnCompleteWorkout.setTitle(str: getCommonString(key: "Complete_key"))
        self.btnStartWorkout.setTitle(str: getCommonString(key: "Start_key"))
        
        self.btnRepeatWorkout.setTitle(str: getCommonString(key: "Repeat_key"))
        self.btnRepeatWorkout.setColor(color: .appthemeRedColor)
        self.btnRepeatWorkout.titleLabel?.font = themeFont(size: 14, fontname: .Helvetica)

        self.heightUnitvw.constant = 0
        self.vwUnit.isHidden = true
                
        self.heightOfVwBottom.constant = 0

        [self.vwRepeatWorkout,self.vwEndWorkout,self.vwCompleteWorkout,self.vwStartWorkout].forEach { (vw) in
            vw?.setShadowToView()
        }
        
//        self.ConstratintBottomView.constant = 0

    }
    
    func isSetAlphaOrNOt(isSet:Bool){
        
        if isSet{
            [self.vwRepeatWorkout,self.vwEndWorkout,self.vwCompleteWorkout,self.vwStartWorkout].forEach { (vw) in
                vw?.alpha = 1.0
            }
            
            self.vwMainBottom.isUserInteractionEnabled = true
            
        }else{
            [self.vwRepeatWorkout,self.vwEndWorkout,self.vwCompleteWorkout,self.vwStartWorkout].forEach { (vw) in
                vw?.alpha = 0.0
            }
            self.vwMainBottom.isUserInteractionEnabled = false
        }
        
    }
    
    func isBottomDeleteShareShow(isShow:Bool){
        
        if isShow{
            heightOfVwBottom.constant = 75
            [self.btnDelete,self.btnShare,self.btnSaveAsTemplete].forEach { (btn) in
                btn?.alpha = 1
            }
            
            self.vwMainBottom.isUserInteractionEnabled = true
            
        }else{
            heightOfVwBottom.constant = 0
            [self.btnDelete,self.btnShare,self.btnSaveAsTemplete].forEach { (btn) in
                btn?.alpha = 0
            }
            self.vwMainBottom.isUserInteractionEnabled = false
        }
    }
    
    func vwBottomHiddenShow(isHidden:Bool = false){
        
        if isHidden{
            vwBottom.isHidden = true
            btnDelete.isHidden = true
            btnSaveAsTemplete.isHidden = true
            btnShare.isHidden = true
            heightOfVwBottom.constant = 0
            topOfStackView.constant = 30.5
//            ConstratintBottomView.constant = 0
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 102, right: 0)
        }else{
//            vwBottom.isHidden = false
            btnDelete.isHidden = false
            btnSaveAsTemplete.isHidden = false
            btnShare.isHidden = false
//            heightOfVwBottom.constant = 75
            topOfStackView.constant = 30.5
//            ConstratintBottomView.constant = 15
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 177, right: 0)
        }
        
    }
    
}
