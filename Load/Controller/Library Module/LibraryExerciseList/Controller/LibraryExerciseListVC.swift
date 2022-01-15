//
//  LibraryExerciseListVC.swift
//  Load
//
//  Created by Haresh Bhai on 05/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
class LibraryExerciseListVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: LibraryExerciseListView = { [unowned self] in
        return self.view as! LibraryExerciseListView
    }()
    
    lazy var mainModelView: LibraryExerciseListViewModel = {
        return LibraryExerciseListViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SELECTED_EXERCISE_LIBRARY_TAB = (self.mainModelView.bodyParts?.id?.stringValue)!
        if self.mainModelView.isFilter {
            self.mainModelView.apiCallSearchLibraryList(searchText: self.mainModelView.searchText, status: (self.mainModelView.bodyParts?.code)!, id: (self.mainModelView.bodyParts?.id?.stringValue)!, isLoading: false)
        }
    }
}
