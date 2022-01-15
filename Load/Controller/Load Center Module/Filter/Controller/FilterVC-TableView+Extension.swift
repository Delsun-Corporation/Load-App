//
//  FilterVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension FilterVC: UITableViewDelegate, UITableViewDataSource, FilterSpecializationDelegate, FilterSpecializationSelectedDelegate, FilterRatingDelegate, FilterSliderDelegate {
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.FilterSection.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 42
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = FilterHeaderView.instanceFromNib() as! FilterHeaderView
        view.section = section
        view.setupUI()
        view.lblTitle.text = self.mainModelView.FilterSection[section]
        return view
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 {
            let cell: FilterDropDownCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "FilterDropDownCell") as! FilterDropDownCell
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            cell.delegate = self
            cell.txtDropDown.placeholder = getCommonString(key: "Select_3_categories_key")
            cell.index = indexPath.section
            cell.txtDropDown.text = self.mainModelView.filterSpecialization == "" ? showSpecialization() : self.mainModelView.filterSpecialization
            return cell
        }
        else if indexPath.section == 5 {
            let cell: FilterRatingCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "FilterRatingCell") as! FilterRatingCell
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            cell.delegate = self
            cell.rateView.rating = self.mainModelView.Rating ?? 0
            return cell
        }
        else if indexPath.section == 6 {
            let cell: FilterSliderCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "FilterSliderCell") as! FilterSliderCell
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            cell.section = indexPath.section
            cell.delegate = self
            cell.setupUI(min: 1, max: 50)
            return cell
        }
        else if indexPath.section == 7 {
            let cell: FilterSliderCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "FilterSliderCell") as! FilterSliderCell
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            cell.section = indexPath.section
            cell.delegate = self
            cell.setupUI(min: 0, max: 500, isShow: true)
            return cell
        }
        else {
            let cell: FilterDropDownCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "FilterDropDownCell") as! FilterDropDownCell
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            cell.delegate = self
            cell.txtDropDown.placeholder = "Select your " + self.mainModelView.FilterSection[indexPath.section]
            cell.index = indexPath.section
            cell.setupUI()
            if self.mainModelView.isFilterClear {
                cell.txtDropDown.text = ""
            }
            if indexPath.section == 0 {
                cell.txtDropDown.text = self.mainModelView.LocationName
            }
            else if indexPath.section == 1 {
                cell.txtDropDown.text = self.mainModelView.LanguageName
            }
            else if indexPath.section == 2 {
                cell.txtDropDown.text = self.mainModelView.Gender
            }
            else if indexPath.section == 4 {
                cell.txtDropDown.text = self.mainModelView.ServiceName
            }
            return cell
        }
    }
    
    //MARK:- Functions
    func FilterSpecializationSelect() {
        self.view.endEditing(true)
        let obj: FilterSpecializationVC = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "FilterSpecializationVC") as! FilterSpecializationVC
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedArray = self.mainModelView.selectedArray
        obj.mainModelView.selectedNameArray = self.mainModelView.selectedNameArray
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func FilterSelected(section: Int, id: String, name: String) {
        if section == 0 {
            self.mainModelView.Location = id
            self.mainModelView.LocationName = name
        }
        else if section == 1 {
            self.mainModelView.Language = id
            self.mainModelView.LanguageName = name
        }
        else if section == 2 {
            self.mainModelView.Gender = id
        }
        else if section == 4 {
            self.mainModelView.Service = id
            self.mainModelView.ServiceName = name
        }
    }
    
    func FilterSpecializationSelectedDidFinish(ids: [Int], names: [String]) {
        self.mainModelView.selectedArray = ids
        self.mainModelView.selectedNameArray = names
        let formattedNameString = (names.map{String($0)}).joined(separator: ", ")
        self.mainModelView.filterSpecialization = formattedNameString
        self.mainView.tableView.reloadSections([3], with: .none)
    }
    
    func FilterRatingDidFinish(rate: Double) {
        self.mainModelView.Rating = rate
    }
    
    func FilterSliderDidFinish(section: Int, start: CGFloat, end: CGFloat) {
        if section == 6 {
            self.mainModelView.YOEStart = start
            self.mainModelView.YOEEnd = end
        }
        else {
            self.mainModelView.RateStart = start
            self.mainModelView.RateEnd = end
        }
    }
    
    func showSpecialization() -> String {
        if FILTER_MODEL?.SpecializationNameArray != nil {
            self.mainModelView.selectedArray = (FILTER_MODEL?.Specialization)!
            self.mainModelView.selectedNameArray = (FILTER_MODEL?.SpecializationNameArray)!
            let formattedNameString = (self.mainModelView.selectedNameArray.map{String($0)}).joined(separator: ", ")
            self.mainModelView.filterSpecialization = formattedNameString
            return self.mainModelView.filterSpecialization
        }
        return ""
    }
}
