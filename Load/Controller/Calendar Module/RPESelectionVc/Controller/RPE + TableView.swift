//
//  RPE + TableView.swift
//  Load
//
//  Created by iMac on 27/04/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation
import UIKit

extension RPESelectionVc: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.mainModelView.arrayData.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RPETblCell") as! RPETblCell
        
//        cell.lblNumber.text = "\(indexPath.row+1)"
//        cell.lblTextData.text = self.mainModelView.arrayData[indexPath.row]

        cell.lblNumber.text = "\(self.mainModelView.selectedRPESliderValue)"
        cell.lblTextData.text = self.mainModelView.arrayData[self.mainModelView.selectedRPESliderValue-1]
        
        return cell
    }
    
}
