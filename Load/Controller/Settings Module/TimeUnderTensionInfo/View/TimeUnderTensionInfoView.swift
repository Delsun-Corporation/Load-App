//
//  TimeUnderTensionInfoView.swift
//  Load
//
//  Created by Yash on 15/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class TimeUnderTensionInfoView: UIView {

    //MARK: - Outlet
    @IBOutlet weak var tblInfo: UITableView!
    @IBOutlet weak var vwHeader: UIView!
    
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var lblSecond1Value: UILabel!
    @IBOutlet weak var lblSecond2Value: UILabel!
    @IBOutlet weak var lblSecond3Value: UILabel!
    @IBOutlet weak var lblSecond4Value: UILabel!
    
    @IBOutlet weak var btnSecond1: CustomButton!
    @IBOutlet weak var btnSecond2: CustomButton!
    @IBOutlet weak var btnSecond3: CustomButton!
    @IBOutlet weak var btnSecond4: CustomButton!
    
    @IBOutlet weak var lblSecond1Title: UILabel!
    @IBOutlet weak var lblSecond1Description: UILabel!
    
    @IBOutlet weak var lblSecond2Title: UILabel!
    @IBOutlet weak var lblSecond2Description: UILabel!
    
    @IBOutlet weak var lblSecond3Title: UILabel!
    @IBOutlet weak var lblSecond3Description: UILabel!
    
    @IBOutlet weak var lblSecond4Title: UILabel!
    @IBOutlet weak var lblSecond4Description: UILabel!
    
    //MARK: - SetupUI
    
    func setupUI(){
        
        lblQuestion.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        
        [self.lblSecond1Value, self.lblSecond2Value, self.lblSecond3Value, self.lblSecond4Value].forEach { (lbl) in
            lbl?.font = themeFont(size: 20, fontname: .ProximaNovaRegular)
            lbl?.textColor = .appthemeOffRedColor
        }
        
        [self.btnSecond1, self.btnSecond2, self.btnSecond3, self.btnSecond4].forEach { (btn) in
            btn?.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
            btn?.setTitleColor(UIColor.appthemeBlackColor, for: .normal)
        }
        
        [self.lblSecond1Title, self.lblSecond2Title, self.lblSecond3Title, self.lblSecond4Title].forEach { (lbl) in
            lbl?.font = themeFont(size: 12, fontname: .ProximaNovaBold)
            lbl?.textColor = .appthemeBlackColor
        }

        [self.lblSecond1Description, self.lblSecond2Description, self.lblSecond3Description, self.lblSecond4Description].forEach { (lbl) in
            lbl?.font = themeFont(size: 12, fontname: .ProximaNovaRegular)
            lbl?.textColor = .appthemeBlackColor
        }
        
        lblQuestion.text = getCommonString(key: "Under_tension_question_key")
        
        btnSecond1.setTitle(str: getCommonString(key: "Eccentric_key"))
        btnSecond2.setTitle(str: getCommonString(key: "Isometric_key"))
        btnSecond3.setTitle(str: getCommonString(key: "Concentric_key"))
        btnSecond4.setTitle(str: getCommonString(key: "Isometric_key"))
        
        lblSecond1Title.text = getCommonString(key: "Eccentric_key")
        lblSecond2Title.text = getCommonString(key: "Isometric_key")
        lblSecond3Title.text = getCommonString(key: "Concentric_key")
        lblSecond4Title.text = getCommonString(key: "Isometric_key")

        lblSecond1Description.text = getCommonString(key: "Contracting_while_lengthening_phase_key")
        lblSecond2Description.text = getCommonString(key: "Pause_after_lengthening_phase_key")
        lblSecond3Description.text = getCommonString(key: "Contracting_while_shortening_phase_key")
        lblSecond4Description.text = getCommonString(key: "Pause_after_shortening_phase_key")
        
        self.tblInfo.tableHeaderView = self.vwHeader
        
        self.tblInfo.register(UINib(nibName: "TimeUnderTensionInfoTblCell", bundle: nil), forCellReuseIdentifier: "TimeUnderTensionInfoTblCell")

    }
    
}

