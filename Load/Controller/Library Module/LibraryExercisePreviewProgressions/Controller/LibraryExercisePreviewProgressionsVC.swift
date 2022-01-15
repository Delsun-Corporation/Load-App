//
//  LibraryExercisePreviewProgressionsVC.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LibraryExercisePreviewProgressionsVC: UIViewController, LibraryChartViewDelegate {
    
    //MARK:- Variables
    lazy var mainView: LibraryExercisePreviewProgressionsView = { [unowned self] in
        return self.view as! LibraryExercisePreviewProgressionsView
        }()
    
    lazy var mainModelView: LibraryExercisePreviewProgressionsViewModel = {
        return LibraryExercisePreviewProgressionsViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        // Do any additional setup after loading the view.
    }
    
    func LibraryChartViewFinish(isNext: Bool) {
        if isNext {
            self.mainModelView.selectedDate = self.mainModelView.selectedDate.getNextMonth() ?? Date()
        }
        else {
            self.mainModelView.selectedDate = self.mainModelView.selectedDate.getPreviousMonth() ?? Date()
        }
        self.mainModelView.setupUI()
    }
}
