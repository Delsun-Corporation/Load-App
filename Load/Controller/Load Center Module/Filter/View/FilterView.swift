//
//  FilterView.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FilterView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnApply: UIButton!

    //MARK: - Functions
    func setupUI(theController:FilterVC) {
        self.setupFont()
        self.tableView.register(UINib(nibName: "FilterDropDownCell", bundle: nil), forCellReuseIdentifier: "FilterDropDownCell")
        self.tableView.register(UINib(nibName: "FilterSpecializationCell", bundle: nil), forCellReuseIdentifier: "FilterSpecializationCell")
        self.tableView.register(UINib(nibName: "FilterSliderCell", bundle: nil), forCellReuseIdentifier: "FilterSliderCell")
        self.tableView.register(UINib(nibName: "FilterRatingCell", bundle: nil), forCellReuseIdentifier: "FilterRatingCell")
        
        if FILTER_MODEL?.Rating != nil {
            theController.mainModelView.Rating = FILTER_MODEL?.Rating
        }
        
        if FILTER_MODEL?.Gender != nil {
            theController.mainModelView.Gender = FILTER_MODEL?.Gender
        }
        
        if FILTER_MODEL?.LocationName != nil {
            theController.mainModelView.Location = FILTER_MODEL?.Location
            theController.mainModelView.LocationName = FILTER_MODEL?.LocationName
        }
        
        if FILTER_MODEL?.LanguageName != nil {
            theController.mainModelView.Language = FILTER_MODEL?.Language
            theController.mainModelView.LanguageName = FILTER_MODEL?.LanguageName
        }
        
        if FILTER_MODEL?.ServiceName != nil {
            theController.mainModelView.Service = FILTER_MODEL?.Service
            theController.mainModelView.ServiceName = FILTER_MODEL?.ServiceName
        }
    }
    
    func setupFont() {
        self.btnApply.titleLabel?.font = themeFont(size: 17, fontname: .Helvetica)
        self.btnApply.setColor(color: .appthemeWhiteColor)
    }
}
