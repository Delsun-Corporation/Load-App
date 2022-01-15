//
//  CardioSummaryHeadeTblCell.swift
//  Load
//
//  Created by iMac on 18/03/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class CardioSummaryHeadeTblCell: UITableViewCell {

    //MARK: - Outlet
    @IBOutlet weak var lblSpeed: UILabel!
    @IBOutlet weak var lblPercentage: UILabel!
    @IBOutlet weak var lblRPM: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblRest: UILabel!
    @IBOutlet weak var lblLvl: UILabel!

    @IBOutlet weak var btnSpeedPace: UIButton!
    @IBOutlet weak var imgDurationArrow: UIImageView!
    @IBOutlet weak var imgSpeedArrow: UIImageView!
    @IBOutlet weak var constraintWidthSpeedArrow: NSLayoutConstraint!
    
    @IBOutlet weak var vwStackView: UIStackView!
    @IBOutlet weak var vwLvl: UIView!
    @IBOutlet weak var viewPercentage: UIView!
    @IBOutlet weak var viewRPM: UIView!
    @IBOutlet weak var btnRPM: UIButton!
    @IBOutlet weak var imgRPMArrow: UIImageView!
    @IBOutlet weak var vwCyclingOutdoorPercentage: UIView!
    
    var isPaceSelected = true
    
    //MARK: - Variable
    
    var activityName = ""
    
    //MARK: - View life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI(){
        
        [self.lblSpeed,self.lblPercentage,self.lblRPM,self.lblDuration,self.lblRest,self.lblLvl].forEach { (lbl) in
            lbl?.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        }
    }
    
    func setDetails(exercise:Exercise?){
        self.btnSpeedPace.isUserInteractionEnabled = false
        self.constraintWidthSpeedArrow.constant = 0
        
        if exercise?.pace != nil && exercise?.pace != "" {
            lblSpeed.text = "Pace"
        }
        
        if exercise?.distance != nil {
            lblDuration.text = "Distance"
        }
        
        if exercise?.watt != nil {
            lblRPM.text = "Watt"
        }
        
        if activityName.lowercased() == "Others".lowercased(){
            
            if exercise?.isSpeed == false{
                lblSpeed.text = "Pace"
            }
        }
        
        changeHeaderAccordingToActivityName()
    }
    
    func setDetailsForTrainingProgram(exercise:WeekWiseWorkoutLapsDetails?) {
        
        self.btnSpeedPace.isUserInteractionEnabled = true
        self.constraintWidthSpeedArrow.constant = 9
        
        if isPaceSelected{
            lblSpeed.text = "Pace"
            self.imgSpeedArrow.image = UIImage(named: "ic_dropdown_black")

        } else {
            lblSpeed.text = "Speed"
            self.imgSpeedArrow.image = UIImage(named: "ic_up_black")
        }
        
        if exercise?.updatedDistance != nil {
            lblDuration.text = "Distance"
        }
        
        changeHeaderAccordingToActivityName()
    }
    
    //MARK: - Yash design changes
    
    func changeHeaderAccordingToActivityName(){
        
        self.vwLvl.isHidden = false
        self.viewPercentage.isHidden = false
        self.viewRPM.isHidden = false
        self.vwCyclingOutdoorPercentage.isHidden = true
        
        switch activityName.lowercased() {
            
        case "Run (Outdoor)".lowercased(), "Outdoor".lowercased():
            self.vwLvl.isHidden = true
            self.viewRPM.isHidden = true
            self.vwStackView.spacing = 20
        case "Run (Indoor)".lowercased(), "Indoor".lowercased():
            self.vwLvl.isHidden = true
            self.viewRPM.isHidden = true
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
