//
//  PresetResistanceTrainingProgramVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 24/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension PresetResistanceTrainingProgramVC: UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PresetResistanceTrainingProgramHeaderView.instanceFromNib() as! PresetResistanceTrainingProgramHeaderView
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
        return GetAllData?.data?.resistancePresetTrainingProgram?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PresetResistanceTrainingProgramCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "PresetResistanceTrainingProgramCell") as! PresetResistanceTrainingProgramCell
        cell.selectionStyle = .none
        cell.tag = indexPath.section
        let model = GetAllData?.data?.resistancePresetTrainingProgram?[indexPath.row]
        cell.setupUI(model: model!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj: CreateResistanceTrainingProgramVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateResistanceTrainingProgramVC") as! CreateResistanceTrainingProgramVC
        obj.mainModelView.responseData = GetAllData?.data?.resistancePresetTrainingProgram?[indexPath.row]
        obj.delegateDimissCreateResistanceScreen = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

//MARK:- Dismiss screen delegate

extension PresetResistanceTrainingProgramVC: dimissCreateResistanceScreenDelegate {
    
    func dismisCreateResistanceScreen(){
        self.dismiss(animated: false, completion: nil)
        self.mainModelView.delegateDismissPreset?.dismissPreset()
    }
}
