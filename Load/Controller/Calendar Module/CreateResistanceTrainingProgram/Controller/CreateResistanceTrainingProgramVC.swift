//
//  CreateResistanceTrainingProgramVC.swift
//  Load
//
//  Created by Haresh Bhai on 24/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol dimissCreateResistanceScreenDelegate {
    func dismisCreateResistanceScreen()
}

class CreateResistanceTrainingProgramVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CreateResistanceTrainingProgramView = { [unowned self] in
        return self.view as! CreateResistanceTrainingProgramView
        }()
    
    lazy var mainModelView: CreateResistanceTrainingProgramViewModel = {
        return CreateResistanceTrainingProgramViewModel(theController: self)
    }()
    
    var delegateDimissCreateResistanceScreen: dimissCreateResistanceScreenDelegate?
    
    //MARK:- Functions
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

extension CreateResistanceTrainingProgramVC: dismissResistanceTrainingProgramPreviewDelegate  {
    
    func dismissResistanceTrainingProgramPreview(){
        self.dismiss(animated: false, completion: nil)
        self.delegateDimissCreateResistanceScreen?.dismisCreateResistanceScreen()
    }
}
