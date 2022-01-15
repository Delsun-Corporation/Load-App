//
//  OwnRequestListingDetailScreenView.swift
//  Load
//
//  Created by iMac on 09/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView

class OwnRequestListingDetailScreenView: UIView {

    //MARK: - Outlet
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
        
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblLocationTitle: UILabel!
    @IBOutlet weak var lblLocationValue: UILabel!
    
    @IBOutlet weak var lblPreferredStartDayTitle: UILabel!
    @IBOutlet weak var lblPreferredStartDayValue: UILabel!
    
    @IBOutlet weak var lblTypeOfTrainingTitle: UILabel!
    @IBOutlet weak var lblTypeOfTrainingValue: UILabel!
    
    @IBOutlet weak var lblCoachSpecializationTitle: UILabel!
    @IBOutlet weak var lblCoachSpecializationValue: UILabel!
    
    @IBOutlet weak var lblCoachExperienceTitle: UILabel!
    @IBOutlet weak var lblCoachExperienceValue: UILabel!
    
    @IBOutlet weak var lblPreferedRattingTitle: UILabel!
    @IBOutlet weak var vwRattingStar: FloatRatingView!
    
    @IBOutlet weak var vwDelete: UIView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnPromote: UIButton!
    @IBOutlet weak var vwPromote: UIView!
    
    @IBOutlet weak var lblInstructionInBottom: UILabel!
    @IBOutlet weak var vwMainBottom: UIView!
    
    //MARK: - SetupUI
    
    func setupUI(){
        
        imgProfile.layer.cornerRadius = imgProfile.bounds.width/2
        imgProfile.layer.masksToBounds = true
        imgProfile.layer.borderColor = UIColor.white.cgColor
        imgProfile.layer.borderWidth = 2.0
        
        lblCountry.textColor = .white
        lblCountry.font = themeFont(size: 10, fontname: .ProximaNovaRegular)
        
        [lblTitle,lblLocationTitle,lblPreferredStartDayTitle,lblTypeOfTrainingTitle,lblCoachSpecializationTitle,lblCoachExperienceTitle,lblPreferedRattingTitle].forEach { (lbl) in
            lbl?.textColor = UIColor.black
            lbl?.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        }
        
        lblTitle.textColor = UIColor.white
        
        [lblLocationValue,lblPreferredStartDayValue,lblTypeOfTrainingValue,lblCoachSpecializationValue,lblCoachExperienceValue].forEach { (lbl) in
                lbl?.textColor = UIColor.black
                lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            }

        lblDate.textColor = UIColor.black
        lblDate.font = themeFont(size: 10, fontname: .ProximaNovaRegular)

        lblInstructionInBottom.textColor = UIColor.black
        lblInstructionInBottom.font = themeFont(size: 13, fontname: .ProximaNovaRegular)

        [btnDelete,btnPromote].forEach { (btn) in
            btn?.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        }
        
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 177, right: 0)

        self.isShowButtonAndLabel(isShow: true)
    }
    
    func isShowButtonAndLabel(isShow:Bool){
        
        if isShow{
            
            [self.vwDelete,self.vwPromote].forEach { (btn) in
                btn?.alpha = 0
            }
            
            self.lblInstructionInBottom.alpha = 0
            self.vwMainBottom.isUserInteractionEnabled = false
            
        }else{
            
            [self.vwDelete,self.vwPromote].forEach { (btn) in
                btn?.alpha = 1
            }
            
            self.lblInstructionInBottom.alpha = 1
            self.vwMainBottom.isUserInteractionEnabled = true
            
        }
    }
    
}
