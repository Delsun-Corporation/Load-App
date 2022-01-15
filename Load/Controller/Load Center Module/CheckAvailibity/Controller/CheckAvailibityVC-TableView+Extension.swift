//
//  CheckAvailibityVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 23/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension CheckAvailibityVC: UITableViewDelegate, UITableViewDataSource, ReloadCalendarViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.mainModelView.expandedHeight != 0 && self.mainModelView.expandedSectionMain == indexPath.row && self.mainModelView.isExpanded {
            //earlier set 280 instead of 368
            //add 88 because 2 line not showing in calendar when expand
            return CGFloat(368 + ((GetAllData?.data?.availableTimes?.count)! * 44) + 14 + 44) // 14 is heaer and footer size, 44 is header size
        }
        return 356
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.mainModelView.expandedHeight != 0 && self.mainModelView.expandedSectionMain == indexPath.row && self.mainModelView.isExpanded {
            //earlier set 280 instead of 368
            //add 88 because 2 line not showing in calendar when expand
            return CGFloat(368 + ((GetAllData?.data?.availableTimes?.count)! * 44) + 14 + 44)
        }
        return 356
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.clientBookedDatesArray == nil ? 0 : self.mainModelView.arrayCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainCalenderCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "MainCalenderCell") as! MainCalenderCell
        cell.tag = indexPath.row
        cell.delegate = self
        cell.clientBookedDatesArray = self.mainModelView.clientBookedDatesArray
        cell.expandedMainSection = self.mainModelView.expandedSection
        
        if self.mainModelView.expandedHeight != 0 && self.mainModelView.expandedSectionMain == indexPath.row  && self.mainModelView.isExpanded {
            cell.isExpanded = self.mainModelView.isExpanded
            cell.expandedMainSection = self.mainModelView.expandedSectionMain
            cell.expandedSection = self.mainModelView.expandedSection
            cell.expandedRow = self.mainModelView.expandedRow
            cell.expandedDate = self.mainModelView.expandedDate
        }
        else {
            cell.isExpanded = false
            cell.expandedMainSection = -1
            cell.expandedSection = -1
            cell.expandedRow = -1
            cell.expandedDate = ""
        }
        cell.setupData()
        return cell
    }
    
    func ReloadCalendarViewDidFinish(tableView: UITableView, height: CGFloat, isExpanded:Bool, sectionMain: Int, section: Int, row: Int, date: String) {
        if self.mainModelView.expandedDate != date || date == "" {
            self.mainModelView.selectedTime = ""
            self.mainModelView.selectedTimeId = ""
        }
        self.mainModelView.isExpanded = isExpanded
        self.mainModelView.expandedSectionMain = sectionMain
        self.mainModelView.expandedSection = section
        self.mainModelView.expandedRow = row
        self.mainModelView.expandedDate = date
        self.mainModelView.expandedHeight = height
        self.mainView.tableView.reloadData()
    }
    
    func SelectedCalendarViewDidFinish(time: String, timeId:String) {
        self.mainModelView.selectedTime = time
        self.mainModelView.selectedTimeId = timeId
    }
}

