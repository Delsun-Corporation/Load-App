//
//  SidemenuView.swift
//  Load
//
//  Created by Haresh Bhai on 02/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SidemenuView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblUserGuide: UILabel!
    @IBOutlet weak var lblContactUs: UILabel!
    
    //MARK:- Functions
    func setupUI(theDelegate: SidemenuVC) {
        self.tableView.isScrollEnabled = false
        self.setupFont()
        self.tableView.register(UINib(nibName: "SidemenuHeaderCell", bundle: nil), forCellReuseIdentifier: "SidemenuHeaderCell")
        self.tableView.register(UINib(nibName: "SidemenuListCell", bundle: nil), forCellReuseIdentifier: "SidemenuListCell")
        
        self.tableView.delegate = theDelegate
        self.tableView.dataSource = theDelegate
        self.tableView.reloadData()
    }
   
    func setupFont() {
        self.lblUserGuide.font = themeFont(size: 15, fontname: .Regular)
        self.lblContactUs.font = themeFont(size: 15, fontname: .Regular)
        
        self.lblUserGuide.setColor(color: .appthemeBlackColor)
        self.lblContactUs.setColor(color: .appthemeBlackColor)
    }
}
