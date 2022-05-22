//
//  ExerciseResistanceMainCellTableViewCell.swift
//  Load
//
//  Created by Haresh Bhai on 23/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ExerciseResistanceMainDelegate: class {
    func ExerciseResistanceMainAddFinish(section:Int, exercisesArray:[ResistanceExerciseModelClass])
    func ExerciseResistanceMainSetArrayFinish(section:Int, exercisesArray:[ResistanceExerciseModelClass])
    func ExerciseResistanceMainEditSection(section:Int)
    func ExerciseResistanceMainEditRow(section:Int, row:Int)
    func ExerciseResistanceMainDisableEdit()
    func ResistanceExerciseHeaderRepsSelected(tag: Int, isDuration:Bool)
    func addActWeightToRecordsAlertView(reps:String,weight:String,id:Int,userId:Int,isShowAlertOrNot:Bool, atIndex:Int)
}

class ExerciseResistanceMainCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource, AddSubRowDelegate, ResistanceExerciseHeaderViewDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    var exercisesMainArray:[LibraryLogList] = [LibraryLogList]()
    weak var delegate:ExerciseResistanceMainDelegate?
    var selectedResistanceValidationList: ResistanceValidationListData?
    var strCustomTrainingGoal = ""
    var isDurationSelected: Bool = true
    var isShowDropdown:Bool = true

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupUI() {
        self.tableView.register(UINib(nibName: "ExerciseResistanceCell", bundle: nil), forCellReuseIdentifier: "ExerciseResistanceCell")
        self.tableView.isScrollEnabled = false
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 103
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ResistanceExerciseHeaderView.instanceFromNib() as? ResistanceExerciseHeaderView
        view?.isDurationSelected = self.isDurationSelected
        view?.btnExercise.tag = self.tag
        view?.delegate = self
        view?.lblTitle.text = self.exercisesMainArray[self.tag].exerciseName?.uppercased()
        view?.isShowDropdown = self.isShowDropdown
        view?.setupUI()
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 24))
        view.backgroundColor = UIColor.clear
        let innerView = UIView(frame: CGRect(x: 0, y: 14, width: UIScreen.main.bounds.width, height: 10))
        innerView.backgroundColor = UIColor.appthemeGrayWildColor
        
        view.addSubview(innerView)
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count :\(self.exercisesMainArray[self.tag].exercisesArray.count)")
        return self.exercisesMainArray[self.tag].exercisesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExerciseResistanceCell = self.tableView.dequeueReusableCell(withIdentifier: "ExerciseResistanceCell") as! ExerciseResistanceCell
        let model = self.exercisesMainArray[self.tag].exercisesArray
        cell.isDurationSelected = self.isDurationSelected
        cell.setupUI()
        cell.selectedResistanceValidationList = self.selectedResistanceValidationList
        cell.tag = self.tag
        cell.index = indexPath.row
        cell.delegate = self
        cell.btnRemove.isHidden = model.count == 1
        cell.setDetails(model: self.exercisesMainArray[self.tag].exercisesArray[indexPath.row])

        if model.count == (indexPath.row + 1){
            if cell.txtWeight.text == "" || cell.txtRest.text == "" || cell.txtReps.text == ""{
                cell.btnAdd.isHidden = true
                cell.imgAdd.isHidden = true
            }else{
                cell.btnAdd.isHidden = false
                cell.imgAdd.isHidden = false
            }
        }else{
            cell.btnAdd.isHidden = true
            cell.imgAdd.isHidden = true
        }

        cell.isShowAlertOrNot = self.exercisesMainArray[self.tag].isShowAlertOrNot
        
        cell.strCustomTrainingGoal = self.strCustomTrainingGoal
        if let weightListAvailable = self.exercisesMainArray[self.tag].repetitionMax{
            print("key Exist")
            cell.selectedResistanceWeightList = weightListAvailable
        }else{
            print("not Exist")
            cell.selectedResistanceWeightList = [RepetitionMax]()
        }
        
        if indexPath.row == (self.exercisesMainArray[self.tag].exercisesArray.count - 1) {
            cell.viewLIne.isHidden = true
        }
        else {
            cell.viewLIne.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.exercisesMainArray[self.tag].exercisesArray[sourceIndexPath.row]
        self.exercisesMainArray[self.tag].exercisesArray.remove(at: sourceIndexPath.row)
        self.exercisesMainArray[self.tag].exercisesArray.insert(movedObject, at: destinationIndexPath.row)
        debugPrint("\(sourceIndexPath.row) => \(destinationIndexPath.row)")
        self.tableView.isEditing = false
        self.tableView.reloadData()
        self.delegate?.ExerciseResistanceMainDisableEdit()
        // To check for correctness enable: self.tableView.reloadData()
    }
    
    func AddRowClicked(section: Int) {
        if self.exercisesMainArray[section].exercisesArray.count != 0 {
            for model in self.exercisesMainArray[section].exercisesArray {
                
                if model.weight == "" || model.weight == nil {
                    makeToast(strMessage: getCommonString(key: "Select_weight_key"))
                    return
                }
                else if (model.reps == "" || model.reps == nil) && (model.duration == "" || model.duration == nil){
                    if self.isDurationSelected {
                        makeToast(strMessage: getCommonString(key: "Select_duration_key"))
                    }
                    else {
                        makeToast(strMessage: getCommonString(key: "Select_reps_key"))
                    }
                    return
                }
                else if model.rest == "" || model.rest == nil {
                    makeToast(strMessage: getCommonString(key: "Select_rest_key"))
                    return
                }
            }
        }
        //MARK; - Anil
//        let last = ResistanceExerciseModelClass
        
      let last =  self.exercisesMainArray[section].exercisesArray.last
        self.exercisesMainArray[section].exercisesArray.append(addSingleRow(Weight: last?.weight ?? "", Reps: self.isDurationSelected ? last?.duration ?? "" : last?.reps ?? "", Rest: last?.rest ?? ""))
        
//        self.exercisesMainArray[section].exercisesArray.append(addSingleRow(Weight: "", Reps: self.isDurationSelected ? "" : "", Rest: ""))
        
        self.tableView.reloadData()
        self.delegate?.ExerciseResistanceMainAddFinish(section: section, exercisesArray: self.exercisesMainArray[section].exercisesArray)
    }
    
    func RemoveRowClicked(row: Int, section: Int) {
        self.delegate?.ExerciseResistanceMainEditRow(section: self.tag, row: row)
    }
    
    func ExerciseResistanceCellFinish(index: Int, section: Int, Weight: String, Reps: String, Duration:String, Rest:String) {
        self.exercisesMainArray[section].exercisesArray[index].weight = Weight
        self.exercisesMainArray[section].exercisesArray[index].reps = Reps
        self.exercisesMainArray[section].exercisesArray[index].rest = Rest
        self.exercisesMainArray[section].exercisesArray[index].duration = Duration
        
        self.delegate?.ExerciseResistanceMainSetArrayFinish(section: section, exercisesArray: self.exercisesMainArray[section].exercisesArray)

        if let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ExerciseResistanceCell{
            print("Cell found for registration")
            let model = self.exercisesMainArray[self.tag].exercisesArray
            
            if Weight == "" || Rest == "" && (Duration == "" || Reps == ""){
                cell.btnAdd.isHidden = true
                cell.imgAdd.isHidden = true
            }else{
//                cell.btnAdd.isHidden = false
//                cell.imgAdd.isHidden = false

                cell.btnAdd.isHidden = model.count != (index + 1)
                cell.imgAdd.isHidden = model.count != (index + 1)
            }
        }else{
            print("Cell not found")
        }
    }
    
    func addSingleRow(Weight: String, Reps: String, Rest: String) -> ResistanceExerciseModelClass {
        var json = JSON()
        if isDurationSelected{
            json = JSON(["Weight":Weight, "Rest":Rest, "duration": Reps])
        }else{
            json = JSON(["Weight":Weight, "Reps": Reps, "Rest":Rest])
        }
        
        return ResistanceExerciseModelClass(JSON: json.dictionaryObject!)!
    }
    
    func ResistanceExerciseHeaderViewFinish(tag: Int) {
        self.delegate?.ExerciseResistanceMainEditSection(section: self.tag)
    }
    
    func ResistanceExerciseHeaderRepsSelected(tag:Int, isDuration: Bool) {
        self.isDurationSelected = isDuration
        for (index, _) in self.exercisesMainArray[self.tag].exercisesArray.enumerated() {
            self.exercisesMainArray[self.tag].exercisesArray[index].reps = ""
            //TODO: - Yash Changes
            self.exercisesMainArray[self.tag].exercisesArray[index].duration = ""
        }
        self.tableView.reloadData()
        self.delegate?.ResistanceExerciseHeaderRepsSelected(tag: self.tag, isDuration: isDuration)
    }
    
    func showAlertForSaveInLibrary(reps: String, weight: String) {
        
        self.delegate?.addActWeightToRecordsAlertView(reps: reps, weight: weight,id: self.exercisesMainArray[self.tag].commonLibraryId == 0 ? self.exercisesMainArray[self.tag].libraryId : self.exercisesMainArray[self.tag].commonLibraryId , userId: self.exercisesMainArray[self.tag].commonLibraryId == 0 ?  Int(getUserDetail()?.data?.user?.id ?? 0) : 0, isShowAlertOrNot: self.exercisesMainArray[self.tag].isShowAlertOrNot,atIndex:self.tag)
    }

}

