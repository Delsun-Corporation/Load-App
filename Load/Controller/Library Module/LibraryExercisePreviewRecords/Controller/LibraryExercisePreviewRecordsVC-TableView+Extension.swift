//
//  LibraryExercisePreviewRecordsVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension LibraryExercisePreviewRecordsVC: UITableViewDelegate, UITableViewDataSource, LibraryPreviewRecordsDelegate {
    
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mainModelView.list != nil {
            return self.mainModelView.getCommanRM().count
        }
        return self.mainModelView.libraryPreviewModel?.repetitionMax?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LibraryExercisePreviewRecordsCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "LibraryExercisePreviewRecordsCell") as! LibraryExercisePreviewRecordsCell
        cell.delegate = self
        cell.enteredWeight = self.mainView.txtKG.text ?? ""
        if self.mainModelView.list != nil {
            //            cell.txtEstWeight.isUserInteractionEnabled = false
            //            cell.txtActWeight.isUserInteractionEnabled = false
            //            let model = self.mainModelView.getCommanRM()[indexPath.row]
            let model = self.mainModelView.list?.repetitionMax?[indexPath.row]
            cell.setupUI(index: indexPath, model: model)
        }
        else {
            let model = self.mainModelView.libraryPreviewModel?.repetitionMax![indexPath.row]
            
            cell.setupUI(index: indexPath, model: model!)
        }

        cell.txtEstWeight.isUserInteractionEnabled = false
        return cell
    }
    
    func LibraryPreviewRecordsEstWeightDidFinish(index: Int, txtEstWeight: String) {
        self.mainModelView.showBtnShow()
        if self.mainModelView.list != nil {
            self.mainModelView.list?.repetitionMax![index].estWeight = txtEstWeight
        }
        else {
            self.mainModelView.libraryPreviewModel?.repetitionMax![index].estWeight = txtEstWeight
        }
    }
    
    func LibraryPreviewRecordsActWeightDidFinish(index: Int, txtActWeight: String) {
        self.mainModelView.showBtnShow()
        if self.mainModelView.list != nil {
            self.mainModelView.list?.repetitionMax![index].actWeight = txtActWeight
        }
        else {
            self.mainModelView.libraryPreviewModel?.repetitionMax![index].actWeight = txtActWeight
        }
        
    }
    
    func AddExerciseFinish(tag:Int, data: String) {
        print("data: \(data)")
        var valueData = data == "" ? "0" : data
        if valueData.last == "." {
            valueData.removeLast()
        }
        let array = self.mainModelView.calculateRM(value: valueData.toFloat(), index: tag)
        
        for (index, value) in array.enumerated() {
            if self.mainModelView.list != nil {
                self.mainModelView.list?.repetitionMax?[index].estWeight = "\(value)"
                //TODO: - yash Changes
                //Comment beacuse act weight dont want to change whrn New RM select
//                self.mainModelView.list?.repetitionMax?[index].actWeight = ""
            }
            else {
                self.mainModelView.libraryPreviewModel?.repetitionMax![index].estWeight = "\(value)"
                //TODO: - yash Changes
                //Comment beacuse act weight dont want to change whrn New RM select
                //This is use for custome exercise
 //               self.mainModelView.libraryPreviewModel?.repetitionMax![index].actWeight = ""
            }
        }
        
        self.mainView.tableView.reloadData()
    }
}

extension LibraryExercisePreviewRecordsVC: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        self.mainModelView.showBtnShow()
        self.mainView.lblRM.text = self.mainModelView.RMTextArray[row]
        self.mainModelView.selectedRM = row == 0 ? 1 : 10
        if self.mainView.txtKG.text?.toTrim() != "" {
            let index: Int = self.mainModelView.selectedRM == 1 ? 0 : 9
            self.AddExerciseFinish(tag: index, data: self.mainView.txtKG.text?.toTrim() ?? "0")
        }
    }
}
