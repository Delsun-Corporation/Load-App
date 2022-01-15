//
//  CreateTrainingLogViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit
import SwiftyJSON

class CreateTrainingLogViewModel {

    //MARK:- Variables
    fileprivate weak var theController:CreateTrainingLogVC!
    var items = NSArray()
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var tabIndex:Int = 0
    var previewData: TrainingLogModelClass?
    var previewDataResistance: TrainingLogResistanceModelClass?
    var isEditCardio: Bool = false
    var isEditResistance: Bool = false
    
    var arrayHeader : [JSON] = []
    var pastSelectedIndex = 0
    
    //MARK:- Functions
    init(theController:CreateTrainingLogVC) {
        self.theController = theController
    }
    
    func setupUI() {
        setArrayHeader()
    }
    
    func setArrayHeader(){
        
        var dictData = JSON()
        dictData["unselectedImage"].stringValue = "ic_cardio_unselect"
        dictData["selectedImage"].stringValue = "ic_cardio"
        dictData["name"].stringValue = "Cardio"
        dictData["selected"].stringValue = self.pastSelectedIndex == 0 ? "1" : "0"
        self.arrayHeader.append(dictData)
        
        dictData = JSON()
        dictData["unselectedImage"].stringValue = "ic_gym_icon"
        dictData["selectedImage"].stringValue = "ic_gym_icon_select"
        dictData["name"].stringValue = "Resistance"
        dictData["selected"].stringValue = self.pastSelectedIndex == 1 ? "1" : "0"
        self.arrayHeader.append(dictData)
        
    }
}
