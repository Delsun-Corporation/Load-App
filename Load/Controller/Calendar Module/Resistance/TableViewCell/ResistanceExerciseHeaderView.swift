//
//  ResistanceExerciseHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ResistanceExerciseHeaderViewDelegate: class {
    func ResistanceExerciseHeaderViewFinish(tag:Int)
    func ResistanceExerciseHeaderRepsSelected(tag:Int, isDuration:Bool)
}

class ResistanceExerciseHeaderView: UIView {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblReps: UILabel!
    @IBOutlet weak var imgReps: UIImageView!
    @IBOutlet weak var lblRest: UILabel!
    @IBOutlet weak var btnExercise: UIButton!
    @IBOutlet weak var btnReps: UIButton!
    
    weak var delegate:ResistanceExerciseHeaderViewDelegate?
    var isDurationSelected:Bool = true
    var isShowDropdown:Bool = true

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ResistanceExerciseHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ResistanceExerciseHeaderView
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
    }
    
    func setupUI() {
        self.setupFont()
        self.setFrame()
        self.showDistance(isShow: self.isDurationSelected)
        if isShowDropdown {
            self.imgReps.isHidden = false
            self.btnReps.isUserInteractionEnabled = true
        }
        else {
            self.imgReps.isHidden = true
            self.btnReps.isUserInteractionEnabled = false
        }
    }
    
    func showDistance(isShow:Bool = true) {
        if isShow {
            self.lblReps.text = "Duration"
            self.imgReps.image = UIImage(named: "ic_up_black")
        }
        else {
            self.lblReps.text = "Reps"
            self.imgReps.image = UIImage(named: "ic_dropdown_black")
        }
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
    
    @IBAction func btnExerciseClicked(_ sender: UIButton) {
        self.delegate?.ResistanceExerciseHeaderViewFinish(tag: sender.tag)
    }
    
    @IBAction func btnRepsSelected(_ sender: Any) {
        self.isDurationSelected = !self.isDurationSelected
        self.showDistance(isShow: self.isDurationSelected)
        self.delegate?.ResistanceExerciseHeaderRepsSelected(tag: self.tag, isDuration: self.isDurationSelected)
    }
}
