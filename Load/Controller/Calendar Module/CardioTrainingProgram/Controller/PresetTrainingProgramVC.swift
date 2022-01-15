//
//  PresetTrainingProgramVC.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class PresetTrainingProgramVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: PresetTrainingProgramView = { [unowned self] in
        return self.view as! PresetTrainingProgramView
        }()
    
    lazy var mainModelView: PresetTrainingProgramViewModel = {
        return PresetTrainingProgramViewModel(theController: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: "Let's set up\nyour preset training program")
    }
}
