//
//  TrainingSettingsVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 30/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension TrainingSettingsVC:UITableViewDataSource, UITableViewDelegate, TrainingSettingsDelegate {
    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.headerArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TrainingHeaderView.instanceFromNib() as? TrainingHeaderView
        view?.setupUI(title: self.mainModelView.headerArray[section])
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.titleArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrainingSettingsCell") as? TrainingSettingsCell else {
            return UITableViewCell()
        }
        let cellViewData = TrainingSettingsCellViewData(cellTag: indexPath.section,
                                                        btnCellTag: indexPath.row,
                                                        txtValueTag: indexPath.row,
                                                        delegate: self,
                                                        height: mainModelView.txtHeight,
                                                        weight: mainModelView.txtWeight,
                                                        isVO2Estimated: self.mainModelView.trainingResponse?.isVO2MaxIsEstimated ?? true,
                                                        hrMax: (self.mainModelView.trainingResponse?.hrMax?.stringValue ?? "").toFloat(),
                                                        hrRest: (self.mainModelView.trainingResponse?.hrRest?.stringValue ?? "").toFloat(),
                                                        model: self.mainModelView.titleArray[indexPath.section],
                                                        indexPath: indexPath,
                                                        text: self.mainModelView.textArray[indexPath.section])
        cell.setupCell(viewData: cellViewData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func TrainingSettingsTextField(text: String, section: Int, row: Int) {
        
        if section == 0 {
            if row == 1 {
                self.mainModelView.txtHeight = text
                self.mainModelView.textArray[0][1] = text
            }
            else {
                self.mainModelView.txtWeight = text
                self.mainModelView.textArray[0][2] = text
            }
            
//            self.mainView.tableView.reloadRows(at: [IndexPath(row: 2, section: 1)], with: .none)
        }
        else if section == 1 {
            self.mainModelView.textArray[1][2] = text
            
            if self.mainModelView.isVO2MaxIsEstimated == true {
                
            } else {
                self.mainModelView.vo2MaxCustomeValue = text
            }
            
        }
        
        self.mainModelView.apiCallSettingCreateUpdateProgram()

    }
    
    func TrainingSettingsTextFieldDismissed() {
        self.mainView?.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
    }
    
    func TrainingSettingsButton(section: Int, row: Int) {
        if section == 0 {
            if row == 0 {
                self.openUnits()
            }else if row == 4{
                self.moveToPhysicActivityLevelController()
            }
        }else if section == 1{
            if row == 0{
                self.moveToAutoPauseController()
            }else if row == 1{
                self.moveToHeartRateController()
            }else if row == 3{
                self.mainModelView.moveRaceTime()
//                self.moveToRunningTimeController()
            }else if row == 4{
                self.moveToBikeSettingController()
            }
        }
        else if section == 2 {
            //Old floww
//            self.mainModelView.moveRaceTime()
            
            //New flow
            if row == 0{
                self.moveToTimeUnderTensionController()
            }
            
        }
    }
    
    func TrainingSettingVO2MaxIsEstimated(isVO2MaxIsEstimated: Bool){
        self.mainModelView.isVO2MaxIsEstimated = isVO2MaxIsEstimated
    }
}

