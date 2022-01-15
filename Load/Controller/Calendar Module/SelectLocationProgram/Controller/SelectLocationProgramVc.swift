//
//  SelectLocationProgramVc.swift
//  Load
//
//  Created by Yash on 16/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class SelectLocationProgramVc: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: SelectLocationProgramView = { [unowned self] in
        return self.view as! SelectLocationProgramView
    }()
    
    lazy var mainModelView: SelectLocationProgramViewModel = {
        return SelectLocationProgramViewModel(theController: self)
    }()

    //handler not working, data Come to this screen but not Training preview screen so not usable for that create Delegate
    var handlerForPassPedometerDistancePace : (Double,Double?) -> Void = { _,_ in}
    var handlerForPassPedometerDate : (Date) -> Void = { _ in}
    var handlerForPassDataOfParticularLapWithPolyline : (String, Double) -> Void = { _ , _ in}
    var handlerNetElevationGain : (Double) -> Void = { _ in}
    var handlerForIndoorParticularLapForReset: (Double) -> Void = {_ in}

    var cameFromButtonClick = MOVE_FROM_START_OR_COMPLETED_TRAINING_PROGRAM_CARDIO.clickOnStart
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Select_your_location_key"))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }
    }

    @IBAction func btnIndoorTapped(_ sender: UIButton) {
        
        if self.cameFromButtonClick == .clickOnStart {
            self.mainModelView.isSelectIndoor = true
            self.mainModelView.handlerActivitySelectionName(getCommonString(key: "Indoor_key"))
            
            let obj: CountDownVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CountDownVC") as! CountDownVC
            obj.mainModelView.delegate = self
            obj.modalPresentationStyle = .overFullScreen
            self.present(obj, animated: true, completion: nil)
        }else{
            self.mainModelView.handlerActivitySelectionName(getCommonString(key: "Indoor_key"))
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnOutdoorTapped(_ sender: UIButton) {
        
        if self.cameFromButtonClick == .clickOnStart {
            
            self.mainModelView.isSelectIndoor = false
            self.mainModelView.handlerActivitySelectionName(getCommonString(key: "Outdoor_key"))
            
            let obj: CountDownVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CountDownVC") as! CountDownVC
            obj.mainModelView.delegate = self
            obj.modalPresentationStyle = .overFullScreen
            self.present(obj, animated: true, completion: nil)
        }else{
            self.mainModelView.handlerActivitySelectionName(getCommonString(key: "Outdoor_key"))
            self.dismiss(animated: true, completion: nil)

        }
    }
    
}

//MARK: - Countdown delegate

extension SelectLocationProgramVc: CountDownViewDelegate{
    
    func CountDownViewFinish(tag:Int) {
        self.startWorkout()
    }
    
    func startWorkout(){
        
        let obj: StartWorkoutVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "StartWorkoutVC") as! StartWorkoutVC
        obj.mainModelView.delegate = self
        obj.mainModelView.isRunAutoPause = self.mainModelView.isRunAutoPause
        obj.mainModelView.trainingProgramId = self.mainModelView.trainingProgramId

        if self.mainModelView.isSelectIndoor {
            obj.mainModelView.activityName = getCommonString(key: "Indoor_key")
        }else{
            obj.mainModelView.activityName = getCommonString(key: "Outdoor_key")
        }
        obj.mainModelView.exerciseArray = self.mainModelView.exerciseArray
        obj.modalPresentationStyle = .overFullScreen
        
        obj.handlerForPassPedometerDistancePace = {[weak self] (distance,pace) in
            print("Distance check in location screen:\(distance)")
            self?.handlerForPassPedometerDistancePace(distance,pace)
            self?.mainModelView.delegateForSelectLocationProgram?.pedometerDistancePace(distance: distance, Pace: pace ?? 0)
        }
        obj.handlerForPassPedometerDate = {[weak self] (startDate) in
            self?.handlerForPassPedometerDate(startDate)
            self?.mainModelView.delegateForSelectLocationProgram?.passpedometerDate(startDate: startDate)
        }
        obj.handlerForPassDataOfParticularLapWithPolyline = {[weak self] (strPolyline,lapDistance) in
            self?.handlerForPassDataOfParticularLapWithPolyline(strPolyline,lapDistance)
            self?.mainModelView.delegateForSelectLocationProgram?.passDataOfParticularLapWithPolyline(strPolyline: strPolyline, lapDistance: lapDistance)
        }
        
        obj.mainModelView.handlerStopActivityUpdate = {[weak self] in
            self?.mainModelView.handlerStopActivityUpdate()
        }
        
        obj.mainModelView.handlerFinishWorkoutOnEndClick = {[weak self] (image) in
            self?.mainModelView.handlerFinishWorkoutOnEndClick(image)
        }
        
        obj.handlerNetElevationGain = {[weak self] (elevation) in
            self?.handlerNetElevationGain(elevation)
            self?.mainModelView.delegateForSelectLocationProgram?.netElevationGain(elevationGain: elevation)
        }
        
        obj.mainModelView.handlerPauseOrNot = {[weak self] (isPause) in
            self?.mainModelView.handlerPauseOrNot(isPause)
            self?.mainModelView.delegateForSelectLocationProgram?.clickOnPauseOrNot(isPause: isPause)
        }
        
        obj.handlerForIndoorParticularLapForReset = {[weak self] (distanceForIndoor) in
            self?.handlerForIndoorParticularLapForReset(distanceForIndoor)
            self?.mainModelView.delegateForSelectLocationProgram?.indoorParticularLapForReset(distance: distanceForIndoor)
        }
        
        self.present(obj, animated: true, completion: nil)
    }
}

//MARK: - WorkoutFinish Delegate
extension SelectLocationProgramVc : StartWorkoutDelegate{
    
    func StartWorkoutFinish(isDone: Bool, exerciseArray: [WeekWiseWorkoutLapsDetails]) {
        
        self.mainModelView.delegate?.StartWorkoutFinish(isDone: isDone, exerciseArray: exerciseArray)
    }
    
    func currentWorkedLapIndex(index: Int) {
        self.mainModelView.delegate?.currentWorkedLapIndex(index: index)
    }
    
    func repeatWokout() {
        self.mainModelView.delegate?.reloadTblData()
    }
    
    func reloadTblData() {
        self.mainModelView.delegate?.reloadTblData()
    }
    
    func closeViewDismissSelectLocationProgram() {
        self.dismiss(animated: false, completion: nil)
        self.mainModelView.delegate?.closeViewDismissSelectLocationProgram()
        
    }
    
}

