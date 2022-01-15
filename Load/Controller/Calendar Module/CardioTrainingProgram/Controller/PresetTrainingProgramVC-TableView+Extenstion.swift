//
//  PresetTrainingProgramVC-TableView+Extenstion.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension PresetTrainingProgramVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 108
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PresetTrainingProgramHeaderView.instanceFromNib() as! PresetTrainingProgramHeaderView
        view.setupUI()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GetAllData?.data?.cardioPresetTrainingProgram?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell: PresetTrainingProgramCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "PresetTrainingProgramCell") as! PresetTrainingProgramCell
        cell.selectionStyle = .none
        cell.tag = indexPath.section
        let model = GetAllData?.data?.cardioPresetTrainingProgram?[indexPath.row]
        cell.setupUI(model: model!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj: CreateCardioTrainingProgramVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateCardioTrainingProgramVC") as! CreateCardioTrainingProgramVC
        obj.delegateDismissPresetTrainigProgram = self
        obj.mainModelView.responseData = GetAllData?.data?.cardioPresetTrainingProgram?[indexPath.row]
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

extension PresetTrainingProgramVC: dismissPresetTrainingProgramScreenDelegate {
        
    func dismissPresetTrainingProgramScreen(){
        self.dismiss(animated: false, completion: nil)
        self.mainModelView.delegateDismissPreset?.dismissPreset()
    }
}

