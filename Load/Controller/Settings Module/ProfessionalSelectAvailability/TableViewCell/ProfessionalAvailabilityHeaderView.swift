//
//  ProfessionalAvailabilityHeaderView.swift
//  Load
//
//  Created by Haresh Bhai on 04/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ProfessionalAvailabilityHeaderDelegate: class {
    func ProfessionalAvailabilityHeaderFinish(tag:Int, isShow:Bool)
}

class ProfessionalAvailabilityHeaderView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSwitch: UIButton!
    @IBOutlet weak var vwLine: UIView!
    
    //MARK:- Variables
    weak var delegate: ProfessionalAvailabilityHeaderDelegate?
    
    //MARK:- Functions
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "ProfessionalAvailabilityHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ProfessionalAvailabilityHeaderView
    }
    
    func setupUI(title:String, isSelected:Bool) {
        self.setFrame()
        self.setupFont()
        self.lblTitle.text = title
        self.showSwitch(isSelected: isSelected)
        
        if btnSwitch.tag == 3{
            self.vwLine.isHidden = false
        }  else {
            self.vwLine.isHidden = isSelected == true ? true : false
        }
        
    }
    
    func setFrame() {
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
    }
    
    func setupFont() {
        self.lblTitle.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblTitle.setColor(color: .appthemeBlackColor)
    }
    
    func showSwitch(isSelected:Bool) {
        self.btnSwitch.isSelected = isSelected
    }
    
    @IBAction func btnSwtchClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.delegate?.ProfessionalAvailabilityHeaderFinish(tag: sender.tag, isShow: self.btnSwitch.isSelected)
    }
    
    //New set
    
    func setupUI(){
        
                
    }
    
}
