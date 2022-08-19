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
    
    var handlerForExerciseName : (String) -> Void = {_ in}

    init(theController:LibraryExercisePreviewVC) {
        self.theController = theController
    }
    
    func setupUI() {
        let view = (self.theController.view as? LibraryExercisePreviewView)
        //TODO: - Yash changes
        self.handlerForExerciseName(theController.mainView.listComman?.exerciseName ?? "")
        view?.setupUICarbonTab(theController: self.theController)
    }
    
}
