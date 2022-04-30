//
//  TrainingSettingsVC.swift
//  Load
//
//  Created by Haresh Bhai on 30/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class TrainingSettingsVC: UIViewController, UnitstDelegate {
  
    //MARK:- @IBOutlet
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK:- Variables
    lazy var mainView: TrainingSettingsView? = { [unowned self] in
        return self.view as? TrainingSettingsView
    }()
    
    lazy var mainModelView: TrainingSettingsViewModel = {
        return TrainingSettingsViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // this save button is set in default navigation bar not in custom
        self.btnSave.isHidden = true
        self.mainView?.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Training_key"))
        self.navigationController?.setWhiteColor()
        self.navigationController?.removeShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController?.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }

    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
    
    func openUnits() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "UnitsVC") as! UnitsVC
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedId = self.mainModelView.txtTypesId
        obj.mainModelView.selectedTitle = self.mainModelView.txtTypes
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func UnitsFinish(id: Int, title: String) {
        self.btnSave.isHidden = false
        self.mainModelView.txtTypesId = id
        self.mainModelView.txtTypes = title
        self.mainModelView.apiCallSettingCreateUpdateProgram()
    }
    
    func moveToPhysicActivityLevelController(){
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "PhysicalActivityLevelVc") as! PhysicalActivityLevelVc
        obj.mainModelView.delegateFinishActivityLevel = self
        obj.mainModelView.selectedPhysicalActivityId = self.mainModelView.selectedPhysicalActivityId
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func moveToHeartRateController(){
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "HeartRateVc") as! HeartRateVc
        obj.mainModelView.delegate = self
        obj.mainModelView.targatHRMax = self.mainModelView.txtHRMax
        obj.mainModelView.targatHRRest = self.mainModelView.txtHRRest
        obj.mainModelView.isHrMaxIsEstimated = self.mainModelView.isHrMaxIsEstimated
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func moveToBikeSettingController(){
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "BikeSettingVc") as! BikeSettingVc
        obj.mainModelView.delegateBike = self
        obj.mainModelView.bikeWeight = self.mainModelView.bikeWeight
        obj.mainModelView.bikeWheelDiameter = self.mainModelView.bikeWheelDiameter
        obj.mainModelView.bikeRearFreeWheel = self.mainModelView.bikeRearFreeWheel
        obj.mainModelView.bikeFrontChainWheel = self.mainModelView.bikeRearFreeWheel
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func moveToRunningTimeController(){
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "RunningTimeVc") as! RunningTimeVc
        self.navigationController?.pushViewController(obj, animated: true)
    }

    func moveToTimeUnderTensionController(){
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "TimerUnderTensionVc") as! TimerUnderTensionVc
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func moveToAutoPauseController(){
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "AutoPauseVc") as! AutoPauseVc
        obj.mainModelView.isRunAutoPause = self.mainModelView.isRunAutoPause
        obj.mainModelView.isCycleAutoPause = self.mainModelView.isCycleAutoPause
        
        obj.handerUpdateAutoPause = {[weak self] (runAutoPause,cycleAutoPause) in
            print("Run auto-pause:\(runAutoPause)")
            print("Cycle auto-pause:\(cycleAutoPause)")
            
            self?.btnSave.isHidden = false
            self?.mainModelView.isRunAutoPause = runAutoPause
            self?.mainModelView.isCycleAutoPause = cycleAutoPause
            self?.mainModelView.apiCallSettingCreateUpdateProgram()
            
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func navigationSaveButtonShowOrHide(){
        
        //Call this method if Client want to remove auto save functionality
        //It is apply when write btnSave.isHidden = false
        
        if let viewWithTag = self.navigationController?.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
            
            self.mainModelView.setupNavigationbar(title: getCommonString(key: "Training_key"))
            self.navigationController?.setWhiteColor()
            self.navigationController?.removeShadow()

        }

//        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
//            vwnav.btnSave.isHidden = self.btnSave.isHidden
//        }
    }
}

//MARK: - Heart Rate delegate
extension TrainingSettingsVC: HeartRateDelegate {
    func HeartRateFinish(HRMaxValue: String, HRRestValue: String,isHrMaxIsEstimated:Bool) {
        print("HRMaxalue : \(HRMaxValue)")
        print("isHrMaxIsEstimated : \(isHrMaxIsEstimated)")

        if self.mainModelView.txtHRMax != HRMaxValue || self.mainModelView.txtHRRest != HRRestValue{
            self.btnSave.isHidden = false
        }
        
        self.mainModelView.txtHRMax = HRMaxValue
        self.mainModelView.txtHRRest = HRRestValue
        self.mainModelView.isHrMaxIsEstimated = isHrMaxIsEstimated
        
        self.mainModelView.apiCallSettingCreateUpdateProgram()

    }
    
}
//MARK: - Physical activityId
extension TrainingSettingsVC: PhysicalAcitivtyFinishSelection{
    func selectedPhysicalActivity(id: Int) {
        self.btnSave.isHidden = false
        self.mainModelView.selectedPhysicalActivityId = id
        self.mainModelView.apiCallSettingCreateUpdateProgram()
    }
    
}

//MARK:  - Bike delegate

extension TrainingSettingsVC: BikeSetttingSelectFinishDelegate{
    
    func BikeData(bikeWeight: CGFloat, bikeWheelDiameter: CGFloat, bikeFrontChainWheel: Int, rearFreeWheel: Int) {
        
        if self.mainModelView.bikeWeight != bikeWeight || self.mainModelView.bikeWheelDiameter != bikeWheelDiameter || self.mainModelView.bikeFrontChainWheel != bikeFrontChainWheel || self.mainModelView.bikeRearFreeWheel != rearFreeWheel{
            self.btnSave.isHidden = false
        }
        
        self.mainModelView.bikeWeight = bikeWeight
        self.mainModelView.bikeWheelDiameter = bikeWheelDiameter
        self.mainModelView.bikeFrontChainWheel = bikeFrontChainWheel
        self.mainModelView.bikeRearFreeWheel = rearFreeWheel
        
        self.mainModelView.apiCallSettingCreateUpdateProgram()
        
    }
    
}
