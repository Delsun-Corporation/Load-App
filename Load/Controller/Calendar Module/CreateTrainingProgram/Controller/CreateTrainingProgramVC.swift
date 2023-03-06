//
//  CreateTrainingProgramVC.swift
//  Load
//
//  Created by Haresh Bhai on 14/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateTrainingProgramVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: CreateTrainingProgramView = { [unowned self] in
        return self.view as! CreateTrainingProgramView
    }()
    
    lazy var mainModelView: CreateTrainingProgramViewModel = {
        return CreateTrainingProgramViewModel(theController: self)
    }()
    
    var isPresetCickable = false
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.mainModelView.setupNavigationbar(title: "") //getCommonString(key: "Select_your_training_program_key"))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
    }
    
    //MARK:- @IBAction
    @IBAction func btnResistanceClicked(_ sender: Any) {
        //For Preset
        if self.isPresetCickable == true{
            let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "PresetResistanceTrainingProgramVC") as! PresetResistanceTrainingProgramVC
            obj.mainModelView.delegateDismissPreset = self
            let nav = UINavigationController(rootViewController: obj)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true, completion: nil)
        }else{
            //For customise
            
        }
    }
    
    @IBAction func btnCardioClicked(_ sender: Any) {
        //Create common delegate for PresetTrainingProgram and PresetResistanceTrainingProgram
        //For Preset
        if self.isPresetCickable {
            let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "PresetTrainingProgramVC") as! PresetTrainingProgramVC
            obj.mainModelView.delegateDismissPreset = self
            let nav = UINavigationController(rootViewController: obj)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true, completion: nil)
        } else {
            
        }
        
    }
    
    @IBAction func btnEditResistanceProgramTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func btnEditCardioProgramTapped(_ sender: UIButton) {
    }
    
    @IBAction func btnDeleteResistanceProgramTapped(_ sender: UIButton) {
        self.alertForDeleteProgramId(programId: self.mainModelView.dataCheckVisibility?.resistancePresetDeleteId ?? 0)
    }
    
    @IBAction func btnDeleteCardioProgramTapped(_ sender: UIButton) {
        self.alertForDeleteProgramId(programId: self.mainModelView.dataCheckVisibility?.cardioPresetDeleteId ?? 0)
    }
    
    func hideAllView(){
        [self.mainView.vwCardio,self.mainView.vwResistance,self.mainView.vwEditCardio,self.mainView.vwEditResistance,self.mainView.vwDeleteCardio,self.mainView.vwDeleteResistance].forEach { (vw) in
            vw?.isHidden = true
        }
        
    }
    
    //MARK: - Other functions
    
    func alertForDeleteProgramId(programId: Int){
        print("ProgramId :]\(programId)")
        
        let alertController = UIAlertController(title: getCommonString(key: "Delete_program_key"), message: getCommonString(key: "Delete_program_msg_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Remove_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            
            self.mainModelView.apiCallForDeleteProgram(programId: programId)
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "Cancel_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
}

//MARK: - SetupData

extension CreateTrainingProgramVC{
    
    func setupData(){
        
        var title = "Choose the mode of workout\nthat you’d like to create."
        
        if self.mainModelView.dataCheckVisibility?.isCardio == true {
            self.mainView.vwCardio.isHidden = false
            title = "Choose the mode of workout\nthat you’d like to create."
        }
        
        if self.mainModelView.dataCheckVisibility?.isResistance == true {
            self.mainView.vwResistance.isHidden = false
            title = "Choose the mode of workout\nthat you’d like to create."
        }
        
        if self.isPresetCickable == true {
            if self.mainModelView.dataCheckVisibility?.isCardioPresetDelete == true {
                self.mainView.vwDeleteCardio.isHidden = false
                title = "Make changes to your\ncurrent program"
            }
            
            if self.mainModelView.dataCheckVisibility?.isResistancePresetDelete == true {
                self.mainView.vwDeleteResistance.isHidden = false
                title = "Make changes to your\ncurrent program"
            }
        } else {
            if self.mainModelView.dataCheckVisibility?.isCardioCustomEdit == true {
                self.mainView.vwEditCardio.isHidden = false
                title = "Make changes to your\ncurrent program"
            }
            
            if self.mainModelView.dataCheckVisibility?.isResistanceCustomEdit == true {
                self.mainView.vwEditResistance.isHidden = false
                title = "Make changes to your\ncurrent program"
            }
        }
        
        self.mainModelView.setupNavigationbar(title: title)
        
    }
}

//MARK: - DimissPreset screen delegate
extension CreateTrainingProgramVC: dismissAndRefreshData{
    func dismissPreset() {
        self.dismiss(animated: false, completion: nil)
        self.mainModelView.delegateTrainingProgram?.onlyDismissTrainingProgram()
    }
}

