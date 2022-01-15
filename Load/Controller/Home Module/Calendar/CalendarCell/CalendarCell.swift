//
//  CalendarCell.swift
//  Load
//
//  Created by Haresh Bhai on 30/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol CalendarSelectionProtocol: class {
    func CalendarSelection(section:Int, row: Int, index: Int, date:String, no:Int)
    func CalendarAutoSelection(section:Int, row: Int, index: Int, date:String, no:Int)
}

class CalendarCell: UITableViewCell {
    
    var model: CalendarModelClass?
    
    @IBOutlet weak var lblNO1: UILabel!
    @IBOutlet weak var lblNO2: UILabel!
    @IBOutlet weak var lblNO3: UILabel!
    @IBOutlet weak var lblNO4: UILabel!
    @IBOutlet weak var lblNO5: UILabel!
    @IBOutlet weak var lblNO6: UILabel!
    @IBOutlet weak var lblNO7: UILabel!
    
    @IBOutlet weak var btnNo1: UIButton!
    @IBOutlet weak var btnNo2: UIButton!
    @IBOutlet weak var btnNo3: UIButton!
    @IBOutlet weak var btnNo4: UIButton!
    @IBOutlet weak var btnNo5: UIButton!
    @IBOutlet weak var btnNo6: UIButton!
    @IBOutlet weak var btnNo7: UIButton!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    @IBOutlet weak var view5: UIView!
    @IBOutlet weak var view6: UIView!
    @IBOutlet weak var view7: UIView!
    
    @IBOutlet weak var viewDots1: CustomView!
    @IBOutlet weak var viewDots2: CustomView!
    @IBOutlet weak var viewDots3: CustomView!
    @IBOutlet weak var viewDots4: CustomView!
    @IBOutlet weak var viewDots5: CustomView!
    @IBOutlet weak var viewDots6: CustomView!
    @IBOutlet weak var viewDots7: CustomView!
    
    
    var currentDayIndex = 0
    var isAlreadyRounded = false
    
