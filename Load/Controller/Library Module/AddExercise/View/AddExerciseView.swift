//
//  AddExerciseView.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SDWebImage

class AddExerciseView: UIView, UITextFieldDelegate {
    
    // MARK: @IBOutlet
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblRecords: UILabel!
    
    @IBOutlet weak var imgMainFront: UIImageView!
    @IBOutlet weak var imgMainBack: UIImageView!
    @IBOutlet weak var viewImage: UIView!
    @IBOutlet weak var lblFront: UILabel!
    @IBOutlet weak var lblBack: UILabel!
    
    @IBOutlet weak var lblExerciseTitle: UILabel!
    @IBOutlet weak var txtExercise: UITextField!
    
    @IBOutlet weak var lblRegionTitle: UILabel!
    @IBOutlet weak var txtRegion: UITextField!
    
    @IBOutlet weak var lblCategoryTitle: UILabel!
    @IBOutlet weak var txtCategory: UITextField!
    
    @IBOutlet weak var lblMechanicsTitle: UILabel!
    @IBOutlet weak var txtMechanics: UITextField!
    @IBOutlet weak var lblMechanicsSubTitle: UILabel!
    
    @IBOutlet weak var lblTargetedMusclesTitle: UILabel!
    @IBOutlet weak var txtTargetedMuscles: UITextField!
    
    @IBOutlet weak var lblMotionTitle: UILabel!
    @IBOutlet weak var txtMotion: UITextField!

    @IBOutlet weak var lblMovementTItle: UILabel!
    @IBOutlet weak var txtMovement: UITextField!
    
    @IBOutlet weak var lblActionForceTitle: UILabel!
    @IBOutlet weak var txtActionForce: UITextField!
    
    @IBOutlet weak var lblEquipmentTitle: UILabel!
    @IBOutlet weak var txtEquipment: UITextField!
    
    @IBOutlet weak var lblLinkTitle: UILabel!
    @IBOutlet weak var txtLink: KMPlaceholderTextView!
    @IBOutlet weak var btnLinkEnableDisable: UIButton!
    
    
    @IBOutlet weak var vwNext: UIView!
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var lblPrimaryMusculer: UILabel!
    @IBOutlet weak var lblSecondaryMuscule: UILabel!
    
    // MARK: Functions
    func setupUI(theController:AddExerciseVC) {
        self.setupFont(theController: theController)
//        self.txtExercise.delegate = self
        self.txtEquipment.isUserInteractionEnabled = false
        
//        self.imgMainFront.sd_setImage(with: GetAllData?.data?.defaultBodyPartImageUrlFront?.toURL(), completed: nil)
//        self.imgMainBack.sd_setImage(with: GetAllData?.data?.defaultBodyPartImageUrlBack?.toURL(), completed: nil)
        
        self.imgMainFront.image = UIImage(named: "anatomy_front")
        self.imgMainBack.image = UIImage(named: "anatomy_back")
        
        self.lblPrimaryMusculer.text = getCommonString(key: "Primary_Muscle_key")
        self.lblSecondaryMuscule.text = getCommonString(key: "Secondary_Muscle_key")
        
        self.lblPrimaryMusculer.font = themeFont(size: 11, fontname: .ProximaNovaBold)
        self.lblSecondaryMuscule.font = themeFont(size: 11, fontname: .ProximaNovaBold)
        
        self.lblPrimaryMusculer.textColor = UIColor(red: 198/255, green: 96/255, blue: 174/255, alpha: 1.0)
        self.lblSecondaryMuscule.textColor = UIColor(red: 228/255, green: 186/255, blue: 218/255, alpha: 1.0)

    }
    
