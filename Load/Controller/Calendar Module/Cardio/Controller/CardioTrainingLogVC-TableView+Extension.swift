//
//  CardioTrainingLogVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

extension CardioTrainingLogVC: UITableViewDelegate, UITableViewDataSource, AddRowDelegate, ExerciseCardioCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.mainModelView.exercisesArray.count : 0//1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: ExerciseCardioCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "ExerciseCardioCell") as! ExerciseCardioCell
            cell.tag = indexPath.row
            cell.delegate = self
            cell.btnRemove.isHidden = self.mainModelView.exercisesArray.count == 1
            cell.activityId = self.mainModelView.activityId
            cell.isShowDistance =  self.mainModelView.isShowDistance
            cell.isShowSpeed =  self.mainModelView.isShowSpeed
            cell.isShowRPM = self.mainModelView.isShowRPM
            cell.isTrainigGoalSelectAsCustomize = self.mainModelView.isTrainigGoalSelectAsCustomize
            cell.selectedCardioValidationList = self.mainModelView.selectedCardioLogValidation
            cell.activityName = self.mainView.txtActivity.text?.toTrim().lowercased() ?? ""
            cell.selectedCardioTrainingLogName = self.mainModelView.selectedTrainingGoalName
            cell.isEdit = self.mainModelView.isEdit
            cell.setupUI()
            cell.setDetails(model: self.mainModelView.exercisesArray[indexPath.row])
            return cell
        }
        else {
            let cell: AddRowCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "AddRowCell") as! AddRowCell
            cell.delegate = self
//            cell.btnRemove.isHidden = self.mainModelView.exercisesArray.count == 0
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.mainModelView.exercisesArray[sourceIndexPath.row]
        self.mainModelView.exercisesArray.remove(at: sourceIndexPath.row)
        self.mainModelView.exercisesArray.insert(movedObject, at: destinationIndexPath.row)
        debugPrint("\(sourceIndexPath.row) => \(destinationIndexPath.row)")
        self.mainView.tableView.isEditing = false
        self.mainView.tableView.reloadData()
        // To check for correctness enable: self.tableView.reloadData()
    }
    
    func AddRowClicked() {
        self.view.endEditing(true)
        if self.mainView.txtActivity.text == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_activity_key"))
            return
        }
        
        if self.mainView.txtTrainingGoal.text == ""{
            makeToast(strMessage: getCommonString(key: "Please_fill_in_your_training_goal_key"))
            return
        }
        
        if self.mainView.txtActivity.text?.toTrim().lowercased() ?? "" == "Swimming".lowercased(){
            
            if self.mainView.txtStyle.text == ""{
                makeToast(strMessage: getCommonString(key: "Please_select_style_key"))
                return
            }
        }
        
        
        if self.mainModelView.exercisesArray.count != 0 {
            var isAllFieled:Bool = true
            for model in self.mainModelView.exercisesArray {
                if model.laps == "" {
                     isAllFieled = false
                }
                
//                if (model.speed == "" || model.speed == nil) && self.mainModelView.isShowSpeed {
//                    isAllFieled = false
//                }
//
//                if (model.pace == "" || model.pace == nil) && !self.mainModelView.isShowSpeed {
//                    isAllFieled = false
//                }
                
                //TODO: - Yash Changes
//                if model.percentage == "" {
//                    isAllFieled = false
//                }
                
//                if (model.distance == "" || model.distance == nil) && self.mainModelView.isShowDistance {
//                    isAllFieled = false
//                }
//
//                if (model.duration == "" || model.duration == nil) && !self.mainModelView.isShowDistance {
//                    isAllFieled = false
//                }
                
                let trainingGoalValue = self.mainView.txtTrainingGoal.text?.toTrim().lowercased()
                
                let speedIntervals = "Speed Intervals".lowercased()
                let lacateToleranceContinuous = "Lactate Tolerance (Continuous)".lowercased()
                let lacateToleranceIntervals = "Lactate Tolerance (Intervals)".lowercased()
                let aerobicIntervals = "Aerobic Intervals".lowercased()
                let aerobicCapacity = "Aerobic Capacity".lowercased()
                let sprint = "Sprint".lowercased()
                let speed = "Speed".lowercased()
                
                switch self.mainView.txtActivity.text?.toTrim().lowercased(){
                    
                case "Run (Outdoor)".lowercased():
                    
                    if (model.distance == "" || model.distance == nil) && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil) && self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if (model.pace == "" || model.pace == nil) && !self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == speedIntervals || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicIntervals{
                        if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                    }
                    
                case "Run (Indoor)".lowercased():
                    if (model.distance == "" || model.distance == nil) && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil) && self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if (model.pace == "" || model.pace == nil) && !self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == speedIntervals || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicIntervals{
                        if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                    }
                    
                case "Cycling (Indoor)".lowercased():
                    
                    if (model.distance == "" || model.distance == nil) && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil) && self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == sprint || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicCapacity{
                        if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                    }
                    
                    //Lvl is comment because static value pass while submit(CardioTrainingViewModel)(CardioTrainingLogVc)
