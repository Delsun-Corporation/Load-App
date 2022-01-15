//
//  CalendarTrainingLogSummary + TableView.swift
//  Load
//
//  Created by iMac on 22/03/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation

extension CalendarTrainingLogSummaryVc : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.mainModelView.controllerMoveFrom == .trainingLog {
            return self.mainModelView.cardioSummaryDetails?.exercise?.count ?? 0
        }
        else if self.mainModelView.controllerMoveFrom == .trainingProgram {
            return self.mainModelView.cardioSummaryDetails?.exerciseTrainingProgram?.count ?? 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataDetailScreenCardioSummaryTblCell") as! DataDetailScreenCardioSummaryTblCell
        
        cell.activityName = self.mainModelView.activityName.lowercased()
        cell.trainingGoalName = self.mainModelView.cardioSummaryDetails?.trainingGoal?.name?.lowercased() ?? ""
        
        var count = 0
        
        if self.mainModelView.controllerMoveFrom == .trainingLog{
            count = self.mainModelView.cardioSummaryDetails?.exercise?.count ?? 0
            cell.setupDetails(exercise: self.mainModelView.cardioSummaryDetails?.exercise?[indexPath.row])
        }else if self.mainModelView.controllerMoveFrom == .trainingProgram{
            count = self.mainModelView.cardioSummaryDetails?.exerciseTrainingProgram?.count ?? 0
            cell.isPaceSelected = self.isPaceSelected
            cell.setupDetailsForTrainingProgram(exercise: self.mainModelView.cardioSummaryDetails?.exerciseTrainingProgram?[indexPath.row])
        }
        
        if count == indexPath.row + 1{
            cell.vwUnderLine.isHidden = true
        }else{
            cell.vwUnderLine.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardioSummaryHeadeTblCell") as! CardioSummaryHeadeTblCell
        
        if self.mainModelView.controllerMoveFrom == .trainingLog{
            cell.imgSpeedArrow.isHidden = true
            if self.mainModelView.cardioSummaryDetails?.exercise?.count ?? 0 > 0{
                cell.activityName = self.mainModelView.activityName
                cell.setDetails(exercise: self.mainModelView.cardioSummaryDetails?.exercise?[0])
            }
        }
        else if self.mainModelView.controllerMoveFrom == .trainingProgram {
            cell.imgSpeedArrow.isHidden = false

            cell.btnSpeedPace.addTarget(self, action: #selector(updateSpeedPace), for: .touchUpInside)
            cell.isPaceSelected = self.isPaceSelected
            if self.mainModelView.cardioSummaryDetails?.exerciseTrainingProgram?.count ?? 0 > 0{
                cell.activityName = self.mainModelView.activityName
                cell.setDetailsForTrainingProgram(exercise: self.mainModelView.cardioSummaryDetails?.exerciseTrainingProgram?[0])
            }
        }
        
        return cell.contentView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    @objc func updateSpeedPace(){
        self.isPaceSelected = !self.isPaceSelected
        self.mainView.tableView.reloadData()
    }
}
