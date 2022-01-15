//
//  PremiumUserProfileDetailsVc + TableViewDelegate.swift
//  Load
//
//  Created by Yash on 01/07/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation
extension PremiumUserProfileDetailsVc: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntroductionPremiumCell") as! IntroductionPremiumCell
            cell.lblValue.text = "Looking for adventure through cycling and peace from yoga."
            return cell
            
        } else if indexPath.row == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChartViewProfileTblCell") as! ChartViewProfileTblCell
            cell.setupUI(theController: self)
            return cell

        } else if indexPath.row == 2 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntroductionPremiumCell") as! IntroductionPremiumCell
            cell.lblValue.text = "Statistics"
            return cell

        } else if indexPath.row == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "IntroductionPremiumCell") as! IntroductionPremiumCell
            cell.lblValue.text = "Presets"
            return cell
        } else if indexPath.row == 4 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventPremiumUserTblCell") as! EventPremiumUserTblCell
            cell.lblEventName.text = "Past events"
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventPremiumUserTblCell") as! EventPremiumUserTblCell
            cell.lblEventName.text = "Upcoming events"
            return cell

        }
       
    }

}
