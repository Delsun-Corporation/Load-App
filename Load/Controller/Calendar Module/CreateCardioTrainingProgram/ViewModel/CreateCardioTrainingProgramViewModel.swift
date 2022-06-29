//
//  CreateCardioTrainingProgramViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreateCardioTrainingProgramViewModel {

    fileprivate weak var theController: CreateCardioTrainingProgramVC!
    var responseData: CardioPresetTrainingProgram?
    var titleArray: [String] = ["", "First, how do you set your program?", "Select date", "Select your frequency (weekly)"]
    var textArray: [String] = ["", "", "", ""]

    var placeHolderArray: [String] = ["", "Select program", "DD / MM / YY", "Select frequency"]
    
    var customArray:[String] = ["MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY", "SUNDAY"]
    var customArraySelected:[Bool] = [false, false, false, false, false, false, false]
    var isDaySelected:Bool = false
    var frequencyId:String = ""
    var maxSelect:Int = 0
    var isStartDate:Bool?
    var startDate: Date = Date()
    var endDate: Date = Date()
    var selectedDate: Date = Date()
    
    init(theController:CreateCardioTrainingProgramVC) {
        self.theController = theController
    }
    
    func setupUI() {

    }
    
    func validateDetails() {
        if self.textArray[1] == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_program_key"))
        }
        else if self.textArray[2] == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_date_key"))
        }
        else if self.textArray[3] == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_frequency_key"))
        }
        else {
            let model = self.customArraySelected.filter { (data) -> Bool in
                return data == true
            }
            if model.count == 0 {
                makeToast(strMessage: getCommonString(key: "Please_select_days_key"))
            }
            else {
                var sDate: Date = Date()
                var eDate: Date = Date()
                
                let monthsToAdd = responseData?.weeks?.intValue ?? 0
                print(monthsToAdd)
                if self.isStartDate! {
                    let newDate = Calendar.current.date(byAdding: .weekOfYear, value: monthsToAdd, to: self.selectedDate)
                    sDate = self.selectedDate
                    eDate = Calendar.current.date(byAdding: .day, value: -1, to: newDate!)!                   
                }
                else {
                    let newDate = Calendar.current.date(byAdding: .weekOfYear, value: -monthsToAdd, to: self.selectedDate)
                    
                    sDate = Calendar.current.date(byAdding: .day, value: 1, to: newDate!)!
                    eDate = self.selectedDate
                }
                
                print(sDate)
                print(eDate)
                
                self.apiCallSaveWorkoutList(startDate: sDate.iso8601, endDate: eDate.iso8601, progress: false)
            }
        }
    }
    
    func apiCallSaveWorkoutList(startDate: String, endDate: String, progress:Bool = true) {        
        let param = [
            "start_date": startDate,
            "end_date": endDate,
            "status" : TRAINING_LOG_STATUS.CARDIO.rawValue
            ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CHECK_PROGRAM_IS_AVAILABLE, params: param as [String : Any], progress: progress, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    self.btnNextClicked()
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        })
    }
    
    func btnNextClicked() {
        let obj: CardioTrainingProgramPreviewVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CardioTrainingProgramPreviewVC") as! CardioTrainingProgramPreviewVC
        
        var str:String = ""
        var arrayDay:[String] = []

        for (index, data) in self.customArraySelected.enumerated() {
            if data == true {
                arrayDay.append(self.customArray[index])
                str += self.customArray[index].lowercased().capitalized + ", "
            }
        }
        
        if str != "" {
            str.removeLast()
            str.removeLast()
        }
        
        let monthsToAdd = responseData?.weeks?.intValue ?? 0
        print(monthsToAdd)
        if self.isStartDate! {
            let newDate = Calendar.current.date(byAdding: .weekOfYear, value: monthsToAdd, to: self.selectedDate)
            self.startDate = self.selectedDate
            self.endDate = Calendar.current.date(byAdding: .day, value: -1, to: newDate!)!
        }
        else {
            let newDate = Calendar.current.date(byAdding: .weekOfYear, value: -monthsToAdd, to: self.selectedDate)

            self.startDate = Calendar.current.date(byAdding: .day, value: 1, to: newDate!)!
            self.endDate = self.selectedDate
        }
        print(self.startDate)
        print(self.endDate)
        
        obj.mainModelView.titleValue = (self.responseData?.title?.capitalized ?? "") + " training program"
        obj.mainModelView.titleSubValue = self.responseData?.subtitle ?? ""
        obj.mainModelView.selectedDate = self.selectedDate
        obj.mainModelView.isStartDate = self.isStartDate
        obj.mainModelView.startDate = self.startDate
        obj.mainModelView.endDate = self.endDate
        obj.mainModelView.frequencySelectedValue = str
        obj.mainModelView.frequencyValue = self.textArray[3]
        obj.mainModelView.frequencyId = self.frequencyId
        obj.mainModelView.presetTrainingProgramsId = self.responseData?.id?.stringValue ?? ""
        obj.mainModelView.customArray = arrayDay
        obj.delegateDismissCardioTrainingProgram = theController
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
}
