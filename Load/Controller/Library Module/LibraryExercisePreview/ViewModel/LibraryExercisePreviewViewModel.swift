//
//  LibraryExercisePreviewViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CarbonKit
import SwiftyJSON

class LibraryExercisePreviewViewModel {

    // MARK: Variables
    fileprivate weak var theController:LibraryExercisePreviewVC!
    var isOpen:Bool = false
    var items = NSArray()
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    var libraryId: String = ""
    var libraryPreviewModel : LibraryListPreviewModelClass?
    
    var handlerForExerciseName : (String) -> Void = {_ in}

    init(theController:LibraryExercisePreviewVC) {
        self.theController = theController
    }
    
    func setupUI() {
       
        print("Library Id : \(libraryId)")
        
        if libraryId != "" {
            theController.mainModelView.apiCallLibraryShow(id: self.libraryId)
        }
        else {
            let view = (self.theController.view as? LibraryExercisePreviewView)
            //TODO: - Yash changes
            self.handlerForExerciseName(theController.mainView.listComman?.exerciseName ?? "")
            view?.setupUICarbonTab(theController: self.theController)
        }
    }
    
}

//MARK: - API calling

extension LibraryExercisePreviewViewModel{
    
    //For custom library show
    func apiCallLibraryShow(id: String) {
        
        let param = ["" : ""] as [String : Any]
        
        ApiManager.shared.MakeGetAPI(name: LIBRARY_SHOW + "/" + id, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let model = LibraryListPreviewModelClass(JSON: data.dictionaryObject!)
                    self.libraryPreviewModel = model
                    let view = (self.theController.view as? LibraryExercisePreviewView)
                    view?.libraryPreviewModel = model
                    //TODO: - Yash Changes
                    print("Model : \(String(describing: model?.exerciseName))")
                    self.handlerForExerciseName(model?.exerciseName ?? "")
                    view?.setupUICarbonTab(theController: self.theController)
                }
                else {
                    let view = (self.theController.view as? LibraryExerciseListMainView)
                    view?.tableView.reloadData()
                }
            }
        }
    }
}
