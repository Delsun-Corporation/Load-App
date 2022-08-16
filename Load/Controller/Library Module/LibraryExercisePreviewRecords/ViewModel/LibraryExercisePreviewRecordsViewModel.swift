//
//  LibraryExercisePreviewRecordsViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class LibraryExercisePreviewRecordsViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:LibraryExercisePreviewRecordsVC!
    var libraryPreviewModel : LibraryListPreviewModelClass?
    var list: LibraryLogList?
    let pickerView = UIPickerView()
    var RMTextArray: [String] = ["1 RM", "10 RM"]
//    var RMArray: [Int] = [100, 95, 93, 90, 87, 85, 83, 80, 77, 75, 70, 67, 65]
    var RMArray: [Int] = [100, 96, 93, 91, 88, 85, 83, 80, 77, 75, 72, 69,67, 64,61,59,56,53,51,48]
    var selectedRM: Int = 1
    
    init(theController:LibraryExercisePreviewRecordsVC) {
        self.theController = theController
    }
    
    func setupUI() {
        let view = (self.theController.view as? LibraryExercisePreviewRecordsView)
        pickerView.delegate = self.theController
        pickerView.dataSource = self.theController
        pickerView.backgroundColor = UIColor.white
        view?.txtRM.inputView = pickerView
        
        self.showBtnShow(isShow: false)
        if list != nil {
            if newApiConfig {
                view?.lblRM.text = "\(list?.selectedRM ?? 1) RM"
                self.selectedRM = list?.selectedRM ?? 1
                view?.txtKG.text = self.list?.repetitionMax?[self.selectedRM - 1].estWeight?.replace(target: ".0", withString: "") ?? "0"
                
                if view?.lblRM.text == "10 RM"{
                    self.pickerView.selectRow(1, inComponent: 0, animated: false)
                }
            }
            else {
                self.list?.repetitionMax = self.getCommanRM()
                view?.tableView.reloadData()
                self.apiCallCustomCommonLibraryDetails(id: "\(self.list?.id ?? 0)")
            }
        }
        else {
            view?.lblRM.text = (self.libraryPreviewModel?.selectedRM ?? "") + " RM"
            self.selectedRM = Int(self.libraryPreviewModel?.selectedRM ?? "1") ?? 1
            view?.txtKG.text = self.libraryPreviewModel?.repetitionMax?[self.selectedRM - 1].estWeight?.replace(target: ".0", withString: "") ?? "0"
            
            print("txtKG : \(view?.txtKG.text)")
            if view?.lblRM.text == "10 RM"{
                self.pickerView.selectRow(1, inComponent: 0, animated: false)
            }
        }
    }
    
    func showBtnShow(isShow:Bool = true) {
        let view = (self.theController.view as? LibraryExercisePreviewRecordsView)
        view?.btnSave.isHidden = !isShow
        view?.viewSave.isHidden = !isShow
        view?.heightViewSave.constant = isShow ? 69 : 0
    }
    
    func editLibrary() {
        let model = self.libraryPreviewModel
        let repetitionMax: NSMutableArray = NSMutableArray()
        for data in (model?.repetitionMax)! {
            let dict: NSDictionary = ["name":data.name!, "est_weight":data.estWeight!, "act_weight":data.actWeight!]
            repetitionMax.add(dict)
        }
        
        var array: [String] = []
        for data in model?.targetedMusclesIds ?? [] {
            array.append("\(data)")
        }
        
        apiCallUpdateLibrary(id: self.libraryPreviewModel?.id?.stringValue ?? "", exercise: model?.exerciseName ?? "", regionIds: model?.regionsIds ?? [], categoryId: model?.categoryId?.stringValue ?? "", subBodyPartId: model?.bodySubPartId?.stringValue ?? "", mechanicsId: model?.mechanicsId?.stringValue ?? "", targetedMusclesId: array, actionForceId: model?.actionForceId?.stringValue ?? "", equipmentIds: model?.equipmentIds ?? [], repetitionMax: repetitionMax, isFavorite: model?.isFavorite?.stringValue ?? "", isActive: model?.isActive?.stringValue ?? "", exerciseLink: self.libraryPreviewModel?.exerciseLink ?? "", selectedRM: self.selectedRM)
    }
    
    func editCommonLibrary() {
        let model = self.list
        let repetitionMax: NSMutableArray = NSMutableArray()
        for data in (model?.repetitionMax)! {
            
            let strActWeight = data.actWeight ?? ""
            
            var strActWeightFinalValue = ""
            
            if let floatValue = NumberFormatter().number(from: strActWeight){
                strActWeightFinalValue = "\((Double(data.actWeight ?? "") ?? 0).rounded(toPlaces: 1))".replace(target: ".0", withString: "")
            }
            
            print("strActWeightFinalValue : \(strActWeightFinalValue)")
            
            let dict: NSDictionary = ["name":data.name!, "est_weight":data.estWeight!, "act_weight":strActWeightFinalValue]
            repetitionMax.add(dict)
        }
        
        print(repetitionMax)
        self.apiCallCommonUpdateLibrary(id: "\(self.list?.id ?? 0)", selectedRM: self.selectedRM, repetitionMax: repetitionMax)
    }
    
    func apiCallCustomCommonLibraryDetails(id:String) {
        
        let param = ["":""] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakeGetAPI(name: CUSTOM_COMMON_LIBRARY_DETAILS + "/" + id, params: param as [String : Any], progress: false, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let model = CommonRepetitionMax(JSON: data.dictionaryObject!)
                    self.list?.repetitionMax = model?.repetitionMax
                    let view = (self.theController.view as? LibraryExercisePreviewRecordsView)
                    view?.lblRM.text = (model?.selectedRM ?? "1") + " RM"
                    self.selectedRM = Int(model?.selectedRM ?? "1") ?? 1
                    view?.txtKG.text = self.list?.repetitionMax?[self.selectedRM - 1].estWeight?.replace(target: ".0", withString: "") ?? "0"
                    
                    if view?.lblRM.text == "10 RM"{
                        self.pickerView.selectRow(1, inComponent: 0, animated: false)
                    }
                    
                    view?.tableView.reloadData()
                }
                else {
                    self.list?.repetitionMax = self.getCommanRM()
                    let view = (self.theController.view as? LibraryExercisePreviewRecordsView)
                    view?.tableView.reloadData()
                }
                
            }
        }
    }
    
    func apiCallUpdateLibrary(id:String, exercise: String, regionIds: [String], categoryId: String, subBodyPartId: String, mechanicsId: String, targetedMusclesId: [String], actionForceId: String, equipmentIds: [Int], repetitionMax: NSMutableArray, isFavorite: String, isActive: String, exerciseLink:String, selectedRM:Int) {
        
        let param = [
            "exercise_name": exercise,
            "user_id": getUserDetail()?.data?.user?.id?.stringValue ?? "",
            "regions_ids": regionIds,
            "category_id": categoryId,
            "mechanics_id": mechanicsId,
            "targeted_muscles_ids": targetedMusclesId,
            "action_force_id": actionForceId,
            "equipment_ids": equipmentIds,
            "selected_rm" : selectedRM,
            "repetition_max": repetitionMax,
            "is_favorite": isFavorite,
            "is_active": isActive,
            "exercise_link" :exerciseLink
            ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePutAPI(name: LIBRARY_UPDATE + "/" + id, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let success = json.getBool(key: .success)
                let message = json.getString(key: .message)
                
                if success {
                    self.showBtnShow(isShow: false)
                    //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_LIST.LIBRARY_LIST_NOTIFICATION.rawValue), object: nil)
                }
                else {
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    func apiCallCommonUpdateLibrary(id:String, selectedRM:Int, repetitionMax: NSMutableArray) {
        let param = [
            "common_libraries_id": Int(id),
            "selected_rm" : selectedRM,
            "repetition_max": repetitionMax
            ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CREATE_UPDATE_COMMON_LIBRARY_DETAILS, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                let message = json.getString(key: .message)
                
                if success {
                    self.showBtnShow(isShow: false)
                }
                else {
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    func getCommanRM() -> [RepetitionMax] {
        var modelArray: [RepetitionMax] = []
        for data in getDefaultJSON().array ?? [] {
            modelArray.append(RepetitionMax(JSON: data.dictionaryObject!)!)
        }
        return modelArray
    }
    
    func calculateRM(value:CGFloat, index:Int) -> [Double] {
        
        print("Text Value:\(value)")
        print("Index:\(index)")
        
        var array: [Double] = []
        for (i, data) in self.RMArray.enumerated() {
            if i == index {
                array.append(Double(value))
            }
            else {
                let rm = self.RMArray[index]
                print("rm:\(rm)")
                print("Data:\(data)")
                let value1 = Double(data) / Double(rm) * Double(value)
                array.append(value1.rounded(toPlaces: 1))
            }
        }
        return array
    }
    
    func getDefaultJSON() -> JSON {
        return JSON([
            [
                "name": "1 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "2 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "3 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "4 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "5 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "6 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "7 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "8 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "9 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "10 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "11 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "12 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "13 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "14 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "15 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "16 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "17 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "18 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "19 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
            [
                "name": "20 RM",
                "est_weight": "0",
                "act_weight": "0"
            ],
        ])
    }
}

