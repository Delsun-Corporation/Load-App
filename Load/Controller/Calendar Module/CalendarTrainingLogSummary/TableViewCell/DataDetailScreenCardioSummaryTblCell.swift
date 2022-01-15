//
//  DataDetailScreenCardioSummaryTblCell.swift
//  Load
//
//  Created by iMac on 22/03/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class DataDetailScreenCardioSummaryTblCell: UITableViewCell {

    //MARK: - Outlet
    @IBOutlet weak var txtSpeed: UITextField!
    @IBOutlet weak var txtPercentage: UITextField!
    @IBOutlet weak var txtDuration: UITextField!
    @IBOutlet weak var txtRest: UITextField!
    
    @IBOutlet weak var vwStackView: UIStackView!
    @IBOutlet weak var vwCyclingOutdoorPercentage: UIView!
    @IBOutlet weak var txtCyclingOutdoorPercentage: UITextField!
    @IBOutlet weak var viewPercentage: UIView!
    @IBOutlet weak var vwLvl: UIView!
    @IBOutlet weak var txtLvl: UITextField!
    @IBOutlet weak var vwUnderLine: UIView!
    
    //MARK: - Variable
    
    var activityName = ""
    var trainingGoalName = ""
    var isPaceSelected = true

        
    //MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupFont() {
        
        [self.txtSpeed,self.txtPercentage,self.txtDuration,self.txtRest,self.txtLvl,self.txtCyclingOutdoorPercentage].forEach { (txt) in
            txt?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            txt?.setColor(color: .appthemeBlackColor)
            txt?.isUserInteractionEnabled = false
        }
        
    }
    
    func setupDetails(exercise:Exercise?){
        
        if exercise?.speed != nil  {
            self.txtSpeed.text = (exercise?.speed == 0.0 || exercise?.speed == nil) ? "-" : self.oneDigitAfterDecimal(value: exercise?.speed ?? 0.0)
        }
        else {
            self.txtSpeed.text = (exercise?.pace == "" || exercise?.pace == nil) ? "-" : exercise?.pace
        }
        
        if exercise?.duration != nil && exercise?.duration != "" {
            self.txtDuration.text = exercise?.duration
        }
        else {
            self.txtDuration.text = self.oneDigitAfterDecimal(value: exercise?.distance ?? 0.0)
        }
        
        self.txtRest.text = (exercise?.rest == "" || exercise?.rest == nil) ? "--:--" : exercise?.rest
        
        if self.activityName == "Run (Outdoor)".lowercased() || self.activityName == "Run (Indoor)".lowercased() {
            if exercise?.percentage != nil{
                self.txtPercentage.text = self.oneDigitAfterDecimal(value: exercise?.percentage ?? 0.0)
            }else{
                self.txtPercentage.text = "-"
            }

            if self.trainingGoalName == "Base Run".lowercased() || self.trainingGoalName == "Fat Burning".lowercased() || self.trainingGoalName == "Pace Run".lowercased() || self.trainingGoalName == "Lactate Tolerance (Continuous)".lowercased() {
                    self.txtRest.text = "--:--"
            }
            
        }else{
            if exercise?.watt != nil{
                self.txtPercentage.text = (exercise?.watt == 0 || exercise?.watt == nil) ? "-" : String(exercise?.watt ?? 0)
            }else{
                self.txtPercentage.text = (exercise?.rpm == 0 || exercise?.rpm == nil) ? "-" : String(exercise?.rpm ?? 0)
            }
        }
        self.txtLvl.text = (exercise?.lvl == 0 || exercise?.lvl == nil) ? "-" : String(exercise?.lvl ?? 0)
            
        if self.activityName == "Cycling (Outdoor)".lowercased(){
            self.txtCyclingOutdoorPercentage.text = self.oneDigitAfterDecimal(value: exercise?.percentage ?? 0.0)
        }
        
        print("activityName : \(self.activityName)")
        changeHeaderAccordingToActivityName()
        
    }
    
    
    func setupDetailsForTrainingProgram(exercise:WeekWiseWorkoutLapsDetails?){
        
        if isPaceSelected {
            self.txtSpeed.text = (exercise?.pace == "" || exercise?.pace == nil) ? "-" : exercise?.pace
        } else {
            self.txtSpeed.text = (exercise?.speed == "" || exercise?.speed == nil) ? "-" : exercise?.speed
        }
        
        if exercise?.updatedDuration != nil && exercise?.updatedDuration != "" {
            self.txtDuration.text = exercise?.updatedDuration
        }
        else if exercise?.updatedDistance != nil && exercise?.updatedDistance != 0.0 {
            self.txtDuration.text = self.oneDigitAfterDecimal(value: exercise?.updatedDistance ?? 0.0)
        }else {
            self.txtDuration.text = "--:--"
        }
        
        self.txtRest.text = (exercise?.updatedRest == "" || exercise?.updatedRest == nil) ? "--:--" : exercise?.updatedRest
        
        if exercise?.updatedPercent != nil && exercise?.updatedPercent != ""{
            self.txtPercentage.text = exercise?.updatedPercent
        }else{
            self.txtPercentage.text = "-"
        }
        
        changeHeaderAccordingToActivityName()
        
    }
    
    func changeHeaderAccordingToActivityName(){
        
        self.vwLvl.isHidden = false
        self.viewPercentage.isHidden = false
        self.vwCyclingOutdoorPercentage.isHidden = true
        
        switch activityName.lowercased() {
            
        case "Run (Outdoor)".lowercased(), "Outdoor".lowercased():
            self.vwLvl.isHidden = true
            self.vwStackView.spacing = 20

        case "Run (Indoor)".lowercased(), "Indoor".lowercased():
            self.vwLvl.isHidden = true
            self.vwStackView.spacing = 20

        case "Cycling (Indoor)".lowercased():
            self.vwLvl.isHidden = false
            self.vwStackView.spacing = 0
        case "Cycling (Outdoor)".lowercased():
            self.vwLvl.isHidden = true
            self.vwCyclingOutdoorPercentage.isHidden = false
            self.vwStackView.spacing = 0
        case "Swimming".lowercased():
            self.vwLvl.isHidden = true
            self.viewPercentage.isHidden = true
            self.vwStackView.spacing = 65

        case "Others".lowercased():
            self.vwLvl.isHidden = false
            self.vwStackView.spacing = 0
            
        default:
            self.vwLvl.isHidden = true
        }
        
    }

    
}
