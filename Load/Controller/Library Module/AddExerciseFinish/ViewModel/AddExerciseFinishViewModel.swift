//
//  AddExerciseFinishViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol BackToScreenDelegate: AnyObject {
    func BackToScreenDidFinish()
}

class AddExerciseFinishViewModel {
    
    // MARK: Variables
    fileprivate weak var theController:AddExerciseFinishVC!
    var RepetitionMax: [RepetitionMaxModelClass] = [RepetitionMaxModelClass]()
    
    var motion: String = ""
    var movement: String = ""
    var isOpen:Bool = false
    var txtExercise: String = ""
    var regionIds: [Int] = []
    var categoryId: String = ""
    var subBodyPartId: String = ""
    var mechanicsId: String = ""
    var actionForceId: String = ""
    var equipmentIds: [Int] = []
    var selectedTargetedMusclesId: [Int] = []
    var targetedMuscle: String = ""
    var isEdit:Bool = false
    var libraryId:String = ""
    var exerciseLink:String = ""
    var libraryPreviewModel : LibraryListPreviewModelClass?
    weak var delegate:BackToScreenDelegate?
//    var RMArray: [Int] = [100, 95, 93, 90, 87, 85, 83, 80, 77, 75, 70, 67, 65]
    var RMArray: [Int] = [100, 96, 93, 91, 88, 85, 83, 80, 77, 75, 72, 69,67, 64,61,59,56,53,51,48]
    let pickerView = UIPickerView()
    var RMTextArray: [String] = ["1 RM", "10 RM"]
    var selectedRM: Int = 1
    
    init(theController:AddExerciseFinishVC) {
        self.theController = theController
    }
    
    // MARK: Functions
    func setupUI() {
        let view = (self.theController.view as? AddExerciseFinishView)
        pickerView.delegate = self.theController
        pickerView.dataSource = self.theController
        pickerView.backgroundColor = UIColor.white
        view?.txtRM.inputView = pickerView
        if self.isEdit {
            view?.lblRM.text = (self.libraryPreviewModel?.selectedRM ?? "") + " RM"
            self.selectedRM = Int(self.libraryPreviewModel?.selectedRM ?? "1") ?? 1
            view?.txtKG.text = self.libraryPreviewModel?.repetitionMax?[self.selectedRM - 1].estWeight?.replace(target: ".0", withString: "") ?? "0"
        }
        else {
            for data in addDefaultJSON().arrayValue {
                RepetitionMax.append(RepetitionMaxModelClass(JSON: data.dictionaryObject!)!)
            }
        }
    }
    
    func ValidateDetails() {
//        let view = (self.theController.view as? AddExerciseFinishView)
//        if view?.txtKG.text == "" && isAllEmpty() {
//            makeToast(strMessage: getCommonString(key: "Please_enter_weight_key"))
//        }
//        else {
            if self.isEdit {
                self.editLibrary()
            }
            else {
                self.createLibrary()
            }
//        }
    }
    
    func createLibrary() {
        let repetitionMax: NSMutableArray = NSMutableArray()
        for data in self.RepetitionMax {
            let dict: NSDictionary = ["name":data.name ?? "", "est_weight":data.estWeight?.stringValue ?? "", "act_weight":data.actWeight?.stringValue ?? ""]
            repetitionMax.add(dict)
        }
        
        apiCallLibraryCreate(exercise: self.txtExercise, regionIds: self.regionIds, categoryId: self.categoryId, subBodyPartId: self.subBodyPartId, mechanicsId: self.mechanicsId, targetedMusclesIds: self.selectedTargetedMusclesId, actionForceId: self.actionForceId, equipmentIds: self.equipmentIds, repetitionMax: repetitionMax, exerciseLink: self.exerciseLink, selectedRM: self.selectedRM, motion: motion, movement: movement)
    }
    
    func editLibrary() {
        let repetitionMax: NSMutableArray = NSMutableArray()
        for data in (self.libraryPreviewModel?.repetitionMax)! {
            let dict: NSDictionary = ["name":data.name!, "est_weight":data.estWeight!, "act_weight":data.actWeight!]
            repetitionMax.add(dict)
        }
        
        apiCallUpdateLibrary(id: (self.libraryPreviewModel?.id?.stringValue)!, exercise: self.txtExercise, regionIds: self.regionIds, categoryId: self.categoryId, subBodyPartId: self.subBodyPartId, mechanicsId: self.mechanicsId, targetedMusclesIds: self.selectedTargetedMusclesId, actionForceId: self.actionForceId, equipmentIds: self.equipmentIds, repetitionMax: repetitionMax, isFavorite: (self.libraryPreviewModel?.isFavorite?.stringValue)!, isActive: (self.libraryPreviewModel?.isActive?.stringValue)!, exerciseLink: self.exerciseLink)
    }
    
