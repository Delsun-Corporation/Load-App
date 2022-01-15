//
//  CreateTrainingLogVC.swift
//  Load
//
//  Created by Haresh Bhai on 04/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateTrainingLogVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: CreateTrainingLogView = { [unowned self] in
        return self.view as! CreateTrainingLogView
    }()
    
    lazy var mainModelView: CreateTrainingLogViewModel = {
        return CreateTrainingLogViewModel(theController: self)
    }()
    
    var selectedDateFromCalendar = ""
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainModelView.setupUI()
        
        print("ARray:\(self.mainModelView.arrayHeader)")
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setColor()
        self.mainView.setupUI(theController: self, isEditCardio: self.mainModelView.isEditCardio, isEditResistance: self.mainModelView.isEditResistance, previewData: self.mainModelView.previewData ?? nil, previewDataResistance: self.mainModelView.previewDataResistance ?? nil,selectedDateFromCalendar: self.selectedDateFromCalendar)
        
        print("ARray:\(self.mainModelView.arrayHeader)")
        
        // Do any additional setup after loading the view.
    }

    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}
