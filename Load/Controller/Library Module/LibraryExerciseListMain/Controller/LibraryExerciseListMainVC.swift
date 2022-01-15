//
//  LibraryExerciseListMainVC.swift
//  Load
//
//  Created by Haresh Bhai on 12/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LibraryExerciseListMainVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: LibraryExerciseListMainView = { [unowned self] in
        return self.view as! LibraryExerciseListMainView
        }()
    
    lazy var mainModelView: LibraryExerciseListMainViewModel = {
        return LibraryExerciseListMainViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SELECTED_LIBRARY_TAB = self.mainModelView.category?.id?.stringValue ?? ""
        if self.mainModelView.isFilter {
            self.mainModelView.apiCallSearchLibraryList(searchText: self.mainModelView.searchText, status: (self.mainModelView.category?.code)!, id: (self.mainModelView.category?.id?.stringValue)!, isLoading: false)
        }
        else {
            if self.mainModelView.category != nil {
                self.mainModelView.apiCallLibraryList(status: (self.mainModelView.category?.code)!, id: (self.mainModelView.category?.id?.stringValue)!, isLoading: false)
            }
        }
    }
}