    func apiCallLibraryCreate(exercise: String, regionIds: [Int], categoryId: String, subBodyPartId: String, mechanicsId: String, targetedMusclesIds: [Int], actionForceId: String, equipmentIds: [Int], repetitionMax: NSMutableArray, exerciseLink: String, selectedRM: Int, motion: String, movement: String) {
        
        var param = [
            "exercise_name": exercise,
            "user_id": getUserDetail()?.data?.user?.id?.stringValue ?? "",
            "regions_ids": regionIds,
            "category_id": categoryId,
            "mechanics_id": mechanicsId,
            "targeted_muscles_ids": targetedMusclesIds,
            "targeted_muscle": targetedMuscle,
            "action_force_id": actionForceId,
            "equipment_ids": equipmentIds,
            "repetition_max": repetitionMax,
            "exercise_link" :exerciseLink,
            "selected_rm" : selectedRM,
            "motion": motion,
            "movement": movement
        ] as [String : Any]
        
        if mechanicsId == "" {
            param.removeValue(forKey: "mechanics_id")
        }
        
        if targetedMusclesIds.isEmpty {
            param.removeValue(forKey: "targeted_muscles_ids")
        }
        
        if actionForceId == "" {
            param.removeValue(forKey: "action_force_id")
        }
        
        if equipmentIds.count == 0 {
            param.removeValue(forKey: "equipment_ids")
        }
        
        if exerciseLink == "" {
            param.removeValue(forKey: "exercise_link")
        }
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: LIBRARY_CREATE, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                let message = json.getString(key: .message)
                
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LIBRARY_LIST_NOTIFICATION.rawValue), object: nil)
                    
                    self.theController.navigationController?.popToRootViewController(animated: true)
                }
                else {
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    func apiCallUpdateLibrary(id:String, exercise: String, regionIds: [Int], categoryId: String, subBodyPartId: String, mechanicsId: String, targetedMusclesIds: [Int], actionForceId: String, equipmentIds: [Int], repetitionMax: NSMutableArray, isFavorite: String, isActive: String, exerciseLink:String) {
        
        var param = [
            "exercise_name": exercise,
            "user_id": getUserDetail()?.data?.user?.id?.stringValue ?? "",
            "regions_ids": regionIds,
            "category_id": categoryId,
            "mechanics_id": mechanicsId,
            "targeted_muscles_ids": targetedMusclesIds,
            "action_force_id": actionForceId,
            "equipment_ids": equipmentIds,
            "repetition_max": repetitionMax,
            "is_favorite": isFavorite,
            "is_active": isActive,
            "exercise_link" :exerciseLink,
            "selected_rm" : selectedRM
            ] as [String : Any]
        
        if mechanicsId == "" {
            param.removeValue(forKey: "mechanics_id")
        }
        
        if targetedMusclesIds.isEmpty {
            param.removeValue(forKey: "targeted_muscles_ids")
        }
        
        if actionForceId == "" {
            param.removeValue(forKey: "action_force_id")
        }
        
        if equipmentIds.count == 0 {
            param.removeValue(forKey: "equipment_ids")
        }
        
//        if exerciseLink == "" {
//            param.removeValue(forKey: "exercise_link")
//        }
        
        print(JSON(param))
        
        ApiManager.shared.MakePutAPI(name: LIBRARY_UPDATE + "/" + id, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let success = json.getBool(key: .success)
                let message = json.getString(key: .message)
                
                if success {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LIBRARY_LIST_NOTIFICATION.rawValue), object: nil)
                    self.theController.navigationController?.popViewController(animated: false)
                    self.delegate?.BackToScreenDidFinish()
                }
                else {
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    func isAllEmpty() -> Bool {
        var isEmptyData:Bool = true
        
        if isEdit {
            for data in (self.libraryPreviewModel?.repetitionMax)! {
                if data.estWeight != "0" {
                    isEmptyData = false
                }
            }
        }
        else {
            for data in self.RepetitionMax {
                if data.estWeight != 0 {
                    isEmptyData = false
                }
            }
        }
        
        return isEmptyData
    }
    
    func calculateRM(value:CGFloat, index:Int) -> [Double] {
        
        print("TextValue:\(value)")
        
        var array: [Double] = []
        for (i, data) in self.RMArray.enumerated() {
            if i == index {
                array.append(Double(value))
            }
            else {
                
                print("data:\(data)")
                let rm = self.RMArray[index]
                print("rm:\(rm)")

                let value1 = Double(data) / Double(rm) * Double(value)
                array.append(value1.rounded(toPlaces: 1))
            }
        }
        return array
    }
    
    func addDefaultJSON() -> JSON {
        return JSON([
            [
                "name": "1 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "2 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "3 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "4 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "5 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "6 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "7 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "8 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "9 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "10 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "11 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "12 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "13 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "14 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "15 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "16 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "17 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "18 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "19 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
            [
                "name": "20 RM",
                "est_weight": 0,
                "act_weight": 0
            ],
        ])
    }
}
