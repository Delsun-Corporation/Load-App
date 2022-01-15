//
//  ResistanceExercisePreviewHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 08/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ResistanceExercisePreviewStartDelegate: class {
    func ResistanceExercisePreviewStartFinish(tag: Int)
    func ResistanceExercisePreviewUnitTapped(tag:Int)
    func ResistanceExerciseExpandTapped(tag:Int)
}

class ResistanceExercisePreviewHeaderView: UIView {

    @IBOutlet weak var vwTitle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vwHeaderActivityName: UIView!
    @IBOutlet weak var heightHeaderActivityName: NSLayoutConstraint!
    
    @IBOutlet weak var lblRepsUnit: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblReps: UILabel!
    @IBOutlet weak var lblRest: UILabel!
    @IBOutlet weak var btnSelectAll: UIButton!
    @IBOutlet weak var vwUnit: UIView!
    @IBOutlet weak var heightOfUnit: NSLayoutConstraint!
    @IBOutlet weak var btnUnit: UIButton!
    @IBOutlet weak var btnExpandExercise: UIButton!
    
    
    weak var delegate: ResistanceExercisePreviewStartDelegate?
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ResistanceExercisePreviewHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ResistanceExercisePreviewHeaderView
    }
    
    func setFrame() {
//        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 95)
    }
    
    func setupUI() {
        self.setupFont()
        self.setFrame()
        
    }
    
    func setupData(section:Int,model:[ExerciseResistance]?){
        
        if let dataModel = model?[section]{
            
            self.lblTitle.text = dataModel.name
            
            self.vwUnit.isHidden = dataModel.selectedUnit == 0 ? true : false
            self.heightOfUnit.constant = dataModel.selectedUnit == 0 ? 0 : 40
            self.btnUnit.isSelected = dataModel.selectedUnit == 0 ? false : true
            
            if dataModel.selectedHeader == 0{
    //            self.vwHeaderActivityName.isHidden = false
    //            self.heightHeaderActivityName.constant = 40
            }else{
                self.vwHeaderActivityName.isHidden = true
                self.heightHeaderActivityName.constant = 0
            }
            
            if dataModel.isCompleted ?? false{
                self.btnSelectAll.setBackgroundImage(UIImage(named: "ic_round_check_box_resistance_header_select"), for: .normal)
                self.vwTitle.backgroundColor = UIColor.appthemeOffRedColor
                self.lblTitle.textColor = UIColor.white
                self.btnExpandExercise.isUserInteractionEnabled = true
                
                if dataModel.selectedHeader == 1{
                    self.btnSelectAll.isUserInteractionEnabled = false
                }else{
                    self.btnSelectAll.isUserInteractionEnabled = true
                }
                
            }else{
                self.btnSelectAll.setBackgroundImage(UIImage(named: "ic_round_check_box_unselect"), for: .normal)
                self.vwTitle.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
                self.lblTitle.textColor = UIColor.appthemeOffRedColor
                self.btnExpandExercise.isUserInteractionEnabled = false
            }
            
            self.lblReps.text = dataModel.data?.first?.reps == nil || dataModel.data?.first?.reps == "" ? "Duration" : "Reps"
            self.lblRepsUnit.text = dataModel.data?.first?.reps == nil || dataModel.data?.first?.reps == "" ? "mm:ss" : "-"
        }

    }
    
    @IBAction func btnExpandExerciseTapped(_ sender: UIButton) {
        self.delegate?.ResistanceExerciseExpandTapped(tag:sender.tag)
    }
    
    @IBAction func btnSelectAllClicked(_ sender: UIButton) {
        self.delegate?.ResistanceExercisePreviewStartFinish(tag: sender.tag)
    }
    
    @IBAction func btnUnitTapped(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true{
            self.heightOfUnit.constant = 40
            self.vwUnit.isHidden = false
            sender.isSelected = false
        }else{
            self.heightOfUnit.constant = 0
            self.vwUnit.isHidden = true
            sender.isSelected = true
        }
        
        self.delegate?.ResistanceExercisePreviewUnitTapped(tag: sender.tag)
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaBold)
        self.lblWeight.font = themeFont(size: 12, fontname: .Helvetica)
        self.lblReps.font = themeFont(size: 12, fontname: .Helvetica)
        self.lblRest.font = themeFont(size: 12, fontname: .Helvetica)
        
        self.lblTitle.setColor(color: .appthemeOffRedColor)
        self.lblWeight.setColor(color: .appthemeBlackColor)
        self.lblReps.setColor(color: .appthemeBlackColor)
        self.lblRest.setColor(color: .appthemeBlackColor)
        
//        self.lblWeight.text = getCommonString(key: "Weight_key")
//        self.lblReps.text = getCommonString(key: "Reps_key")
//        self.lblRest.text = getCommonString(key: "Rest_key")
    }
}