//                    if model.lvl == "" || model.lvl == nil {
//                        isAllFieled = false
//                    }
                    
                    if (model.rpm == "" || model.rpm == nil) && self.mainModelView.isShowRPM {
                        isAllFieled = false
                    }
                    
                    if (model.watt == "" || model.watt == nil) && !self.mainModelView.isShowRPM {
                        isAllFieled = false
                    }
                    
                case "Cycling (Outdoor)".lowercased():
                   
                    if (model.distance == "" || model.distance == nil) && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.speed == "" || model.speed == nil) && self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if (model.rpm == "" || model.rpm == nil) && self.mainModelView.isShowRPM {
                        isAllFieled = false
                    }
                    
                    if (model.watt == "" || model.watt == nil) && !self.mainModelView.isShowRPM {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == sprint || trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == aerobicCapacity{
                        if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                    }
                    
                case "Swimming".lowercased():
                  
                    if (model.distance == "" || model.distance == nil) && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.pace == "" || model.pace == nil) && !self.mainModelView.isShowSpeed {
                        isAllFieled = false
                    }
                    
                    if trainingGoalValue == lacateToleranceIntervals || trainingGoalValue == speed{
                        if model.rest == "" || model.rest == nil {
                            isAllFieled = false
                        }
                    }
                    
                case "Others".lowercased():
                    
                    if (model.distance == "" || model.distance == nil) && self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
                    if (model.duration == "" || model.duration == nil) && !self.mainModelView.isShowDistance {
                        isAllFieled = false
                    }
                    
//                    if (model.speed == "" || model.speed == nil) && self.mainModelView.isShowSpeed {
//                        isAllFieled = false
//                    }
//
//                    if (model.pace == "" || model.pace == nil) && !self.mainModelView.isShowSpeed {
//                        isAllFieled = false
//                    }
//
//                    if (model.rpm == "" || model.rpm == nil) && self.mainModelView.isShowRPM {
//                        isAllFieled = false
//                    }
//
//                    if (model.watt == "" || model.watt == nil) && !self.mainModelView.isShowRPM {
//                        isAllFieled = false
//                    }
//
//                    if model.lvl == "" || model.lvl == nil {
//                        isAllFieled = false
//                    }
//
//                    if model.rest == "" || model.rest == nil {
//                        isAllFieled = false
//                    }
                    
                default:
                    
                    if model.rest == "" || model.rest == nil {
                        isAllFieled = false
                    }
                    
                }
                
                //TODO: - Yash Changes
