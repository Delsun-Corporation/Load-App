//
//  ResistanceTrainingLogView.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ResistanceTrainingLogView: UIView {
    
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblWhen: UILabel!
    @IBOutlet weak var txtWhen: UITextField!
    
    @IBOutlet weak var lblTrainingGoal: UILabel!
    @IBOutlet weak var txtTrainingGoal: UITextField!
    
    @IBOutlet weak var lblIntensity: UILabel!
    @IBOutlet weak var txtIntensity: UITextField!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var lblNotes: UILabel!
    @IBOutlet weak var txtNotes: KMPlaceholderTextView!
    
    @IBOutlet weak var lblExercise: UILabel!
    
    @IBOutlet weak var btnSendToFriend: CustomButton!
    @IBOutlet weak var btnSaveAsTemplete: CustomButton!
    @IBOutlet weak var btnLogIt: UIButton!
//    @IBOutlet weak var lblLogTitle: UILabel!
    
    @IBOutlet weak var viewCustomTrainingGoal: UIView!
    @IBOutlet weak var heightCustomTrainingGoal: NSLayoutConstraint!
    @IBOutlet weak var txtCustomTrainingGoal: UITextField!

    @IBOutlet weak var vwSaveAsTemplate: UIView!
    @IBOutlet weak var vwSendToFriend: UIView!
    @IBOutlet weak var constraintBottomVwMainBottom: NSLayoutConstraint!

    
    func setupUI() {
        self.setupFont()
//        self.tableView.register(UINib(nibName: "ExerciseResistanceCell", bundle: nil), forCellReuseIdentifier: "ExerciseResistanceCell")
        self.tableView.register(UINib(nibName: "ExerciseResistanceMainCell", bundle: nil), forCellReuseIdentifier: "ExerciseResistanceMainCell")
        self.tableView.isScrollEnabled = false
    }
    
    func setupFont() {
        self.lblWhen.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblIntensity.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTrainingGoal.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtWhen.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtIntensity.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtName.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtTrainingGoal.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblExercise.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.btnSaveAsTemplete.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.btnSendToFriend.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.btnLogIt.titleLabel?.font = themeFont(size: 23, fontname: .ProximaNovaBold)
//        self.lblLogTitle.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblNotes.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtNotes.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        self.lblWhen.setColor(color: .appthemeBlackColorAlpha30)
        self.lblIntensity.setColor(color: .appthemeBlackColorAlpha30)
        self.lblName.setColor(color: .appthemeBlackColorAlpha30)
        self.lblTrainingGoal.setColor(color: .appthemeBlackColorAlpha30)
        self.txtWhen.setColor(color: .appthemeBlackColor)
        self.txtIntensity.setColor(color: .appthemeBlackColor)
        self.txtName.setColor(color: .appthemeBlackColor)
        self.txtTrainingGoal.setColor(color: .appthemeBlackColor)
        self.lblExercise.setColor(color: .appthemeBlackColor)
        self.btnSaveAsTemplete.setColor(color: .appthemeRedColor)
        self.btnSendToFriend.setColor(color: .appthemeRedColor)
        self.btnLogIt.setColor(color: .appthemeWhiteColor)
//        self.lblLogTitle.setColor(color: .appthemeBlackColor)
        self.lblNotes.setColor(color: .appthemeBlackColorAlpha30)
        self.txtNotes.setColor(color: .appthemeBlackColor)

        self.lblWhen.text = getCommonString(key: "When_key")
        self.lblIntensity.text = getCommonString(key: "Intensity_key")
        self.lblName.text = getCommonString(key: "Workout_Name_key")
        self.lblTrainingGoal.text = getCommonString(key: "Training_Goal_key")
        
        self.txtWhen.placeholder = getCommonString(key: "Select_your_date_key")
        self.txtIntensity.placeholder = getCommonString(key: "Select_your_Intensity_key")
        self.txtName.placeholder = getCommonString(key: "Title_your_workout_key")
        self.txtTrainingGoal.placeholder = getCommonString(key: "Select_your_goal_key")
        
        self.btnSaveAsTemplete.setTitle(str: getCommonString(key: "Save_as_template_key"))
        self.btnSendToFriend.setTitle(str: getCommonString(key: "Send_to_friend_key"))
        self.lblNotes.text = getCommonString(key: "Notes_key")
        self.txtNotes.placeholder = getCommonString(key: "Leave_your_notes_here_key")

        self.btnLogIt.setTitle(str: getCommonString(key: "Log_it_key"))
        
        self.constraintBottomVwMainBottom.constant = -79
        
        btnLogIt.backgroundColor = UIColor.appthemeGrayColor
        btnLogIt.isUserInteractionEnabled = false
        
        [self.btnSaveAsTemplete,self.btnSendToFriend].forEach { (btn) in
            btn?.borderColor = UIColor.appthemeBlackColor
            btn?.borderWidth = 1
            btn?.setTitleColor(UIColor.appthemeBlackColor, for: .normal)
            btn?.isUserInteractionEnabled = false
        }
        
        
        [self.vwSendToFriend,self.vwSaveAsTemplate].forEach { (vw) in
            vw?.isHidden = true
        }

    }
}
