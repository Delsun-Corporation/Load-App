//
//  AddExerciseFinishView.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AddExerciseFinishView: UIView {

    // MARK: @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var lblMeasured: UILabel!    
    @IBOutlet weak var txtRM: UITextField!
    @IBOutlet weak var lblRM: UILabel!
    @IBOutlet weak var txtKG: UITextField!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var lblRecords: UILabel!

    // MARK: Functions
    func setupUI(theController: AddExerciseFinishVC) {
        self.setupFont()
        self.txtKG.delegate = theController
        self.tableView.register(UINib(nibName: "AddExerciseFinishCell", bundle: nil), forCellReuseIdentifier: "AddExerciseFinishCell")        
//        self.tableView.isHidden = true
        self.tableView.reloadData()
    }
    
    func setupFont() {
        self.lblMeasured.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblRM.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.txtKG.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.btnAdd.titleLabel?.font = themeFont(size: 17, fontname: .Helvetica)
        self.lblDetails.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        self.lblRecords.font = themeFont(size: 14, fontname: .ProximaNovaRegular)

        self.lblMeasured.setColor(color: .appthemeBlackColor)
        self.txtKG.setColor(color: .appthemeBlackColor)
        self.btnAdd.setColor(color: .appthemeWhiteColor)
        self.lblDetails.setColor(color: .appthemeRedColor)
        self.lblRecords.setColor(color: .appthemeRedColor)

        self.lblMeasured.text = getCommonString(key: "Input_your_weight_lifted_for_the_selected_RM_key")
        self.btnAdd.setTitle(str: getCommonString(key: "Add_key"))
    }
}
