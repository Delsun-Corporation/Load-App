//
//  CreateRequestStepTwoView.swift
//  Load
//
//  Created by Haresh Bhai on 24/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView

class CreateRequestStepTwoView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblCoachRequirement: UILabel!
    @IBOutlet weak var lblRequestTitle: UILabel!    
    
    @IBOutlet weak var txtSpecialization: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblCoachExperience: UILabel!
    @IBOutlet weak var txtCoachExperience: UITextField!
    
    @IBOutlet weak var lblTypesOfTraining: UILabel!
    @IBOutlet weak var txtTypesOfTraining: UITextField!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var txtLocation: UITextField!
    
    @IBOutlet weak var lblRating: UILabel!    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var rateView: FloatRatingView!
    
    //MARK:- Functions
    func setupUI(theController:CreateRequestStepTwoVC) {
        self.txtTypesOfTraining.isUserInteractionEnabled = false
        let nibName = UINib(nibName: "SpecializationCell", bundle:nil)
        self.collectionView.register(nibName, forCellWithReuseIdentifier: "SpecializationCell")
        self.collectionView.delegate = theController
        self.collectionView.dataSource = theController
        self.setupFont()
        self.setupRating(rate: 0)
    }
    
    func setupRating(rate:Double) {
        rateView.delegate = self
        rateView.contentMode = UIView.ContentMode.scaleAspectFit
        rateView.type = .halfRatings
        rateView.rating = rate
    }
    
    func setupFont() {
        self.lblCoachRequirement.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblRequestTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblCoachExperience.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtCoachExperience.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.txtSpecialization.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblTypesOfTraining.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtTypesOfTraining.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblLocation.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.txtLocation.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblRating.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.btnNext.titleLabel?.font = themeFont(size: 17, fontname: .Regular)
        
        self.lblCoachRequirement.setColor(color: .appthemeBlackColor)
        self.lblRequestTitle.setColor(color: .appthemeBlackColorAlpha30)
        self.lblCoachExperience.setColor(color: .appthemeBlackColorAlpha30)
        self.txtCoachExperience.setColor(color: .appthemeBlackColor)
        self.txtSpecialization.setColor(color: .appthemeBlackColor)

        self.lblTypesOfTraining.setColor(color: .appthemeBlackColorAlpha30)
        self.txtTypesOfTraining.setColor(color: .appthemeBlackColor)
        self.lblLocation.setColor(color: .appthemeBlackColorAlpha30)
        self.txtLocation.setColor(color: .appthemeBlackColor)
        self.lblRating.setColor(color: .appthemeBlackColorAlpha30)
        self.btnNext.setColor(color: .appthemeWhiteColor)
        
        self.lblCoachRequirement.text = getCommonString(key: "Coach_Requirement_key")
        self.lblRequestTitle.text = getCommonString(key: "What_sports_specialization_key")
        self.lblCoachExperience.text = getCommonString(key: "What_is_the_minimum_coach’s_experience?_key")
        self.txtCoachExperience.placeholder = getCommonString(key: "Select_years_key")
        self.txtSpecialization.placeholder = getCommonString(key: "Select_your_specialization_key")
        self.lblTypesOfTraining.text = getCommonString(key: "Types_of_training_key")
        self.txtTypesOfTraining.placeholder = getCommonString(key: "Select_training_key")
        self.lblLocation.text = getCommonString(key: "Location_key")
        self.txtLocation.placeholder = getCommonString(key: "Select_location_key")
        self.lblRating.text = getCommonString(key: "Ratings_key")
        self.btnNext.setTitle(str: getCommonString(key: "Next_key"))
    }    
}

extension CreateRequestStepTwoView: FloatRatingViewDelegate {
    // MARK: FloatRatingViewDelegate
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
    }
}

