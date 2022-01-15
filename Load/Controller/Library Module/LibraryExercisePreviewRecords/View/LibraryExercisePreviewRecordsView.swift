//
//  LibraryExercisePreviewRecordsView.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LibraryExercisePreviewRecordsView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblRepetitionMax: UILabel!
    @IBOutlet weak var lblEstWeight: UILabel!
    @IBOutlet weak var lblActWeight: UILabel!

    @IBOutlet weak var viewSave: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var heightViewSave: NSLayoutConstraint!
    @IBOutlet weak var lblRM: UILabel!
    @IBOutlet weak var txtKG: UITextField!
    @IBOutlet weak var txtRM: UITextField!

    //MARK:- Functions
    func setupUI(theController: LibraryExercisePreviewRecordsVC) {
        self.setupFont()
        self.txtKG.delegate = theController

        self.tableView.register(UINib(nibName: "LibraryExercisePreviewRecordsCell", bundle: nil), forCellReuseIdentifier: "LibraryExercisePreviewRecordsCell")
        self.tableView.reloadData()
    }
    
    func setupFont() {
        self.lblRepetitionMax.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblEstWeight.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.lblActWeight.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.btnSave.titleLabel?.font = themeFont(size: 17, fontname: .Helvetica)

        self.lblRepetitionMax.setColor(color: .appthemeBlackColor)
        self.lblEstWeight.setColor(color: .appthemeBlackColor)
        self.lblActWeight.setColor(color: .appthemeBlackColor)
        self.btnSave.setColor(color: .appthemeWhiteColor)

        self.lblRepetitionMax.text = getCommonString(key: "Repetition_Max_key")
        self.lblEstWeight.text = getCommonString(key: "Est._Weight_key")
        self.lblActWeight.text = getCommonString(key: "Act._Weight_(kg)_key")
        self.btnSave.setTitle(str: getCommonString(key: "Save_key"))
    }    
}
