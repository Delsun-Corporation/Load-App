//
//  AddExerciseFinishVC-TableView+ExtensionViewController.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension AddExerciseFinishVC: UITableViewDelegate, UITableViewDataSource, AddExerciseFinishDelegate {
    
    // MARK: TableView Delegates
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = AddExerciseFinishHeaderView.instanceFromNib() as? AddExerciseFinishHeaderView
        view?.setupUI()
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.isEdit ? (self.mainModelView.libraryPreviewModel?.repetitionMax?.count)! : 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddExerciseFinishCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "AddExerciseFinishCell") as! AddExerciseFinishCell
//        if indexPath.row == 0 || indexPath.row == 9 {
//            cell.txtKG.isUserInteractionEnabled = true
//        }
//        else {
            cell.txtKG.isUserInteractionEnabled = false
//        }
        if self.mainModelView.isEdit {
            cell.setupUpdatedUI(index: indexPath, repetitionMax: (self.mainModelView.libraryPreviewModel?.repetitionMax![indexPath.row])!, theController: self)
        }
        else {
            cell.setupUI(index: indexPath, repetitionMax: self.mainModelView.RepetitionMax[indexPath.row], theController: self)
        }
        return cell
    }
    
    // MARK: Functions
    func AddExerciseFinishDidFinish(tag: Int, data: String) {
        var value = data == "" ? "0" : data
        if value.last == "." {
            value.removeLast()
        }
        if tag == 0 {
            self.mainView.txtKG.text = value
        }
        if self.mainModelView.isEdit {
            self.mainModelView.libraryPreviewModel?.repetitionMax![tag].estWeight = value
        }
        else {
            self.mainModelView.RepetitionMax[tag].estWeight = NSNumber(value: Int(value) ?? 0)
        }
    }
    
    func AddExerciseFinish(tag:Int, data: String) {
        var valueData = data == "" ? "0" : data
        if valueData.last == "." {
            valueData.removeLast()
        }
        let array = self.mainModelView.calculateRM(value: valueData.toFloat() ?? 0, index: tag)
        
        if self.mainModelView.isEdit {
            for (index, value) in array.enumerated() {
                self.mainModelView.libraryPreviewModel?.repetitionMax![index].estWeight = "\(value)"
            }
        }
        else {
            for (index, value) in array.enumerated() {
                self.mainModelView.RepetitionMax[index].estWeight = NSNumber(floatLiteral: value.rounded(toPlaces: 1))
            }
        }
        self.mainView.tableView.reloadData()
    }
}

extension AddExerciseFinishVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.mainModelView.RMTextArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//        for view in pickerView.subviews{
//            view.backgroundColor = UIColor.clear
//        }
        
        let activity = self.mainModelView.RMTextArray[row]
        let myView = PickerView.instanceFromNib() as! PickerView
        myView.setupUI()
        myView.imgIcon.image = nil
        myView.lblText.text = activity
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.mainView.lblRM.text = self.mainModelView.RMTextArray[row]
        self.mainModelView.selectedRM = row == 0 ? 1 : 10
        if self.mainView.txtKG.text?.toTrim() != "" {
            let index: Int = self.mainModelView.selectedRM == 1 ? 0 : 9
            self.AddExerciseFinish(tag: index, data: self.mainView.txtKG.text?.toTrim() ?? "0")
        }
    }
}
