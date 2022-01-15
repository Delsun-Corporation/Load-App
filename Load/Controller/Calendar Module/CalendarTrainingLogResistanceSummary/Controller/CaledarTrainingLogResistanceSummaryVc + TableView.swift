//
//  CaledarTrainingLogResistanceSummaryVc + TableView.swift
//  Load
//
//  Created by iMac on 20/05/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

extension CalendarTrainingLogResistanceSummaryVc : UITableViewDelegate, UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.resistanceSummaryDetails?.additionalExercise?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.resistanceSummaryDetails?.additionalExercise?[section].data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResistanceSummaryExerciseCell") as! ResistanceSummaryExerciseCell
        
        let dict = self.mainModelView.resistanceSummaryDetails?.additionalExercise?[indexPath.section].data?[indexPath.row]
        cell.setupData(data: dict)
        if (indexPath.row + 1) == (self.mainModelView.resistanceSummaryDetails?.additionalExercise?[indexPath.section].data?.count ?? 0){
            cell.vwUnderline.isHidden = true
        }else{
            cell.vwUnderline.isHidden = false
        }
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResistanceSummaryHeaderCell") as! ResistanceSummaryHeaderCell
        
        let dict = self.mainModelView.resistanceSummaryDetails?.additionalExercise?[section]
        cell.setupData(data: dict)
        return cell.contentView
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vw = UIView()
        vw.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1.0)
        return vw
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 83
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 45
        }else if (indexPath.row + 1) == (self.mainModelView.resistanceSummaryDetails?.additionalExercise?[indexPath.section].data?.count ?? 0){
            return 47
        }
        return 39
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }


}

