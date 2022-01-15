//
//  CreateTrainingVC.swift
//  Load
//
//  Created by Haresh Bhai on 03/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateTrainingVC: UIViewController, dismissSelectTrainingProgramDelegate {
    
    //MARK:- Variables
    lazy var mainView: CreateTrainingView = { [unowned self] in
        return self.view as! CreateTrainingView
    }()
    
    lazy var mainModelView: CreateTrainingViewModel = {
        return CreateTrainingViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Create_key"))
        self.navigationController?.setColor()
        self.mainView.setupUI()
        self.mainModelView.setupUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnTrainingProgramClicked(_ sender: Any) {
        
        //Old flow
        /*
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateTrainingProgramVC") as! CreateTrainingProgramVC
        obj.mainModelView.delegateTrainingProgram = self
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)
         */
        
        //New Flow
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "SelectTrainingProgramVC") as! SelectTrainingProgramVC
        obj.mainModelView.delegateDismiss = self
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnTrainingLogClicked(_ sender: Any) {
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateTrainingLogVC") as! CreateTrainingLogVC
        obj.selectedDateFromCalendar = self.mainModelView.selectedDateFromCalendar
//        obj.mainView.selectedDateFromCalendar = self.mainModelView.selectedDateFromCalendar
//        obj.mainModelView.selectedDateFromCalendar = self.mainModelView.selectedDateFromCalendar
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func dismissSelectTrainingProgram() {
        self.mainModelView.delegateCreateTraining?.dismissCreateTraining()
        self.dismiss(animated: false, completion: nil)
    }

}
