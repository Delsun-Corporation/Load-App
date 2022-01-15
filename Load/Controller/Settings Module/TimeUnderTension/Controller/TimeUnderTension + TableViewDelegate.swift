//
//  TimeUnderTension + TableViewDelegate.swift
//  Load
//
//  Created by iMac on 02/08/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

extension TimerUnderTensionVc: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.arrayTimeUnderTensionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimeUndertensionHeaderView") as! TimeUndertensionHeaderView
        
        let dict =  self.mainModelView.arrayTimeUnderTensionList[indexPath.row]
        cell.btnArrow.tag = indexPath.row
        cell.txtValueForInput.tag = indexPath.row
        cell.delegate = self
        cell.vwUnderLine.isHidden = (indexPath.row+1 == self.mainModelView.arrayTimeUnderTensionList.count) ? true : false
        cell.setupUI(data: dict)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict =  self.mainModelView.arrayTimeUnderTensionList[indexPath.row]
        
        if dict.selectedIndex == 0{
            return 68
        }else{
            return 165
        }
        
    }
    
}

//MARK: - Cell delegate
extension TimerUnderTensionVc: TimeUnderTensionSelectionDelegate {
    
    func timeUnderTensionSelectedRow(index: Int) {
      
        let dict =  self.mainModelView.arrayTimeUnderTensionList[index]
        if dict.selectedIndex == 0{
            dict.selectedIndex = 1
        }else{
            dict.selectedIndex = 0
        }
        self.mainModelView.arrayTimeUnderTensionList[index] = dict
        self.mainView.tblTimeUnderTension.reloadData()

    }
    
    func timeUnderTensionUpdatedData(index: Int, second1: String, second2: String, second3: String, second4: String) {
        
        self.mainModelView.apiCallForUpdateDataList(index: index, tensionId: String(self.mainModelView.arrayTimeUnderTensionList[index].id), tempo1: second1, tempo2: second2, tempo3: second3, tempo4: second4,isSelected: self.mainModelView.arrayTimeUnderTensionList[index].selectedIndex)
        
    }
    
}
