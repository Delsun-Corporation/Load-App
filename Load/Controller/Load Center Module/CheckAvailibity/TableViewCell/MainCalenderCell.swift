//
//  MainCalenderCell.swift
//  Load
//
//  Created by Haresh Bhai on 23/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol ReloadCalendarViewDelegate: class {
    func ReloadCalendarViewDidFinish(tableView: UITableView, height: CGFloat, isExpanded:Bool, sectionMain:Int, section: Int, row: Int, date: String)
    func SelectedCalendarViewDidFinish(time: String, timeId:String)
}

class MainCalenderCell: UITableViewCell, CheckAvailibilityTimeDelegate {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblMonthName: UILabel!
    @IBOutlet weak var tableView: UITableView!    
    
    @IBOutlet weak var lblMon: UILabel!
    @IBOutlet weak var lblTue: UILabel!
    @IBOutlet weak var lblWed: UILabel!
    @IBOutlet weak var lblThu: UILabel!
    @IBOutlet weak var lblFri: UILabel!
    @IBOutlet weak var lblDat: UILabel!
    @IBOutlet weak var lblSun: UILabel!

    //MARK:- Varibales
    var calendarArray: CalendarModelClass?
    var currentShowMonth = Date()
    var expandedMainSection:Int = -1
    var isExpanded:Bool = false
    var expandedSection:Int = -1
    var expandedRow:Int = -1
    var expandedIndex:Int = 0
    var expandedDate:String = ""
    var arrayCount:Int = 0
    var clientBookedDatesArray: ClientBookedDatesModelClass?
    var selectedRow:Int?
    weak var delegate: ReloadCalendarViewDelegate?
    
    //MARK:- Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setupData() {
        self.setupFont()
        self.layoutSubviews()
        self.layoutIfNeeded()
        self.contentView.layoutIfNeeded()
        self.tableView.layoutIfNeeded()
        self.tableView.isScrollEnabled = false
        self.currentShowMonth = Calendar.current.date(byAdding: .month, value: self.tag, to: Date())!
        self.tableView.register(UINib(nibName: "CheckAvailibilityCalendarCell", bundle: nil), forCellReuseIdentifier: "CheckAvailibilityCalendarCell")
        self.tableView.register(UINib(nibName: "CheckAvailibilityTimeCell", bundle: nil), forCellReuseIdentifier: "CheckAvailibilityTimeCell")
        self.tableView.register(UINib(nibName: "TrainingListFooterCell", bundle: nil), forCellReuseIdentifier: "TrainingListFooterCell")
        self.tableView.register(UINib(nibName: "CheckAvailibilityHeaderCell", bundle: nil), forCellReuseIdentifier: "CheckAvailibilityHeaderCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.lblMonthName.text = self.currentShowMonth.toString(dateFormat: "MMMM yyyy").uppercased()
        
        let data = self.makeDateArray(date: currentShowMonth, position: currentShowMonth.startOfMonth().position(), PreviousCount: currentShowMonth.getPreviousMonth()!.count(), currentCount: currentShowMonth.startOfMonth().count())
        calendarArray = CalendarModelClass(JSON: JSON(data).dictionaryObject!)
        self.tableView.reloadData()
    }
    
    func setupFont() {
        self.lblMonthName.font = themeFont(size: 18, fontname: .ProximaNovaRegular)
        self.lblMon.font = themeFont(size: 9, fontname: .ProximaNovaRegular)
        self.lblTue.font = themeFont(size: 9, fontname: .ProximaNovaRegular)
        self.lblWed.font = themeFont(size: 9, fontname: .ProximaNovaRegular)
        self.lblThu.font = themeFont(size: 9, fontname: .ProximaNovaRegular)
        self.lblFri.font = themeFont(size: 9, fontname: .ProximaNovaRegular)
        self.lblDat.font = themeFont(size: 9, fontname: .ProximaNovaRegular)
        self.lblSun.font = themeFont(size: 9, fontname: .ProximaNovaRegular)

        self.lblMonthName.setColor(color: .appthemeBlackColor)
        self.lblMon.setColor(color: .appthemeBlackColor)
        self.lblTue.setColor(color: .appthemeBlackColor)
        self.lblWed.setColor(color: .appthemeBlackColor)
        self.lblThu.setColor(color: .appthemeBlackColor)
        self.lblFri.setColor(color: .appthemeBlackColor)
        self.lblDat.setColor(color: .appthemeRedColor)
        self.lblSun.setColor(color: .appthemeRedColor)
    }
    
