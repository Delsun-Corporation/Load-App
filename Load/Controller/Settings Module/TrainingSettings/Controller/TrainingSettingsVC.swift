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
        self.mainView?.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Training_key"), color:UIColor.black)
        self.navigationController?.setWhiteColor()
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
    
    func openUnits() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "UnitsVC") as! UnitsVC
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedId = self.mainModelView.txtTypesId
        obj.mainModelView.selectedTitle = self.mainModelView.txtTypes
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func UnitsFinish(id: String, title: String) {
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
        obj.mainModelView.bikeFrontChainWheel = self.mainModelView.bikeFrontChainWheel
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func moveToRunningTimeController(){
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "RunningTimeVc") as! RunningTimeVc
        self.navigationController?.pushViewController(obj, animated: true)
    }

    func moveToTimeUnderTensionController(){
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "TimerUnderTensionVc") as! TimerUnderTensionVc
        obj.mainModelView.setTimeUnderTensionDelegate(delegate: self.mainModelView)
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    func moveToAutoPauseController(){
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "AutoPauseVc") as! AutoPauseVc
        obj.mainModelView.isRunAutoPause = self.mainModelView.isRunAutoPause
        obj.mainModelView.isCycleAutoPause = self.mainModelView.isCycleAutoPause
        
        obj.handerUpdateAutoPause = {[weak self] (runAutoPause,cycleAutoPause) in
            print("Run auto-pause:\(runAutoPause)")
            print("Cycle auto-pause:\(cycleAutoPause)")
            
            self?.mainModelView.isRunAutoPause = runAutoPause
            self?.mainModelView.isCycleAutoPause = cycleAutoPause
            self?.mainModelView.apiCallSettingCreateUpdateProgram()
            
        }
        self.navigationController?.pushViewController(obj, animated: true)
    }
}

//MARK: - Heart Rate delegate
extension TrainingSettingsVC: HeartRateDelegate {
    func HeartRateFinish(HRMaxValue: String, HRRestValue: String,isHrMaxIsEstimated:Bool) {
        print("HRMaxalue : \(HRMaxValue)")
        print("isHrMaxIsEstimated : \(isHrMaxIsEstimated)")
        self.mainModelView.txtHRMax = HRMaxValue
        self.mainModelView.txtHRRest = HRRestValue
        self.mainModelView.isHrMaxIsEstimated = isHrMaxIsEstimated
        
        self.mainModelView.apiCallSettingCreateUpdateProgram()

    }
    
}
//MARK: - Physical activityId
extension TrainingSettingsVC: PhysicalAcitivtyFinishSelection{
    func selectedPhysicalActivity(id: String) {
        self.mainModelView.selectedPhysicalActivityId = id
        self.mainModelView.apiCallSettingCreateUpdateProgram()
    }
    
}

//MARK:  - Bike delegate

extension TrainingSettingsVC: BikeSetttingSelectFinishDelegate{
    
    func BikeData(bikeWeight: CGFloat, bikeWheelDiameter: CGFloat, bikeFrontChainWheel: Int, rearFreeWheel: Int) {
        
        self.mainModelView.bikeWeight = bikeWeight
        self.mainModelView.bikeWheelDiameter = bikeWheelDiameter
        self.mainModelView.bikeFrontChainWheel = bikeFrontChainWheel
        self.mainModelView.bikeRearFreeWheel = rearFreeWheel
        
        self.mainModelView.apiCallSettingCreateUpdateProgram()
        
    }
    
}
