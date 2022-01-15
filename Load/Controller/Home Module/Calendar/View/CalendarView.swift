//
//  CalendarView.swift
//  Load
//
//  Created by Haresh Bhai on 29/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CalendarView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblMonthName: UILabel!    
    @IBOutlet weak var lblMon: UILabel!
    @IBOutlet weak var lblTue: UILabel!
    @IBOutlet weak var lblWed: UILabel!
    @IBOutlet weak var lblThu: UILabel!
    @IBOutlet weak var lblFri: UILabel!
    @IBOutlet weak var lblSat: UILabel!
    @IBOutlet weak var lblSun: UILabel!

    func setupUI(theDelegate: CalendarVC) {
        self.setupFont()
        self.tableView.layoutIfNeeded()
        self.tableView.register(UINib(nibName: "CalendarCell", bundle: nil), forCellReuseIdentifier: "CalendarCell")
        self.tableView.register(UINib(nibName: "TrainingListCell", bundle: nil), forCellReuseIdentifier: "TrainingListCell")
        self.tableView.register(UINib(nibName: "TrainingListProgramCell", bundle: nil), forCellReuseIdentifier: "TrainingListProgramCell")
        self.tableView.register(UINib(nibName: "TrainingListFooterCell", bundle: nil), forCellReuseIdentifier: "TrainingListFooterCell")
        self.tableView.register(UINib(nibName: "TrainingListHeaderCell", bundle: nil), forCellReuseIdentifier: "TrainingListHeaderCell")
        self.tableView.register(UINib(nibName: "GSPCell", bundle: nil), forCellReuseIdentifier: "GSPCell")
        self.tableView.register(UINib(nibName: "ProgressionCell", bundle: nil), forCellReuseIdentifier: "ProgressionCell")        
        self.tableView.register(UINib(nibName: "AverageCell", bundle: nil), forCellReuseIdentifier: "AverageCell")
        
        self.tableView.delegate = theDelegate
        self.tableView.dataSource = theDelegate
        self.tableView.reloadData()
    }
    
    func setupFont() {
        self.lblMonthName.font = themeFont(size: 14, fontname: .Regular)
        self.lblMon.font = themeFont(size: 8, fontname: .ProximaNovaRegular)
        self.lblTue.font = themeFont(size: 8, fontname: .ProximaNovaRegular)
        self.lblWed.font = themeFont(size: 8, fontname: .ProximaNovaRegular)
        self.lblThu.font = themeFont(size: 8, fontname: .ProximaNovaRegular)
        self.lblFri.font = themeFont(size: 8, fontname: .ProximaNovaRegular)
        self.lblSat.font = themeFont(size: 8, fontname: .ProximaNovaRegular)
        self.lblSun.font = themeFont(size: 8, fontname: .ProximaNovaRegular)
    }
}
