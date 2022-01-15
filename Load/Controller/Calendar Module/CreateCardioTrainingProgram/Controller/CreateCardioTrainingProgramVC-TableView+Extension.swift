//
//  CreateCardioTrainingProgramVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension CreateCardioTrainingProgramVC: UITableViewDelegate, UITableViewDataSource, CreateCardioTrainingProgramDayDelegate, CreateCardioTrainingProgramTextFieldDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.responseData == nil ? 0 : 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }
        return self.mainModelView.isDaySelected ? self.mainModelView.customArraySelected.count + 1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell: CreateCardioTrainingProgramHeaderCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "CreateCardioTrainingProgramHeaderCell") as! CreateCardioTrainingProgramHeaderCell
                cell.selectionStyle = .none
                cell.tag = indexPath.section
                cell.setupUI(model: self.mainModelView.responseData!)
                return cell
            }
            else {
                let cell: CreateCardioTrainingProgramTextFieldCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "CreateCardioTrainingProgramTextFieldCell") as! CreateCardioTrainingProgramTextFieldCell
                cell.delegate = self
                cell.selectionStyle = .none
                cell.tag = indexPath.row
                cell.responseData = self.mainModelView.responseData
                cell.isStartDate = self.mainModelView.isStartDate
                cell.cardioId = self.mainModelView.responseData?.id?.stringValue ?? ""
                cell.setupUI(title: self.mainModelView.titleArray[indexPath.row], text: self.mainModelView.textArray[indexPath.row], placeHolder: self.mainModelView.placeHolderArray[indexPath.row])
                cell.viewLine.isHidden = indexPath.row == 3
                return cell
            }
        }
        else {
            if indexPath.row == 0 {
                let cell: SelectDayHeaderCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "SelectDayHeaderCell") as! SelectDayHeaderCell
                cell.selectionStyle = .none
                cell.tag = indexPath.section
                cell.setupUI()
                return cell
            }
            else {
                let cell: CreateCardioTrainingProgramDayCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "CreateCardioTrainingProgramDayCell") as! CreateCardioTrainingProgramDayCell
                cell.selectionStyle = .none
                cell.tag = indexPath.row - 1
                cell.delegate = self
                cell.setupUI(title: self.mainModelView.customArray[indexPath.row - 1].lowercased().capitalized, isSelected: self.mainModelView.customArraySelected[indexPath.row - 1])
                cell.viewLine.isHidden = indexPath.row == (self.mainModelView.customArraySelected.count)
                return cell
            }
        }
    }
    
    func CreateCardioTrainingProgramDayCellFinish(tag: Int) {
        let model = self.mainModelView.customArraySelected.filter { (data) -> Bool in
            return data == true
        }
        if model.count == self.mainModelView.maxSelect {
            if self.mainModelView.customArraySelected[tag] == false {
                return
            }
        }
            
        self.mainModelView.customArraySelected[tag] = !self.mainModelView.customArraySelected[tag]
     
        self.mainView.tableView.reloadData()
    }
    
    func CreateCardioProgramFinish(text:String, isStartDate:Bool) {
        self.mainModelView.textArray[2] = ""
        self.mainModelView.selectedDate = Date()
        
        self.mainModelView.textArray[1] = text
        self.mainModelView.isStartDate = isStartDate
        self.mainView.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
        
    }
    
    func CreateCardioDateFinish(text: String, date: Date) {
        self.mainModelView.textArray[2] = text
        self.mainModelView.selectedDate = date
    }
    
    func CreateCardioDayFinish(text:String, id: String, limit:Int) {
        self.mainModelView.textArray[3] = text
        self.mainModelView.frequencyId = id
        self.mainModelView.maxSelect = limit
        self.mainModelView.isDaySelected = true
        for (index, _) in self.mainModelView.customArraySelected.enumerated() {
            self.mainModelView.customArraySelected[index] = false
        }
        self.mainView.tableView.reloadSections([1], with: .none)
    }
}


public extension Int {
    public var asWord: String {
        let numberValue = NSNumber(value: self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return formatter.string(from: numberValue)!
    }
}
