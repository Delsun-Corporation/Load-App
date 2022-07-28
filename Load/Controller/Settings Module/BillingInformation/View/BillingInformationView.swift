//
//  BillingInformationView.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class BillingInformationView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vwBottom: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK: - Functions
    func setupUI(theController:BillingInformationVC) {
        self.tableView.register(UINib(nibName: "BillingInformationHeaderCell", bundle: nil), forCellReuseIdentifier: "BillingInformationHeaderCell")
        self.tableView.register(UINib(nibName: "BillingInformationCardCell", bundle: nil), forCellReuseIdentifier: "BillingInformationCardCell")
        self.tableView.register(UINib(nibName: "BillingInformationTextCell", bundle: nil), forCellReuseIdentifier: "BillingInformationTextCell")
        self.tableView.register(UINib(nibName: "BillingInformationAddCell", bundle: nil), forCellReuseIdentifier: "BillingInformationAddCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
        self.tableView.reloadData()
        setupFont()
    }
    
    func setupFont(){
        
        self.btnSave.setTitle(str: getCommonString(key: "Save_key"))
        self.btnSave.setTitleColor(UIColor.white, for: .normal)
        self.btnSave.backgroundColor = UIColor.appthemeOffRedColor
        self.btnSave.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaBold)
        self.btnSave.isEnabled = true
        self.btnSave.isUserInteractionEnabled = true
        
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 176, right: 0)

        self.vwBottom.alpha = 0.0
        self.vwBottom.isUserInteractionEnabled = false
    }
}
