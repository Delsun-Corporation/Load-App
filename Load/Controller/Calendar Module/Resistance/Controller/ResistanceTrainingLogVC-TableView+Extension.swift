//
//  ResistanceTrainingLogVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

extension ResistanceTrainingLogVC: UITableViewDelegate, UITableViewDataSource, AddExerciseDelegate, ResistanceExerciseHeaderViewDelegate, ExerciseResistanceMainDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.mainModelView.exercisesMainArray[indexPath.row].exercisesArray.count * 73) + 127//UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.mainModelView.exercisesMainArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell: ExerciseResistanceMainCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "ExerciseResistanceMainCell") as! ExerciseResistanceMainCell
        cell.tableView.isEditing = indexPath.row == self.mainModelView.isEditRow ?? -1
        cell.exercisesMainArray = self.mainModelView.exercisesMainArray
        
        print("CustomTrainingGoal : \(self.mainModelView.selectedResistanceValidationList?.trainingGoalDetail?.name ?? "")")
        
        cell.strCustomTrainingGoal = self.mainModelView.selectedResistanceValidationList?.trainingGoalDetail?.name ?? ""
        cell.selectedResistanceValidationList = self.mainModelView.selectedResistanceValidationList
        
        //TODO: - yash added
        
        if self.mainModelView.selectedResistanceValidationList?.trainingGoalDetail?.name?.lowercased() == "Active Recovery".lowercased() || self.mainModelView.selectedResistanceValidationList?.trainingGoalDetail?.name?.lowercased() == "physical adaptation".lowercased() ||  self.mainModelView.selectedResistanceValidationList?.trainingGoalDetail?.name?.lowercased() == "strength".lowercased() {
            cell.isShowDropdown = false
        }else{
            cell.isShowDropdown = self.mainModelView.isShowDropdown
        }
        
        cell.isDurationSelected = self.mainModelView.isSelectedDuration[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self
        cell.setupUI()
        return cell
    }
   
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.mainModelView.exercisesMainArray[sourceIndexPath.row]
        self.mainModelView.exercisesMainArray.remove(at: sourceIndexPath.row)
        self.mainModelView.exercisesMainArray.insert(movedObject, at: destinationIndexPath.row)
        debugPrint("\(sourceIndexPath.row) => \(destinationIndexPath.row)")
        self.mainView.tableView.isEditing = false
        // To check for correctness enable: self.tableView.reloadData()
    }
    
    func ExerciseResistanceMainAddFinish(section: Int, exercisesArray: [ResistanceExerciseModelClass]) {
        self.mainModelView.exercisesMainArray[section].exercisesArray = exercisesArray
        self.mainView.tableView.reloadRows(at: [IndexPath(row: section, section: 0)], with: .none)
        self.autoTableViewHeight()
        
        self.changeColorAccordingToClickable()
        
    }
    
    func ExerciseResistanceMainSetArrayFinish(section: Int, exercisesArray: [ResistanceExerciseModelClass]) {
        self.mainModelView.exercisesMainArray[section].exercisesArray = exercisesArray
        
        changeColorAccordingToClickable()
        print("Array : \(self.mainModelView.exercisesMainArray[section].toJSON())")

    }
    
    func ExerciseResistanceCellFinish(index: Int, section: Int, Weight: String, Reps: String, Duration:String, Rest:String) {
        self.mainModelView.exercisesMainArray[section].exercisesArray[index].weight = Weight
        self.mainModelView.exercisesMainArray[section].exercisesArray[index].reps = Reps
        self.mainModelView.exercisesMainArray[section].exercisesArray[index].rest = Rest
        self.mainModelView.exercisesMainArray[section].exercisesArray[index].duration = Duration
        
        changeColorAccordingToClickable()
        
    }
 
    func ExerciseResistanceMainEditSection(section: Int) {
        self.mainModelView.showActionSheetSection(section: section)
        
        changeColorAccordingToClickable()
    }
    
    func ExerciseResistanceMainEditRow(section: Int, row:Int) {
        self.mainModelView.showActionSheet(row: row, section: section)
        
        changeColorAccordingToClickable()
    }
    
    func ExerciseResistanceMainDisableEdit() {
        self.mainModelView.isEditRow = nil
    }
    
    func autoTableViewHeight() {
        var count:Int = 0
        for data in self.mainModelView.exercisesMainArray {
            count += data.exercisesArray.count
        }
        self.mainView.tableViewHeight.constant = CGFloat((self.mainModelView.exercisesMainArray.count * 127) + (count * 73))
    }
    
    func AddExerciseDidFinish(listArray: [LibraryExerciseModelClass]) {
            
    }
    
    func AddAllExerciseDidFinish(listArray: [LibraryLogList]) {
        
        //TODO: - Yash changes
        self.mainView.layoutIfNeeded()
        self.mainView.tableView.layoutIfNeeded()

//        self.mainModelView.exercisesMainArray.removeAll()
        
        self.mainModelView.exercisesMainArray += listArray
        
        var count:Int = 0
        
        print("Before selected Duration:\(self.mainModelView.isSelectedDuration)")
        
        self.mainModelView.isSelectedDuration.removeAll()
        for (index, _) in self.mainModelView.exercisesMainArray.enumerated() {
            if self.mainModelView.previewData?.trainingGoal?.name?.lowercased() == "Muscular Endurance (Long)".lowercased() {
                self.mainModelView.isSelectedDuration.append(true)
            }
            else {
                
                if self.mainModelView.exercisesMainArray[index].exercisesArray.first?.duration == "" || self.mainModelView.exercisesMainArray[index].exercisesArray.first?.duration == nil{
                    self.mainModelView.isSelectedDuration.append(false)
                }else{
                    self.mainModelView.isSelectedDuration.append(true)
                }

            }
            
            if self.mainModelView.exercisesMainArray[index].exercisesArray.count == 0{
                count += 1
                self.mainModelView.exercisesMainArray[index].exercisesArray.append(addSingleRow())
            }else{
                count += self.mainModelView.exercisesMainArray[index].exercisesArray.count
            }
            
        }
        
        print("After selected Duration:\(self.mainModelView.isSelectedDuration)")
        
        self.mainView.tableViewHeight.constant = CGFloat((self.mainModelView.exercisesMainArray.count * 127) + (count * 73))
//        self.mainModelView.exercisesMainArray = listArray
        self.mainView.tableView.reloadData()
        
        self.changeColorAccordingToClickable()
    }
    
    func addSingleRow() -> ResistanceExerciseModelClass {
        let json = JSON(["Weight":"", "Reps":"", "Rest":""])
        return ResistanceExerciseModelClass(JSON: json.dictionaryObject!)!
    }
    
    func ResistanceExerciseHeaderViewFinish(tag: Int) {
        self.mainModelView.showActionSheetSection(section: tag)
    }
    
    func ResistanceExerciseHeaderRepsSelected(tag: Int, isDuration: Bool) {
        self.mainModelView.isSelectedDuration[tag] = isDuration
    }

    func addActWeightToRecordsAlertView(reps: String, weight: String, id: Int, userId: Int, isShowAlertOrNot: Bool, atIndex: Int) {
        print("David's debug id \(id)")
        if isShowAlertOrNot{
            
            let repitationMax = self.getDefaultJSON(reps: reps, weight: weight,atIndex : atIndex)
            self.mainModelView.apiCallUpdateLibraryAfterAlert(id: String(id), repetitionMax: repitationMax , isMsgShowAgain: true,userId:userId,atIndex: atIndex)
            
        }else{
            print("David's debug reps \(reps)")
            print("David's debug weight \(weight)")
            showCustomAlertVC(reps: reps, weight: weight, id: id, userId: userId,atIndex : atIndex)
        }
        
    }
    
    func showCustomAlertVC(reps: String, weight: String,id: Int,userId: Int, atIndex : Int){
        
        self.view.endEditing(true)
        
        let obj = AlertLibrary()
        obj.modalPresentationStyle = .overFullScreen
        obj.handlerSelectYes = {[weak self] (isShowMsgDontShowAgain) in
            print("isShowMsgDontShowAgain : \(isShowMsgDontShowAgain)")
            
            let repitationMax = self?.getDefaultJSON(reps: reps, weight: weight,atIndex:atIndex)
            print("David's debug select yes \(repitationMax)")
            self?.mainModelView.apiCallUpdateLibraryAfterAlert(id: String(id), repetitionMax: repitationMax ?? [], isMsgShowAgain: isShowMsgDontShowAgain,userId:userId,atIndex : atIndex)
            
        }
        
        obj.handlerSelectNo = {[weak self] in
            self?.view.endEditing(true)
        }
        
        self.present(obj, animated: false, completion: nil)
    }

    func getDefaultJSON(reps: String, weight: String,atIndex: Int) -> NSMutableArray {
        
        if let repetationMaxAvailable = self.mainModelView.exercisesMainArray[atIndex].repetitionMax, !repetationMaxAvailable.isEmpty{
            
            print("repetationMaxAvailable : \(repetationMaxAvailable)")
            
            var arrayData = repetationMaxAvailable
            
//            if reps == "13" || reps == "14"{
//                arrayData[11].actWeight = weight
//            }else if reps == "16" || reps == "17" || reps == "18" || reps == "19" || reps == "20"{
//                arrayData[12].actWeight = weight
//            }else{
                for i in 0..<arrayData.count{
                    
                    if let name = arrayData[i].name?.replacingOccurrences(of: " RM", with: ""){
                        if name == reps{
                            arrayData[i].actWeight = weight
                            break
                        }
                    }
                }
//            }
            
            
            let repetitionMax: NSMutableArray = NSMutableArray()
           for data in arrayData {
               let dict: NSDictionary = ["name":data.name!, "est_weight":data.estWeight!, "act_weight":data.actWeight!]
               repetitionMax.add(dict)
           }
            
            return repetitionMax
            
        }else{
            var arrayData = ([
                [
                    "name": "1 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "2 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "3 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "4 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "5 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "6 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "7 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "8 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "9 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "10 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "11 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "12 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "13 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "14 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "15 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "16 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "17 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "18 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "19 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
                [
                    "name": "20 RM",
                    "est_weight": "0",
                    "act_weight": "0"
                ],
            ])
            
            
//            if reps == "13" || reps == "14"{
//                arrayData[11]["act_weight"] = weight
//            }else if reps == "16" || reps == "17" || reps == "18" || reps == "19" || reps == "20"{
//                arrayData[12]["act_weight"] = weight
//            }else{
                for i in 0..<arrayData.count{
                    
                    print("i : \(i) value : \(arrayData[i])")
                    
                    if let name = arrayData[i]["name"]?.replacingOccurrences(of: " RM", with: ""){
                        if name == reps{
                            arrayData[i]["act_weight"] = weight
                            break
                        }
                    }
                }
//            }
            
            return NSMutableArray(array: arrayData)
            
        }
        
    }

}
