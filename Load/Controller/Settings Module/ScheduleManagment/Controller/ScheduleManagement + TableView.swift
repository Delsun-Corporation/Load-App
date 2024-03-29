//
//  ScheduleManagement + TableView.swift
//  Load
//
//  Created by Yash on 17/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON

extension ScheduleManagmentVc : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GetAllData?.data?.professionalScheduleAdvanceBooking?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleManagementTblCell") as? ScheduleManagementTblCell else {
            return UITableViewCell()
        }
        
        if let id = self.mainModelView.timeInAdvanceId {
            for i in 0..<(GetAllData?.data?.professionalScheduleAdvanceBooking?.count ?? 0) {
                let data = GetAllData?.data?.professionalScheduleAdvanceBooking?[i]
                if data?.id == id {
                    data?.selected = 1
                }
                else {
                    data?.selected = 0
                }
                GetAllData?.data?.professionalScheduleAdvanceBooking?[i] = data!
            }
        }
        else {
            for i in 0..<(GetAllData?.data?.professionalScheduleAdvanceBooking?.count ?? 0) {
                let data = GetAllData?.data?.professionalScheduleAdvanceBooking?[i]
                data?.selected = 0
                GetAllData?.data?.professionalScheduleAdvanceBooking?[i] = data!
            }
        }
        
        cell.setupUI(data: GetAllData?.data?.professionalScheduleAdvanceBooking?[indexPath.row])
        cell.viewLine.isHidden = ((GetAllData?.data?.professionalScheduleAdvanceBooking?.count ?? 0)-1) == indexPath.row ? true : false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let _ = GetAllData?.data?.professionalScheduleAdvanceBooking {
            
            for i in 0..<(GetAllData?.data?.professionalScheduleAdvanceBooking?.count ?? 0) {
                let data = GetAllData?.data?.professionalScheduleAdvanceBooking?[i]
                data?.selected = 0
                GetAllData?.data?.professionalScheduleAdvanceBooking?[i] = data!
            }
            
            GetAllData?.data?.professionalScheduleAdvanceBooking?[indexPath.row].selected = 1
            self.mainModelView.timeInAdvanceId = GetAllData?.data?.professionalScheduleAdvanceBooking?[indexPath.row].id
        }
        
        tableView.reloadData()
        
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 61
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {
            return 61
        }
        return 45
    }
}
