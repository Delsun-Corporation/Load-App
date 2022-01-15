//
//  CreateEventFinishView.swift
//  Load
//
//  Created by Haresh Bhai on 28/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventFinishView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnPublish: UIButton!
    
    //MARK:- Functions
    func setupUI(theController: CreateEventFinishVC) {
        self.layoutIfNeeded()
        self.setupFont()
        self.tableView.register(UINib(nibName: "EventPhotoFinishCell", bundle: nil), forCellReuseIdentifier: "EventPhotoFinishCell")
        self.tableView.register(UINib(nibName: "EventPreviewDescriptionCell", bundle: nil), forCellReuseIdentifier: "EventPreviewDescriptionCell")
        self.tableView.register(UINib(nibName: "EventDetailsCell", bundle: nil), forCellReuseIdentifier: "EventDetailsCell")
        self.tableView.register(UINib(nibName: "AmenitiesCell", bundle: nil), forCellReuseIdentifier: "AmenitiesCell")
        self.tableView.register(UINib(nibName: "LoadMoreCell", bundle: nil), forCellReuseIdentifier: "LoadMoreCell")
        self.tableView.register(UINib(nibName: "EventReviewCell", bundle: nil), forCellReuseIdentifier: "EventReviewCell")
        self.tableView.register(UINib(nibName: "EventRulesCell", bundle: nil), forCellReuseIdentifier: "EventRulesCell")
        self.tableView.register(UINib(nibName: "EventOtherEventCell", bundle: nil), forCellReuseIdentifier: "EventOtherEventCell")
        self.tableView.dataSource = theController
        self.tableView.delegate = theController
    }
    
    func setupFont() {
        self.btnPublish.titleLabel?.font = themeFont(size: 17, fontname: .Helvetica)
        self.btnPublish.setColor(color: .appthemeWhiteColor)
    }
}
