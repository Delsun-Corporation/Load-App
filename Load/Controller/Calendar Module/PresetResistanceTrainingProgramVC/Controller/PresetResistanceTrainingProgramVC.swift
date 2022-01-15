//
//  PresetResistanceTrainingProgramVC.swift
//  Load
//
//  Created by Haresh Bhai on 24/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class PresetResistanceTrainingProgramVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: PresetResistanceTrainingProgramView = { [unowned self] in
        return self.view as! PresetResistanceTrainingProgramView
        }()
    
    lazy var mainModelView: PresetResistanceTrainingProgramViewModel = {
        return PresetResistanceTrainingProgramViewModel(theController: self)
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
