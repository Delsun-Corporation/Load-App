//
//  CreateEventStepThirdView.swift
//  Load
//
//  Created by Haresh Bhai on 26/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventStepSecondView: UIView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnNext: UIButton!    

    //MARK:- Functions
    func setupUI() {
        self.tableView.register(UINib(nibName: "EventAboutCell", bundle: nil), forCellReuseIdentifier: "EventAboutCell")
        self.tableView.register(UINib(nibName: "EventAmenitiesHeaderCell", bundle: nil), forCellReuseIdentifier: "EventAmenitiesHeaderCell")
        self.tableView.register(UINib(nibName: "EventAmenitiesCell", bundle: nil), forCellReuseIdentifier: "EventAmenitiesCell")
        self.setupFont()
    }
    
    func setupFont() {
        self.btnNext.titleLabel?.font = themeFont(size: 17, fontname: .Helvetica)
        self.btnNext.setColor(color: .appthemeWhiteColor)
        self.btnNext.setTitle(str: getCommonString(key: "Save_and_Continue_key"))
    }
}
