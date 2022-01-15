//
//  LogPreviewResistanceView.swift
//  Load
//
//  Created by Haresh Bhai on 08/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LogPreviewResistanceView: UIView {
    
    //MARK: - Outlet
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
    
    @IBOutlet weak var lblCompletedVolumeTitle: UILabel!
    @IBOutlet weak var lblCompletedVolumeValue: UILabel!
    
    @IBOutlet weak var lblTargetedVolumeTitle: UILabel!
    @IBOutlet weak var lblTargetedVolumeValue: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightTableView: NSLayoutConstraint!
    
    @IBOutlet weak var lblExercise: UILabel!
    
    @IBOutlet weak var btnSaveAsTemplete: CustomButton!
    @IBOutlet weak var btnCompleteWorkout: UIButton!
    @IBOutlet weak var btnStartWorkout: UIButton!
    @IBOutlet weak var btnEndWorkout: UIButton!
//    @IBOutlet weak var btnRepeatWorkout: UIButton!
    
    @IBOutlet weak var vwMainBottom: UIView!
    @IBOutlet weak var vwCompleteWorkout: CustomView!
//    @IBOutlet weak var vwRepeatWorkout: CustomView!
    @IBOutlet weak var vwEndWorkout: CustomView!
    @IBOutlet weak var vwStartWorkout: CustomView!
    
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var heightOfVwBottom: NSLayoutConstraint!
    
    @IBOutlet weak var ConstratintBottomViewHeigh: NSLayoutConstraint!


    //MARK: - SetupUI
    func setupUI() {
        self.setupFont()
        self.imgProfile.layer.cornerRadius = self.imgProfile.bounds.width / 2
        self.imgProfile.layer.masksToBounds = true
        self.imgProfile.clipsToBounds = true
        self.tableView.register(UINib(nibName: "ExerciseResistancePreviewCell", bundle: nil), forCellReuseIdentifier: "ExerciseResistancePreviewCell")
        self.tableView.isScrollEnabled = false
    }

    func setupFont() {
        self.lblWhen.font = themeFont(size: 18, fontname: .ProximaNovaBold)
        self.lblDate.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblSubTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTrainingGoalTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTrainingGoal.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblIntensityTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblIntensity.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblExercise.font = themeFont(size: 12, fontname: .Helvetica)
        self.btnEndWorkout.titleLabel?.font = themeFont(size: 14, fontname: .Helvetica)

        self.btnSaveAsTemplete.setColor(color: .appthemeRedColor)
        self.btnCompleteWorkout.setColor(color: .appthemeRedColor)
        self.btnEndWorkout.setColor(color: .appthemeRedColor)
        self.btnStartWorkout.setColor(color: .appthemeWhiteColor)
        
        [self.lblCompletedVolumeTitle,self.lblTargetedVolumeTitle].forEach { (lbl) in
            lbl?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
            lbl?.textColor = UIColor.appthemeBlackColor
        }
        
        [self.lblCompletedVolumeValue,self.lblTargetedVolumeValue].forEach { (lbl) in
            lbl?.font = themeFont(size: 30, fontname: .ProximaNovaBold)
            lbl?.textColor = UIColor.appthemeBlackColor
        }
        
        self.heightOfVwBottom.constant = 0

        [self.vwEndWorkout,self.vwCompleteWorkout,self.vwStartWorkout].forEach { (vw) in
            vw?.setShadowToView()
        }

        self.lblCompletedVolumeValue.textColor = UIColor.appthemeOffRedColor
        
        self.lblWhen.setColor(color: .appthemeBlackColor)
        self.lblDate.setColor(color: .appthemeBlackColor)
        self.lblIntensity.setColor(color: .appthemeBlackColor)
        self.lblTrainingGoal.setColor(color: .appthemeBlackColor)
        self.lblIntensityTitle.setColor(color: .appthemeBlackColor)
        self.lblTrainingGoalTitle.setColor(color: .appthemeBlackColor)
        self.lblName.setColor(color: .appthemeBlackColorAlpha30)
        
        self.lblExercise.setColor(color: .appthemeBlackColor)
     
//        self.btnEndWorkout.setColor(color: .appthemeWhiteColor)
        
        self.lblWhen.text = getCommonString(key: "When_key")
        self.lblIntensity.text = getCommonString(key: "Intensity_key")
        self.lblName.text = getCommonString(key: "Notes_key")
        self.lblTrainingGoal.text = getCommonString(key: "Training_Goal_key")
        
        self.btnEndWorkout.setTitle(str: getCommonString(key: "End_Workout_key"))
        self.btnSaveAsTemplete.setTitle(str: getCommonString(key: "Save_as_template_key"))
        self.btnCompleteWorkout.setTitle(str: getCommonString(key: "Complete_key"))
        self.btnStartWorkout.setTitle(str: getCommonString(key: "Start_key"))

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
//            ConstratintBottomView.constant = 0
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 102, right: 0)
        }else{
//            vwBottom.isHidden = false
            btnDelete.isHidden = false
            btnSaveAsTemplete.isHidden = false
            btnShare.isHidden = false
//            heightOfVwBottom.constant = 75
//            ConstratintBottomView.constant = 15
            self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 177, right: 0)
        }
        
    }
    
    func isSetAlphaOrNOt(isSet:Bool){
        
        if isSet{
            [self.vwEndWorkout,self.vwCompleteWorkout,self.vwStartWorkout].forEach { (vw) in
                vw?.alpha = 1.0
            }
            
            self.vwMainBottom.isUserInteractionEnabled = true
            
        }else{
            [self.vwEndWorkout,self.vwCompleteWorkout,self.vwStartWorkout].forEach { (vw) in
                vw?.alpha = 0.0
            }
            self.vwMainBottom.isUserInteractionEnabled = false
        }
        
    }


}
