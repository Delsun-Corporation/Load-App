//
//  CreateRequestStepOneVC.swift
//  Load
//
//  Created by Haresh Bhai on 22/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateRequestStepOneVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: CreateRequestStepOneView = { [unowned self] in
        return self.view as! CreateRequestStepOneView
    }()
    
    lazy var mainModelView: CreateRequestStepOneViewModel = {
        return CreateRequestStepOneViewModel(theController: self)
    }()

    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.setColor()
        self.mainView.setupUI()
        self.mainModelView.setupUI()  
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Create_request_title"))
    }
    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnStartDateClicked(_ sender: Any) {
        if self.mainView.txtStartTraining.text?.toTrim() == "" {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeStyle = DateFormatter.Style.none
            dateFormatter.dateFormat = "MM/dd/yyyy"
            self.mainView.txtStartTraining.text = dateFormatter.string(from: Date())
            self.mainModelView.selectedDateStartTraining =  Date()
            
        }
        self.mainView.txtStartTraining.becomeFirstResponder()
    }    
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.mainModelView.validateDetails()    
     }
}
