//
//  CalendarVCfd.swift
//  Load
//
//  Created by Haresh Bhai on 30/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension CalendarVC: UITableViewDelegate, UITableViewDataSource, CalendarSelectionProtocol, TrainingListDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.calendarArray == nil ? 0 : (6 + 3) // 6 : Calendar, 3: Extra cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 7 {
            return 490
        }
        else if indexPath.section == 8 {
            return 170
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 7 {
            return 490
        }
        else if indexPath.section == 8 {
            return 170
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 6 {
            return 0
        }
        
        if section > 6 {
            return self.mainModelView.isExpanded ? (section == self.mainModelView.expandedSection ? (self.mainModelView.arrayCount + 2) : 1) : 1
        }
        else {
            let arr = self.mainModelView.logList?.trainingLogList?.filter({ (list) -> Bool in
                return (list.date?.contains(self.mainModelView.expandedDate))!
            })            
            
            let arr1 = self.mainModelView.logList?.trainingProgramList?.filter({ (list) -> Bool in
                let startDate = (list.startDate ?? "").UTCToLocal().convertDateFormater()
                let endDate = (list.endDate ?? "").UTCToLocal().convertDateFormater()
                
                let sdate = startDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
                let edate = endDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
                
                var weekdayTest = Calendar.current.component(.weekday, from: edate).makeRealWeekDay()
                if weekdayTest == 7 {
                    weekdayTest = 0
                }
                let testEndDate = Calendar.current.date(byAdding: .day, value: -(weekdayTest), to: edate)
                if self.mainModelView.expandedDate == "" {
                    return false
                }
                
                let dayName = self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd").toString(dateFormat: "EEEE").uppercased()
                var isDayContain = list.days?.contains(where: { (str) -> Bool in
                    return str == dayName
                })
                //                print("expandedDate -> ", self.mainModelView.expandedDate)
                
                var isBetween = self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd").isBetweeen(date: sdate, andDate: testEndDate!)
                if !isBetween {
                    isBetween = self.mainModelView.expandedDate == startDate.toString(dateFormat: "yyyy-MM-dd") || self.mainModelView.expandedDate == testEndDate!.toString(dateFormat: "yyyy-MM-dd")
                }
                
                var isShowFirst:Bool = true
                var isShowLast:Bool = true
                var is24:Bool = false
                
                if isBetween {
                    let title = list.presetTrainingProgram?.title?.lowercased().replace(target: "km", withString: "").toTrim()
                    
                    if title == "42" {
                        let array42:[String] = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
                        
                        guard let (_, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: array42) else {
                            return false
                        }
                        
                        if weekNo == 24 {
                            is24 = true
                            isBetween = true
                            isDayContain = true
                        }
                    }
                }
                
                if isBetween {
                    let title = list.presetTrainingProgram?.title?.lowercased().replace(target: "km", withString: "").toTrim()
                    if title == "5" {
                        let freq = list.trainingFrequency?.code?.lowercased() == "5x".lowercased()
                        guard let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: list.days ?? []) else {
                            return false
                        }
                        //                        print(dayNo)
                        //                        print(weekNo)
                        
                        if dayNo == 1 && weekNo <= 6 && freq && list.days?.count == 5 {
                            isShowFirst = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "4x" && dayNo > 3 && weekNo >= 18 && (list.days?.count ?? 0) > 3 {
                            isShowLast = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 4 && weekNo >= 18 && (list.days?.count ?? 0) > 4 {
                            isShowLast = false
                        }
                    }
                    else if title == "10" {
                        let freq = list.trainingFrequency?.code?.lowercased() == "6x".lowercased()
                        guard let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: list.days ?? []) else {
                            return false
                        }
                        //                        print(dayNo)
                        //                        print(weekNo)
                        if dayNo == 1 && weekNo <= 6 && freq && list.days?.count == 6 {
                            isShowFirst = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 4 && weekNo == 10 && (list.days?.count ?? 0) > 4 {
                            isShowLast = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "6x" && dayNo > 5 && weekNo == 10 && (list.days?.count ?? 0) > 5 {
                            isShowLast = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 3 && weekNo >= 24 && (list.days?.count ?? 0) > 3 {
                            isShowLast = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "6x" && dayNo > 4 && weekNo >= 24 && (list.days?.count ?? 0) > 4 {
                            isShowLast = false
                        }
                    }
                    else if title == "21" {
                        let freq = list.trainingFrequency?.code?.lowercased() == "6x".lowercased()
                        guard let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: list.days ?? []) else {
                            return false
                        }
                        //                        print(dayNo)
                        //                        print(weekNo)
                        if dayNo == 1 && weekNo <= 6 && freq && list.days?.count == 6 {
                            isShowFirst = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 4 && (weekNo == 10 || weekNo == 22) && (list.days?.count ?? 0) > 4 {
                            isShowLast = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "6x" && dayNo > 5 && (weekNo == 10 || weekNo == 22) && (list.days?.count ?? 0) > 5 {
                            isShowLast = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 3 && weekNo >= 24  && (list.days?.count ?? 0) > 3 {
                            isShowLast = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "6x" && dayNo > 4 && weekNo >= 24 && (list.days?.count ?? 0) > 4 {
                            isShowLast = false
                        }
                    }
                    else if title == "42" {
                        let array42:[String] = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
                        
                        let freq = list.trainingFrequency?.code?.lowercased() == "6x".lowercased()
                        guard let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: is24 ? array42 : list.days ?? []) else {
                            return false
                        }
                        //                        print(dayNo)
                        //                        print(weekNo)
                        if dayNo == 1 && weekNo <= 6 && freq && list.days?.count == 6 {
                            isShowFirst = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 4 && (weekNo == 10 || weekNo == 16 || weekNo == 21 || weekNo == 22 || weekNo == 23) && (list.days?.count ?? 0) > 4 {
                            isShowLast = false
                        }
                        
                        if list.trainingFrequency?.code?.lowercased() == "6x" && dayNo > 5 && (weekNo == 10 || weekNo == 16 || weekNo == 21 || weekNo == 22 || weekNo == 23) && (list.days?.count ?? 0) > 5 {
                            isShowLast = false
                        }
                        
                        //                        if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 5 && weekNo >= 24  && (list.days?.count ?? 0) > 5 {
                        //                            isShowLast = false
                        //                        }
                        if weekNo == 24 && dayNo < 7{
                            isShowFirst = true
                            isShowLast = true
                            isDayContain = true
                        }
                        
                        if weekNo == 24 && dayNo == 7 {
                            isShowLast = false
                            isDayContain = false
                        }
                    }
                }
                
                return isBetween && (isDayContain ?? false) && isShowFirst && isShowLast
                //                return self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd").isBetweeen(date: sdate!, andDate: edate!) && isDayContain ?? false
            })
            return self.mainModelView.isExpanded ? (section == self.mainModelView.expandedSection && ((arr?.count ?? 0)! != 0 || (arr1?.count ?? 0)! != 0) ? ((arr?.count ?? 0)! + (arr1?.count ?? 0)! + 3) : 1) : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section < 6 {
            if indexPath.row == 0 {
                let cell: CalendarCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "CalendarCell") as! CalendarCell
                cell.tag = indexPath.section
                cell.delegate = self
                let arr = self.mainModelView.logList?.trainingLogList
                
                cell.removeSelectedDate()
                
                if !self.mainModelView.isReloaded[indexPath.section] {
                    if arr != nil {
                         cell.makeCircle(ofIndex: indexPath.section)
                        self.mainModelView.lastSelectedSection = indexPath.section
                        self.mainModelView.isReloaded[indexPath.section] = true
                    }
                }else{
                    cell.makeCircle(ofIndex: indexPath.section)
                }
                
                //set common other wise data will change while scroll table
                cell.setupData(data: self.mainModelView.calendarArray!, trainingLogList: arr, trainingProgramList: self.mainModelView.logList?.trainingProgramList ?? [], section: self.mainModelView.expandedSection, row: self.mainModelView.expandedRow, expandedDate: self.mainModelView.expandedDate)
                
                return cell
            }
            else if indexPath.row == 1 {
                let cell: TrainingListHeaderCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "TrainingListHeaderCell") as! TrainingListHeaderCell
                cell.setImage(index: self.mainModelView.expandedIndex)
                return cell
            }
            else {
                let arr = self.mainModelView.logList?.trainingLogList?.filter({ (list) -> Bool in
                    (list.date?.contains(self.mainModelView.expandedDate))!
                })
                
                let arr1 = self.mainModelView.logList?.trainingProgramList?.filter({ (list) -> Bool in
                    let startDate = (list.startDate ?? "").UTCToLocal().convertDateFormater()
                    let endDate = (list.endDate ?? "").UTCToLocal().convertDateFormater()
                    
                    let sdate = startDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
                    let edate = endDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
                    if self.mainModelView.expandedDate == "" {
                        return false
                    }
                    
                    let dayName = self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd").toString(dateFormat: "EEEE").uppercased()
                    var isDayContain = list.days?.contains(where: { (str) -> Bool in
                        return str == dayName
                    })
                    
                    //                    print("expandedDate -> ", self.mainModelView.expandedDate)
                    var isBetween = self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd").isBetweeen(date: sdate, andDate: edate)
                    if !isBetween {
                        isBetween = self.mainModelView.expandedDate == startDate.toString(dateFormat: "yyyy-MM-dd") || self.mainModelView.expandedDate == endDate.toString(dateFormat: "yyyy-MM-dd")
                    }
                    
                    var isShowFirst:Bool = true
                    var isShowLast:Bool = true
                    
                    if isBetween {
                        let title = list.presetTrainingProgram?.title?.lowercased().replace(target: "km", withString: "").toTrim()
                        if title == "42" {
                            guard let (_, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: list.days ?? []) else {
                                return false
                            }
                            
                            if weekNo == 24 {
                                isBetween = true
                                isDayContain = true
                            }
                        }
                    }
                    
                    if isBetween {
                        let title = list.presetTrainingProgram?.title?.lowercased().replace(target: "km", withString: "").toTrim()
                        if title == "5" {
                            let freq = list.trainingFrequency?.code?.lowercased() == "5x".lowercased()
                            guard let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: list.days ?? []) else {
                                return false
                            }
                            //                            print(dayNo)
                            //                            print(weekNo)
                            if dayNo == 1 && weekNo <= 6 && freq && list.days?.count == 5 {
                                isShowFirst = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "4x" && dayNo > 3 && weekNo >= 18 && (list.days?.count ?? 0) > 3 {
                                isShowLast = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 4 && weekNo >= 18 && (list.days?.count ?? 0) > 4 {
                                isShowLast = false
                            }
                        }
                        else if title == "10" {
                            let freq = list.trainingFrequency?.code?.lowercased() == "6x".lowercased()
                            guard let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: list.days ?? []) else {
                                return false
                            }
                            //                            print(dayNo)
                            //                            print(weekNo)
                            if dayNo == 1 && weekNo <= 6 && freq && list.days?.count == 6 {
                                isShowFirst = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 4 && weekNo == 10 && (list.days?.count ?? 0) > 4 {
                                isShowLast = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "6x" && dayNo > 5 && weekNo == 10 && (list.days?.count ?? 0) > 5 {
                                isShowLast = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 3 && weekNo >= 24 && (list.days?.count ?? 0) > 3 {
                                isShowLast = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "6x" && dayNo > 4 && weekNo >= 24 && (list.days?.count ?? 0) > 4 {
                                isShowLast = false
                            }
                        }
                        else if title == "21" {
                            let freq = list.trainingFrequency?.code?.lowercased() == "6x".lowercased()
                            guard let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: list.days ?? []) else {
                                return false
                            }
                            //                            print(dayNo)
                            //                            print(weekNo)
                            if dayNo == 1 && weekNo <= 6 && freq && list.days?.count == 6 {
                                isShowFirst = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 4 && (weekNo == 10 || weekNo == 22) && (list.days?.count ?? 0) > 4 {
                                isShowLast = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "6x" && dayNo > 5 && (weekNo == 10 || weekNo == 22) && (list.days?.count ?? 0) > 5 {
                                isShowLast = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 3 && weekNo >= 24  && (list.days?.count ?? 0) > 3 {
                                isShowLast = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "6x" && dayNo > 4 && weekNo >= 24 && (list.days?.count ?? 0) > 4 {
                                isShowLast = false
                            }
                        }
                        else if title == "42" {
                            let freq = list.trainingFrequency?.code?.lowercased() == "6x".lowercased()
                            guard let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: list.days ?? []) else {
                                return false
                            }
                            //                            print(dayNo)
                            //                            print(weekNo)
                            if dayNo == 1 && weekNo <= 6 && freq && list.days?.count == 6 {
                                isShowFirst = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 4 && (weekNo == 10 || weekNo == 16 || weekNo == 21 || weekNo == 22 || weekNo == 23) && (list.days?.count ?? 0) > 4 {
                                isShowLast = false
                            }
                            
                            if list.trainingFrequency?.code?.lowercased() == "6x" && dayNo > 5 && (weekNo == 10 || weekNo == 16 || weekNo == 21 || weekNo == 22 || weekNo == 23) && (list.days?.count ?? 0) > 5 {
                                isShowLast = false
                            }
                            
                            //                            if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 5 && weekNo >= 24  && (list.days?.count ?? 0) > 5 {
                            //                                isShowLast = false
                            //                            }
                            if weekNo == 24 {
                                isShowLast = true
                                isShowLast = true
                                isDayContain = true
                            }
                        }
                    }
                    
                    return isBetween && (isDayContain ?? false) && isShowFirst && isShowLast
                    //                    return self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd").isBetweeen(date: sdate!, andDate: edate!) && isDayContain ?? false
                })
                let index = ((arr?.count ?? 0) + (arr1?.count ?? 0))
               
                if (indexPath.row - 2) == index {
                    let cell: TrainingListFooterCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "TrainingListFooterCell") as! TrainingListFooterCell
                    return cell
                }
                else if arr?.count ?? 0 > (indexPath.row - 2) {
                    let cell: TrainingListCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "TrainingListCell") as! TrainingListCell
                    cell.tag = indexPath.row - 2
                    cell.delegate = self
                    cell.setupUI(model: arr![indexPath.row - 2])
                    return cell
                }
                else {
                    let indexArray1 = (arr?.count ?? 0) + 2
                    let cell: TrainingListProgramCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "TrainingListProgramCell") as! TrainingListProgramCell
                    cell.tag = indexPath.row - indexArray1
                    cell.delegate = self
                    let (weekNo, dayNo) = self.getTrainingProgramWeekNo(tag: cell.tag, trainingId: arr1![indexPath.row - indexArray1].id?.stringValue ?? "")
                    
                    cell.setupUIForBlankData()
                    
                    self.mainModelView.apiCallDailyPrograms(programId: arr1![indexPath.row - indexArray1].id?.stringValue ?? "", weekNumber: weekNo, workoutNumber: dayNo, progress: false) { (model, error) in
                        if error == "" || error == nil{
                            cell.setupUIProgram(model: model)
                        }
                    }
                    return cell
                }
            }
        }
        else if indexPath.section == 6 {
            let cell: GSPCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "GSPCell") as! GSPCell
            cell.setupUI()
            return cell
        }
        else if indexPath.section == 7 {
            let cell: ProgressionCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "ProgressionCell") as! ProgressionCell
            cell.setupUI(theController: self)
            return cell
        }
        else {
            let cell: AverageCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "AverageCell") as! AverageCell
            cell.setupUI()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
       
//        if self.mainModelView.isExpanded == true && indexPath.section < 6 && self.mainModelView.expandedSection == indexPath.section {
////            cell.alpha = 0
//            UIView.animate(
//                withDuration: 0.5,
//                delay: 0.05 ,
//                animations: {
//                    tableView.layoutIfNeeded()
////                    cell.alpha = 1
//            })
//        }

    }
    
    func CalendarSelection(section: Int, row: Int, index:Int, date: String, no: Int) {
        
        self.mainModelView.selectedDate = date
        
        self.mainModelView.isReloaded[section] = false

        let (pDate, cDate, _) = self.checkDateMonth(date: date)
        
        if pDate {
            self.mainModelView.currentShowMonth = self.mainModelView.currentShowMonth.getPreviousMonth()!
            self.mainModelView.setupData(isExpanded: true, expandedDate: date)
        }
        else if cDate {
            if self.mainModelView.expandedSection == section && self.mainModelView.expandedRow == row {
                
                self.mainModelView.selectedDate = ""

                self.mainModelView.isExpanded = false
                self.mainModelView.expandedDate = ""
                self.mainModelView.expandedSection = -1
                self.mainModelView.expandedSection = -1
            }
            else {
                self.mainModelView.isExpanded = true
                self.mainModelView.expandedDate = date
                self.mainModelView.expandedSection = section
                self.mainModelView.expandedRow = row
                self.mainModelView.expandedIndex = row
            }

            self.mainView.tableView.beginUpdates()
            self.mainView.tableView.reloadSections([self.mainModelView.lastSelectedSection], with: .automatic)
            self.mainView.tableView.reloadSections([section], with: .automatic)
            self.mainView.tableView.endUpdates()

        }
        else {
            self.mainModelView.currentShowMonth = self.mainModelView.currentShowMonth.getNextMonth()!
            self.mainModelView.setupData(isExpanded: true, expandedDate: date)
        }
    }
    
    
    func CalendarAutoSelection(section: Int, row: Int, index: Int, date: String, no: Int) {
        var isReload:Bool = false
        
        if self.mainModelView.expandedSection == -1 {
            isReload = true
        }
        self.mainModelView.isExpanded = true
        self.mainModelView.expandedDate = date
        self.mainModelView.expandedSection = section
        self.mainModelView.expandedRow = row
        self.mainModelView.expandedIndex = row
        if isReload {
            self.mainView.tableView.reloadData()
        }
        //        if self.expandedDate != "" {
        //            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) {
        //                view?.tableView.reloadData()
        //            }
        //        }
    }
    
    func checkDateMonth(date: String) -> (Bool, Bool, Bool) {
        let dateMonth = date.convertDateFormater(format: "yyyy-MM-dd", isUTC: false).toString(dateFormat: "MM")
        let currentDateMonth = (self.mainModelView.currentShowMonth.setTimeZero() ?? Date()).toString(dateFormat: "MM")
        
        var pDate:Bool = false
        var cDate:Bool = false
        var nDate:Bool = false
        
        if Int(dateMonth)! == 12 && Int(currentDateMonth)! == 1 {
            pDate = true
        }
        else if Int(dateMonth)! == 1 && Int(currentDateMonth)! == 12 {
            nDate = true
        }
        else if Int(dateMonth)! < Int(currentDateMonth)! {
            pDate = true
        }
        else if Int(dateMonth) == Int(currentDateMonth) {
            cDate = true
        }
        else {
            nDate = true
        }
        
        return (pDate, cDate, nDate)
    }
    
    func TrainingListFinish(isTrainingLog: Bool, tag: Int, trainingId:String, weekdayWiseMainIDForProgram: String, isCompleted:Bool?) {
        if isTrainingLog {
            let arr = self.mainModelView.logList?.trainingLogList?.filter({ (list) -> Bool in
                (list.date?.contains(self.mainModelView.expandedDate))!
            })
            let status = arr?[tag].status
            if status?.lowercased() == TRAINING_LOG_STATUS.CARDIO.rawValue.lowercased() {
                
                if arr?[tag].isComplete == 0{ // workout is not complete
                    let obj: LogPreviewVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "LogPreviewVC") as! LogPreviewVC
                    obj.mainModelView.trainingLogId = trainingId
                    obj.mainModelView.expandedDate = self.mainModelView.expandedDate
                    let nav = UINavigationController(rootViewController: obj)
                    nav.modalPresentationStyle = .overFullScreen
                    self.present(nav, animated: true, completion: nil)
                }else{ // workout is completed

                    let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CalendarTrainingLogSummaryVc") as! CalendarTrainingLogSummaryVc
                    obj.mainModelView.date = self.mainModelView.expandedDate
                    obj.mainModelView.controllerMoveFrom = .trainingLog
                    obj.mainModelView.isComeFromCalendar = true
                    obj.mainModelView.trainingLogId = trainingId
                    let nav = UINavigationController(rootViewController: obj)
                    nav.modalPresentationStyle = .overFullScreen
                    self.present(nav, animated: true, completion: nil)
                }
                
            }
            else {
                
                //Comment for demo test
                if arr?[tag].isComplete == 0{ // workout is not compelted
                    let obj: LogPreviewResistanceVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "LogPreviewResistanceVC") as! LogPreviewResistanceVC
                    obj.mainModelView.trainingLogId = trainingId
                    obj.mainModelView.expandedDate = self.mainModelView.expandedDate
                    let nav = UINavigationController(rootViewController: obj)
                    nav.modalPresentationStyle = .overFullScreen
                    self.present(nav, animated: true, completion: nil)
                }else{
                    let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CalendarTrainingLogResistanceSummaryVc") as! CalendarTrainingLogResistanceSummaryVc
                    obj.modalPresentationStyle = .overFullScreen
                    obj.mainModelView.date = self.mainModelView.expandedDate
                    obj.mainModelView.trainingLogId = trainingId
                    obj.mainModelView.isComeFromCalendar = true
                    let nav = UINavigationController(rootViewController: obj)
                    nav.modalPresentationStyle = .overFullScreen
                    self.present(nav, animated: true, completion: nil)
                }
            }
        }
        else {
            var is24: Bool = false
            let array42:[String] = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
            
            let arr = self.mainModelView.logList?.trainingProgramList?.filter({ (list) -> Bool in
                let startDate = (list.startDate ?? "").UTCToLocal().convertDateFormater()
                let endDate = (list.endDate ?? "").UTCToLocal().convertDateFormater()
                
                let sdate = startDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
                let edate = endDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
                if self.mainModelView.expandedDate == "" {
                    return false
                }
                
                let dayName = self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd").toString(dateFormat: "EEEE").uppercased()
                var isDayContain = list.days?.contains(where: { (str) -> Bool in
                    return str == dayName
                })
                
                var isBetween = self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd").isBetweeen(date: sdate, andDate: edate)
                if !isBetween {
                    isBetween = self.mainModelView.expandedDate == startDate.toString(dateFormat: "yyyy-MM-dd") || self.mainModelView.expandedDate == endDate.toString(dateFormat: "yyyy-MM-dd")
                }
                
                let title = list.presetTrainingProgram?.title?.lowercased().replace(target: "km", withString: "").toTrim()
                
                if title == "42" {
                    
                    guard let (no, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: array42) else {
                        return false
                    }
                    
                    if weekNo == 24 {
                        is24 = true
                        isBetween = true
                        isDayContain = true
                    }
                }
                
                return isBetween && isDayContain ?? false
            })
            
            let modelData = arr?.first
            
            let sDate = (modelData?.startDate ?? "").UTCToLocal().convertDateFormater()
            let eDate = (modelData?.endDate ?? "").UTCToLocal().convertDateFormater()
            
            var (dayNo, weekNo) = self.getWeekNumber(startDate: sDate, endDate: eDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd", isUTC: false), days: is24 ? array42 : modelData?.days ?? [])
            print("weekDay -> ", dayNo)
            let title = modelData?.presetTrainingProgram?.title?.lowercased().replace(target: "km", withString: "").toTrim()
            if title == "5" {
                let freq = modelData?.trainingFrequency?.code?.lowercased() == "5x".lowercased()
                if weekNo <= 6 && freq &&  modelData?.days?.count == 5 {
                    dayNo = dayNo - 1
                }
            }
            else if title == "10" {
                let freq = modelData?.trainingFrequency?.code?.lowercased() == "6x".lowercased()
                if weekNo <= 6 && freq && modelData?.days?.count == 6 {
                    dayNo = dayNo - 1
                }
            }
            else if title == "21" {
                let freq = modelData?.trainingFrequency?.code?.lowercased() == "6x".lowercased()
                if weekNo <= 6 && freq && modelData?.days?.count == 6 {
                    dayNo = dayNo - 1
                }
            }
            else if title == "42" {
                let freq = modelData?.trainingFrequency?.code?.lowercased() == "6x".lowercased()
                if weekNo <= 6 && freq && modelData?.days?.count == 6 {
                    dayNo = dayNo - 1
                }
            }
            //            let freq = modelData?.trainingFrequency?.code?.lowercased() == "5x".lowercased()
            //            if weekNo <= 6 && freq &&  modelData?.days?.count == 5 {
            //                dayNo = dayNo - 1
            //            }
            print("weekDay Updated-> ", dayNo)
            print("weekNo Updated-> ", weekNo)
            
            print("ModelData:\(modelData?.toJSON())")
            
            //            let selectedDate = self.mainModelView.expandedDate
            //            let currentDate = Date().toString(dateFormat: "yyyy-MM-dd")
            //            if currentDate == selectedDate {
            self.mainModelView.apiCallGetSettingDetails(trainingId:trainingId, weekday: dayNo, weekNumber: weekNo, weekdayWiseMainIDForProgram: weekdayWiseMainIDForProgram, isCompleted: isCompleted)
            //            }
            //            else {
            //                makeToast(strMessage: getCommonString(key: "You_can't_select_this_program_key"))
            //            }
        }
    }
    
    func getTrainingProgramWeekNo(tag: Int, trainingId:String) -> (Int, Int){
        var is24: Bool = false
        let arr = self.mainModelView.logList?.trainingProgramList?.filter({ (list) -> Bool in
            let startDate = (list.startDate ?? "").UTCToLocal().convertDateFormater()
            let endDate = (list.endDate ?? "").UTCToLocal().convertDateFormater()
            
            //            let sdate = startDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
            //            let edate = endDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
            var weekdayTestEnd = Calendar.current.component(.weekday, from: endDate).makeRealWeekDay()
            if weekdayTestEnd == 7 {
                weekdayTestEnd = 0
            }
            let testEndDate = Calendar.current.date(byAdding: .day, value: -(weekdayTestEnd), to: endDate)
            
            
            let weekdayTest = Calendar.current.component(.weekday, from: startDate).makeRealWeekDay()
            let testStartDate = Calendar.current.date(byAdding: .day, value: -(weekdayTest - 1), to: startDate)
            let sdate = testStartDate!.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
            
            if self.mainModelView.expandedDate == "" {
                return false
            }
            
            let dayName = self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd").toString(dateFormat: "EEEE").uppercased()
            var isDayContain = list.days?.contains(where: { (str) -> Bool in
                return str == dayName
            })
            
            var isBetween = self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd").isBetweeen(date: sdate, andDate: testEndDate!)
            if !isBetween {
                isBetween = self.mainModelView.expandedDate == testStartDate!.toString(dateFormat: "yyyy-MM-dd") || self.mainModelView.expandedDate == testEndDate!.toString(dateFormat: "yyyy-MM-dd")
            }
            
            let title = list.presetTrainingProgram?.title?.lowercased().replace(target: "km", withString: "").toTrim()
            
            if title == "42" {
                let array42:[String] = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
                
                guard let (_, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd"), days: array42) else {
                    return false
                }
                
                if weekNo == 24 {
                    is24 = true
                    isBetween = true
                    isDayContain = true
                }
            }
            
            return isBetween && isDayContain ?? false
        })
        
        let modelData = arr?.first
        
        let sDate = (modelData?.startDate ?? "").UTCToLocal().convertDateFormater()
        let weekdayTest = Calendar.current.component(.weekday, from: sDate).makeRealWeekDay()
        let testStartDate = Calendar.current.date(byAdding: .day, value: -(weekdayTest - 1), to: sDate)
        let eDate = (modelData?.endDate ?? "").UTCToLocal().convertDateFormater()
        
        let array42:[String] = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
        
        var (dayNo, weekNo) = self.getWeekNumber(startDate: testStartDate!, endDate: eDate, selectedDate: self.mainModelView.expandedDate.convertDateFormater(format: "yyyy-MM-dd", isUTC: false), days: is24 ? array42 : modelData?.days ?? [])
        print("weekDay -> ", dayNo)
        print("weekNo -> ", weekNo)
        let title = modelData?.presetTrainingProgram?.title?.lowercased().replace(target: "km", withString: "").toTrim()
        if title == "5" {
            let freq = modelData?.trainingFrequency?.code?.lowercased() == "5x".lowercased()
            if weekNo <= 6 && freq &&  modelData?.days?.count == 5 {
                dayNo = dayNo - 1
            }
        }
        else if title == "10" {
            let freq = modelData?.trainingFrequency?.code?.lowercased() == "6x".lowercased()
            if weekNo <= 6 && freq && modelData?.days?.count == 6 {
                dayNo = dayNo - 1
            }
        }
        else if title == "21" {
            let freq = modelData?.trainingFrequency?.code?.lowercased() == "6x".lowercased()
            if weekNo <= 6 && freq && modelData?.days?.count == 6 {
                dayNo = dayNo - 1
            }
        }
        else if title == "42" {
            let freq = modelData?.trainingFrequency?.code?.lowercased() == "6x".lowercased()
            if weekNo <= 6 && freq && modelData?.days?.count == 6 {
                dayNo = dayNo - 1
            }
        }
        
        print("weekDay Updated-> ", dayNo)
        print("weekNo Updated-> ", weekNo)
        
        return (weekNo, dayNo)
    }
    
    func getWeekNumber(startDate:Date, endDate: Date, selectedDate:Date, days: [String]) -> (Int, Int) {
        
        let weekdayTest = Calendar.current.component(.weekday, from: startDate).makeRealWeekDay()
        let testStartDate = Calendar.current.date(byAdding: .day, value: -(weekdayTest - 1), to: startDate)
        
        var weekNumber = 0
        let diffInDays = (Calendar.current.dateComponents([.day], from: testStartDate!, to: selectedDate).day ?? 0) + 1
        let datesBetweenArray = Date.dates(from: testStartDate!, to: selectedDate)
        
        var weekCount = 1
        var dayCount = 0
        
        for index in 0..<diffInDays {
            dayCount += 1
            
            if dayCount == 8 {
                weekCount += 1
                dayCount = 1
            }
            
            if weekNumber == days.count {
                weekNumber = 0
            }
            if datesBetweenArray.count != 0 {
                if datesBetweenArray[index] == selectedDate {
                    let day = selectedDate.toString(dateFormat: "EEEE").uppercased()
                    if days.contains(day) {
                        weekNumber += 1
                    }
                }
                else {
                    let day = datesBetweenArray[index].toString(dateFormat: "EEEE").uppercased()
                    if days.contains(day) {
                        weekNumber += 1
                    }
                }
            }
        }
        return (weekNumber, weekCount)
    }
}

