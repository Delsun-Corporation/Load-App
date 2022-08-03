//
//  ProfessionalSelectAvailabilityView.swift
//  Load
//
//  Created by Haresh Bhai on 04/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfessionalSelectAvailabilityView: UIView {

    //MARK: - @IBOutlet
    @IBOutlet weak var tblCalendar: UITableView! // Calendar TableView
    @IBOutlet weak var calendarHeaderView: UIView!
    @IBOutlet weak var lblMonthName: UILabel!
    
    @IBOutlet weak var constraintTopOfTblCalendar: NSLayoutConstraint!
    @IBOutlet weak var tblShowData: UITableView!
    
    //MARK: - Functions
    func setupUI(theController:ProfessionalSelectAvailabilityVC) {
        
        self.tblCalendar.register(UINib(nibName: "CalendarCell", bundle: nil), forCellReuseIdentifier: "CalendarCell")

        //Old data
//        self.tableView.register(UINib(nibName: "ProfessionalAvailabilityCell", bundle: nil), forCellReuseIdentifier: "ProfessionalAvailabilityCell")
        self.tblCalendar.dataSource = theController
        self.tblCalendar.delegate = theController
        self.tblCalendar.tableHeaderView = self.calendarHeaderView
        self.tblCalendar.reloadData()
        
        self.tblShowData.register(UINib(nibName: "AvailabilityWithDurationtblCell", bundle: nil), forCellReuseIdentifier: "AvailabilityWithDurationtblCell")
        self.tblShowData.dataSource = theController
        self.tblShowData.delegate = theController
        
        self.setupFont()
    }
    
    func setupFont(){
        lblMonthName.textColor = UIColor.appthemeOffRedColor
        lblMonthName.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
    }
}
