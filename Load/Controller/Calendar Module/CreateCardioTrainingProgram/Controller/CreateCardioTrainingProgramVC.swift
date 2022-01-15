//
//  CreateCardioTrainingProgramVC.swift
//  Load
//
//  Created by Haresh Bhai on 16/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol dismissPresetTrainingProgramScreenDelegate {
    func dismissPresetTrainingProgramScreen()
}

class CreateCardioTrainingProgramVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CreateCardioTrainingProgramView = { [unowned self] in
        return self.view as! CreateCardioTrainingProgramView
        }()
    
    lazy var mainModelView: CreateCardioTrainingProgramViewModel = {
        return CreateCardioTrainingProgramViewModel(theController: self)
    }()
    
    var delegateDismissPresetTrainigProgram: dismissPresetTrainingProgramScreenDelegate?
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewWithTag = self.navigationController!.view.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }

        navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.setWhiteColor()
        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
}

extension CreateCardioTrainingProgramVC: dismissCardioTrainingProgramDelegate {
    
    func dismissCreateCardioTrainingProgram(){
        self.dismiss(animated: false, completion: nil)
        self.delegateDismissPresetTrainigProgram?.dismissPresetTrainingProgramScreen()
    }
    
}
