//
//  CreateRequestFinishView.swift
//  Load
//
//  Created by Haresh Bhai on 24/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView
class CreateRequestFinishView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblBroadCastSummery: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblYears: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblStartDateTitle: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblCoachRequirement: UILabel!
    @IBOutlet weak var lblExperienceTitle: UILabel!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var lblSportSpecializationTitle: UILabel!
    @IBOutlet weak var lblSportSpecialization: UILabel!
    @IBOutlet weak var lblTypesOfTrainingTitle: UILabel!
    @IBOutlet weak var lblTypesOfTraining: UILabel!
    @IBOutlet weak var lblLocationTitle: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var rateView: FloatRatingView!
    @IBOutlet weak var btnPublish: UIButton!

    //MARK:- Functions
    func setupUI() {
        self.setupFont()
    }
    
    func setupFont() {
        self.lblBroadCastSummery.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblTitle.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblYears.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblDescription.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblStartDateTitle.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblStartDate.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblCoachRequirement.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblExperienceTitle.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblExperience.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblSportSpecializationTitle.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblSportSpecialization.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTypesOfTrainingTitle.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblTypesOfTraining.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblLocationTitle.font = themeFont(size: 12, fontname: .ProximaNovaBold)
        self.lblLocation.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        self.lblRating.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.btnPublish.titleLabel?.font = themeFont(size: 17, fontname: .Regular)

        self.lblBroadCastSummery.setColor(color: .appthemeBlackColor)
        self.lblTitle.setColor(color: .appthemeBlackColor)
        self.lblYears.setColor(color: .appthemeBlackColor)
        self.lblDescription.setColor(color: .appthemeBlackColor)
       
        self.lblStartDateTitle.setColor(color: .appthemeBlackColor)

        self.lblStartDate.setColor(color: .appthemeBlackColor)
        self.lblCoachRequirement.setColor(color: .appthemeBlackColor)
       
        self.lblExperienceTitle.setColor(color: .appthemeBlackColor)

        self.lblExperience.setColor(color: .appthemeBlackColor)
        
        self.lblSportSpecialization.setColor(color: .appthemeBlackColor)
        self.lblSportSpecialization.setColor(color: .appthemeBlackColor)
        self.lblTypesOfTrainingTitle.setColor(color: .appthemeBlackColor)
        self.lblTypesOfTraining.setColor(color: .appthemeBlackColor)

        self.lblLocation.setColor(color: .appthemeBlackColor)
        self.lblLocation.setColor(color: .appthemeBlackColor)

        self.lblRating.setColor(color: .appthemeBlackColor)
        self.btnPublish.setColor(color: .appthemeWhiteColor)

        self.lblBroadCastSummery.text = getCommonString(key: "Broadcast_Summery_key")
        self.lblCoachRequirement.text = getCommonString(key: "Coach_Requirement_key")
        self.lblStartDateTitle.text = getCommonString(key: "Expected_start_date_key")
        self.lblSportSpecializationTitle.text = getCommonString(key: "Sport_specialization_key")
        self.lblTypesOfTrainingTitle.text = getCommonString(key: "Types_of_training_provide_key")
        self.lblLocationTitle.text = getCommonString(key: "Location:_key")
        self.lblRating.text = getCommonString(key: "Ratings_minimum_key")
        self.btnPublish.setTitle(str: getCommonString(key: "Publish_key"))        
    }
}