    func setupFont(theController:AddExerciseVC) {
        self.lblDetails.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblRecords.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        [self.lblFront,self.lblBack].forEach { (lbl) in
            lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            lbl?.setColor(color: .appthemeBlackColor)
        }
        
        self.lblExerciseTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtExercise.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblRegionTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtRegion.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblCategoryTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtCategory.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMechanicsTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtMechanics.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMechanicsSubTitle.font = themeFont(size: 11, fontname: .ProximaNovaThin)
        self.lblTargetedMusclesTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtTargetedMuscles.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblActionForceTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtActionForce.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblEquipmentTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtEquipment.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblLinkTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtLink.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMotionTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtMotion.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblMovementTItle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtMovement.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.btnNext.titleLabel?.font = themeFont(size: 23, fontname: .ProximaNovaBold)
         
        self.lblDetails.setColor(color: .appthemeRedColor)
        self.lblRecords.setColor(color: .appthemeBlackColor)
        self.lblExerciseTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.txtExercise.setColor(color: .appthemeBlackColor)
        self.lblRegionTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.txtRegion.setColor(color: .appthemeBlackColor)
        self.lblCategoryTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.txtCategory.setColor(color: .appthemeBlackColor)
        self.lblMechanicsTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.txtMechanics.setColor(color: .appthemeBlackColor)
        self.lblMechanicsSubTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.lblTargetedMusclesTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.txtTargetedMuscles.setColor(color: .appthemeBlackColor)
        self.lblActionForceTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.txtActionForce.setColor(color: .appthemeBlackColor)
        self.lblEquipmentTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.txtEquipment.setColor(color: .appthemeBlackColor)
        self.lblLinkTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.txtLink.setColor(color: .appthemeBlackColor)
        self.btnNext.setColor(color: .appthemeWhiteColor)
        
        self.lblDetails.text = getCommonString(key: "Details_key")
        self.lblRecords.text = getCommonString(key: "Records_key")
        self.lblExerciseTitle.text = getCommonString(key: "Exercise_key")
        self.lblFront.text = getCommonString(key: "Front_key")
        self.lblBack.text = getCommonString(key: "Back_key")
        self.txtExercise.placeholder = getCommonString(key: "Name_your_exercise_key")
        self.lblRegionTitle.text = getCommonString(key: "Region_key")
        self.txtRegion.placeholder = getCommonString(key: "Select_region_key")
        self.lblCategoryTitle.text = getCommonString(key: "Category_key")
        self.txtCategory.placeholder = getCommonString(key: "Select_category_key")
        self.lblMechanicsTitle.text = getCommonString(key: "Mechanics_key")
        self.txtMechanics.placeholder = getCommonString(key: "Select_the_exercise_mechanics_key")
        self.lblTargetedMusclesTitle.text = getCommonString(key: "Targeted_Muscles_key")
        self.txtTargetedMuscles.placeholder = getCommonString(key: "Select_the_main_muscle_involved_key")
        self.lblMechanicsSubTitle.text = getCommonString(key: "Refers_to_the_number_of_joints_involved_key")
        self.lblActionForceTitle.text = getCommonString(key: "Action_/_Force_key")
        self.txtActionForce.placeholder = getCommonString(key: "Select_the_direction_of_the_force_key")
        self.lblEquipmentTitle.text = getCommonString(key: "Equipment_key")
        self.txtEquipment.placeholder = getCommonString(key: "Select_the_equipment_used_key")
        self.lblLinkTitle.text = getCommonString(key: "Link_key")
        self.txtLink.placeholder = getCommonString(key: "Provide_the_exercise_URL_link_key")
        self.btnNext.setTitle(str: getCommonString(key: "Next_key"))
        
        [self.txtExercise,self.txtCategory,self.txtRegion,self.txtMechanics,self.txtTargetedMuscles,self.txtActionForce,self.txtEquipment,self.txtMotion,self.txtMovement].forEach { (txt) in
            
            txt?.delegate = theController
            txt?.attributedPlaceholder = NSAttributedString(string: txt?.placeholder ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.appthemeBlackColor])

        }
        
        self.txtLink.placeholderColor = UIColor.appthemeBlackColor
        self.txtLink.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        
        vwNext.alpha = 0
        vwNext.isUserInteractionEnabled = false
        
        

    }
    
    //MARK: - TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        print(txtAfterUpdate.count)
        if textField == self.txtExercise {
            if txtAfterUpdate.count > 30 {
                return false
            }
        }
       
        return true
    }
}

