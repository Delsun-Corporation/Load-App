//
//  ResistanceConfirmationPageView.swift
//  Load
//
//  Created by iMac on 12/02/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class ResistanceConfirmationPageView: UIView {

    //MARK: - Outlet
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblResistance: UILabel!
    @IBOutlet weak var lblTotalDuration: UILabel!
    @IBOutlet weak var txtTotalDuration: UITextField!
    @IBOutlet weak var lblExercise: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var vwNext: UIView!
    
    //MARK:- setupUI
    func setupUI(theController:ResistanceConfirmationPageVc) {
        
        self.lblExercise.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblResistance.font = themeFont(size: 11, fontname: .ProximaNovaThin)
        self.lblResistance.textColor = .appthemeBlackColor
        
        lblTotalDuration.textColor = UIColor.appthemeBlackColorAlpha30
        lblTotalDuration.font = themeFont(size: 15, fontname: .ProximaNovaRegular)

        txtTotalDuration.textColor = UIColor.appthemeBlackColor
        txtTotalDuration.delegate = theController
        txtTotalDuration.font = themeFont(size: 15, fontname: .Helvetica)

        btnNext.setColor(color: UIColor.white)
        btnNext.setTitle(str: getCommonString(key: "Next_key"))
        btnNext.titleLabel?.font = themeFont(size: 23, fontname: .ProximaNovaBold)

        //        self.tableView.register(UINib(nibName: "ExerciseResistanceCell", bundle: nil), forCellReuseIdentifier: "ExerciseResistanceCell")
        self.tableView.register(UINib(nibName: "ExerciseResistanceMainCell", bundle: nil), forCellReuseIdentifier: "ExerciseResistanceMainCell")
        self.tableView.isScrollEnabled = false
        
        self.vwNext.alpha = 0.0
        self.vwNext.isUserInteractionEnabled = false

    }

}
