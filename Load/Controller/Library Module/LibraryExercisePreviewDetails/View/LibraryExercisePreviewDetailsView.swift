//
//  LibraryExercisePreviewDetailsView.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LibraryExercisePreviewDetailsView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var imgMainFront: UIImageView!
    @IBOutlet weak var imgMainBack: UIImageView!
    @IBOutlet weak var viewImage: UIView!

    @IBOutlet weak var lblExerciseTitle: UILabel!
    @IBOutlet weak var lblExercise: UILabel!
    
    @IBOutlet weak var lblMotionTitle: UILabel!
    @IBOutlet weak var lblMotion: UILabel!
    
    @IBOutlet weak var lblMovementTitle: UILabel!
    @IBOutlet weak var lblMovement: UILabel!
    
    @IBOutlet weak var lblMechanicsTitle: UILabel!
    @IBOutlet weak var lblMechanicsSubTitle: UILabel!
    @IBOutlet weak var lblMechanics: UILabel!
    
    @IBOutlet weak var lblTargetedMusclesTitle: UILabel!
    @IBOutlet weak var lblTargetedMuscles: UILabel!
    
    @IBOutlet weak var lblActionForceTitle: UILabel!
    @IBOutlet weak var lblActionForce: UILabel!
    
    @IBOutlet weak var lblEquipmentTitle: UILabel!
    @IBOutlet weak var lblEquipment: UILabel!
    
    @IBOutlet weak var lblLinkTitle: UILabel!
    @IBOutlet weak var lblLink: UILabel!
    
    @IBOutlet weak var viewLinkHeight: NSLayoutConstraint!
    @IBOutlet weak var viewLink: UIView!
    
    @IBOutlet weak var vwTxtLinkForDefault: UIView!
    @IBOutlet weak var txtLink: KMPlaceholderTextView!
    @IBOutlet weak var btnLink: UIButton!
    
    @IBOutlet weak var lblPrimaryMusculer: UILabel!
    @IBOutlet weak var lblSecondaryMuscule: UILabel!

    
    //MARK:- Functions
    func setupUI(theController: LibraryExercisePreviewDetailsVC) {
        self.setupFont()
        
        self.lblPrimaryMusculer.text = getCommonString(key: "Primary_Muscle_key")
        self.lblSecondaryMuscule.text = getCommonString(key: "Secondary_Muscle_key")
        
        self.lblPrimaryMusculer.font = themeFont(size: 11, fontname: .ProximaNovaBold)
        self.lblSecondaryMuscule.font = themeFont(size: 11, fontname: .ProximaNovaBold)
        
        self.lblPrimaryMusculer.textColor = UIColor(red: 198/255, green: 96/255, blue: 174/255, alpha: 1.0)
        self.lblSecondaryMuscule.textColor = UIColor(red: 228/255, green: 186/255, blue: 218/255, alpha: 1.0)

    }
    
    func setupFont() {
        self.lblExerciseTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblExercise.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblMotionTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMotion.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblMovementTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMovement.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        self.lblMechanicsTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMechanics.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblTargetedMusclesTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMechanicsSubTitle.font = themeFont(size: 12, fontname: .ProximaNovaThin)
        self.lblTargetedMuscles.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblActionForceTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblActionForce.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblEquipmentTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblEquipment.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblLinkTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
//        self.lblLink.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        
        self.txtLink.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtLink.textAlignment = .left
        self.txtLink.textContainer.lineFragmentPadding = 0
        self.txtLink.placeholderColor = UIColor.appthemeBlackColor
        self.txtLink.textContainerInset = UIEdgeInsets(top: 6, left: 0, bottom: 0, right: 30)
        
        self.lblExerciseTitle.setColor(color: .appthemeBlackColor)
        self.lblExercise.setColor(color: .appthemeBlackColor)
        self.lblMechanicsTitle.setColor(color: .appthemeBlackColor)
        self.lblMechanics.setColor(color: .appthemeBlackColor)
        self.lblTargetedMusclesTitle.setColor(color: .appthemeBlackColor)
        self.lblMechanicsSubTitle.setColor(color: .appthemeBlackColor)
        self.lblTargetedMuscles.setColor(color: .appthemeBlackColor)
        self.lblActionForceTitle.setColor(color: .appthemeBlackColor)
        self.lblActionForce.setColor(color: .appthemeBlackColor)
        self.lblEquipmentTitle.setColor(color: .appthemeBlackColor)
        self.lblEquipment.setColor(color: .appthemeBlackColor)
        
        self.lblLinkTitle.setColor(color: .appthemeBlackColorAlpha30)
//        self.lblLink.setColor(color: .appthemeBlackColor)
        self.txtLink.setColor(color: .appthemeBlackColor)
        
        self.lblExerciseTitle.text = getCommonString(key: "Exercise_key")
        self.lblMechanicsTitle.text = getCommonString(key: "Mechanics_key")
        self.lblMechanicsSubTitle.text = getCommonString(key: "Refers_to_the_number_of_joints_involved_key")
        self.lblTargetedMusclesTitle.text = getCommonString(key: "Targeted_Muscles_key")
        self.lblActionForceTitle.text = getCommonString(key: "Action_/_Force_key")
        self.lblEquipmentTitle.text = getCommonString(key: "Equipment_key")
        self.lblLinkTitle.text = getCommonString(key: "Link_key")
        self.txtLink.placeholder = getCommonString(key: "Provide_the_exercise_URL_link_key")

        self.lblTargetedMuscles.sizeToFit()

    }
}
