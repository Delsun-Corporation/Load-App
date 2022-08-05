//
//  PhysicalActivityLevelViewModel.swift
//  Load
//
//  Created by iMac on 18/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

protocol PhysicalAcitivtyFinishSelection {
    func selectedPhysicalActivity(id: Int)
}

import Foundation
import SwiftyJSON

class PhysicalActivityLevelViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:PhysicalActivityLevelVc!
    var profileDetails: PhysicalActivityModelClass?
    var selectedPhysicalActivityId = 0
    var isUpdated:Bool = false
    var delegateFinishActivityLevel : PhysicalAcitivtyFinishSelection?
    
    //MARK:- Functions
    init(theController:PhysicalActivityLevelVc) {
        self.theController = theController
    }
    
    func setupUI(){
        getPhysicalActivityList()
    }

}

//MARK: - API Calling
extension PhysicalActivityLevelViewModel {
    
    func getPhysicalActivityList() {
        let param = ["": ""] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakeGetAPI(name: ALL_PHYSICAL_ACTIVITY_LIST , params: param as [String : Any], progress: true, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    self.profileDetails = PhysicalActivityModelClass(JSON: json.dictionaryObject!)
                    let view = (self.theController.view as? PhysicalActivityLevelView)
                    view?.tblPhysicalActivity.reloadData()
                }
                else {
                    
                }
            }
        })
    }

}
