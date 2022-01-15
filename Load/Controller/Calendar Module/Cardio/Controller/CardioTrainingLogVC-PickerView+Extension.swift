//
//  CardioTrainingLogVCfdsf.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

extension CardioTrainingLogVC: UIPickerViewDataSource, UIPickerViewDelegate {
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.mainModelView.activityPickerView {
            return GetAllData?.data?.trainingActivity?.count ?? 0
        }
        else if pickerView == self.mainModelView.intensityPickerView {
            return GetAllData?.data?.trainingIntensity?.count ?? 0
        }
        else if pickerView == self.mainModelView.trainingGoalPickerView {
            return self.mainModelView.getTrainingGoal().count
        }
        else if pickerView == self.mainModelView.targatHRPickerView {
            return self.mainModelView.getHRList().count
        }else if pickerView == self.mainModelView.stylePickerView{
            return GetAllData?.data?.trainingLogStyle?.count ?? 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
//        for view in pickerView.subviews{
//            view.backgroundColor = UIColor.clear
//        }
        
        if pickerView == self.mainModelView.activityPickerView {
            let activity = GetAllData?.data?.trainingActivity![row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI(isShowImage: true)
            myView.imgIcon.sd_setImage(with: URL(string: SERVER_URL+(activity?.iconPathRed)!), completed: nil)
            myView.imgIcon.contentMode = .scaleAspectFit
            myView.lblText.text = activity!.name?.capitalized
            
            return myView
            
        }
        else if pickerView == self.mainModelView.intensityPickerView {
            let activity = GetAllData?.data?.trainingIntensity![row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity!.name?.capitalized
            return myView
        }
        else if pickerView == self.mainModelView.trainingGoalPickerView {
            let activity = self.mainModelView.getTrainingGoal()[row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.lblText.text = activity.name?.capitalized
            return myView
        }
        else if pickerView == self.mainModelView.targatHRPickerView {
            let model = self.mainModelView.getHRList()[row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            
            if model.trimmed().contains(" Estimated HR"){
                let str = " Estimated HR"
                
                let estimatedCount = str.count
                let totalCount = model.count
                
                let finalCount = totalCount - estimatedCount
                
                let value = model.dropFirst(finalCount)
                print("Value :\(value)")
                myView.lblText.text = String(value)
            }else{
                 myView.lblText.text = model.capitalized
            }
            
            return myView
        }else if pickerView == self.mainModelView.stylePickerView{
            let swimingStyle = GetAllData?.data?.trainingLogStyle![row]
            let myView = PickerView.instanceFromNib() as! PickerView
            myView.setupUI()
            myView.imgIcon.image = nil
            myView.imgWidth.constant = 0
            myView.lblText.text = swimingStyle?.name ?? ""
            return myView
        }
        return UIView()
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.mainModelView.activityPickerView {
            let activity = GetAllData?.data?.trainingActivity![row]

            if self.mainModelView.activityId != (activity?.id?.stringValue)! {
                self.mainModelView.exercisesArray.removeAll()
            }
            self.mainView.txtActivity.text = activity?.name?.capitalized ?? ""
            self.mainModelView.activityId = activity?.id?.stringValue ?? ""
            
            print("txtActivity Name : \(self.mainView.txtActivity.text)")
            print("DidSelect Name : \(activity?.name?.capitalized ?? "")")
            
            self.mainView.txtIntensity.text = ""
            self.mainView.txtTargetHR.text = ""
            self.mainView.txtTrainingGoal.text = ""

            self.mainModelView.showExerciseHeader()
            self.hideShowHeaderAccordingToActivity(name: self.mainView.txtActivity.text ?? "")
            self.mainView.tableView.reloadData()
        }
        else if pickerView == self.mainModelView.intensityPickerView {
            let activity = GetAllData?.data?.trainingIntensity![row]
            self.mainView.txtIntensity.text = activity?.name?.capitalized ?? ""
            self.mainModelView.intensityId = activity?.id?.stringValue ?? ""
            self.mainModelView.selectedTargatHRId = activity?.targetHr ?? ""
            //New comment
//            self.mainModelView.trainingGoalId = ""
//            self.mainModelView.isGoalCustom = false
//            self.mainView.txtTrainingGoal.text = ""

            //Not needed below comment
//            self.mainView.txtTargetHR.text = ""
            self.mainModelView.setTrainingGoal(isSet: true)
            
            let hr = self.mainModelView.showTargetHr(hr: activity?.targetHr ?? "",activityID:self.mainModelView.activityId)
            self.mainModelView.targatHRId = hr

            //TODO: - yash changes
            self.mainView.txtTargetHR.text = hr == "0" ? "" : hr + " bpm"
//            self.mainView.txtTargetHR.isUserInteractionEnabled = hr == "0"
            self.mainModelView.targatHR = hr == "0" ? "" : hr + " Estimated HR"
            
            if self.mainModelView.isGoalCustom == false{
                for i in 0..<self.mainModelView.exercisesArray.count{
                    self.mainModelView.exercisesArray[i].laps = ""
                    self.mainModelView.exercisesArray[i].speed = ""
                    self.mainModelView.exercisesArray[i].pace = ""
                    self.mainModelView.exercisesArray[i].percentage = ""
                    self.mainModelView.exercisesArray[i].duration = ""
                    self.mainModelView.exercisesArray[i].distance = ""
                    self.mainModelView.exercisesArray[i].rest = ""
                    self.mainModelView.exercisesArray[i].lvl = ""
                    self.mainModelView.exercisesArray[i].watt = ""
                    self.mainModelView.exercisesArray[i].rpm = ""
                }
                
                self.mainModelView.selectedCardioLogValidation = nil
                self.mainView.txtTrainingGoal.text = ""
                self.mainModelView.trainingGoalId = ""

            }
            self.mainView.tableView.reloadData()
            
            self.mainModelView.targatHRPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        else if pickerView == self.mainModelView.trainingGoalPickerView {
            
            for i in 0..<self.mainModelView.exercisesArray.count{
                self.mainModelView.exercisesArray[i].laps = ""
                self.mainModelView.exercisesArray[i].speed = ""
                self.mainModelView.exercisesArray[i].pace = ""
                self.mainModelView.exercisesArray[i].percentage = ""
                self.mainModelView.exercisesArray[i].duration = ""
                self.mainModelView.exercisesArray[i].distance = ""
                self.mainModelView.exercisesArray[i].rest = ""
                self.mainModelView.exercisesArray[i].watt = ""
                self.mainModelView.exercisesArray[i].rpm = ""
                self.mainModelView.exercisesArray[i].lvl = ""
            }

            let activity = self.mainModelView.getTrainingGoal()[row]
            let name = activity.name?.capitalized ?? ""
            
            self.mainModelView.selectedTrainingGoalName = name
            
            self.mainModelView.trainingGoalId = activity.id?.stringValue ?? ""
            print("Training Goal Id : \(self.mainModelView.trainingGoalId)")
            
            if name.lowercased() != "customize" {
                
                self.mainModelView.isTrainigGoalSelectAsCustomize = false
                self.mainView.txtTrainingGoal.text = name
                self.mainModelView.isGoalCustom = false
                self.mainView.txtTrainingGoal.placeholder = getCommonString(key: "Fill_in_your_training_goal_key")
            }
            else {
                getCustomizeGoalID()
                self.mainView.txtTrainingGoal.placeholder = ""
                self.mainModelView.isTrainigGoalSelectAsCustomize = true
                self.mainView.txtTrainingGoal.text = ""
                self.mainModelView.isGoalCustom = true
            }
            
            
            if name.lowercased() == "customize" {
                self.view.endEditing(true)
                self.mainModelView.setTrainingGoal(isSet: false)
        //        self.mainModelView.showCustomTrainingGoal(isShow: true)
//                self.mainView.txtCustomTrainingGoal.becomeFirstResponder()
            }
            else {
//                self.mainModelView.showCustomTrainingGoal(isShow: false)
            }
            
            self.mainModelView.getValidationFromId()
            self.mainView.tableView.reloadData()
            
        }
        else if pickerView == self.mainModelView.targatHRPickerView {
            if row == 0 {

                if self.mainModelView.getHRList()[row].trimmed().contains(" Estimated HR"){
                  self.mainView.txtTargetHR.text = self.mainModelView.getHRList()[row].replacingOccurrences(of: " Estimated HR", with: " bpm")
                }else{
                    self.mainView.txtTargetHR.text = self.mainModelView.getHRList()[row]
                }
                
            }
            else {
                self.mainView.txtTargetHR.text = ""
                self.mainView.txtTargetHR.resignFirstResponder()
                self.mainView.txtTargetHR.inputView = nil
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                        self.mainView.txtTargetHR.setAsNumericKeyboard(delegate: self,isUseHyphen:true)
                        self.mainView.txtTargetHR.becomeFirstResponder()
                    }, completion: nil)
                }
            }
        }
        else if pickerView == self.mainModelView.stylePickerView{
           
            let style = GetAllData?.data?.trainingLogStyle![row]
            self.mainModelView.selectedSwimmingStyle = String(Int(style?.id ?? 0))
            self.mainView.txtStyle.text = style?.name
            
        }
    }
    
    func getCustomizeGoalID(){
        
        var selectedTrainingGoal : TrainingGoalLogCardio? = nil
        
        if GetAllData?.data?.trainingGoalLogCardio?.contains(where: { (cardio) -> Bool in
            if cardio.name?.lowercased() == "Customize".lowercased(){
                selectedTrainingGoal = cardio
                return true
            }
            return false
        }) ?? false{
            
//            print("Name  : \(selectedTrainingGoal?.name)")
            print("ID : \(selectedTrainingGoal?.id)")
            self.mainModelView.trainingGoalId = String(Int(selectedTrainingGoal?.id ?? NSNumber()))
            self.mainModelView.getValidationFromId()
        }else{
            print("Not Found")
        }
    }
    
}

