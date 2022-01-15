//
//  ProfessionalLoadCenterVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 31/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension ProfessionalLoadCenterVC:UITableViewDataSource, UITableViewDelegate, ProfessionalLoadCenterDelegate, MultiSelectionDelegate {
    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.headerArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        }
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = TrainingHeaderView.instanceFromNib() as? TrainingHeaderView
        view?.setupUI(title: self.mainModelView.headerArray[section])
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.titleArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 6 && indexPath.row == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessionalLoadCenterAutoAcceptCell") as! ProfessionalLoadCenterAutoAcceptCell
//            cell.selectionStyle = .none
//            cell.delegate = self
//            cell.btnSwitch.isSelected = self.mainModelView.txtAutoAccept
//            let model = self.mainModelView.titleArray[indexPath.section]
//            cell.setupUI(indexPath: indexPath, title: model)
//            return cell
//        }
//        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessionalLoadCenterCell") as! ProfessionalLoadCenterCell
            cell.selectionStyle = .none
            cell.delegate = self
            let model = self.mainModelView.titleArray[indexPath.section]
            let modelPlaceHolder = self.mainModelView.placeHolderArray[indexPath.section]
            let modelText = self.mainModelView.textArray[indexPath.section]
            cell.professionalTypeId = self.mainModelView.txtTypesId
            cell.setupUI(indexPath: indexPath, title: model, text: modelText, placeholder: modelPlaceHolder)
            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func ProfessionalLoadCenterButtonDidFinish(text:String, section: Int, row: Int) {
        
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
        
        print(section)
        print(row)
        if section == 0 {
            self.mainModelView.BasicProfileClicked()
        }
        else if section == 1 {
//            self.mainModelView.TypeClicked()
        }
        else if section == 2 {
            if row == 0 {
                self.mainModelView.BasicRequirementClicked()
            }
            else {
                self.mainModelView.FormsClicked()
            }
        }
        else if section == 3 {
            //Old
            
            var dataEntry: [MultiSelectionDataEntry] = [MultiSelectionDataEntry]()
            for data in self.mainModelView.amenitiesArray {
                dataEntry.append(MultiSelectionDataEntry(id: (data.first as? String) ?? "", title: (data.first as? String) ?? "", isSelected: (data[1] as! Bool)))
            }
            let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "MultiSelectionVC") as! MultiSelectionVC
            obj.mainModelView.delegate = self
            obj.mainModelView.data = dataEntry
            obj.mainModelView.title = self.mainModelView.titleArray[section].first ?? ""
            let nav = UINavigationController(rootViewController: obj)
            nav.modalPresentationStyle = .overFullScreen
            self.present(nav, animated: true, completion: nil)
            
            //New
            /*
            let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalActivityVC") as! ProfessionalActivityVC
//            obj.mainModelView.delegate = self
//            obj.mainModelView.selectedArray = dataEntry
//            obj.mainModelView.selectedNameArray = self.selectedNameArray
            let nav = UINavigationController(rootViewController: obj)
            nav.modalPresentationStyle = .overFullScreen
            self.present(nav, animated: true) {
            }*/

            
        }
        else if section == 4 {
            self.mainModelView.CancellationClicked()
        }
        else if section == 5 {
//            self.mainModelView.PaymentClicked()
        }
        else if section == 6 {
            if row == 0{
                self.mainModelView.SelectAvailibilityClicked()
            }else if row == 1{
                self.mainModelView.scheduleManagment()
            }
            
        }
    }
    
    func ProfessionalLoadCenterDidFinish(text: String, section: Int, row: Int) {
        self.btnSave.isHidden = false
        if section == 1 {
            if row == 0 {
                self.mainModelView.textArray[1][0] = text
                self.mainModelView.txtDuration = text
            }
            else if row == 1 {
                self.mainModelView.textArray[1][1] = text
                self.mainModelView.txtTypes = text
                self.mainModelView.txtTypesId = getTypeId(strTypeName: text)
                self.mainView.tableView.reloadSections(NSIndexSet(index: 1) as IndexSet, with: .none)
            } else if row == 2 {
                self.mainModelView.textArray[1][2] = text
                self.mainModelView.txtNumberOfSessionPerPackage = text
            }
            else if row == 3 {
                self.mainModelView.textArray[1][3] = text
                self.mainModelView.txtMaximumClient = text
            }
        }
        else if section == 3 {
            self.mainModelView.textArray[3][0] = text
            self.mainModelView.txtAmenitiesArray = text
        }
        else if section == 5 {
//            if row == 0 {
//                self.mainModelView.textArray[5][0] = text
//                self.mainModelView.txtOptions = text
//            }
//            else
            if row == 0 {
                self.mainModelView.textArray[5][0] = text.replacingOccurrences(of: "$", with: "")
                self.mainModelView.txtPerSession = text
            }
            else if row == 1 {
                self.mainModelView.textArray[5][1] = text
                self.mainModelView.txtPerMultipleSessions = text.replacingOccurrences(of: "$", with: "")
            }
        }
        
        self.mainModelView.saveDetails()
    }
    
    func ProfessionalLoadCenterType(text: String, section: Int, row: Int) {
        self.mainModelView.textArray[section][row] = text
        
        if let cell = self.mainView.tableView.cellForRow(at: IndexPath(row: 2, section: 1)) as? ProfessionalLoadCenterCell{
            
            if text.lowercased() == "Package".lowercased() || text.lowercased() == "Single and package".lowercased() {
                cell.txtValue.isUserInteractionEnabled = true
                cell.txtValue.textColor = .appthemeBlackColor
                cell.lblTitle.textColor = .appthemeBlackColor
            } else {
                cell.txtValue.isUserInteractionEnabled = false
                cell.lblTitle.textColor = .gray
                cell.txtValue.textColor = .gray
                self.mainModelView.textArray[1][2] = ""
            }
        }
    }
    
    func getTypeId(strTypeName:String) -> Int {
        
        var selectedTypeId: Int = 0
        for data in GetAllData?.data?.professionalTypes ?? [] {
            if strTypeName == data.name ?? "" {
                selectedTypeId = data.id as! Int
            }
        }
        return selectedTypeId
        
    }
    
    func MultiSelectionDidFinish(selectedData: [MultiSelectionDataEntry]) {
        print(selectedData)
        var amenitiesArray:[[Any]] = self.mainModelView.amenitiesArray
        for (index, data) in self.mainModelView.amenitiesArray.enumerated() {
            amenitiesArray[index][1] = false
            for dataValue in selectedData {
                if dataValue.title == (data[0] as? String) {
                    amenitiesArray[index][1] = true
                }
            }
        }
        self.mainModelView.amenitiesArray = amenitiesArray
        self.btnSave.isHidden = false
        let array = amenitiesArray.filter({ (data) -> Bool in
            return (data[1] as? Bool) == true
        })
        var str: [String] = []
        for data in array {
            str.append(data[0] as! String)
        }
        self.mainModelView.txtAmenitiesArray = str.joined(separator: ", ")
        self.mainModelView.textArray[3][0] = self.mainModelView.txtAmenitiesArray
        self.mainView.tableView.reloadSections([3], with: .none)
        
        self.mainModelView.saveDetails()
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Professional_key"))

    }
    
    func dismissPopupScreen(){
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Professional_key"))
    }
    
    func ProfessionalAutoAcceptFinish(isSelected: Bool) {
//        self.mainModelView.txtAutoAccept = isSelected
//        self.btnSave.isHidden = false
//        self.mainModelView.saveDetails()
    }
    
    func removeNavigtaionAndShowButtonSave(){
        
        //Call this method if Client want to remove auto save functionality
        //It is apply when write btnSave.isHidden = false

        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }

        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Professional_key"))

    }
    
    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
}
