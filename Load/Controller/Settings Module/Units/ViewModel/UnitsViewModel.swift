//
//  UnitsViewModel.swift
//  Load
//
//  Created by iMac on 23/01/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol UnitstDelegate: AnyObject {
    func UnitsFinish(id: Int, title: String, units: [[String: Any]]?)
}

class UnitsViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:UnitsVC!
    var selectedId:Int = 0
    var selectedTitle:String = ""
    weak var delegate:UnitstDelegate?
    var profileDetails: UnitsModelClass?
    var isUpdated:Bool = false

    //MARK:- Functions
    init(theController:UnitsVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.getUnitsList()
    }
    
    func selectUnit(in unitIndex: Int) {
        // Deselect all units beside the selected index first
        guard let profileDetails = profileDetails?.data else {
            return
        }
        
        for (index, datum) in profileDetails.enumerated() {
            datum.isSelected = index == unitIndex
        }
    }
    
    func convertTrainingUnitsDataToDict() -> [[String: Any]]? {
        guard let profileDetails = profileDetails?.data, !profileDetails.isEmpty else {
            return nil
        }
        var dictToSave = [[String: Any]]()
        for datum in profileDetails {
            let param = [
                "title": datum.title,
                "description": datum.description ?? "",
                "is_selected": datum.isSelected
            ] as [String : Any]
            
            dictToSave.append(param)
        }
        
        return dictToSave
    }
    
    func getUnitsList() {
        let param = ["": ""] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakeGetAPI(name: ALL_TRAINING_UNITS_LIST , params: param as [String : Any], progress: true, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    self.profileDetails = UnitsModelClass(JSON: json.dictionaryObject!)
                    let view = (self.theController.view as? UnitsView)
                    view?.tableView.reloadData()
                }
                else {
                    
                }
            }
        })
    }
}
