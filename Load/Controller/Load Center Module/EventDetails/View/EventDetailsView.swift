//
//  EventDetailsView.swift
//  Load
//
//  Created by Haresh Bhai on 18/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import FloatRatingView

class EventDetailsView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblRateCount: UILabel!
    @IBOutlet weak var rateView: FloatRatingView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnBookmark: UIButton!
    
    //MARK:- Functions
    func setupUI(theController: EventDetailsVC) {
        self.setupFont()
        self.layoutIfNeeded()
        self.tableView.register(UINib(nibName: "EventPhotoCell", bundle: nil), forCellReuseIdentifier: "EventPhotoCell")
        self.tableView.register(UINib(nibName: "EventDescriptionCell", bundle: nil), forCellReuseIdentifier: "EventDescriptionCell")
        self.tableView.register(UINib(nibName: "EventDetailsCell", bundle: nil), forCellReuseIdentifier: "EventDetailsCell")
        self.tableView.register(UINib(nibName: "AmenitiesCell", bundle: nil), forCellReuseIdentifier: "AmenitiesCell")
        self.tableView.register(UINib(nibName: "LoadMoreCell", bundle: nil), forCellReuseIdentifier: "LoadMoreCell")
        self.tableView.register(UINib(nibName: "EventReviewCell", bundle: nil), forCellReuseIdentifier: "EventReviewCell")
        self.tableView.register(UINib(nibName: "EventRulesCell", bundle: nil), forCellReuseIdentifier: "EventRulesCell")
        self.tableView.register(UINib(nibName: "EventOtherEventCell", bundle: nil), forCellReuseIdentifier: "EventOtherEventCell")    
    }
    
    func setupFont() {
        self.lblPrice.font = themeFont(size: 20, fontname: .ProximaNovaBold)
        self.lblRateCount.font = themeFont(size: 10, fontname: .ProximaNovaRegular)
        self.btnContinue.titleLabel?.font = themeFont(size: 16, fontname: .ProximaNovaBold)
        self.lblPrice.setColor(color: .appthemeBlackColor)
        self.lblRateCount.setColor(color: .appthemeBlackColor)
        self.btnContinue.setColor(color: .appthemeWhiteColor)
    }
}
