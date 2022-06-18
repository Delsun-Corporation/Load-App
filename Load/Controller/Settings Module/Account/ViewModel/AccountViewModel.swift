//
//  AccountViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 26/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class AccountViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:AccountVC!
    var selectedDateStart:Date?
    var selectedDateEnd:Date?
    var isSnoozeSelected = false
    
    //MARK:- Functions
    init(theController:AccountVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.DOBSetup()
        isSnoozeSelected = !theController.snoozeToggleButton.isSelected
    }
    
    func DOBSetup() {
        let view = (theController.view as? AccountView)
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
            //datePickerView.setValue(UIColor.clear, forKey: "magnifierLineColor")
            datePickerView.setValue(false, forKey: "highlightsToday")
        }
        
        datePickerView.backgroundColor = UIColor.white
        datePickerView.setValue(UIColor.appthemeOffRedColor, forKeyPath: "textColor")
        view?.txtStartDate.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChangedStart), for: UIControl.Event.valueChanged)
        
        let datePickerView1:UIDatePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePickerView1.preferredDatePickerStyle = .wheels
            datePickerView1.setValue(UIColor.clear, forKey: "magnifierLineColor")
            datePickerView1.setValue(false, forKey: "highlightsToday")
        }
        datePickerView1.backgroundColor = UIColor.white
        
        datePickerView1.setValue(UIColor.appthemeOffRedColor, forKeyPath: "textColor")
        datePickerView1.datePickerMode = UIDatePicker.Mode.date
        view?.txtEndDate.inputView = datePickerView1
        if self.selectedDateStart != nil {
            datePickerView1.minimumDate = self.selectedDateStart
        }
        datePickerView1.addTarget(self, action: #selector(datePickerValueChangedEnd), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChangedStart(sender:UIDatePicker) {
        let view = (theController.view as? AccountView)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "MM/dd/yyyy"
        view?.txtStartDate.text = dateFormatter.string(from: sender.date)
        self.selectedDateStart = sender.date
        if self.selectedDateEnd == nil {
            self.selectedDateEnd = sender.date
            view?.txtEndDate.text = dateFormatter.string(from: sender.date)
        }
        if (self.selectedDateStart! > self.selectedDateEnd!) && self.selectedDateStart != nil && self.selectedDateEnd != nil {
            self.selectedDateEnd = sender.date
            view?.txtEndDate.text = dateFormatter.string(from: sender.date)
        }
        self.DOBSetup()
    }
    
    @objc func datePickerValueChangedEnd(sender:UIDatePicker) {
        let view = (theController.view as? AccountView)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "MM/dd/yyyy"
        view?.txtEndDate.text = dateFormatter.string(from: sender.date)
        self.selectedDateEnd = sender.date
    }
    
    func showActionSheet() {
        let alert = UIAlertController(title: nil, message: "Please Select an Option", preferredStyle: .actionSheet)
        
        let view = (self.theController.view as? AccountView)
        if view?.lblTypeOfAccountValue.text?.lowercased() != "free" {
            alert.addAction(UIAlertAction(title: "Free", style: .default , handler:{ (UIAlertAction)in
                let view = (self.theController.view as? AccountView)
                view?.lblTypeOfAccountValue.text = "Free"
                view?.viewSnooze.isHidden = true
                let account = GetAllData?.data?.accounts
                for data in account ?? [] {
                    if data.name?.lowercased() == "free" {
                        self.apiCallForUpdateAccountType(accountId: (data.id?.intValue)!)
                    }
                }
            }))
        }
        
        if view?.lblTypeOfAccountValue.text?.lowercased() != "premium" {
            alert.addAction(UIAlertAction(title: "Premium", style: .default , handler:{ (UIAlertAction)in
                let view = (self.theController.view as? AccountView)
                view?.lblTypeOfAccountValue.text = "Premium"
                view?.viewSnooze.isHidden = false
                let account = GetAllData?.data?.accounts
                for data in account ?? [] {
                    if data.name?.lowercased() == "premium" {
                        self.apiCallForUpdateAccountType(accountId: (data.id?.intValue)!)
                    }
                }
            }))
        }
        
        if view?.lblTypeOfAccountValue.text?.lowercased() != "professional" {
            alert.addAction(UIAlertAction(title: "Professional", style: .default , handler:{ (UIAlertAction)in
                let view = (self.theController.view as? AccountView)
                view?.lblTypeOfAccountValue.text = "Professional"
                view?.viewSnooze.isHidden = true
                let account = GetAllData?.data?.accounts
                for data in account ?? [] {
                    if data.name?.lowercased() == "professional" {
                        self.apiCallForUpdateAccountType(accountId: (data.id?.intValue)!)
                    }
                }
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler:{ (UIAlertAction)in
            print("User click Cancel button")
        }))
        
        self.theController.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    func apiCallForUpdateAccountType(accountId:Int) {
        let param = ["account_id":accountId] as [String : Any]
        ApiManager.shared.MakePostAPI(name: UPDATE_ACCOUNT_DATA, params: param as [String : Any], progress: false, vc: self.theController, isAuth: false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let message = json.getString(key: .message)
                makeToast(strMessage: message)
                var jsonData = getUserDetailJSON()
                print(json)
                jsonData["data"]["user"].setIntValue(key: .account_id, value: accountId)
                print(jsonData)
                saveJSON(j: jsonData, key: USER_DETAILS_KEY)
            }
        }
    }
    
    func apiCallForUpdateAccountSnooze(isSnooze:Bool, startDate:String, endDate: String) {
        var param = ["is_snooze":isSnooze, "start_date":startDate, "end_date":endDate] as [String : Any]
        if startDate == "" {
            param.removeValue(forKey: "start_date")
            param.removeValue(forKey: "end_date")
        }
        ApiManager.shared.MakePostAPI(name: UPDATE_ACCOUNT_SNOOZE, params: param as [String : Any], progress: false, vc: self.theController, isAuth: false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                var jsonData = getUserDetailJSON()
                print(jsonData)
                jsonData["data"]["user"].setIntValue(key: .is_snooze, value: isSnooze ? 1 : 0)
                if isSnooze {
                    print(startDate)
                    print(endDate)
                    let sDate = self.selectedDateStart?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    let eDate = self.selectedDateEnd?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    if jsonData["data"]["user"]["user_snooze_detail"].isEmpty {
                        jsonData["data"]["user"]["user_snooze_detail"] = JSON()
                        jsonData["data"]["user"]["user_snooze_detail"].setValue(key: .start_date, value: sDate!)
                        jsonData["data"]["user"]["user_snooze_detail"].setValue(key: .end_date, value: eDate!)
                    }
                    else {
                        jsonData["data"]["user"]["user_snooze_detail"].setValue(key: .start_date, value: sDate!)
                        jsonData["data"]["user"]["user_snooze_detail"].setValue(key: .end_date, value: eDate!)
                    }
                }
                print(jsonData)
                saveJSON(j: jsonData, key: USER_DETAILS_KEY)
            }
        }
    }
    
    // Hide for LOAD-29
    //    func setUpNavigationBarRightButton(isRightButtonHidden:Bool) {
    //        if !isRightButtonHidden
    //        {
    //            let rightButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonAction))
    //            rightButton.tintColor = UIColor.white
    //            self.theController.navigationItem.rightBarButtonItem = rightButton
    //        }
    //        else {
    //            self.theController.navigationItem.rightBarButtonItem = nil
    //        }
    //    }
    
    func isSaveIsAvailable() -> Bool {
        if self.selectedDateStart == nil {
            makeToast(strMessage: getCommonString(key: "Please_select_start_date_key"))
            return false
        }
        else if self.selectedDateEnd == nil {
            makeToast(strMessage: getCommonString(key: "Please_select_end_date_key"))
            return false
        }
        else if self.selectedDateStart! > self.selectedDateEnd! {
            makeToast(strMessage: getCommonString(key: "Start_date_is_greterthan_to_end_date_key"))
            return false
        }
        
        return true
    }
    
    @objc func saveButtonAction() {
        let view = (self.theController.view as? AccountView)
        // Make sure that save is available
        guard isSaveIsAvailable() == true else {
            return
        }
        
        guard let isSnooze = view?.btnSnooze.isSelected, let startDate = selectedDateStart?.iso8601,
              let endDate = selectedDateEnd?.iso8601 else {
            return
        }
        self.apiCallForUpdateAccountSnooze(isSnooze: isSnooze, startDate: startDate, endDate: endDate)
    }
}
