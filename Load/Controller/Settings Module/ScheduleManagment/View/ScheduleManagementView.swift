//
//  ScheduleManagementView.swift
//  Load
//
//  Created by Yash on 14/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class ScheduleManagementView: UIView {

    //MARK: - Outlet
    @IBOutlet weak var lblAdvanceBooking: UILabel!
    @IBOutlet weak var btnAdvanceBooking: UIButton!
    
    @IBOutlet weak var tblAdvacneBooking: UITableView!
    @IBOutlet weak var ConstraintHeightTblAdvance: NSLayoutConstraint!
    
    @IBOutlet weak var lblAutoAccept: UILabel!
    @IBOutlet weak var btnAutoAccept: UIButton!
    @IBOutlet weak var lblAutoAcceptDescription: UILabel!
    
    //MARK: - SetupUI
    
    func setupUI(){
        self.setupFont()
    }
    
    func setupFont(){
        
        [self.lblAutoAccept,self.lblAdvanceBooking].forEach { (lbl) in
            lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
            lbl?.setColor(color: .appthemeBlackColor)
        }
        
        self.lblAutoAcceptDescription.font = themeFont(size: 11, fontname: .ProximaNovaRegular)
        self.lblAutoAcceptDescription.setColor(color: .appthemeBlackColor)
        
        lblAutoAccept.text = getCommonString(key: "Allow_auto-accept_key")
        
        let newString = NSMutableAttributedString()
        newString.append(getCommonString(key: "Auto_accept_description_key").withBoldText(text: getCommonString(key: "Auto_accept_key")))
        newString.append(getCommonString(key: "Auto_accept_description_2_key").withBoldText(text: getCommonString(key: "Auto_accept_key")))
        
        self.lblAutoAcceptDescription.attributedText = newString

        self.tblAdvacneBooking.register(UINib(nibName: "ScheduleManagementTblCell", bundle: nil), forCellReuseIdentifier: "ScheduleManagementTblCell")
        self.tblAdvacneBooking.tableFooterView = UIView()
        
        tblAdvacneBooking.estimatedRowHeight = 45.0
        tblAdvacneBooking.rowHeight = UITableView.automaticDimension
        
    }
    
}
