//
//  ResistanceSummaryHeaderCell.swift
//  Load
//
//  Created by iMac on 20/05/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class ResistanceSummaryHeaderCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblReps: UILabel!
    @IBOutlet weak var lblRest: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupFont()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaBold)
        self.lblWeight.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblReps.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblRest.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        
        self.lblTitle.setColor(color: .appthemeRedColor)
        self.lblWeight.setColor(color: .appthemeBlackColor)
        self.lblReps.setColor(color: .appthemeBlackColor)
        self.lblRest.setColor(color: .appthemeBlackColor)
        
        //        self.lblWeight.text = getCommonString(key: "Weight_(kg)_key")
        //        self.lblReps.text = getCommonString(key: "Reps_key")
        //        self.lblRest.text = getCommonString(key: "Rest_(s)_key")
    }
    
    func setupData(data:ExerciseResistance?){
        
        if data?.data?.count ?? 0 > 0{
           
            let exerciseData = data?.data
            
            if exerciseData?[0].reps != "" {
                self.lblReps.text = "Reps"
            }else{
                self.lblReps.text = "Duration"
            }
        }
        
        self.lblTitle.text = data?.name
    }


}
