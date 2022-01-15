//
//  CardioTrainingProgramPreviewVC.swift
//  Load
//
//  Created by Haresh Bhai on 17/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol dismissCardioTrainingProgramDelegate {
    func dismissCreateCardioTrainingProgram()
}

class CardioTrainingProgramPreviewVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CardioTrainingProgramPreviewView = { [unowned self] in
        return self.view as! CardioTrainingProgramPreviewView
        }()
    
    lazy var mainModelView: CardioTrainingProgramPreviewViewModel = {
        return CardioTrainingProgramPreviewViewModel(theController: self)
    }()
    
    var delegateDismissCardioTrainingProgram:dismissCardioTrainingProgramDelegate?
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
}
