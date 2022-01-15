//
//  ResistanceTrainingProgramPreviewVC.swift
//  Load
//
//  Created by Haresh Bhai on 24/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol dismissResistanceTrainingProgramPreviewDelegate {
    func dismissResistanceTrainingProgramPreview()
}

class ResistanceTrainingProgramPreviewVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: ResistanceTrainingProgramPreviewView = { [unowned self] in
        return self.view as! ResistanceTrainingProgramPreviewView
        }()
    
    lazy var mainModelView: ResistanceTrainingProgramPreviewViewModel = {
        return ResistanceTrainingProgramPreviewViewModel(theController: self)
    }()
    
    var delegateDismissResistanceTrainingProgramPreview: dismissResistanceTrainingProgramPreviewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
}