    func makeDateArray(date: Date, position:Int, PreviousCount: Int, currentCount:Int) -> NSDictionary {
        
        var arrayDate:[String] = []
        var arrayNo:[Int] = []
        print(PreviousCount)
        print(position)
        print(position - 2)

        if position != 1 {
            for i in (PreviousCount - (position - 2))...PreviousCount {
                arrayNo.append(i)
                let day = i > 9 ? "\(i)" : "0\(i)"
                arrayDate.append((date.getPreviousMonth()?.year)! + "-" + (date.getPreviousMonth()?.month)! + "-" + day)
            }
        }
        
        for i in 1...currentCount {
            arrayNo.append(i)
            let day = i > 9 ? "\(i)" : "0\(i)"
            arrayDate.append((date.year) + "-" + (date.month) + "-" + day)
        }
        
        if arrayNo.count < 42 {
            for i in 1...(42 - arrayNo.count) {
                arrayNo.append(i)
                let day = i > 9 ? "\(i)" : "0\(i)"
                arrayDate.append((date.getNextMonth()?.year)! + "-" + (date.getNextMonth()?.month)! + "-" + day)
            }
        }
        return ["no":arrayNo,"date":arrayDate]
    }
}

extension MainCalenderCell: UITableViewDelegate, UITableViewDataSource, CalendarSelectionProtocol {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.calendarArray == nil ? 0 : 6 // 6 : Calendar
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isExpanded && expandedMainSection == self.tag ? ((section == self.expandedSection && GetAllData?.data?.availableTimes?.count != 0 ? ((GetAllData?.data?.availableTimes?.count ?? 0) + 2) : 1)) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: CheckAvailibilityCalendarCell = self.tableView.dequeueReusableCell(withIdentifier: "CheckAvailibilityCalendarCell") as! CheckAvailibilityCalendarCell
            cell.tag = indexPath.section
            cell.selectionStyle = .none
            cell.delegate = self
            cell.clientBookedDatesArray = self.clientBookedDatesArray
            cell.setupData(data: self.calendarArray!, section: self.expandedSection, row: self.expandedRow)
            return cell
        }
        else if indexPath.row == 1 {
            let cell: CheckAvailibilityHeaderCell = self.tableView.dequeueReusableCell(withIdentifier: "CheckAvailibilityHeaderCell") as! CheckAvailibilityHeaderCell
            cell.selectionStyle = .none
            cell.setImage(index: self.expandedIndex)
            return cell
        }
        else {
            
            if (indexPath.row - 2) == GetAllData?.data?.availableTimes?.count  {
                let cell: TrainingListFooterCell = self.tableView.dequeueReusableCell(withIdentifier: "TrainingListFooterCell") as! TrainingListFooterCell
                return cell
            }
            else {
                let cell: CheckAvailibilityTimeCell = self.tableView.dequeueReusableCell(withIdentifier: "CheckAvailibilityTimeCell") as! CheckAvailibilityTimeCell
                cell.selectionStyle = .none
                cell.tag = indexPath.row - 2
                cell.section = indexPath.section
                cell.delegate = self
                cell.clientBookedDatesArray = self.clientBookedDatesArray
                cell.setupUI(index: indexPath.row - 2, date: self.expandedDate)
                if selectedRow == nil {
                    cell.showColor(index: -1)
                }
                else {
                    cell.showColor(index: self.selectedRow!)
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.layoutIfNeeded()
    }
    
    func CalendarSelection(section: Int, row: Int, index:Int, date: String, no: Int) {
        self.selectedRow = -1
        if self.expandedSection == section && self.expandedRow == row {
            self.isExpanded = false
            self.expandedDate = ""
            self.expandedSection = -1
            self.expandedRow = -1
        }
        else {
            self.isExpanded = true
            self.expandedDate = date
            self.expandedSection = section
            self.expandedRow = row
            self.expandedIndex = row
        }
        self.tableView.reloadData {
            self.delegate?.ReloadCalendarViewDidFinish(tableView: self.tableView, height: self.tableView.contentSize.height, isExpanded: self.isExpanded, sectionMain: self.tag, section: self.expandedSection, row: self.expandedRow, date: self.expandedDate)
        }
    }
    
    func CalendarAutoSelection(section: Int, row: Int, index: Int, date: String, no: Int) {
        
    }
    
    func CheckAvailibilityTimeDidFinish(row: Int, section: Int) {
        self.delegate?.SelectedCalendarViewDidFinish(time: GetAllData?.data?.availableTimes?[row].name ?? "", timeId: GetAllData?.data?.availableTimes?[row].id?.stringValue ?? "")
        self.selectedRow = row
        self.tableView.reloadSections([section], with: .none)
    }
}