    weak var delegate: CalendarSelectionProtocol?
    var expandedSection:Int = -1
    var expandedRow:Int = -1
    var trainingProgramList: [TrainingProgramList]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupData(data: CalendarModelClass, trainingLogList: [TrainingLogList]?, trainingProgramList: [TrainingProgramList], section: Int, row:Int, expandedDate:String) {
        self.trainingProgramList = trainingProgramList
        self.expandedSection = section
        self.expandedRow = row
        self.setupFont()
        self.model = data
        
        btnNo1.tag = self.tag * 7
        btnNo2.tag = (self.tag * 7) + 1
        btnNo3.tag = (self.tag * 7) + 2
        btnNo4.tag = (self.tag * 7) + 3
        btnNo5.tag = (self.tag * 7) + 4
        btnNo6.tag = (self.tag * 7) + 5
        btnNo7.tag = (self.tag * 7) + 6
        
        self.lblNO1.text = "\(self.model!.no![self.tag * 7])"
        self.lblNO2.text = "\(self.model!.no![(self.tag * 7) + 1])"
        self.lblNO3.text = "\(self.model!.no![(self.tag * 7) + 2])"
        self.lblNO4.text = "\(self.model!.no![(self.tag * 7) + 3])"
        self.lblNO5.text = "\(self.model!.no![(self.tag * 7) + 4])"
        self.lblNO6.text = "\(self.model!.no![(self.tag * 7) + 5])"
        self.lblNO7.text = "\(self.model!.no![(self.tag * 7) + 6])"
        
        self.makeAutoSelect(expandedDate: expandedDate)
        self.setColor()
        self.makeCircle()
        self.makeSelectedCircleRed()
        self.makeRounded(label: self.lblNO1)
        self.makeRounded(label: self.lblNO2)
        self.makeRounded(label: self.lblNO3)
        self.makeRounded(label: self.lblNO4)
        self.makeRounded(label: self.lblNO5)
        self.makeRounded(label: self.lblNO6)
        self.makeRounded(label: self.lblNO7)
        
        //background Color set to white in all cases
        [self.view1,self.view2,self.view3,self.view4,self.view5,self.view6,self.view7].forEach { (vw) in
            vw?.backgroundColor = .white
        }
        
        //TODO:- This function use for Highlight blue color in Calendar cell
        //currently no need to show color in highlight
        /*
        let isFirstView1 =  self.checkIsFirstOrLast(date: self.model!.date![self.tag * 7])
        let isFirstView2 =  self.checkIsFirstOrLast(date: self.model!.date![(self.tag * 7) + 1])
        let isFirstView3 =  self.checkIsFirstOrLast(date: self.model!.date![(self.tag * 7) + 2])
        let isFirstView4 =  self.checkIsFirstOrLast(date: self.model!.date![(self.tag * 7) + 3])
        let isFirstView5 =  self.checkIsFirstOrLast(date: self.model!.date![(self.tag * 7) + 4])
        let isFirstView6 =  self.checkIsFirstOrLast(date: self.model!.date![(self.tag * 7) + 5])
        let isFirstView7 =  self.checkIsFirstOrLast(date: self.model!.date![(self.tag * 7) + 6])
        
        self.showView(view: self.view1, Value: isViewShow(model: trainingProgramList, btnNo: self.btnNo1), isFirstOrLast: isFirstView1)
        self.showView(view: self.view2, Value: isViewShow(model: trainingProgramList, btnNo: self.btnNo2), isFirstOrLast: isFirstView2)
        self.showView(view: self.view3, Value: isViewShow(model: trainingProgramList, btnNo: self.btnNo3), isFirstOrLast: isFirstView3)
        self.showView(view: self.view4, Value: isViewShow(model: trainingProgramList, btnNo: self.btnNo4), isFirstOrLast: isFirstView4)
        self.showView(view: self.view5, Value: isViewShow(model: trainingProgramList, btnNo: self.btnNo5), isFirstOrLast: isFirstView5)
        self.showView(view: self.view6, Value: isViewShow(model: trainingProgramList, btnNo: self.btnNo6), isFirstOrLast: isFirstView6)
        self.showView(view: self.view7, Value: isViewShow(model: trainingProgramList, btnNo: self.btnNo7), isFirstOrLast: isFirstView7)
         */
        
        self.showLine(view: self.viewDots1, trainingLogList: trainingLogList, trainingProgramList: trainingProgramList, date: self.model!.date![self.tag * 7])
        self.showLine(view: self.viewDots2, trainingLogList: trainingLogList, trainingProgramList: trainingProgramList, date: self.model!.date![(self.tag * 7) + 1])
        self.showLine(view: self.viewDots3, trainingLogList: trainingLogList, trainingProgramList: trainingProgramList, date: self.model!.date![(self.tag * 7) + 2])
        self.showLine(view: self.viewDots4, trainingLogList: trainingLogList, trainingProgramList: trainingProgramList, date: self.model!.date![(self.tag * 7) + 3])
        self.showLine(view: self.viewDots5, trainingLogList: trainingLogList, trainingProgramList: trainingProgramList, date: self.model!.date![(self.tag * 7) + 4])
        self.showLine(view: self.viewDots6, trainingLogList: trainingLogList, trainingProgramList: trainingProgramList, date: self.model!.date![(self.tag *  7) + 5])
        self.showLine(view: self.viewDots7, trainingLogList: trainingLogList, trainingProgramList: trainingProgramList, date: self.model!.date![(self.tag * 7) + 6])
    }
    
    func checkIsFirstOrLast(date:String) -> Int {
        let sdate = date.convertDateFormater(format: "yyyy-MM-dd")
        let weekdayTest = Calendar.current.component(.weekday, from: sdate).makeRealWeekDay()
        if weekdayTest == 1 {
            return 1
        }
        else if weekdayTest == 7 {
            return 2
        }
        return 0 // 0: nil, 1 : first, 2: last
    }
    
    func makeAutoSelect(expandedDate:String) {
        if expandedDate == "" {
            return
        }
        let tag0 = self.btnNo1.tag
        let tag1 = self.btnNo2.tag
        let tag2 = self.btnNo3.tag
        let tag3 = self.btnNo4.tag
        let tag4 = self.btnNo5.tag
        let tag5 = self.btnNo6.tag
        let tag6 = self.btnNo7.tag
        
        if self.model!.date![tag0] == expandedDate {
            let tag = self.btnNo1.tag
            self.delegate?.CalendarAutoSelection(section: self.tag, row: 0, index: tag, date: self.model!.date![tag], no: self.model!.no![tag])
        }
        else if self.model!.date![tag1] == expandedDate {
            let tag = self.btnNo2.tag
            self.delegate?.CalendarAutoSelection(section: self.tag, row: 1, index: tag, date: self.model!.date![tag], no: self.model!.no![tag])
        }
        else if self.model!.date![tag2] == expandedDate {
            let tag = self.btnNo3.tag
            self.delegate?.CalendarAutoSelection(section: self.tag, row: 2, index: tag, date: self.model!.date![tag], no: self.model!.no![tag])
        }
        else if self.model!.date![tag3] == expandedDate {
            let tag = self.btnNo4.tag
            self.delegate?.CalendarAutoSelection(section: self.tag, row: 3, index: tag, date: self.model!.date![tag], no: self.model!.no![tag])
        }
        else if self.model!.date![tag4] == expandedDate {
            let tag = self.btnNo5.tag
            self.delegate?.CalendarAutoSelection(section: self.tag, row: 4, index: tag, date: self.model!.date![tag], no: self.model!.no![tag])
        }
        else if self.model!.date![tag5] == expandedDate {
            let tag = self.btnNo6.tag
            self.delegate?.CalendarAutoSelection(section: self.tag, row: 5, index: tag, date: self.model!.date![tag], no: self.model!.no![tag])
        }
        else if self.model!.date![tag6] == expandedDate {
            let tag = self.btnNo7.tag
            self.delegate?.CalendarAutoSelection(section: self.tag, row: 6, index: tag, date: self.model!.date![tag], no: self.model!.no![tag])
        }
    }
    