//                if model.rest == "" || model.rest == nil {
//                    isAllFieled = false
//                }
                
                if !isAllFieled {
                    makeToast(strMessage: getCommonString(key: "Please_fill_all_details_key"))
                    return
                }
            }
        }
        if self.mainModelView.exercisesArray.count == 0 {
            let json = JSON(["laps":"", "speed":"", "pace":"", "percentage":"", "duration":"", "distance":"", "rest":"","lvl": "", "rpm": "", "watt": ""])
            self.mainModelView.exercisesArray.append(CardioExerciseModelClass(JSON: json.dictionaryObject!)!)
        }
        else {
            let model = self.mainModelView.exercisesArray.last
            let laps = "\((Int(model?.laps ?? "") ?? 1)+1)"
            let speed = model?.speed ?? ""
            let pace = model?.pace ?? ""
            let percentage = model?.percentage ?? ""
            let duration = model?.duration ?? ""
            let distance = model?.distance ?? ""
            let rest = model?.rest ?? ""
            //
            let lvl = model?.lvl ?? ""
            let rpm = model?.rpm ?? ""
            let watt = model?.watt ?? ""
            
            let json = JSON(["laps":laps, "speed":speed, "pace":pace, "percentage":percentage, "duration":duration, "distance":distance, "rest":rest,"lvl": lvl, "rpm": rpm, "watt": watt])
//            let json = JSON(["Laps":"\(laps)", "Speed":"", "Pace":"", "Percentage":"", "Duration":"", "Distance":"", "Rest":"","Lvl": "", "rpm": "", "watt": ""])
            print(json)
            self.mainModelView.exercisesArray.append(CardioExerciseModelClass(JSON: json.dictionaryObject!)!)
        }
        self.mainView.layoutIfNeeded()
        self.mainView.tableView.layoutIfNeeded()
        self.mainView.tableViewHeight.constant = CGFloat((self.mainModelView.exercisesArray.count * 70) + 0) //70
        self.mainView.tableView.reloadData()
        self.mainView.lblLapsTitle.text = self.mainModelView.getTotalLaps(total: self.mainModelView.exercisesArray.count)
        
        //Check userinteraction set or not
        self.changeColorAccordingToClickable()
    }
    
    func RemoveRowClicked(tag: Int) {
        print(tag)
        self.view.endEditing(true)
        self.mainModelView.showActionSheet(row: tag)
    }
    
    func RemoveRowClicked() {
        self.mainModelView.exercisesArray.removeLast()
        self.mainView.tableViewHeight.constant = CGFloat((self.mainModelView.exercisesArray.count * 70) + 0) //70
        self.mainView.tableView.reloadData()
        self.mainView.lblLapsTitle.text = self.mainModelView.getTotalLaps(total: self.mainModelView.exercisesArray.count)
    }
    
    func ExerciseCardioCellFinish(index: Int, Laps: String, Speed: String, Pace: String, Percentage: String, Duration: String, Distance: String, Rest: String, Lvl: String, RPM: String, Watt: String) {
        
        self.mainModelView.exercisesArray[index].laps = String(index+1)
        self.mainModelView.exercisesArray[index].speed = Speed
        self.mainModelView.exercisesArray[index].pace = Pace
        self.mainModelView.exercisesArray[index].percentage = Percentage
        self.mainModelView.exercisesArray[index].duration = Duration
        self.mainModelView.exercisesArray[index].distance = Distance
        
        if Rest == "--:--"{
            self.mainModelView.exercisesArray[index].rest = ""
        }else{
            self.mainModelView.exercisesArray[index].rest = Rest
        }
        
        self.mainModelView.exercisesArray[index].lvl = Lvl
        self.mainModelView.exercisesArray[index].rpm = RPM
        self.mainModelView.exercisesArray[index].watt = Watt
        
        print("laps : \(index+1) , speed: \(Speed), pace: \(Pace) , percentage:\(Percentage) , duration:\(Duration) , distance: \(Distance) , rest : \(Rest) , lvl : \(Lvl) , rpm : \(RPM) , Watt : \(Watt)")
        
        //Check userinteraction set or not
        self.changeColorAccordingToClickable()

    }
    
}
