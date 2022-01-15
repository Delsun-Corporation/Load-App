//
//  CreateEventStepSecondVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 26/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension CreateEventStepSecondVC: UITableViewDelegate, UITableViewDataSource, EventListDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return section == 2 ? self.mainModelView.amenitiesArray.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: EventAboutCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "EventAboutCell") as! EventAboutCell
            cell.tag = indexPath.row
            cell.delegate = self
            return cell
        }
        else if indexPath.section == 1 {
            let cell: EventAmenitiesHeaderCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "EventAmenitiesHeaderCell") as! EventAmenitiesHeaderCell
            cell.tag = indexPath.row
            return cell
        }
        else {
            let cell: EventAmenitiesCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "EventAmenitiesCell") as! EventAmenitiesCell
            cell.delegate = self
            let str = self.mainModelView.amenitiesArray[indexPath.row].first
            cell.setupUI(str: str as! String, indexPath: indexPath)
            return cell
        }
    }
    
    func EventAboutDidFinish(text: String) {
        self.mainModelView.txtDescription = text
    }
    
    func EventAmentiesDidFinish(tag: Int, isOn: Bool) {
        self.mainModelView.amenitiesArray[tag][1] = isOn
    }
}