    func showLine(view: CustomView, trainingLogList: [TrainingLogList]?, trainingProgramList: [TrainingProgramList]?, date: String) {
        let arr = trainingLogList?.filter({ (list) -> Bool in
            return (list.date?.contains(date))!
        })
        
        if arr?.count != 0 && arr != nil {
            view.isHidden = false
        }
        else {
            //            view.isHidden = true
            self.showLineProgram(view: view, trainingProgramList: trainingProgramList, date: date)
        }
    }
    
    func showLineProgram(view: CustomView, trainingProgramList: [TrainingProgramList]?, date: String) {
        
        let arr1 = trainingProgramList?.filter({ (list) -> Bool in
            let startDate = (list.startDate ?? "").UTCToLocal().convertDateFormater()
            let endDate = (list.endDate ?? "").UTCToLocal().convertDateFormater()
            
            let sdate = startDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
            let edate = endDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
            
            var weekdayTest = Calendar.current.component(.weekday, from: edate).makeRealWeekDay()
            if weekdayTest == 7 {
                weekdayTest = 0
            }
            let testEndDate = Calendar.current.date(byAdding: .day, value: -(weekdayTest), to: edate)
            
            if date == "" {
                return false
            }
            let dayName = date.convertDateFormater(format: "yyyy-MM-dd").toString(dateFormat: "EEEE").uppercased()
            var isDayContain = list.days?.contains(where: { (str) -> Bool in
                return str == dayName
            })
            var isBetween = date.convertDateFormater(format: "yyyy-MM-dd").isBetweeen(date: sdate, andDate: testEndDate!) && isDayContain ?? false
            if !isBetween {
                isBetween = date == startDate.toString(dateFormat: "yyyy-MM-dd") || date == testEndDate!.toString(dateFormat: "yyyy-MM-dd")
            }
            
            var isShowFirst:Bool = true
            var isShowLast:Bool = true
            let title = list.presetTrainingProgram?.title?.lowercased().replace(target: "km", withString: "").toTrim()

            var isBetween42 = date.convertDateFormater(format: "yyyy-MM-dd").isBetweeen(date: sdate, andDate: testEndDate!)
            
            if !isBetween42 {
                isBetween42 = date == startDate.toString(dateFormat: "yyyy-MM-dd") || date == testEndDate!.toString(dateFormat: "yyyy-MM-dd")
            }
            var is24:Bool = false
            if isBetween42 {
                if title == "42" {
                    let array42:[String] = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]

                    let (_, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: date.convertDateFormater(format: "yyyy-MM-dd"), days: array42)
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
                    let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: date.convertDateFormater(format: "yyyy-MM-dd"), days: list.days ?? [])
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
                    let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: date.convertDateFormater(format: "yyyy-MM-dd"), days: list.days ?? [])
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
                    let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: date.convertDateFormater(format: "yyyy-MM-dd"), days: list.days ?? [])
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
                    let (dayNo, weekNo) = getWeek(startDate: startDate, endDate: endDate, selectedDate: date.convertDateFormater(format: "yyyy-MM-dd"), days: is24 ? array42 : list.days ?? [])
                    if dayNo == 1 && weekNo <= 6 && freq && list.days?.count == 6 {
                        isShowFirst = false
                    }
                    
                    if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 4 && (weekNo == 10 || weekNo == 16 || weekNo == 21 || weekNo == 22 || weekNo == 23) && (list.days?.count ?? 0) > 4 {
                        isShowLast = false
                    }
                    
                    if list.trainingFrequency?.code?.lowercased() == "6x" && dayNo > 5 && (weekNo ==  10 || weekNo == 16 || weekNo == 21 || weekNo == 22 || weekNo == 23) && (list.days?.count ?? 0) > 5 {
                        isShowLast = false
                    }
                    
//                    if list.trainingFrequency?.code?.lowercased() == "5x" && dayNo > 5 && weekNo >= 24  && (list.days?.count ?? 0) > 5 {
//                        isShowLast = false
//                    }
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
            return isBetween && isShowFirst && isShowLast && (isDayContain ?? false)
        })
        
        if arr1?.count != 0 && arr1 != nil {
            view.isHidden = false
        }
        else {
            view.isHidden = true
        }
    }
    
    func showView(view: UIView, Value:Int, isFirstOrLast:Int) {
        if Value == 0 {
            self.removeRoundView(view: view)
        }
        else if Value == 1 {
            self.roundLeftView(view: view)
        }
        else if Value == 2 {
            self.roundRightView(view: view)
        }
        else if Value == 3 {
            if isFirstOrLast == 0 {
                self.centerRoundView(view: view)
            }
            else if isFirstOrLast == 1 {
                self.roundLeftView(view: view)
            }
            else if isFirstOrLast == 2 {
                self.roundRightView(view: view)
            }
            else {
                self.centerRoundView(view: view)
            }
        }
        else if Value == 4 {
            self.roundLeftRightView(view: view)
        }
    }
    
    func isContains(date: Date, dateArray: [TrainingProgramList]) -> Bool {
        let isContainsDate = dateArray.contains(where: { (modelData) -> Bool in
            let startDate = modelData.startDate?.convertDateFormater()
            let endDate = modelData.endDate?.convertDateFormater()
            
            let nowDate = date.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
            let sdate = startDate?.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
            let edate = endDate?.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
            return nowDate.isBetweeen(date: sdate!, andDate: edate!)
        })
        return isContainsDate
    }
    
    func isViewShow(model: [TrainingProgramList], btnNo: UIButton) -> Int {
        var value:Int = 0 // 0:Empty, 1:Left , 2:Right, 3:Center
        
        let now = self.model!.date![btnNo.tag].convertDateFormater(format: "yyyy-MM-dd")
        let nowDate = now.toString(dateFormat: "yyyy-MM-dd")
        
        var matchAraryStart: [String] = []
        var matchAraryEnd: [String] = []
        
        let dateArray = model.filter { (modelData) -> Bool in
            let sDate = (modelData.startDate ?? "").UTCToLocal().convertDateFormater()
            let startDate = sDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
            let eDate = (modelData.endDate ?? "").UTCToLocal().convertDateFormater()
            let endDate = eDate.toString(dateFormat: "yyyy-MM-dd").convertDateFormater(format: "yyyy-MM-dd")
            
            var weekdayTest = Calendar.current.component(.weekday, from: endDate).makeRealWeekDay()
            if weekdayTest == 7 {
                weekdayTest = 0
            }
            let testEndDate = Calendar.current.date(byAdding: .day, value: -(weekdayTest), to: endDate)
            matchAraryStart.append((sDate.toString(dateFormat: "yyyy-MM-dd")))
            matchAraryEnd.append((testEndDate!.toString(dateFormat: "yyyy-MM-dd")))
            return now.isBetweeen(date: startDate, andDate: testEndDate!)
        }
        
        let isStartContaints = matchAraryStart.contains { (str) -> Bool in
            return str == nowDate
        }
        
        let isEndContaints = matchAraryEnd.contains { (str) -> Bool in
            return str == nowDate
        }
        
        if isStartContaints && isEndContaints {
            value = 3
        }
        else if dateArray.count != 0 {
            
            let firstDate = dateArray.filter { (modelData) -> Bool in
                let startDate = (modelData.startDate ?? "").UTCToLocal().convertDateFormater()
                let sdate = startDate.toString(dateFormat: "yyyy-MM-dd")
                let isContains = self.isContains(date: startDate, dateArray: model)
                return nowDate == sdate && !isContains
            }
            
            let endDate = dateArray.filter { (modelData) -> Bool in
                let endDate = (modelData.endDate ?? "").UTCToLocal().convertDateFormater()
                var weekdayTest = Calendar.current.component(.weekday, from: endDate).makeRealWeekDay()
                if weekdayTest == 7 {
                    weekdayTest = 0
                }
                let testEndDate = Calendar.current.date(byAdding: .day, value: -(weekdayTest), to: endDate)
                let edate = testEndDate!.toString(dateFormat: "yyyy-MM-dd")
                let isContains = self.isContains(date: testEndDate!, dateArray: model)
                return nowDate == edate && !isContains
            }
            
            if firstDate.count != 0 {
                value = 1
            }
            else if endDate.count != 0 {
                value = 2
            }
            else {
                value = 3
            }
        }
        else {
            let firstDate = model.filter { (modelData) -> Bool in
                let startDate = (modelData.startDate ?? "").UTCToLocal().convertDateFormater()
                let sdate = startDate.toString(dateFormat: "yyyy-MM-dd")
                return nowDate == sdate
            }
            
            let endDate = model.filter { (modelData) -> Bool in
                let endDate = (modelData.endDate ?? "").UTCToLocal().convertDateFormater()
                var weekdayTest = Calendar.current.component(.weekday, from: endDate).makeRealWeekDay()
                if weekdayTest == 7 {
                    weekdayTest = 0
                }
                let testEndDate = Calendar.current.date(byAdding: .day, value: -(weekdayTest), to: endDate)
                let edate = testEndDate!.toString(dateFormat: "yyyy-MM-dd")
                return nowDate == edate
            }
            
            if firstDate.count != 0 {
                value = 1
            }
            else if endDate.count != 0 {
                value = 2
            }
        }
        return value
    }
    
    func roundLeftView(view: UIView) {
        view.roundCorners(corners: [.bottomLeft, .topLeft], radius: view.bounds.height)
        view.backgroundColor = UIColor.appthemeBlueAlphaColor
    }
    
    func roundRightView(view: UIView) {
        view.roundCorners(corners: [.bottomRight, .topRight], radius: view.bounds.height)
        view.backgroundColor = UIColor.appthemeBlueAlphaColor
    }
    
    func removeRoundView(view: UIView) {
        view.roundCorners(corners: [], radius: 0)
        view.backgroundColor = UIColor.clear
    }
    
    func centerRoundView(view: UIView) {
        view.roundCorners(corners: [], radius: 0)
        view.backgroundColor = UIColor.appthemeBlueAlphaColor
    }
    
    func roundLeftRightView(view: UIView) {
        view.roundCorners(corners: [.bottomRight, .topRight, .bottomLeft, .topLeft], radius: view.bounds.height)
        view.backgroundColor = UIColor.appthemeBlueAlphaColor
    }
    
    func makeCircleLabel(label: UILabel) {
        label.layer.borderColor = UIColor.appthemeRedColor.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.height / 2
        label.backgroundColor = UIColor.white
        
        self.isAlreadyRounded = true
        self.currentDayIndex = self.tag
        
    }
    
    func makeSelectedCircleRed() {
        if self.tag == self.expandedSection {
            if expandedRow == 0 {
                self.makeCircleColor(label: self.lblNO1)
            }
            else if expandedRow == 1 {
                self.makeCircleColor(label: self.lblNO2)
            }
            else if expandedRow == 2 {
                self.makeCircleColor(label: self.lblNO3)
            }
            else if expandedRow == 3 {
                self.makeCircleColor(label: self.lblNO4)
            }
            else if expandedRow == 4 {
                self.makeCircleColor(label: self.lblNO5)
            }
            else if expandedRow == 5 {
                self.makeCircleColor(label: self.lblNO6)
            }
            else if expandedRow == 6 {
                self.makeCircleColor(label: self.lblNO7)
            }
        }
        else {
            self.removeCircleColor(label: self.lblNO1)
            self.removeCircleColor(label: self.lblNO2)
            self.removeCircleColor(label: self.lblNO3)
            self.removeCircleColor(label: self.lblNO4)
            self.removeCircleColor(label: self.lblNO5)
            self.removeCircleColor(label: self.lblNO6)
            self.removeCircleColor(label: self.lblNO7)
            self.makeCircle()
        }
    }
    
    func setupFont() {
        self.lblNO1.font = themeFont(size: 16, fontname: .Regular)
        self.lblNO2.font = themeFont(size: 16, fontname: .Regular)
        self.lblNO3.font = themeFont(size: 16, fontname: .Regular)
        self.lblNO4.font = themeFont(size: 16, fontname: .Regular)
        self.lblNO5.font = themeFont(size: 16, fontname: .Regular)
        self.lblNO6.font = themeFont(size: 16, fontname: .Regular)
        self.lblNO7.font = themeFont(size: 16, fontname: .Regular)
        
        self.lblNO1.setColor(color: .appthemeBlackTabColor)
        self.lblNO2.setColor(color: .appthemeBlackTabColor)
        self.lblNO3.setColor(color: .appthemeBlackTabColor)
        self.lblNO4.setColor(color: .appthemeBlackTabColor)
        self.lblNO5.setColor(color: .appthemeBlackTabColor)
        self.lblNO6.setColor(color: .appthemeBlackTabColor)
        self.lblNO7.setColor(color: .appthemeBlackTabColor)
    }
    
    func makeRounded(label: UILabel) {
        label.layer.cornerRadius = label.bounds.width / 2
        label.clipsToBounds = true
    }
    
    func makeCircle() {
        let date = Date().toString(dateFormat: "yyyy-MM-dd")
        self.lblNO1.backgroundColor = .clear
        self.lblNO2.backgroundColor = .clear
        self.lblNO3.backgroundColor = .clear
        self.lblNO4.backgroundColor = .clear
        self.lblNO5.backgroundColor = .clear
        self.lblNO6.backgroundColor = .clear
        self.lblNO7.backgroundColor = .clear
        
        self.lblNO1.layer.borderColor = UIColor.clear.cgColor
        self.lblNO2.layer.borderColor = UIColor.clear.cgColor
        self.lblNO3.layer.borderColor = UIColor.clear.cgColor
        self.lblNO4.layer.borderColor = UIColor.clear.cgColor
        self.lblNO5.layer.borderColor = UIColor.clear.cgColor
        self.lblNO6.layer.borderColor = UIColor.clear.cgColor
        self.lblNO7.layer.borderColor = UIColor.clear.cgColor
        
        if date == "\(self.model!.date![self.tag * 7])" {
            self.makeCircleLabel(label: self.lblNO1)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 1])" {
            self.makeCircleLabel(label: self.lblNO2)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 2])" {
            self.makeCircleLabel(label: self.lblNO3)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 3])" {
            self.makeCircleLabel(label: self.lblNO4)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 4])" {
            self.makeCircleLabel(label: self.lblNO5)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 5])" {
            self.makeCircleLabel(label: self.lblNO6)
        }
        
        if date == "\(self.model!.date![(self.tag * 7) + 6])" {
            self.makeCircleLabel(label: self.lblNO7)
        }
    }
    
    func setColor() {
        self.makeTextBlack()
        self.lblNO1.alpha = 1
        self.lblNO2.alpha = 1
        self.lblNO3.alpha = 1
        self.lblNO4.alpha = 1
        self.lblNO5.alpha = 1
        self.lblNO6.alpha = 1
        self.lblNO7.alpha = 1
        
        self.btnNo1.isUserInteractionEnabled = true
        self.btnNo2.isUserInteractionEnabled = true
        self.btnNo3.isUserInteractionEnabled = true
        self.btnNo4.isUserInteractionEnabled = true
        self.btnNo5.isUserInteractionEnabled = true
        self.btnNo6.isUserInteractionEnabled = true
        self.btnNo7.isUserInteractionEnabled = true
        
        if self.tag == 0 || self.tag == 4 || self.tag == 5 {
            if self.tag == 0 {
                if Int(self.lblNO1.text!)! >= 15 {
                    //self.lblNO1.textColor = .gray
                    self.lblNO1.alpha = 0.15
                    self.btnNo1.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO2.text!)! >= 15 {
                    //                    self.lblNO2.textColor = .gray
                    self.lblNO2.alpha = 0.15
                    self.btnNo2.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO3.text!)! >= 15 {
                    //                    self.lblNO3.textColor = .gray
                    self.lblNO3.alpha = 0.15
                    self.btnNo3.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO4.text!)! >= 15 {
                    //                    self.lblNO4.textColor = .gray
                    self.lblNO4.alpha = 0.15
                    self.btnNo4.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO5.text!)! >= 15 {
                    //                    self.lblNO5.textColor = .gray
                    self.lblNO5.alpha = 0.15
                    self.btnNo5.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO6.text!)! >= 15 {
                    //                    self.lblNO6.textColor = .gray
                    self.lblNO6.alpha = 0.15
                    self.btnNo6.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO7.text!)! >= 15 {
                    //                    self.lblNO7.textColor = .gray
                    self.lblNO7.alpha = 0.15
                    self.btnNo7.isUserInteractionEnabled = false
                }
            }
            else {
                if Int(self.lblNO1.text!)! <= 15 {
                    //                    self.lblNO1.textColor = .gray
                    self.lblNO1.alpha = 0.15
                    self.btnNo1.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO2.text!)! <= 15 {
                    //                    self.lblNO2.textColor = .gray
                    self.lblNO2.alpha = 0.15
                    self.btnNo2.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO3.text!)! <= 15 {
                    //                    self.lblNO3.textColor = .gray
                    self.lblNO3.alpha = 0.15
                    self.btnNo3.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO4.text!)! <= 15 {
                    //                    self.lblNO4.textColor = .gray
                    self.lblNO4.alpha = 0.15
                    self.btnNo4.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO5.text!)! <= 15 {
                    //                    self.lblNO5.textColor = .gray
                    self.lblNO5.alpha = 0.15
                    self.btnNo5.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO6.text!)! <= 15 {
                    //                    self.lblNO6.textColor = .gray
                    self.lblNO6.alpha = 0.15
                    self.btnNo6.isUserInteractionEnabled = false
                }
                
                if Int(self.lblNO7.text!)! <= 15 {
                    //                    self.lblNO7.textColor = .gray
                    self.lblNO7.alpha = 0.15
                    self.btnNo7.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    func makeCircleColor(label: UILabel) {
        label.backgroundColor = UIColor.appthemeRedColor
        label.textColor = .white
    }
    
    
    func removeCircleColor(label: UILabel) {
        label.backgroundColor = UIColor.clear
        label.textColor = .black
        self.setColor()
    }
    
    func makeTextBlack() {
        self.lblNO1.textColor = .black
        self.lblNO2.textColor = .black
        self.lblNO3.textColor = .black
        self.lblNO4.textColor = .black
        self.lblNO5.textColor = .black
        self.lblNO6.textColor = .black
        self.lblNO7.textColor = .black
    }
    
    @IBAction func btnNo1Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 0, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo2Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 1, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo3Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 2, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo4Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 3, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo5Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 4, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo6Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 5, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    @IBAction func btnNo7Clicked(_ sender: UIButton) {
        self.delegate?.CalendarSelection(section: self.tag, row: 6, index: sender.tag, date: self.model!.date![sender.tag], no: self.model!.no![sender.tag])
    }
    
    
    //TODO: - Yash changes
    
    func removeSelectedDate(){
        self.removeCircleColor(label: self.lblNO1)
        self.removeCircleColor(label: self.lblNO2)
        self.removeCircleColor(label: self.lblNO3)
        self.removeCircleColor(label: self.lblNO4)
        self.removeCircleColor(label: self.lblNO5)
        self.removeCircleColor(label: self.lblNO6)
        self.removeCircleColor(label: self.lblNO7)
        
    }
    
    func makeCircle(ofIndex:Int) {
        let date = Date().toString(dateFormat: "yyyy-MM-dd")
        
        if date == "\(self.model?.date?[ofIndex * 7])" {
            if !isAlreadyRounded{
                self.makeCircleLabel(label: self.lblNO1)
            }else{
                self.lblNO1.backgroundColor = UIColor.white
            }
        }
        
        if date == "\(self.model?.date?[(ofIndex * 7) + 1])" {
            if !isAlreadyRounded{
                self.makeCircleLabel(label: self.lblNO2)
            }else{
                self.lblNO2.backgroundColor = UIColor.white
            }
            
        }
        
        if date == "\(self.model?.date?[(ofIndex * 7) + 2])" {
            if !isAlreadyRounded{
                self.makeCircleLabel(label: self.lblNO3)
            }else{
                self.lblNO3.backgroundColor = UIColor.white
            }
            
        }
        
        if date == "\(self.model?.date?[(ofIndex * 7) + 3])" {
            if !isAlreadyRounded{
                self.makeCircleLabel(label: self.lblNO4)
            }else{
                self.lblNO4.backgroundColor = UIColor.white
            }
            
        }
        
        if date == "\(self.model?.date?[(ofIndex * 7) + 4])" {
            
            if !isAlreadyRounded{
                self.makeCircleLabel(label: self.lblNO5)
            }else{
                self.lblNO5.backgroundColor = UIColor.white
            }
        }
        
        if date == "\(self.model?.date?[(ofIndex * 7) + 5])" {
            if !isAlreadyRounded{
                self.makeCircleLabel(label: self.lblNO6)
            }else{
                self.lblNO6.backgroundColor = UIColor.white
            }
        }
         
        if date == "\(self.model?.date?[(ofIndex * 7) + 6])" {
            if !isAlreadyRounded{
                self.makeCircleLabel(label: self.lblNO7)
            }else{
                self.lblNO7.backgroundColor = UIColor.white
            }
        }
    }
    
}

//MARK:- Design change for Settings -> Professional -> Select Availability
extension CalendarCell {
    
    func setupDataForAvailability(data: CalendarModelClass, selectionName: String, selectedCustomDayName: [String]) {
        self.setupFontForAvailability()
        self.model = data
        
        btnNo1.tag = self.tag * 7
        btnNo2.tag = (self.tag * 7) + 1
        btnNo3.tag = (self.tag * 7) + 2
        btnNo4.tag = (self.tag * 7) + 3
        btnNo5.tag = (self.tag * 7) + 4
        btnNo6.tag = (self.tag * 7) + 5
        btnNo7.tag = (self.tag * 7) + 6
        
        self.lblNO1.text = "\(self.model!.no![self.tag * 7])"
        self.lblNO2.text = "\(self.model!.no![(self.tag * 7) + 1])"
        self.lblNO3.text = "\(self.model!.no![(self.tag * 7) + 2])"
        self.lblNO4.text = "\(self.model!.no![(self.tag * 7) + 3])"
        self.lblNO5.text = "\(self.model!.no![(self.tag * 7) + 4])"
        self.lblNO6.text = "\(self.model!.no![(self.tag * 7) + 5])"
        self.lblNO7.text = "\(self.model!.no![(self.tag * 7) + 6])"
        
        self.setColorAccordingToName(selectionName: selectionName, selectedCustomDayName: selectedCustomDayName)
        self.makeRounded(label: self.lblNO1)
        self.makeRounded(label: self.lblNO2)
        self.makeRounded(label: self.lblNO3)
        self.makeRounded(label: self.lblNO4)
        self.makeRounded(label: self.lblNO5)
        self.makeRounded(label: self.lblNO6)
        self.makeRounded(label: self.lblNO7)
        
        //background Color set to white in all cases
        [self.view1,self.view2,self.view3,self.view4,self.view5,self.view6,self.view7].forEach { (vw) in
            vw?.backgroundColor = .white
        }
    }
    
    func setupFontForAvailability() {
        self.lblNO1.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO2.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO3.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO4.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO5.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO6.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        self.lblNO7.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        self.lblNO1.setColor(color: .appthemeBlackTabColor)
        self.lblNO2.setColor(color: .appthemeBlackTabColor)
        self.lblNO3.setColor(color: .appthemeBlackTabColor)
        self.lblNO4.setColor(color: .appthemeBlackTabColor)
        self.lblNO5.setColor(color: .appthemeBlackTabColor)
        self.lblNO6.setColor(color: .appthemeBlackTabColor)
        self.lblNO7.setColor(color: .appthemeBlackTabColor)
    }

    func setColorAccordingToName(selectionName: String, selectedCustomDayName: [String]) {
        self.makeTextBlack()
        self.lblNO1.alpha = 1
        self.lblNO2.alpha = 1
        self.lblNO3.alpha = 1
        self.lblNO4.alpha = 1
        self.lblNO5.alpha = 1
        self.lblNO6.alpha = 1
        self.lblNO7.alpha = 1
        
        self.btnNo1.isUserInteractionEnabled = true
        self.btnNo2.isUserInteractionEnabled = true
        self.btnNo3.isUserInteractionEnabled = true
        self.btnNo4.isUserInteractionEnabled = true
        self.btnNo5.isUserInteractionEnabled = true
        self.btnNo6.isUserInteractionEnabled = true
        self.btnNo7.isUserInteractionEnabled = true
        
        if selectionName.lowercased() == "" || selectionName.lowercased() == "Message to discuss".lowercased() {
            self.setColor()
        }else if selectionName.lowercased() == "Everyday".lowercased() {
            self.lblNO1.alpha = 1
            self.lblNO2.alpha = 1
            self.lblNO3.alpha = 1
            self.lblNO4.alpha = 1
            self.lblNO5.alpha = 1
            self.lblNO6.alpha = 1
            self.lblNO7.alpha = 1
        }else if selectionName.lowercased() == "Weekdays only".lowercased() {
            self.lblNO1.alpha = 1
            self.lblNO2.alpha = 1
            self.lblNO3.alpha = 1
            self.lblNO4.alpha = 1
            self.lblNO5.alpha = 1
            self.lblNO6.alpha = 0.15
            self.lblNO7.alpha = 0.15
        } else if selectionName.lowercased() == "Weekends only".lowercased() {
            self.lblNO1.alpha = 0.15
            self.lblNO2.alpha = 0.15
            self.lblNO3.alpha = 0.15
            self.lblNO4.alpha = 0.15
            self.lblNO5.alpha = 0.15
            self.lblNO6.alpha = 1
            self.lblNO7.alpha = 1
        } else if selectionName.lowercased() == "Custom".lowercased() {
            
            if selectedCustomDayName.contains("Monday".lowercased()) {
                self.lblNO1.alpha = 1

            } else {
                self.lblNO1.alpha = 0.15
            }
            
            if selectedCustomDayName.contains("Tuesday".lowercased()) {
                self.lblNO2.alpha = 1

            } else {
                self.lblNO2.alpha = 0.15
            }
            
            if selectedCustomDayName.contains("Wednesday".lowercased()) {
                self.lblNO3.alpha = 1

            } else {
                self.lblNO3.alpha = 0.15
            }
            
            if selectedCustomDayName.contains("Thursday".lowercased()) {
                self.lblNO4.alpha = 1

            } else {
                self.lblNO4.alpha = 0.15
            }
            
            if selectedCustomDayName.contains("Friday".lowercased()) {
                self.lblNO5.alpha = 1

            } else {
                self.lblNO5.alpha = 0.15
            }
            
            if selectedCustomDayName.contains("Saturday".lowercased()) {
                self.lblNO6.alpha = 1
                
            } else {
                self.lblNO6.alpha = 0.15
            }
            
            if selectedCustomDayName.contains("Sunday".lowercased()) {
                self.lblNO7.alpha = 1
                
            } else {
                self.lblNO7.alpha = 0.15
            }
        }
    }

}
