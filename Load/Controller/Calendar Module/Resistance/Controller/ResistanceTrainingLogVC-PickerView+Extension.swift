//
//  ResistanceTrainingLogVC-PickerView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension ResistanceTrainingLogVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.mainModelView.intensityPickerView {
            return GetAllData?.data?.trainingIntensity?.count ?? 0
        }
        else if pickerView == self.mainModelView.trainingGoalPickerView {
            return self.mainModelView.getTrainingGoal().count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//for view in pickerView.subviews{
//                view.backgroundColor = UIColor.clear
//            }
        
        if pickerView == self.mainModelView.intensityPickerView {
            let activity = GetAllData?.data?.trainingIntensity![row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity!.name?.capitalized
            return myView
        }
        else if pickerView == self.mainModelView.trainingGoalPickerView {
            let activity = self.mainModelView.getTrainingGoal()[row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity.name?.capitalized
            return myView
        }
        return UIView()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.mainModelView.intensityPickerView {
            let activity = GetAllData?.data?.trainingIntensity![row]
            self.mainView.txtIntensity.text = activity?.name?.capitalized
            self.mainModelView.intensityId = (activity?.id?.stringValue)!
            self.mainView.txtTrainingGoal.text = ""
            self.mainView.txtTrainingGoal.placeholder = getCommonString(key: "Select_your_goal_key")
            self.mainModelView.trainingGoalId = ""
            
            //TODO: - Yash Changes for empty ID
            self.mainModelView.setTrainingGoal(isSet: true)
            
            self.mainModelView.selectedResistanceValidationList = nil
            
//            self.mainModelView.exercisesMainArray.removeAll()
//            self.mainView.tableViewHeight.constant = 0
            for (index, data) in self.mainModelView.exercisesMainArray.enumerated() {
                for (indexSub, _) in data.exercisesArray.enumerated() {
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].weight = ""
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].reps = ""
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].rest = ""
                    //TODO: - yash Changes
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].duration = ""
                    
                    if let cell = self.mainView.tableView.cellForRow(at: IndexPath(item: index, section: indexSub)) as? ExerciseResistanceMainCell{
//                        cell.ExerciseResistanceCellFinish(index: indexSub, section: index, Weight: "", Reps: "", Duration: "", Rest: "")
                    }
                }
            }
            
            self.mainModelView.resetSelectedDuration()
            
            self.mainView.tableView.reloadData()
        }
        else if pickerView == self.mainModelView.trainingGoalPickerView {
            let activity = self.mainModelView.getTrainingGoal()[row]
            self.mainView.txtTrainingGoal.text = activity.name?.capitalized
            self.mainModelView.trainingGoalId = (activity.id?.stringValue)!
            
            let name = activity.name?.capitalized ?? ""
            if name.lowercased() != "customize" {
                self.mainView.txtTrainingGoal.text = name
                self.mainView.txtTrainingGoal.placeholder = getCommonString(key: "Select_your_goal_key")
                self.mainModelView.isGoalCustom = false
//                self.mainModelView.showCustomTrainingGoal(isShow: false)
            }
            else {
                self.mainView.txtTrainingGoal.text = ""
                self.mainView.txtTrainingGoal.placeholder = ""
                self.mainModelView.isGoalCustom = true
                self.view.endEditing(true)
                self.mainModelView.setTrainingGoal(isSet: false)
//                self.mainModelView.showCustomTrainingGoal(isShow: true)
//                self.mainView.txtCustomTrainingGoal.becomeFirstResponder()
            }
            self.mainModelView.getValicationFromId()
//            self.mainModelView.exercisesMainArray.removeAll()
//            self.mainView.tableViewHeight.constant = 0
            for (index, data) in self.mainModelView.exercisesMainArray.enumerated() {
                for (indexSub, _) in data.exercisesArray.enumerated() {
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].weight = ""
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].reps = ""
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].rest = ""
                    //TODO: - yash changes
                    self.mainModelView.exercisesMainArray[index].exercisesArray[indexSub].duration = ""
                    
                    if let cell = self.mainView.tableView.cellForRow(at: IndexPath(item: index, section: indexSub)) as? ExerciseResistanceMainCell{
//                        cell.ExerciseResistanceCellFinish(index: indexSub, section: index, Weight: "", Reps: "", Duration: "", Rest: "")
                    }
                }
            }
            self.mainModelView.resetSelectedDuration()
            
            print("activity name : \(activity.name)")
            
             // Old Flow
            if activity.name?.lowercased() == "Muscular Endurance (Medium)".lowercased() || activity.name?.lowercased() == "Muscular Endurance (Short)".lowercased() || activity.name?.lowercased() == "customize" {
                self.mainModelView.isShowDropdown = true
            }
            else {
                self.mainModelView.isShowDropdown = false
            }
            
            self.mainView.tableView.reloadData()
        }
    }
}
