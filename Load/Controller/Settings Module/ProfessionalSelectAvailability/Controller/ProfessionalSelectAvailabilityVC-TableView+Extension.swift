//
//  ProfessionalSelectAvailabilityVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 04/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension ProfessionalSelectAvailabilityVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == self.mainView.tblCalendar {
            return self.mainModelView.calendarArray == nil ? 0 : 6 // 6 : Calendar
        } else {
            return self.mainModelView.arrayMain.count
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.mainView.tblCalendar {
            return 40
        }
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == self.mainView.tblCalendar {
            return 40
        }
        else {
            if self.mainModelView.arrayMain[indexPath.section]["selected"].boolValue == true {
                
                
                if indexPath.section == 2 { // Weekends only
                    return 63
                } else if indexPath.section == 3 {
                    return 0
                }
                else if indexPath.section == 4 { // custom
                    
                    if self.mainModelView.arrayMain[indexPath.section]["data"][indexPath.row]["selected_day"].boolValue == true {
                        return UITableView.automaticDimension
                        
                    } else {
                        return 46
                    }
                    
                } else {
                    return UITableView.automaticDimension
                }
                
            } else {
                return 46
            }
        }
         
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if tableView == self.mainView.tblCalendar {
            let vw = UIView()
            return vw
        } else {

            let view = ProfessionalAvailabilityHeaderView.instanceFromNib() as! ProfessionalAvailabilityHeaderView
            view.btnSwitch.tag = section
            view.delegate = self
            view.setupUI(title: self.mainModelView.arrayMain[section]["title"].stringValue, isSelected: self.mainModelView.arrayMain[section]["selected"].boolValue)

            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.mainView.tblCalendar {
            return 0
        } else {
            return 61
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.mainView.tblCalendar {
            return 1
        } else {
            
            if self.mainModelView.arrayMain[section]["selected"].boolValue == true {
                return self.mainModelView.arrayMain[section]["data"].count
            } else {
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.mainView.tblCalendar {
            let cell: CalendarCell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell") as! CalendarCell
            cell.tag = indexPath.section
            cell.setupDataForAvailability(data: self.mainModelView.calendarArray!,selectionName: selectedAvailibility,selectedCustomDayName: self.selectedCustomDayName)
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AvailabilityWithDurationtblCell") as! AvailabilityWithDurationtblCell
            
            let dict = self.mainModelView.arrayMain[indexPath.section]["data"][indexPath.row]
            
            cell.selectionStyle = .none
            cell.sectionTag = indexPath.section
            cell.btnDaySelect.tag = indexPath.row
            cell.delegateAvailibility = self
            cell.lblDayName.text = dict["name"].stringValue
            cell.txtOpeningHours.text = dict["openning_hours"].stringValue
            cell.txtBreak.text = dict["break"].stringValue.isEmpty ? self.mainModelView.defaultHours : dict["break"].stringValue
            cell.indexPath = indexPath
            cell.timeRangePickerData = mainModelView.timeRangePickerData
            cell.onChangeOpeningHours = { [weak self] openingHours, index in
                self?.mainModelView.arrayMain[index.section]["data"][index.row]["openning_hours"].stringValue = openingHours
            }
            
            cell.onChangeBreakHours = { [weak self] breakHours, index in
                self?.mainModelView.arrayMain[index.section]["data"][index.row]["break"].stringValue = breakHours
            }
            
            if dict["selected_day"].boolValue == true {
                cell.lblDayName.textColor = UIColor.appthemeOffRedColor
                cell.imgCheckmark.isHidden = false
            } else {
                cell.lblDayName.textColor = UIColor.appthemeBlackColor
                cell.imgCheckmark.isHidden = true
            }
            
            if indexPath.section == 2 {  //Weekends only
                //No need to add else conditin because if Weekends only selected then pass row count otherwise return 0

//                if self.mainModelView.arrayMain[indexPath.section]["selected"].boolValue == true {
                    cell.vwDuration.isHidden = false
                    cell.vwDayNameAndCheckmark.isHidden = true
                    cell.heightOfConstraintvwNameAndCheckmark.constant = 0
                
//                } else {
//                    cell.vwDayNameAndCheckmark.isHidden = false
//                    cell.vwDuration.isHidden = false
//                    cell.heightOfConstraintvwNameAndCheckmark.constant = 46
//                }
            } else if indexPath.section == 4 { // custom
                
                if dict["selected_day"].boolValue == true {
                    cell.vwDuration.isHidden = false
                    cell.vwDayNameAndCheckmark.isHidden = false
                    cell.heightConstraintVwDuration.constant = 63
                    cell.heightOfConstraintvwNameAndCheckmark.constant = 46
                } else {
                    cell.vwDayNameAndCheckmark.isHidden = false
                    cell.vwDuration.isHidden = true
                    cell.heightConstraintVwDuration.constant = 0
                    cell.heightOfConstraintvwNameAndCheckmark.constant = 46
                }
                
            } else {
                cell.vwDuration.isHidden = false
                cell.vwDayNameAndCheckmark.isHidden = false
                cell.heightConstraintVwDuration.constant = 63
                cell.heightOfConstraintvwNameAndCheckmark.constant = 46
            }
            
            return cell
        }
        
    }
}

//MARK: -Header delegate
extension ProfessionalSelectAvailabilityVC:  ProfessionalAvailabilityHeaderDelegate {

    func ProfessionalAvailabilityHeaderFinish(tag: Int, isShow: Bool) {
        
        for i in 0..<self.mainModelView.arrayMain.count {
            self.mainModelView.arrayMain[i]["selected"].boolValue = false
        }
        
        self.mainModelView.arrayMain[tag]["selected"].boolValue = isShow
        if isShow {
            selectedAvailibility = self.mainModelView.arrayMain[tag]["title"].stringValue
        } else {
            selectedAvailibility = ""
        }
        self.mainView.tblShowData.reloadData()
        self.mainView.tblCalendar.reloadData()
    }
    
}

//MARK: - custom day selection delegate

extension ProfessionalSelectAvailabilityVC:  AvailibilityDurationCellDelegate {
    
    func selectedDayInCustom(section:Int, row: Int) {
        
        if self.mainModelView.arrayMain[section]["data"][row]["selected_day"].boolValue == true {
            self.mainModelView.arrayMain[section]["data"][row]["selected_day"].boolValue = false
            
            let strDayName = self.mainModelView.arrayMain[section]["data"][row]["name"].stringValue.lowercased()
            
            let index = self.selectedCustomDayName.firstIndex(of: strDayName) ?? 0
            self.selectedCustomDayName.remove(at: Int(index))
            
        } else {
            self.mainModelView.arrayMain[section]["data"][row]["selected_day"].boolValue = true
            self.selectedCustomDayName.append(self.mainModelView.arrayMain[section]["data"][row]["name"].stringValue.lowercased())
        }
        
        self.mainView.tblShowData.reloadData()
        self.mainView.tblCalendar.reloadData()
        
    }

}
