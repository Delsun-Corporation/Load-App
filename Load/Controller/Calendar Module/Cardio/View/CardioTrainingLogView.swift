//
//  CardioTrainingLogView.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CardioTrainingLogView: UIView {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var txtActivity: UITextField!
    
    @IBOutlet weak var lblWhen: UILabel!
    @IBOutlet weak var txtWhen: UITextField!
    
    @IBOutlet weak var lblIntensity: UILabel!
    @IBOutlet weak var txtIntensity: UITextField!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var lblTrainingGoal: UILabel!
    @IBOutlet weak var txtTrainingGoal: UITextField!
    
    @IBOutlet weak var lblTargetHR: UILabel!
    @IBOutlet weak var txtTargetHR: UITextField!
    
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var txtNotes: KMPlaceholderTextView!
    
    @IBOutlet weak var vwStyle: UIView!
    @IBOutlet weak var lblStyleHeading: UILabel!
    @IBOutlet weak var txtStyle: UITextField!
    
    //    @IBOutlet weak var lblLaps: UILabel!
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblRPM: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblRest: UILabel!
    @IBOutlet weak var lblLvl: UILabel!
    
    @IBOutlet weak var btnSendToFriend: CustomButton!
    @IBOutlet weak var btnSaveAsTemplete: CustomButton!
    @IBOutlet weak var btnLogIt: UIButton!
    
    @IBOutlet weak var imgDurationArrow: UIImageView!
    @IBOutlet weak var imgSpeedArrow: UIImageView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var lblLapsTitle: UILabel!
    @IBOutlet weak var widthSpeedArrowImage: NSLayoutConstraint!
    
    //Exercise
    
    @IBOutlet weak var stackViewHeader: UIStackView!
    @IBOutlet weak var vwLvl: UIView!
    @IBOutlet weak var viewPercentage: UIView!
    @IBOutlet weak var viewRPM: UIView!
    @IBOutlet weak var btnRPM: UIButton!
     @IBOutlet weak var imgRPMArrow: UIImageView!
    
    @IBOutlet weak var vwCyclingOutdoorPercentage: UIView!
    
    @IBOutlet weak var viewCustomTrainingGoal: UIView!
    @IBOutlet weak var heightCustomTrainingGoal: NSLayoutConstraint!
    @IBOutlet weak var txtCustomTrainingGoal: UITextField!

    @IBOutlet weak var vwMainBottom: UIView!
    
    @IBOutlet weak var vwlogIt: UIView!
    @IBOutlet weak var vwBottom2Buttons: UIView!
    @IBOutlet weak var constraintBottomVwMainBottom: NSLayoutConstraint!
    
    @IBOutlet weak var vwSaveAsTemplate: UIView!
    @IBOutlet weak var vwSendToFriend: UIView!
    
    //MARK: - SetUp UI
    
    func setupUI(theController:CardioTrainingLogVC) {
        self.setupFont()
        
        [txtActivity,txtWhen,txtName,txtIntensity,txtTargetHR,txtTrainingGoal].forEach { (txt) in
            txt?.delegate = theController
        }
        
//        self.txtTargetHR.delegate = theController
        self.mainScrollView.delegate = theController
        self.tableView.isScrollEnabled = false
        self.tableView.register(UINib(nibName: "AddRowCell", bundle: nil), forCellReuseIdentifier: "AddRowCell")
        self.tableView.register(UINib(nibName: "ExerciseCardioCell", bundle: nil), forCellReuseIdentifier: "ExerciseCardioCell")
    }
    
    func setupFont() {
        self.lblActivity.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblWhen.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblIntensity.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTrainingGoal.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTargetHR.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNotes.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblStyleHeading.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.txtActivity.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtWhen.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtIntensity.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtTrainingGoal.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtTargetHR.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtStyle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtNotes.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblLapsTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

//        self.lblLaps.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblSpeed.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblPercentage.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblRPM.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblDuration.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblRest.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblLvl.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        
        self.btnSaveAsTemplete.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.btnSendToFriend.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.btnLogIt.titleLabel?.font = themeFont(size: 23, fontname: .ProximaNovaBold)
       
        self.lblActivity.setColor(color: .appthemeBlackColorAlpha30)
        self.lblWhen.setColor(color: .appthemeBlackColorAlpha30)
        self.lblIntensity.setColor(color: .appthemeBlackColorAlpha30)
        self.lblName.setColor(color: .appthemeBlackColorAlpha30)
        self.lblTrainingGoal.setColor(color: .appthemeBlackColorAlpha30)
        self.lblTargetHR.setColor(color: .appthemeBlackColorAlpha30)
        self.lblStyleHeading.setColor(color: .appthemeBlackColorAlpha30)
        self.lblNotes.setColor(color: .appthemeBlackColorAlpha30)
        self.txtActivity.setColor(color: .appthemeBlackColor)
        self.txtWhen.setColor(color: .appthemeBlackColor)
        self.txtIntensity.setColor(color: .appthemeBlackColor)
        self.txtName.setColor(color: .appthemeBlackColor)
        self.txtTrainingGoal.setColor(color: .appthemeBlackColor)
        self.txtTargetHR.setColor(color: .appthemeBlackColor)
        self.txtNotes.setColor(color: .appthemeBlackColor)
//        self.lblLaps.setColor(color: .appthemeBlackColor)
        self.lblSpeed.setColor(color: .appthemeBlackColor)
        self.lblPercentage.setColor(color: .appthemeBlackColor)
        self.lblRPM.setColor(color: .appthemeBlackColor)
        self.lblDuration.setColor(color: .appthemeBlackColor)
        self.lblRest.setColor(color: .appthemeBlackColor)
        self.lblLvl.setColor(color: .appthemeBlackColor)
        self.btnSaveAsTemplete.setColor(color: .appthemeRedColor)
        self.btnSendToFriend.setColor(color: .appthemeRedColor)
        self.btnLogIt.setColor(color: .appthemeWhiteColor)
        self.lblLapsTitle.setColor(color: .appthemeBlackColor)

        self.lblActivity.text = getCommonString(key: "Activity_key")
        self.lblWhen.text = getCommonString(key: "When_key")
        self.lblIntensity.text = getCommonString(key: "Intensity_key")
        self.lblName.text = getCommonString(key: "Workout_Name_key")
        self.lblTrainingGoal.text = getCommonString(key: "Training_Goal_key")
        self.lblTargetHR.text = getCommonString(key: "Target_HR_key")
        self.lblNotes.text = getCommonString(key: "Notes_key")
        
        self.txtActivity.placeholder = getCommonString(key: "Select_your_workout_key")
        self.txtWhen.placeholder = getCommonString(key: "Select_your_date_key")
        self.txtIntensity.placeholder = getCommonString(key: "Select_your_Intensity_key")
        self.txtName.placeholder = getCommonString(key: "Title_your_workout_key")
        self.txtTrainingGoal.placeholder = getCommonString(key: "Fill_in_your_training_goal_key")
        self.txtTargetHR.placeholder = getCommonString(key: "Select_your_target_HR_key")
        self.txtNotes.placeholder = getCommonString(key: "Leave_your_notes_here_key")
        
        self.btnSaveAsTemplete.setTitle(str: getCommonString(key: "Save_as_template_key"))
        self.btnSendToFriend.setTitle(str: getCommonString(key: "Send_to_friend_key"))
        self.btnLogIt.setTitle(str: getCommonString(key: "Log_it_key"))
        
        btnLogIt.backgroundColor = UIColor.appthemeGrayColor
        btnLogIt.isUserInteractionEnabled = false
        
        [self.btnSaveAsTemplete,self.btnSendToFriend].forEach { (btn) in
            btn?.borderColor = UIColor.appthemeBlackColor
            btn?.borderWidth = 1
            btn?.setTitleColor(UIColor.appthemeBlackColor, for: .normal)
            btn?.isUserInteractionEnabled = false
        }

//        self.constraintVwMainBottomHeight.constant = 0
//        self.vwMainBottom.isHidden = true
//        self.vwMainBottom.isUserInteractionEnabled = false
        
        self.constraintBottomVwMainBottom.constant = -79
        
        [self.vwSendToFriend,self.vwSaveAsTemplate].forEach { (vw) in
            vw?.isHidden = true
        }

//        self.constraintTopVwLogIt.constant = -70
//
//        [self.vwSendToFriend,self.vwSaveAsTemplate].forEach { (vw) in
//            vw?.alpha = 0.0
//        }
        
//        self.mainScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 177, right: 0)

    }
}
