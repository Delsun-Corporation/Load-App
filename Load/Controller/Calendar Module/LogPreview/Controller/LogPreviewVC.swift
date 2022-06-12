//
//  LogPreviewVC.swift
//  Load
//
//  Created by Haresh Bhai on 07/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreMotion
import GoogleMaps
import Polyline

class LogPreviewVC: UIViewController, NewMessageSelectDelegate, CountDownViewDelegate {
    
    //MARK:- Variables
    @IBOutlet weak var btnEdit: UIButton!

    lazy var mainView: LogPreviewView = { [unowned self] in
        return self.view as! LogPreviewView
    }()
    
    lazy var mainModelView: LogPreviewViewModel = {[weak self] in
        return LogPreviewViewModel(theController: self)
    }()
    
    //MARK: - variable
    
    var isAlreadyCall = false
    var activityManager  : CMMotionActivityManager?
    var pedometer : CMPedometer?
    @IBOutlet weak var btnRightBarButton: UIBarButtonItem!
    
    var isRecallMainCountingSteps = true
    
    var timerForMotion : Timer?
    var countForMotion = 0
    
    var countForTotalStationaryTime = 0
    
    var isAutoPauseCheckForAlert = false
    var isEndAlertShowing = false

    //For outdoors
    var lattitude  = Double()
    var longitude = Double()
    var arrWayPoint: [CLLocationCoordinate2D] = []
    
    //main Distance and Index
    var lastIndex = 0
    var totalDistancConverted = 0.0
    //--------------------
    
    //Inner lap index
    var lastLapIndex = 0
    var lapCoveredDistance = 0.0

    //Button animation
    var isLongGestureForEnd = false
    var isLongGestureForRepeat = false
    var isLongGestureForComplete = false

    //Click on End that time set date
    var dateClickonEndButton = Date()

    //MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.white
        self.mainModelView.setupUI()
        self.mainView.setupUI()
        self.mainView.scrollView.delegate = self
        
        self.btnEdit.titleLabel?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        
        pedometer = CMPedometer()
        activityManager = CMMotionActivityManager()

        if let value = Defaults.value(forKey: self.mainModelView.trainingLogId) as? Int{
            countForTotalStationaryTime = Int(value)
        }

        //Set for distance check
        AppDelegate.shared?.delegateUpadateLatLong = self
        AppDelegate.shared?.locationManager.startUpdatingLocation()

        //Get data from database
        guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
            return
        }
        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.activityId == Int(self.mainModelView.trainingLogId)}

        if routeObjects.count > 0{
            /*
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                try! realm.write{
                    self.drawTotalPath(strPolyLine: routeObjects[0].allTrackRoute)
                }
            }*/

            self.mainModelView.getCurrenIndexOfCurrentLap()
            
            self.totalDistancConverted = routeObjects[0].totalCoveredDistance
            self.mainModelView.totalDistanceWithPedometer = routeObjects[0].totalCoveredDistance

            self.lapCoveredDistance = routeObjects[0].lapArray[self.mainModelView.currentWorkedIndex].lapCoverDistance
            self.mainModelView.coverdDistanceOfLapWithPedometer  = CGFloat(self.lapCoveredDistance)
            
            self.mainModelView.netElevationGain = routeObjects[0].elevationGain
            
        }
        
        //add gesture
        self.addLongGestureInButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setWhiteColorWithLine()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.activityManager?.stopActivityUpdates()
        self.activityManager = nil
        self.pedometer?.stopEventUpdates()
        self.pedometer?.stopUpdates()
        self.pedometer = nil
        self.removeTimerOfMotion()

        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)

        if let cell = self.mainView.tableView.cellForRow(at: IndexPath(row: self.mainModelView.currentWorkedIndex, section: 0)) as? LogPreviewCell{
            print("cell enter")
            if cell.timerofUpdateProgressbar != nil{
                cell.timerofUpdateProgressbar?.invalidate()
                cell.timerofUpdateProgressbar = nil
            }
        }
    }
    
    deinit {
        print("Deallocate :\(self)")
    }
    
    @objc func applicationDidBecomeActive(notification: NSNotification) {
        
        let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""

        if activityName.lowercased() == "Run (Outdoor)".lowercased() || activityName.lowercased() == "Cycling (Outdoor)".lowercased(){
            self.checkLocationPermissionAvailableOrNot()
        }

    }

    func callMethodAfterAPI(){
        
        if self.isAlreadyCall == true{
            return
        }

        if (self.mainModelView.previewData?.exercise?.count ?? 0) > 0{

            if  self.mainModelView.previewData?.exercise?[0].startTime != "" {

                let dateStart = self.mainModelView.previewData?.exercise?[0].startTime == "" ? Date() : self.mainModelView.previewData?.exercise?[0].startTime.convertDateFormater()

                isAlreadyCall = true
                
                if !isCheckForOutdoors(){
                    //This is for indoors only
                    self.startUpdating(fromDate: dateStart!)
                }
            }
        }
    }
    
    func isCheckForOutdoors() -> Bool{
        
        let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""
               
        if activityName.lowercased() == "Cycling (Outdoor)".lowercased() || activityName.lowercased() == "Run (Outdoor)".lowercased(){
            
            AppDelegate.shared?.locationManager.allowsBackgroundLocationUpdates = true
            
            return true
        }else{
            return false
        }
    }

    /*
    override func viewDidLayoutSubviews() {
        if self.mainModelView.checkIsExerciseStarted(){
            
            if let view = (self.view as? LogPreviewView){
                
                view.ConstratintBottomViewHeigh.constant = 102
                
                view.isBottomDeleteShareShow(isShow: false)
                view.vwBottomHiddenShow(isHidden: true)
                
                print("contentsizeHeight:\(view.scrollView.contentSize.height)")
                print("safeAreaHeigh:\(view.safeAreaHeight)")
                
                if view.scrollView.contentSize.height+102 <= view.safeAreaHeight{
                    view.isSetAlphaOrNOt(isSet: true)
                }else{
                    view.isSetAlphaOrNOt(isSet: false)
                }
            }
            
        }else{
            if let view = (self.view as? LogPreviewView){
                
                view.vwBottomHiddenShow(isHidden: false)
                
                print("contentsizeHeight:\(view.scrollView.contentSize.height)")
                print("safeAreaHeigh:\(view.safeAreaHeight)")
                
                if view.scrollView.contentSize.height+177 <= view.safeAreaHeight{
                    view.isSetAlphaOrNOt(isSet: true)
                    view.isBottomDeleteShareShow(isShow: true)
                }else{
                    view.isSetAlphaOrNOt(isSet: false)
                    view.isBottomDeleteShareShow(isShow: false)
                }
            }
        }
    }
    */

    func setCompleteButtonColor(){
        
        if self.mainModelView.checkIsExerciseStarted(){
            self.btnEdit.setTitle(str: "Switch View")
            self.btnEdit.setTitleColor(UIColor.appthemeRedColor, for: .normal)
            self.btnEdit.setImage(nil, for: .normal)
            self.btnEdit.contentHorizontalAlignment = .center
            self.btnRightBarButton.width = 200
            
            self.mainView.vwRepeatWorkout.isHidden = false
            self.mainView.vwEndWorkout.isHidden = false
            self.mainView.vwCompleteWorkout.isHidden = true
            self.mainView.vwStartWorkout.isHidden = true
            
            mainView.ConstratintBottomViewHeigh.constant = 102
            
            mainView.isBottomDeleteShareShow(isShow: false)
            mainView.vwBottomHiddenShow(isHidden: true)
            
            print("content y:\(mainView.scrollView.contentOffset.y)")
            print("safeAreaHeigh:\(view.safeAreaHeight)")
            print("contentsize:\(mainView.scrollView.contentSize.height)")
            
            if (mainView.scrollView.contentOffset.y + mainView.safeAreaHeight - 102) >= mainView.scrollView.contentSize.height{
                mainView.isSetAlphaOrNOt(isSet: true)
            }else{
                mainView.isSetAlphaOrNOt(isSet: false)
            }

        }else{
            
            self.btnEdit.setTitle(str: "")
            self.btnEdit.setImage(UIImage(named: "ic_edit_red"), for: .normal)
            self.btnEdit.contentHorizontalAlignment = .right
            self.btnRightBarButton.width = 50
            
            self.mainView.vwCompleteWorkout.isHidden = false
            self.mainView.vwStartWorkout.isHidden = false
            self.mainView.vwEndWorkout.isHidden = true
            self.mainView.vwRepeatWorkout.isHidden = true
            
//            mainView.vwBottomHiddenShow(isHidden: false)
//            
//            print("contentsizeHeight:\(mainView.scrollView.contentSize.height)")
//            print("safeAreaHeigh:\(view.safeAreaHeight)")
//
//            if (mainView.scrollView.contentOffset.y + mainView.safeAreaHeight - 177) >= mainView.scrollView.contentSize.height{
//                mainView.isSetAlphaOrNOt(isSet: true)
//                mainView.isBottomDeleteShareShow(isShow: true)
//            }else{
//                mainView.isSetAlphaOrNOt(isSet: false)
//                mainView.isBottomDeleteShareShow(isShow: false)
//            }
//
        }
        
        /*
        if (self.mainModelView.previewData?.exercise?[0].startTime == nil) || (self.mainModelView.previewData?.exercise?[0].startTime == "") {
            
            self.mainView.btnEndWorkout.isUserInteractionEnabled = true
            self.mainView.btnEndWorkout.borderColor = UIColor.appthemeRedColor
            self.mainView.btnEndWorkout.setColor(color: .appthemeRedColor)
            self.mainView.btnEndWorkout.backgroundColor = UIColor.white

            self.mainView.btnStartWorkout.setTitle(str: getCommonString(key: "Start_key"))
        }else{
            self.mainView.btnEndWorkout.borderColor = UIColor.gray
            self.mainView.btnEndWorkout.setColor(color: .white)
            self.mainView.btnEndWorkout.backgroundColor = UIColor.gray
            self.mainView.btnEndWorkout.isUserInteractionEnabled = false
            
            self.mainView.btnStartWorkout.setTitle(str: getCommonString(key: "End_key"))
        }
        */
    }
    
    func addLongGestureInButton(){
        
        let longGestureComplete = UILongPressGestureRecognizer(target: self, action: #selector(longTapBtnComplete))
        self.mainView.btnCompleteWorkout.addGestureRecognizer(longGestureComplete)

        
        let longGestureEnd = UILongPressGestureRecognizer(target: self, action: #selector(longTapBtnEnd))
        self.mainView.btnEndWorkout.addGestureRecognizer(longGestureEnd)
        
        let longGestureRepeat = UILongPressGestureRecognizer(target: self, action: #selector(longTapBtnRepeat))
        self.mainView.btnRepeatWorkout.addGestureRecognizer(longGestureRepeat)
        
    }
    
    //add Gesture methods
    
    @objc func longTapBtnComplete(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            self.mainView.btnCompleteWorkout.backgroundColor = .white
            self.mainView.btnCompleteWorkout.setTitleColor(.appthemeOffRedColor, for: .normal)
            self.btnCompleteWorkoutClicked(self.mainView.btnCompleteWorkout)
        }
        else if sender.state == .began {
            print("Began")
            self.isLongGestureForComplete = true
            self.mainView.btnCompleteWorkout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
            self.mainView.btnCompleteWorkout.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func longTapBtnEnd(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            self.mainView.btnEndWorkout.backgroundColor = .white
            self.mainView.btnEndWorkout.setTitleColor(.appthemeOffRedColor, for: .normal)
            self.btnEndWorkoutTapped(self.mainView.btnEndWorkout)
        }
        else if sender.state == .began {
            print("Began")
            self.isLongGestureForEnd = true
            self.mainView.btnEndWorkout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
            self.mainView.btnEndWorkout.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func longTapBtnRepeat(_ sender: UIGestureRecognizer){
        print("Long tap")
        if sender.state == .ended {
            self.mainView.btnRepeatWorkout.backgroundColor = .white
            self.mainView.btnRepeatWorkout.setTitleColor(.appthemeOffRedColor, for: .normal)
            self.btnRepeatTapped(self.mainView.btnRepeatWorkout)
        }
        else if sender.state == .began {
            print("Began")
            self.isLongGestureForRepeat = true
            self.mainView.btnRepeatWorkout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
            self.mainView.btnRepeatWorkout.setTitleColor(.white, for: .normal)
        }
    }


    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        AppDelegate.shared?.delegateUpadateLatLong = nil
        self.mainModelView.delegate?.DismissPreviewDidFinish()
    }
    
    @IBAction func btnEditClicked(_ sender: UIButton) {
        
        print("Title : \(self.btnEdit.titleLabel?.text)")
        print("Image : \(self.btnEdit.currentImage)")
        
        if self.btnEdit.currentImage == nil{
            let selectedDate = self.mainModelView.expandedDate
            let currentDate = Date().toString(dateFormat: "yyyy-MM-dd")
            //        if currentDate == selectedDate {
            if self.mainModelView.checkIsCompleted() {
                return
            }
            
//            if let cell = self.mainView.tableView.cellForRow(at: IndexPath(row: self.mainModelView.currentWorkedIndex, section: 0)) as? LogPreviewCell{
//                print("cell enter")
//                if cell.timerofUpdateProgressbar != nil{
//                    cell.timerofUpdateProgressbar?.invalidate()
//                    cell.timerofUpdateProgressbar = nil
//                }
//            }
            
            self.removeTimerOfMotion()
            self.isAutoPauseCheckForAlert = false
            self.activityManager?.stopActivityUpdates()
            self.activityManager = nil
            
            self.redirectToStartWoktoutCardioVc()
            
            //TODO: - Pedo add
//            checkAuthorizationStatusForPedometer()
//
//            let obj: CountDownVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CountDownVC") as! CountDownVC
//            obj.mainModelView.delegate = self
//            obj.modalPresentationStyle = .overFullScreen
//            self.present(obj, animated: true, completion: nil)
            //        }
            //        else {
            //            makeToast(strMessage: getCommonString(key: "You_can't_start_future_workout"))
            //        }
        }else{
            let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateTrainingLogVC") as! CreateTrainingLogVC
            obj.mainModelView.previewData = self.mainModelView.previewData
            obj.mainModelView.isEditCardio = true
            obj.mainModelView.isEditResistance = false
            obj.mainModelView.tabIndex = 0
            obj.mainModelView.pastSelectedIndex = 0
            let nav = UINavigationController(rootViewController: obj)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnStartWorkoutClicked(_ sender: Any) {
        let selectedDate = self.mainModelView.expandedDate
        let currentDate = Date().toString(dateFormat: "yyyy-MM-dd")
        //        if currentDate == selectedDate {
        if self.mainModelView.checkIsCompleted() {
            return
        }
        
        let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased()
        if activityName == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){
            self.mainModelView.getSaveDataFromLocalDatabase()
        }
        
        //TODO: - Pedo add
        checkAuthorizationStatusForPedometer()
        
        let obj: CountDownVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CountDownVC") as! CountDownVC
        obj.mainModelView.delegate = self
        obj.modalPresentationStyle = .overFullScreen
        self.present(obj, animated: true, completion: nil)
        //        }
        //        else {
        //            makeToast(strMessage: getCommonString(key: "You_can't_start_future_workout"))
        //        }
    }
    
    func CountDownViewFinish(tag:Int) {
        
        self.removeTimerOfMotion()
        self.isAutoPauseCheckForAlert = false
        self.activityManager?.stopActivityUpdates()
        self.activityManager = nil

        self.redirectToStartWoktoutCardioVc()
    }
    
    func redirectToStartWoktoutCardioVc(){
        
        var obj: StartWorkoutCardioVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "StartWorkoutCardioVC") as! StartWorkoutCardioVC
        if UIScreen.main.bounds.size.height == 568 {
            obj = StartWorkoutCardioVC.init(nibName: "StartWorkoutCardioVC", bundle: nil)
        }
        
        obj.mainModelView.delegate = self
        obj.mainModelView.isRunAutoPause = self.mainModelView.previewData?.runAutoPause ?? false
        obj.mainModelView.isCycleAutoPause = self.mainModelView.previewData?.cycleAutoPause ?? false
        obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
        obj.mainModelView.activityImage = self.mainModelView.previewData?.trainingActivity?.iconPathRed ?? ""
        obj.mainModelView.exerciseArray = self.mainModelView.previewData?.exercise ?? []
        obj.mainModelView.activityName = self.mainModelView.previewData?.trainingActivity?.name ?? ""
        obj.modalPresentationStyle = .overFullScreen
        
        self.mainModelView.isLogPreviewScreenOpen = false
        
        obj.handlerForIndoorParticularLapForReset = {[weak self] (distanceForIndoor) in
            self?.mainModelView.coverdDistanceOfLapWithPedometer = CGFloat(distanceForIndoor)
            self?.mainView.tableView.reloadData()
            self?.mainModelView.isLogPreviewScreenOpen = false
            
            self?.removeTimerOfMotion()
            if !(self?.isCheckForOutdoors() ?? false){
                //This is for indoors only
                self?.startUpdating(fromDate: self?.mainModelView.previewData?.exercise?[0].startTime.convertDateFormater() ?? Date())
            }else{
                AppDelegate.shared?.locationManager.startUpdatingLocation()
            }
        }
        
        obj.handlerForPassPedometerDistancePace = {[weak self] (distance,pace) in
//            makeToast(strMessage: "DIstance : \(distance)")
            self?.mainModelView.totalDistanceWithPedometer = distance
            self?.totalDistancConverted = distance
            self?.mainModelView.totalAverageActivePacePedometer = pace
        }
        
        obj.mainModelView.handlerUserClickOnYesOrNoInAlert = {[weak self] in
            self?.setCompleteButtonColor()
        }
        
        //uncomment because this help for indicator in lap
        obj.handlerForPassPedometerDate = {[weak self] (startDate) in
            print("startdate:\(startDate)")
            self?.removeTimerOfMotion()
            if !(self?.isCheckForOutdoors() ?? false){
                //This is for indoors only
                self?.startUpdating(fromDate: startDate)
            }else{
                AppDelegate.shared?.locationManager.startUpdatingLocation()
            }
        }

        obj.mainModelView.handlerClickOnCloseView = {[weak self] in
            self?.removeTimerOfMotion()
            self?.activityManager = CMMotionActivityManager()
            self?.isAutoPauseCheckForAlert = false
            self?.mainModelView.isLogPreviewScreenOpen = true
            
            self?.mainView.imgOfStartWorkout.image = nil
            self?.mainModelView.checkRepeatClickableOrNot()
            self?.mainModelView.getCurrenIndexOfCurrentLap()
            
            if let value = Defaults.value(forKey: self?.mainModelView.trainingLogId ?? "0") as? Int{
                self?.countForTotalStationaryTime = Int(value)
            }
            
            let activityName = self?.mainModelView.previewData?.trainingActivity?.name?.lowercased()
            if activityName == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){
                AppDelegate.shared?.delegateUpadateLatLong = self
                AppDelegate.shared?.locationManager.startUpdatingLocation()

                if self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isPause == false{
                    
                    self?.removeTimerOfMotion()
                    
                    if self?.timerForMotion == nil{
                        self?.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self?.check10secondOrNot), userInfo: nil, repeats: true)
                    }

                }
                self?.getTrackDistance()

            } else {
                self?.reCallMainCountingStep()
            }
            

            //Get data from database
            
//            let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self!.mainModelView.trainingLogId)}
//
//            if routeObjects.count > 0{
//
//                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
//                    try! realm.write{
//                        self?.drawTotalPath(strPolyLine: routeObjects[0].allTrackRoute)
//                    }
//                }
//            }
        }
        
        obj.handlerForPassDataOfParticularLapWithPolyline = {[weak self] (strPolyline,lapDistance) in
            self?.lapCoveredDistance = lapDistance
            self?.mainModelView.coverdDistanceOfLapWithPedometer = CGFloat(lapDistance)
            self?.mainModelView.isLogPreviewScreenOpen = false
            
            self?.mainView.tableView.reloadData()
            
//            makeToast(strMessage: "Lap Distance LogPreview :\(self?.lapCoveredDistance)")
            
               //MARK:- COMMENT CHECK
//            self?.findDistanceOfParticularLap(polyline: strPolyline, fromIndex: 0, currentIndex: 0)
            
        }
        
        obj.mainModelView.handlerStopActivityUpdate = {[weak self] in
            self?.removeTimerOfMotion()
            self?.activityManager = nil
            self?.activityManager?.stopActivityUpdates()
        }
        
        obj.mainModelView.handlerFinishWorkoutOnEndClick = {[weak self] (image) in
//            if image != nil{
//                self?.navigationController?.navigationBar.isHidden = true
//            }else{
//                self?.navigationController?.navigationBar.isHidden = false
//            }
            self?.mainView.imgOfStartWorkout.image = image ?? nil
            self?.mainModelView.isLogPreviewScreenOpen = true
        }
        
        obj.handlerNetElevationGain = {[weak self] (elevation) in
//            makeToast(strMessage: "ElevationL\(elevation)")
            self?.mainModelView.netElevationGain = elevation
        }
        
        obj.mainModelView.handlerPauseOrNot = {[weak self] (isPause) in
            self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isPause = isPause
            self?.reCallMainCountingStep()
            self?.mainView.tableView.reloadData()
        }
        
        self.present(obj, animated: true, completion: nil)
        
    }
    
    @IBAction func btnCompleteWorkoutClicked(_ sender: Any) {
        
        if isLongGestureForComplete == false{
            UIView.animate(withDuration: 0.05, animations: {
                self.mainView.btnCompleteWorkout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
                self.mainView.btnCompleteWorkout.setTitleColor(.white, for: .normal)
            }) { (status) in
                self.mainView.btnCompleteWorkout.backgroundColor = .white
                self.mainView.btnCompleteWorkout.setTitleColor(.appthemeOffRedColor, for: .normal)
            }
        }else{
            isLongGestureForComplete = false
        }
        
        
        if self.mainModelView.previewData?.isComplete ?? false {
            return
        }
        
        setVibration()

        let selectedDate = self.mainModelView.expandedDate
        let currentDate = Date().toString(dateFormat: "yyyy-MM-dd")
//        if currentDate == selectedDate {
            let alertController = UIAlertController(title: getCommonString(key: "Complete_Workout_key"), message: getCommonString(key: "Do_you_want_to_complete_this_workout_key"), preferredStyle: UIAlertController.Style.alert)
            
            let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
                
                //Comment for dismiss
                let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""
                       
                if activityName.lowercased() == "Cycling (Outdoor)".lowercased() || activityName.lowercased() == "Run (Outdoor)".lowercased(){
                    self.mainModelView.isClickOnCompleteButton = true
                }
                self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: true)
            }
            
            let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
                print("Cancel")
            }
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
//        }
//        else {
//            makeToast(strMessage: getCommonString(key: "You_can't_end_future_workout"))
//        }
    }
    
    @IBAction func btnRepeatTapped(_ sender: UIButton) {
        
        if isLongGestureForRepeat == false{
            UIView.animate(withDuration: 0.05, animations: {
                self.mainView.btnRepeatWorkout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
                self.mainView.btnRepeatWorkout.setTitleColor(.white, for: .normal)
            }) { (status) in
                self.mainView.btnRepeatWorkout.backgroundColor = .white
                self.mainView.btnRepeatWorkout.setTitleColor(.appthemeOffRedColor, for: .normal)
            }
        }else{
            isLongGestureForRepeat = false
        }
        
        self.mainModelView.isRepeatExercise = true
        
        self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: false)

        let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""
        if activityName == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){
            
            if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].duration == nil || self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].duration == ""{
                
                try? realm?.write{
                    guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
                        return
                    }
                    
                    let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.activityId == Int(self.mainModelView.trainingLogId)}
                    
                    if routeObjects.count > 0 {
                        
                        //We cannot Righ last index endTo because user also walk some km afrer complete lap so we have to take start of that repeat and recent value of Index passes
                        //                        let lastIndex = routeObjects[0].lapArray.count - 1
                        //                        routeObjects[0].lapArray[lastIndex].endTo
                        let startingIndex = self.lastIndex
                        
                        for i in 0..<routeObjects[0].lapArray.count{
                            routeObjects[0].lapArray[i].lapCoverDistance = 0
                        }
                        
                        routeObjects[0].isAutomaticallyPause = false
                        routeObjects[0].isPauseAfterAllLapCompleted = false

                        lapCoveredDistance = 0.0
                        self.mainModelView.coverdDistanceOfLapWithPedometer = 0.0
                    }
                }
            }
        }
    }
    
    @IBAction func btnEndWorkoutTapped(_ sender: UIButton) {
        
        if isLongGestureForEnd == false{
            UIView.animate(withDuration: 0.05, animations: {
                self.mainView.btnEndWorkout.backgroundColor = UIColor(red: 255/225, green: 8/255, blue: 86/255, alpha: 1)
                self.mainView.btnEndWorkout.setTitleColor(.white, for: .normal)
            }) { (status) in
                self.mainView.btnEndWorkout.backgroundColor = .white
                self.mainView.btnEndWorkout.setTitleColor(.appthemeOffRedColor, for: .normal)
            }
        }else{
            isLongGestureForEnd = false
        }
        
        setVibration()
        isEndAlertShowing = true
        
        self.dateClickonEndButton = Date()

        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        let dataCount = (self.mainModelView.previewData?.exercise?.count ?? 1) - 1
        self.mainModelView.previewData?.exercise?[dataCount].endTime = date
        
        if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isPause == false{
            
            if !(self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0)-1].isCompleted == true && self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0 )-1].isCompletedRest == true){
                
                self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isPause = true
                self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].pauseTime = date

            }
        }
        
        let alertController = UIAlertController(title: getCommonString(key: "End_Workout_key"), message: getCommonString(key: "Do_you_want_to_stop_the_workout_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: true)
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
            self.isEndAlertShowing = false
            
            if self.endAlertCancelMainTapped(){
                return
            }
            
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: false)
            
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
       self.mainModelView.deleteLog()
    }
    
    @IBAction func btnSaveAsTempleteClicked(_ sender: Any) {
        self.mainModelView.apiCallForUpdate(isSavedWorkout: true)
    }
    
    @IBAction func btnShareClicked(_ sender: Any) {
        let obj: NewMessageSelectVC
            = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "NewMessageSelectVC") as! NewMessageSelectVC
        obj.mainModelView.delegate = self
        self.navigationController?.pushViewController(obj, animated: true)
    }    
    
    @IBAction func btnShowUnitTapped(_ sender: UIButton) {
        
        if self.mainView.btnShowUnit.isSelected{
            self.mainView.heightUnitvw.constant = 0
            self.mainView.vwUnit.isHidden = true
        }else{
            self.mainView.heightUnitvw.constant = 40
            self.mainView.vwUnit.isHidden = false
        }
        
        self.mainView.btnShowUnit.isSelected = !self.mainView.btnShowUnit.isSelected

    }
    
    func NewMessageSelectDidFinish(name: String, id: String) {
        SocketIOHandler.shared.shareFriendTrainingLog(toIds: [Int(id) ?? 0], trainingLogId: self.mainModelView.previewData?.id?.intValue ?? 0)
    }
    
    //MARK: - Other functions
    
    func endAlertCancelMainTapped() -> Bool {
        
        let miliseconds = String(Date().timeIntervalSince(self.dateClickonEndButton))
        print("Milisecond \(miliseconds)")
        
        // add second differnce of click on End and Click on No added in StartTime of 0 index


        //Set for Outdoor only
        var secondDifferenceForOutdoor = 0
        if miliseconds.contains("."){
            let array = miliseconds.split(separator: ".")
            
            let firstIndex = array[0]
            let secondIndex = array[1]
            
            if ("0.\(secondIndex)").toFloat() > 0.5{
                secondDifferenceForOutdoor = (Int(String(firstIndex)) ?? 1) + 1
            }else{
                secondDifferenceForOutdoor = Int(String(firstIndex)) ?? 0
            }
        }
        
        //Before in below condition set as AUR Codition Now set And Condition for futher issue check with AUR
        if self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0)-1].isCompleted == true && self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0 )-1].isCompletedRest == true{
            print("Return call")
            
            //This is applies for both otherwise Total Duration value jump
            let valueAddigForStartTimeForOutdoor = self.mainModelView.previewData?.exercise?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifferenceForOutdoor))
            let convertToStringForStartTimeForOutDoor = valueAddigForStartTimeForOutdoor?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.mainModelView.previewData?.exercise?[0].startTime = convertToStringForStartTimeForOutDoor ?? ""
            
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: false)

            return true
        }
        
        //For indoor n all
        let secondDifference = self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].pauseTime.convertDateFormater().secondDifference(to: Date()) ?? 0

        let valueAddigForStartTime = self.mainModelView.previewData?.exercise?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
        let convertToStringForStartTime = valueAddigForStartTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isClickOnPause == false{
            if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isPause == true{
                self.mainModelView.previewData?.exercise?[0].startTime = convertToStringForStartTime ?? ""
                self.userClickOnCancelForEndAlert()
            }
        }else{
            
            //Only for Outdoor because in outdoor Total Duration constantly increase even if pause
            
            if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isPause == true{
                if self.mainModelView.previewData?.trainingActivity?.name?.lowercased() == "Run (Outdoor)".lowercased() || self.mainModelView.previewData?.trainingActivity?.name?.lowercased() == "Cycling (Outdoor)".lowercased(){
                    
    //                if  self.isCheckForAutoPause == true{
                    
                    let valueAddigForStartTimeForOutdoor = self.mainModelView.previewData?.exercise?[0].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifferenceForOutdoor))
                    let convertToStringForStartTimeForOutDoor = valueAddigForStartTimeForOutdoor?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    self.mainModelView.previewData?.exercise?[0].startTime = convertToStringForStartTimeForOutDoor ?? ""
                    
    //                }
                }
            }

        }
        
        
        return false
    }
    
    func userClickOnCancelForEndAlert(){
        
        let secondDifference = self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].pauseTime.convertDateFormater().secondDifference(to: Date()) ?? 0
        
        //for indoor start time change so total duration set as same
        
        if self.mainModelView.currentWorkedIndex == 0 {
            
            let valueAddigForAddRestTime = self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].repeatTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
            
            let convertToStringForAddRestTime = valueAddigForAddRestTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].repeatTime = convertToStringForAddRestTime ?? ""
            
        }else{
            
            let valueAddigForAddRestTime = self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].startTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
            
            let convertToStringForAddRestTime = valueAddigForAddRestTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].startTime = convertToStringForAddRestTime ?? ""
        }
        
        let valueAddigForAddRestTime = self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].addedRestTime.convertDateFormater().addingTimeInterval(TimeInterval(secondDifference))
        let convertToStringForAddRestTime = valueAddigForAddRestTime?.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].addedRestTime = convertToStringForAddRestTime ?? ""
        
        self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isPause = false
        self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].pauseTime = ""
        
    }

    
    func redirectToCardioSummary(){
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CalendarTrainingLogSummaryVc") as! CalendarTrainingLogSummaryVc
        obj.mainModelView.controllerMoveFrom = .trainingLog
        obj.mainModelView.date = self.mainModelView.expandedDate
        obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
        obj.mainModelView.delegateDismissTrainingLogSummary = self
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: true, completion: nil )
    }
    
    func redirectToRPESelection(){
        
        let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""
        
        if activityName.lowercased() == "Others".lowercased() || activityName.lowercased() == "Cycling (Outdoor)".lowercased() || activityName.lowercased() == "Run (Outdoor)".lowercased(){
            
            let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "RPESelectionVc") as! RPESelectionVc
            obj.mainModelView.delegateDismissRPESelection = self
            obj.mainModelView.controllerMoveFrom = .trainingLog
            obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
            let nav = UINavigationController(rootViewController: obj)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true) {
                self.mainView.imgOfStartWorkout.image = nil
            }
            
        }else{
            
            let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "ConfirmationPageVc") as! ConfirmationPageVc
            obj.mainModelView.delegateConfirmation = self
            obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
            let nav = UINavigationController(rootViewController: obj)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true) {
                self.mainView.imgOfStartWorkout.image = nil
            }

        }
    }
    
    func redirectionForOutdoor(){
            
        let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""
            
        if activityName.lowercased() == "Cycling (Outdoor)".lowercased() || activityName.lowercased() == "Run (Outdoor)".lowercased(){
            
            self.mainModelView.isClickOnCompleteButton = false
            
            let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "ConfirmationPageVc") as! ConfirmationPageVc
            obj.mainModelView.delegateConfirmation = self
            obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
            let nav = UINavigationController(rootViewController: obj)
            nav.modalPresentationStyle = .overCurrentContext
            self.present(nav, animated: true, completion: nil)
            
//            let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "RPESelectionVc") as! RPESelectionVc
//            obj.mainModelView.delegateDismissRPESelection = self
//            obj.mainModelView.trainingLogId = self.mainModelView.trainingLogId
//            let nav = UINavigationController(rootViewController: obj)
//            nav.modalPresentationStyle = .overCurrentContext
//            self.present(nav, animated: true, completion: nil)
           
        }
    }
    
//    func removeTimer(){
//
//        if let cell = self.mainView.tableView.cellForRow(at: IndexPath(row: self.mainModelView.currentWorkedIndex, section: 0)) as? LogPreviewCell{
//            print("cell enter")
//            if cell.timerofUpdateProgressbar != nil{
//                cell.timerofUpdateProgressbar?.invalidate()
//                cell.timerofUpdateProgressbar = nil
//            }
//        }
//    }
}

extension LogPreviewVC: delegateDismissCalendarTrainingLogSummary{
    
    func dismissCalendarTrainingLogSummary() {
        
        self.dismiss(animated: true) {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
            
            self.mainModelView.delegate?.DismissPreviewDidFinish()
//            }
        }
    }
}

extension LogPreviewVC: delegateDismissRPESelection{
    func dismissdelegateDismissRPESelection() {
        self.dismiss(animated: true) {
            self.redirectToCardioSummary()
        }
    }
}

extension LogPreviewVC : dismissConfirmationPageDelegate{
    func dismissConfirmationPage() {
        self.dismiss(animated: true) {
            self.redirectToCardioSummary()
        }
    }
}

//MARK; - yash Added
extension LogPreviewVC {

    func hideShowHeaderAccordingToActivity(name:String){

        let activityNameInLowerCased = name.lowercased()

        self.mainView.vwLvl.isHidden = false
        self.mainView.viewPercentage.isHidden = false
        self.mainView.viewRPM.isHidden = true
        self.mainView.vwCyclingOutdoorPercentage.isHidden = true

        switch activityNameInLowerCased {

        case "Run (Outdoor)".lowercased():
            self.mainView.vwLvl.isHidden = true
            self.mainView.vwStackViewHeader.spacing = 5
            self.mainView.vwStackViewUnit.spacing = 5
            
        case "Run (Indoor)".lowercased():
            self.mainView.vwLvl.isHidden = true
            self.mainView.vwStackViewHeader.spacing = 5
            self.mainView.vwStackViewUnit.spacing = 5
            
        case "Cycling (Indoor)".lowercased():
            self.mainView.vwLvl.isHidden = false
            self.mainView.viewRPM.isHidden = false
            self.mainView.vwStackViewHeader.spacing = 0
            self.mainView.vwStackViewUnit.spacing = 0

        case "Cycling (Outdoor)".lowercased():
            self.mainView.vwLvl.isHidden = true
            self.mainView.viewRPM.isHidden = false
            self.mainView.vwCyclingOutdoorPercentage.isHidden = false
            self.mainView.vwStackViewHeader.spacing = 0
            self.mainView.vwStackViewUnit.spacing = 0

        case "Swimming".lowercased():
            self.mainView.viewPercentage.isHidden = true
            self.mainView.vwLvl.isHidden = true
            
            self.mainView.vwStackViewHeader.spacing = 35
            self.mainView.vwStackViewUnit.spacing = 35
            
        case "Others".lowercased():
            self.mainView.viewRPM.isHidden = false
            self.mainView.vwStackViewHeader.spacing = 0
            self.mainView.vwStackViewUnit.spacing = 0
        default:
            self.mainView.vwLvl.isHidden = true

        }
    }
    
    func hideShowUnitHeaderAccordingToActivity(name:String){

        let activityNameInLowerCased = name.lowercased()

        self.mainView.vwLvlUnit.isHidden = false
        self.mainView.vwPercentageUnit.isHidden = false
        self.mainView.vwRPMUnit.isHidden = true
        self.mainView.vwCyclingOutdoorPercentageUnit.isHidden = true
        
        switch activityNameInLowerCased {

        case "Run (Outdoor)".lowercased():
            self.mainView.vwLvlUnit.isHidden = true

        case "Run (Indoor)".lowercased():
            self.mainView.vwLvlUnit.isHidden = true

        case "Cycling (Indoor)".lowercased():
            self.mainView.vwLvlUnit.isHidden = false
            self.mainView.vwRPMUnit.isHidden = false

        case "Cycling (Outdoor)".lowercased():
            self.mainView.vwLvlUnit.isHidden = true
            self.mainView.vwRPMUnit.isHidden = false
            self.mainView.vwCyclingOutdoorPercentageUnit.isHidden = false
            
        case "Swimming".lowercased():
            self.mainView.vwPercentageUnit.isHidden = true
            self.mainView.vwLvlUnit.isHidden = true

        case "Others".lowercased():
            self.mainView.vwRPMUnit.isHidden = false
            
            if self.mainModelView.previewData?.exercise?[0].isSpeed == false {
                self.mainView.lblSpeed.text = "Pace"
                self.mainView.lblSpeedUnit.text = "min/500m"
            }
            else if self.mainModelView.previewData?.exercise?[0].isSpeed == true{
                self.mainView.lblSpeed.text = "Speed"
                self.mainView.lblSpeedUnit.text = "km/hr"
            }
            else{
                self.mainView.lblSpeedUnit.text = "-"
            }
            
        default:
            self.mainView.vwLvlUnit.isHidden = true

        }
    }

}


//TODO: - Pedometer Methods for finding distance

extension LogPreviewVC{
    
    func checkAuthorizationStatusForPedometer() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            print("Not Available")
        case CMAuthorizationStatus.authorized:
            print("Available")

        default:break
        }
        
    }
    /*
    func updateStepsCountLabelUsing(startDate: Date) {
           pedometer.queryPedometerData(from: startDate, to: Date()) {
               [weak self] pedometerData, error in
               if let error = error {
                print("Error : \(error.localizedDescription)")
                
               } else if let pedometerData = pedometerData {
                   DispatchQueue.main.async {
                    print("Distance :\(pedometerData.distance?.floatValue)")
                    self?.mainModelView.totalDistanceWithPedometer = pedometerData.distance?.doubleValue ?? 0.0
                    self?.mainModelView.totalAverageActivePacePedometer = pedometerData.averageActivePace?.doubleValue ?? nil
                   }
               }
           }
       }
    */
    
     func startUpdating(fromDate:Date) {
            if CMMotionActivityManager.isActivityAvailable() {
                startTrackingActivityType()
            } else {
                
    //            makeToast(strMessage: "Phone is not in motion")
                print("Phone is not in motion")
               // activityTypeLabel.text = "Not available"
            }

            if CMPedometer.isStepCountingAvailable() {
                startCountingSteps(fromDate: fromDate)
            } else {
              //  stepsCountLabel.text = "Not available"
            }
        }
    
    func startTrackingActivityType() {
        
        if activityManager == nil{
            return
        }
        
        if isEndAlertShowing == true{
            return
        }
        
        activityManager = CMMotionActivityManager()
        
        activityManager?.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            
            guard let activity = activity else { return }
            
            DispatchQueue.main.async {
                if activity.walking {
                    print("LogPreview walking")
                    self?.commonMethodForActivity()
                    
                } else if activity.stationary {
                    print("LogPreview stationary")
                    
//                    let activityName = self?.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""
//
//                    if activityName == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased() {
//
//                        //Old condition wrong in second lap always return false bcz icCompleted always false
//                        //                        if (self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompleted == true) && (self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == false || self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == nil){
//
//                        if (self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompleted == false || self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompleted  == nil){
//                            if self?.timerForMotion == nil{
//                                print("LOGPREIVEW ENTER IN TIME ENTER IN TIMER ===================== ENTER IN TIMER ENTER IN TIMER")
//                                self?.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self?.check10secondOrNot), userInfo: nil, repeats: true)
//                            }
//                        }else{
//                            self?.removeTimerOfMotion()
//                        }
//                    }
                    
                } else if activity.running {
                    print("LogPreview running")
                    self?.commonMethodForActivity()
                } else if activity.automotive {
                    print("LogPreview automotive")
                    self?.commonMethodForActivity()
                }else if activity.cycling{
                    print("LogPreview cycling")
                    self?.commonMethodForActivity()
                }
            }
        }
        
//        print("LOGPREIVEW ACTIVITY DETECT")
//
//        let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""
//        if activityName == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){
//            if (self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex ?? 0].isCompleted == false || self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex ?? 0].isCompleted  == nil){
//                if self.timerForMotion == nil{
//                    print("LOGPREIVEW NO ACTIVITY IN TIMER ======== ENTER IN TIMER")
//                    self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check5secondOrNot), userInfo: nil, repeats: true)
//                }
//            }else{
//                self.removeTimerOfMotion()
//            }
//        }
        
    }

    private func startCountingSteps(fromDate:Date) {
        pedometer?.startUpdates(from: fromDate) {
            [weak self] pedometerData, error in
            
            guard let pedometerData = pedometerData, error == nil else { return }
            
            DispatchQueue.main.async {
                
                if self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isPause == true{
                    return
                }
                
                print("Distance :\(pedometerData.distance?.floatValue)")
                
                //Comment for while
                //                self?.mainView.lblTotalDistance.text = self?.setOneDigitWithFloor(value: (CGFloat((pedometerData.distance?.floatValue ?? 0.0)/1000)))
                
                //                s/m convert to km/hr 57.30
                let paceConvertTokmhr = (pedometerData.currentPace?.floatValue ?? 0.0) * 16.67
                
                let distance = pedometerData.distance?.doubleValue ?? 0.0
                let pace = pedometerData.currentPace?.doubleValue ?? nil
                
                self?.mainModelView.totalDistanceWithPedometer = distance
                self?.mainModelView.totalAverageActivePacePedometer = Double(paceConvertTokmhr)
                
                //FOR UPDATE TOTAL DISTANCE(StartWorkout every time not call main method)
                
                let dataDict:[String: Any] = ["distance": distance]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CARDIO_UPDATED_TOTAL_DISTANCE.rawValue), object: nil, userInfo: dataDict)

                if self?.mainModelView.previewData?.exercise?[0].duration == nil || self?.mainModelView.previewData?.exercise?[0].duration == ""{
                    
                    if (self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompleted == false || self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompleted == nil) && (self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompletedRest == false || self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompletedRest == nil)
                    {
                        //                        if self?.mainModelView.exerciseArray[0].startTime != self?.mainModelView.exerciseArray[0].repeatTime{
                        
                        var dateRepeat : Date?
                        
                        print("CurrentIndex:\(self?.mainModelView.currentWorkedIndex)")
                        
                        if self?.mainModelView.currentWorkedIndex == 0{
                            
                            dateRepeat = self?.mainModelView.previewData?.exercise?[0].repeatTime == "" ? Date() : self?.mainModelView.previewData?.exercise?[0].repeatTime.convertDateFormater()
                            
                        }else{
                            dateRepeat = self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].startTime == "" ? Date() : self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].startTime.convertDateFormater()
                        }
                        
                        if self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompleted == true && self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompletedRest == true{
                            print("Both Complted")
                            
                        }else{
                            self?.startUpdatingForRepeat(fromDate: dateRepeat ?? Date())
                        }
                    }
                }
            }
        }
    }
    
    func commonMethodForActivity(){
        let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased()
        if activityName == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){
            
            self.removeTimerOfMotion()
            
            var isPaused = false
            guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
                return
            }
            let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.activityId == Int(self.mainModelView.trainingLogId)}
            
            if self.mainModelView.previewData?.exercise?.count ?? 0 > 0{
                
                if self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0) - 1].isCompleted == true && self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0) - 1].isCompletedRest == true{

                    if routeObjects.count > 0{
                        if routeObjects[0].isPauseAfterAllLapCompleted == false{
                            isPaused = false
                        }else{
                            isPaused = true
                        }
                    }
                    
                }else{
                    if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isPause == false{
                        isPaused = false
                    }else{
                        isPaused = true
                    }
                }
            }
            
            if isPaused{

                if routeObjects.count > 0 {
                    
                    if routeObjects[0].isAutomaticallyPause == true{
                        
                        if self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0) - 1].isCompleted == true && self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0) - 1].isCompletedRest == true{
                            
                            try? realm?.write{
                                
                                if routeObjects.count > 0{
                                    routeObjects[0].isAutomaticallyPause = false
                                    routeObjects[0].isPauseAfterAllLapCompleted = false
                                }
                            }
                            
                        }else{
                            if (self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted != true){
                                
                                try? realm?.write{
                                    
                                    if routeObjects.count > 0{
                                        routeObjects[0].isAutomaticallyPause = false
                                    }
                                }

                                self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isPause = false

                            }
                        }
                        
                    }
                    
                }
                
            }
            
/*
            if isPaused {
                if (self.mainModelView.exerciseArray[self.mainModelView.index].isCompleted != true){
                    
                    let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.mainModelView.trainingLogId)}

                    try! realm.write{
                        
                        if routeObjects.count > 0{
                            routeObjects[0].isAutomaticallyPause = true
                        }
                    }

                    
                }
            }*/
        }
    }
    
    @objc func check10secondOrNot(){
        
        if activityManager == nil{
            return
        }
        
        if isEndAlertShowing == true{
            return
        }
        
        if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == true && (self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest == false || self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest == nil){
            
            return
        }
        
//        if (self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == false || self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted  == nil){
//
//        }else{
//            return
//        }
        
        countForMotion += 1
        print("LOGPREIVEW countForMotion:\(countForMotion)")
        
        if countForMotion > 5{
            
            print("LOGPREIVEW PHONE IS NOT IN MOTION")
            
            countForTotalStationaryTime += 1
            print("countForTotalStationaryTime:\(countForTotalStationaryTime)")
            
            Defaults.set(countForTotalStationaryTime, forKey: self.mainModelView.trainingLogId)
            Defaults.synchronize()

        }
        
        var isAutoPauseCheck = false
        
        if countForMotion >= 11{
            
            print("value defaults:\(Defaults.value(forKey: self.mainModelView.trainingLogId))")
            
//            countForTotalStationaryTime += 1
//            print("countForTotalStationaryTime:\(countForTotalStationaryTime)")
//
//            Defaults.set(countForTotalStationaryTime, forKey: self.mainModelView.trainingLogId)
//            Defaults.synchronize()

            let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased()
            
            if activityName == "Run (Outdoor)".lowercased(){
                isAutoPauseCheck = self.mainModelView.previewData?.runAutoPause ?? false
            }
                
            if activityName == "Cycling (Outdoor)".lowercased() {
                isAutoPauseCheck = self.mainModelView.previewData?.cycleAutoPause ?? false
            }
            
            if isAutoPauseCheck{
//                if !self.mainModelView.isPaused {
//                    self.btnPauseClicked(self.mainView.btnPlayPause)
//                }
            }else{
                if self.isAutoPauseCheckForAlert == false{
                    self.isAutoPauseCheckForAlert = true
                    autoPauseAlert()
                }
            }
        }
    }
    
    func autoPauseAlert(){
        
        let alertController = UIAlertController(title: "", message: getCommonString(key: "Do_you_want_to_continue_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            
            self.isAutoPauseCheckForAlert = false
            self.removeTimerOfMotion()
            
            if self.timerForMotion == nil{
                self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
            }
            
//            print("isActivity available : \(CMMotionActivityManager.isActivityAvailable())")
//            if CMMotionActivityManager.isActivityAvailable() {
//                self.startTrackingActivityType()
//            }
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            print("Cancel")
            
            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            print("date:\(date)")

            let dataCount = (self.mainModelView.previewData?.exercise?.count ?? 1) - 1
            self.mainModelView.previewData?.exercise?[dataCount].endTime = date

            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: true)

        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func removeTimerOfMotion(){
        if self.timerForMotion != nil{
            print("REMOVE REMOVE TIMER")
            countForMotion = 0
            self.timerForMotion?.invalidate()
            self.timerForMotion = nil
        }
    }

}

//MARK: - For distance and repeat functionality

extension LogPreviewVC{
    
    func startUpdatingForRepeat(fromDate:Date) {
            if CMMotionActivityManager.isActivityAvailable() {
                startTrackingActivityType()
            } else {
                
    //            makeToast(strMessage: "Phone is not in motion")
                print("Phone is not in motion")
               // activityTypeLabel.text = "Not available"
            }

            if CMPedometer.isStepCountingAvailable() {

                startCountingStepsForRepeat(fromDate:fromDate)
                
            } else {
              //  stepsCountLabel.text = "Not available"
            }
        }
    
    func updateStepsCountLabelForRepeatWorkout(startDate: Date) {
//           pedometer.queryPedometerData(from: startDate, to: Date()) {
//               [weak self] pedometerData, error in
//               if let error = error {
//                print("Error : \(error.localizedDescription)")
//
//               } else if let pedometerData = pedometerData {
//                   DispatchQueue.main.async {
//
//                    let distance = pedometerData.distance?.doubleValue ?? 0.0
//                    print("Repeat Distance: \(distance)")
//                   }
//               }
//           }
       }
    
    private func startCountingStepsForRepeat(fromDate:Date) {
        pedometer?.startUpdates(from: fromDate) {
            [weak self] pedometerData, error in
            
            guard let pedometerData = pedometerData, error == nil else { return }

            DispatchQueue.main.async {
                
                if (self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompleted == true) && (self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompletedRest == true){
                    return
                }
                
                if self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isPause == true{
                    return
                }

               if (self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompleted == false || self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompleted == nil) && (self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompletedRest == false || self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompletedRest == nil)
                {
                    
                    let distance = pedometerData.distance?.floatValue ?? 0.0
                    
                    //Decimal change
//                    self?.mainView.lblCount.text = self?.setOneDigitWithFloor(value: (CGFloat((pedometerData.distance?.floatValue ?? 0.0)/1000)))
                    
                    //                self?.mainView.lblCount.text = self?.oneDigitAfterDecimal(value: ((pedometerData.distance?.floatValue ?? 0.0)/1000))
                    
                    self?.mainModelView.coverdDistanceOfLapWithPedometer  = CGFloat(distance)
//                    self?.mainView.tableView.reloadData()
                
//                    self?.mainView.tableView.reloadRows(at: [IndexPath(row: self?.mainModelView.currentWorkedIndex ?? 0, section: 0)], with: .none)
                    
                    let totalDistanceValue = (self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].distance ?? 0.0) * 1000.0
                    
                    print("Log Preview Repeat Distance: :\(distance)")
                
                    if (self?.mainModelView.coverdDistanceOfLapWithPedometer ?? 0.0) >= totalDistanceValue{
                        
                        if self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompleted == true && self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompletedRest == true{
                            
                            print("Lap number: \(self?.mainModelView.currentWorkedIndex) Completed both")
                            
                        }else{
                            
                        }
                        
                    }
                    
                    if self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompleted == true && self?.mainModelView.previewData?.exercise?[self?.mainModelView.currentWorkedIndex ?? 0].isCompletedRest == true{
                        
                    }else{
                        
                        if self?.isRecallMainCountingSteps == true{
                            self?.isRecallMainCountingSteps = false
                            self?.perform(#selector(self?.reCallMainCountingStep), with: nil, afterDelay: 5.0)
                        }else{
                            
                        }
                    }
                }
            }
        }
    }

    @objc func reCallMainCountingStep(){
        
        isRecallMainCountingSteps = true
        
        self.mainView.tableView.reloadData()

        let dateStart = self.mainModelView.previewData?.exercise?[0].startTime == "" ? Date() : self.mainModelView.previewData?.exercise?[0].startTime.convertDateFormater()
        
        self.startUpdating(fromDate: dateStart ?? Date())
        
    }
}
//MARK: - ScrollView Delegate

extension LogPreviewVC: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height+177 <= mainView.safeAreaHeight{
            return
        }
        
        if self.mainView.scrollView.panGestureRecognizer.translation(in: scrollView).y > 0{
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                [self.mainView.vwRepeatWorkout,self.mainView.vwEndWorkout,self.mainView.vwCompleteWorkout,self.mainView.vwStartWorkout].forEach { (vw) in
                    vw?.alpha = 0.0
                }
                
                self.mainView.vwMainBottom.isUserInteractionEnabled = false
                
                if self.mainModelView.checkIsExerciseStarted(){
                    
                }else{
                    self.mainView.heightOfVwBottom.constant = 0
                    self.mainView.isBottomDeleteShareShow(isShow: false)
                }
//                self.mainView.constraintBottomofStackView.constant = 0
//                self.mainView.ConstratintBottomView.constant = 0
                self.mainView.layoutIfNeeded()

            }, completion: nil)
            
        }
        else{
            
            if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            }else{
                
                if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                    scrollEndMethod()
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        scrollEndMethod()
    }
    
    func scrollEndMethod(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            [self.mainView.vwRepeatWorkout,self.mainView.vwEndWorkout,self.mainView.vwCompleteWorkout,self.mainView.vwStartWorkout,self.mainView.vwBottom].forEach { (vw) in
                vw?.alpha = 1.0
            }
            
            self.mainView.vwMainBottom.isUserInteractionEnabled = true
            
            if self.mainModelView.checkIsExerciseStarted(){
                
            }else{
                self.mainView.heightOfVwBottom.constant = 75
                self.mainView.isBottomDeleteShareShow(isShow: true)
            }
            
//            self.mainView.constraintBottomofStackView.constant = 30.5
//            self.mainView.heightOfVwBottom.constant = 75
//            self.mainView.ConstratintBottomView.constant = 15
            self.mainView.layoutIfNeeded()
        }, completion: nil)

    }
    
}


extension LogPreviewVC: updateLatLongDelegate{
    
    func updatedLatLong(lat: Double,long: Double) {
        
        print("lat:\(lat)\t long:\(long)")
        
//        makeToast(strMessage: "LogPreview ======================== ")
        
        let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""
        if activityName == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){
            
            getPreviousTrackPolyline()

            if self.mainModelView.previewData?.exercise?[0].startTime == ""{
                return
            }
            
            //When user enter that time Timer set nil
            self.removeTimerOfMotion()

            if lattitude != lat && longitude != long {
                guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
                    return
                }
                let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.activityId == Int(self.mainModelView.trainingLogId)}
                
                //When user click on End button that time user goes to 10 second timer so that time isPaused call and Loader continue
                if self.isEndAlertShowing == true{
                    
                }else{
                    //Timer set here Reason we know like how many second before it call this method
                   
                    self.commonMethodForActivity()
                    
                    if self.mainModelView.previewData?.exercise?.count ?? 0 > 0{

                        if self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0) - 1].isCompleted == true && self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0) - 1].isCompletedRest == true{

                            if routeObjects.count > 0 {
                                if routeObjects[0].isPauseAfterAllLapCompleted == false{
                                    if self.timerForMotion == nil{
                                        self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
                                    }
                                }
                            }
                            
                        }else{
                            
                            //TODO:- Add Comment here because If it's pause then Total Duration already continue
                            
//                            if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isPause == false{
                                
                                if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == false || self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == nil{
                                        
                                    if self.timerForMotion == nil{
                                        self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
                                    }
                                }
//                            }
                        }
                    }
                   
                }
                
                lattitude = lat
                longitude = long
                
                var wayPoint : [String:String] = [:]
                wayPoint = ["way_lat" : String(lattitude),
                            "way_lng" : String(longitude)]
                
                let destination = CLLocationCoordinate2DMake(lattitude, longitude)
                arrWayPoint.append(destination)
                
                let polyline = Polyline(coordinates: arrWayPoint)
                let encodedPolyline: String = polyline.encodedPolyline
                
                print("enocodedPolyline : \(encodedPolyline)")
                
                print("TraininngGaolId : \(Int(self.mainModelView.trainingLogId))")
                
                try? realm?.write{
                    if routeObjects.count > 0{
                        routeObjects[0].allTrackRoute = encodedPolyline
                        
                        if arrWayPoint.count > 1{
                            routeObjects[0].secondLastIndex = arrWayPoint.count - 2
                            routeObjects[0].lastIndex = arrWayPoint.count - 1
                        }
                        
                        if self.mainModelView.previewData?.exercise?.count ?? 0 > 0{

                            if self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0) - 1].isCompleted == true && self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0) - 1].isCompletedRest == true{

                                if routeObjects[0].isPauseAfterAllLapCompleted == false{
                                    self.drawTotalPath(strPolyLine: routeObjects[0].allTrackRoute)
                                }
                                
                            }else{
                                if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isPause == false{
                                    self.drawTotalPath(strPolyLine: routeObjects[0].allTrackRoute)
                                }
                            }
                        }
                        
                    }
                }
            }
            else{
                print("timer call")
                //            let activityName = self.mainModelView.activityName.lowercased()
                //
                //            if activityName == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased() {
                //
                //                //Old condition wrong in second lap always return false bcz icCompleted always false
                //                //                        if (self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompleted == true) && (self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == false || self?.mainModelView.exerciseArray[self?.mainModelView.index ?? 0].isCompletedRest == nil){
                //
                //                if (self.mainModelView.exerciseArray[self.mainModelView.index ?? 0].isCompleted == false || self.mainModelView.exerciseArray[self.mainModelView.index ?? 0].isCompleted == nil){
                //                    if self.timerForMotion == nil{
                //                        print("ENTER IN TIME ENTER IN TIMER ===================== ENTER IN TIMER ENTER IN TIMER")
                //                        self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
                //                    }
                //                }else{
                //                    self.removeTimerOfMotion()
                //                }
                //            }
            }
        }
        
    }
    
}

//MARK: - Location/database related changes
extension LogPreviewVC{
    
    func getTrackDistance(){
        
        guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
            return
        }
        
        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.activityId == Int(self.mainModelView.trainingLogId)}

        if routeObjects.count > 0 {
            
            //We cannot Righ last index endTo because user also walk some km afrer complete lap so we have to take start of that repeat and recent value of Index passes
            //                        let lastIndex = routeObjects[0].lapArray.count - 1
            //                        routeObjects[0].lapArray[lastIndex].endTo
            
            self.mainModelView.totalDistanceWithPedometer = routeObjects[0].totalCoveredDistance
            self.totalDistancConverted = routeObjects[0].totalCoveredDistance
            
            self.lapCoveredDistance = routeObjects[0].lapArray[self.mainModelView.currentWorkedIndex].lapCoverDistance
            self.mainModelView.coverdDistanceOfLapWithPedometer  = CGFloat(self.lapCoveredDistance )
            
        }

    }
    
    func getPreviousTrackPolyline(){
        guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
            return
        }
        let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.activityId == Int(self.mainModelView.trainingLogId)}
        
        if routeObjects.count > 0{
            
            let polyline = Polyline(encodedPolyline: routeObjects[0].allTrackRoute)
            
            let decodedCoordinates: [CLLocationCoordinate2D] = polyline.coordinates!
            //   print("decodedCoordinates \(String(describing: decodedCoordinates))")
            self.arrWayPoint = []
            self.arrWayPoint = decodedCoordinates
            
        }
        
    }
    
    /*
     func findingAvgSpeed(){
     
     //        if self.mainModelView.exerciseArray[0].startTime == ""{
     //            return
     //        }
     //
     //        if self.mainModelView.exerciseArray[self.mainModelView.index].startTime == ""{
     //            return
     //        }
     //
     //        let startTime = self.mainModelView.exerciseArray[self.mainModelView.index].startTime
     //
     //        let time = Int(Date().timeIntervalSince(startTime.convertDateFormater()))
     //        print("time:\(time)")
     //        let avgSpeed = distanceOfLapForIndoor/CGFloat(time)
     //
     //        makeToast(strMessage: "avg speed : \(avgSpeed * 3.6)")
     
     }*/
    
    func drawTotalPath(strPolyLine:String)
    {
        //TODO: - Comment drawpath with Polyline
        
        if self.mainModelView.previewData == nil{
            return
        }
        
        let polyline = Polyline(encodedPolyline:strPolyLine)
        let decodedCoordinates: [CLLocationCoordinate2D] = polyline.coordinates!
        
        let decodeForElevationGain : [CLLocation] = polyline.locations!
        
        if decodedCoordinates.count > 1{
            guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
                return
            }
            let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data!.user!.id!.stringValue && $0.activityId == Int(self.mainModelView.trainingLogId)}
            
            if routeObjects.count > 0{
                
                //
                let secondLastIndex = decodedCoordinates[routeObjects[0].secondLastIndex]
                let lastIndex = decodedCoordinates[routeObjects[0].lastIndex]
                
                //finding elevation gain
                
                let oldAltitude = decodeForElevationGain[routeObjects[0].secondLastIndex].altitude
                let newAltitude = decodeForElevationGain[routeObjects[0].secondLastIndex].altitude

                let diff = oldAltitude - newAltitude
                
                self.mainModelView.netElevationGain += max(0, diff)
                
                routeObjects[0].elevationGain = self.mainModelView.netElevationGain

                //We can calculate Total Distance while it's not pause

                totalDistancConverted = totalDistancConverted + self.distance(driver: lastIndex, from: secondLastIndex)

                routeObjects[0].totalCoveredDistance = totalDistancConverted
                print("Total Distance:\(self.totalDistancConverted)")
                
                self.mainModelView.totalDistanceWithPedometer = totalDistancConverted
                
                //
                //For finding particular lap cover distance
                //
                
                if self.mainModelView.previewData?.exercise?.count ?? 0 > 0{
                    
                    if (self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == nil || self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == false) && (self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest == nil || self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest == false){
                        
                        let lapDistance = (self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].distance ?? 0.0)*1000
                        
                        lapCoveredDistance = lapCoveredDistance + self.distance(driver: lastIndex, from: secondLastIndex)
                        print("LogPreview lapCoveredDistance = \(lapCoveredDistance)")
                        
                        self.mainModelView.coverdDistanceOfLapWithPedometer  = CGFloat(lapCoveredDistance)
                        self.mainView.tableView.reloadData()
                        
                        routeObjects[0].lapArray[self.mainModelView.currentWorkedIndex].lapCoverDistance = lapCoveredDistance
                        
                        if lapCoveredDistance >= Double(lapDistance){
                            
                            lapCoveredDistance = 0.0
                            
                            //                                if routeObjects.count > 0{
                            //
                            //                                    if self.mainModelView.index + 1 == self.mainModelView.exerciseArray.count{
                            //                                        routeObjects[0].lapArray[self.mainModelView.index].startFrom = fromIndex
                            //                                        routeObjects[0].lapArray[self.mainModelView.index].endTo = currentIndex
                            //                                    }else{
                            //                                        routeObjects[0].lapArray[self.mainModelView.index].startFrom = fromIndex
                            //                                        routeObjects[0].lapArray[self.mainModelView.index].endTo = currentIndex
                            //
                            //                                        routeObjects[0].lapArray[self.mainModelView.index+1].startFrom = currentIndex
                            //                                    }
                            //                                }
                            //                            }
                            
                            if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == true && self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest == true{
                                
                                print("Lap number: \(self.mainModelView.currentWorkedIndex) Completed both")
                                
                            }else{
                                
                                if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == true && self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest == true{
                                    
                                }else{
                                    
                                }
                            }
                        }
                        
                      }
                    }
                }
            }
        }
        
        /*
        for i in self.lastIndex..<decodedCoordinates.count
        {
            if i > 0
            {
                if lastIndex < i{
                    let dictFirst = decodedCoordinates[i]
                    let dictSecond = decodedCoordinates[i-1]
                    totalDistancConverted = totalDistancConverted + self.distance(driver: dictFirst, from: dictSecond)
                    
                    lastIndex = i
                    print("lastIndex:\(lastIndex)")
                    print("TotalDistanceConveted = \(totalDistancConverted)")
                    
                    self.mainModelView.totalDistanceWithPedometer = totalDistancConverted
                    
                    //set for elevation gain
                    
                    let oldAltitude = decodeForElevationGain[i-1].altitude
                    let newAltitude = decodeForElevationGain[i].altitude
                    
                    let diff = oldAltitude - newAltitude
                    
                    self.mainModelView.netElevationGain += max(0, diff)
                    
//                    makeToast(strMessage: "ElevationL\(self.mainModelView.netElevationGain)")
                    
                    
                    //                    makeToast(strMessage: "\(totalDistancConverted)")
                    
                    if self.mainModelView.previewData?.exercise?[0].duration == nil || self.mainModelView.previewData?.exercise?[0].duration == ""{
                        
                        if (self.mainModelView.previewData?.exercise?.count ?? 0) > 0 {
                            if (self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == nil || self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == false) && (self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest == nil || self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest == false){
                                
                                //                            if self.mainModelView.index == 0{
                                //                                findDistanceOfParticularLap(polyline: strPolyLine, fromIndex: getStartFrom, currentIndex: lastIndex)
                                //                            }else{
                                
                                let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.mainModelView.trainingLogId)}
                                
                                let getStartFrom = routeObjects[0].lapArray[self.mainModelView.currentWorkedIndex].startFrom
                                
                                if getStartFrom <= lastIndex{
                                    if routeObjects.count > 0{
                                        
                                        findDistanceOfParticularLap(polyline: strPolyLine, fromIndex: getStartFrom, currentIndex: lastIndex)
                                    }
                                }
                                //                         }
                            }
                        }
                    }
                    
                }
            }
        }
        */
//    }
    
    func distance(driver: CLLocationCoordinate2D, from: CLLocationCoordinate2D) -> CLLocationDistance {
        let driver = CLLocation(latitude: driver.latitude, longitude: driver.longitude)
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        return driver.distance(from: from)
    }

    
    func findDistanceOfParticularLap(polyline:String,fromIndex:Int,currentIndex: Int){
        /*
        let routeObjects = Array(realm.objects(CardioActivityRoute.self)).filter { $0.userId == getUserDetail().data!.user!.id!.stringValue && $0.activityId == Int(self.mainModelView.trainingLogId)}
        
        //        if self.mainModelView.exerciseArray[self.mainModelView.index].duration == nil || self.mainModelView.exerciseArray[self.mainModelView.index].duration == ""{
        
        let lapDistance = (self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].distance ?? 0.0)*1000
        
        let polyline = Polyline(encodedPolyline:polyline)
        let decodedCoordinates: [CLLocationCoordinate2D] = polyline.coordinates!
        
        print("FromIndex : \(fromIndex)")
        print("CurrentIndex : \(currentIndex)")
        
        //Every time update last so when user click on Next lap that time value consider from here
        
        if routeObjects.count > 0{
            routeObjects[0].lapArray[self.mainModelView.currentWorkedIndex].endTo = currentIndex
        }
        
        for i in fromIndex..<decodedCoordinates.count
        {
            if i > 0
            {
                if lastLapIndex < i{
                    let dictFirst = decodedCoordinates[i]
                    let dictSecond = decodedCoordinates[i-1]
                    
                    print("Before screen show Distance : \(lapCoveredDistance)")
                    
                    lapCoveredDistance = lapCoveredDistance + self.distance(driver: dictFirst, from: dictSecond)
                    
                    print("lapCoveredDistance : \(lapCoveredDistance)")
                    
//                    makeToast(strMessage: "After Lap Distance LogPreview :\(lapCoveredDistance)")
                    self.lastLapIndex = i
                    
                    self.mainModelView.coverdDistanceOfLapWithPedometer  = CGFloat(lapCoveredDistance)
                    self.mainView.tableView.reloadData()
                    
                    if lapCoveredDistance >= Double(lapDistance){
                        
                        //                            try! realm.write{
                        
                        //Save data to realm local database Write comment because already written in DrawPath method
                        
                        lapCoveredDistance = 0.0
                        
                        if routeObjects.count > 0{
                            
                            if self.mainModelView.currentWorkedIndex + 1 == self.mainModelView.previewData?.exercise?.count{
                                routeObjects[0].lapArray[self.mainModelView.currentWorkedIndex].startFrom = fromIndex
                                routeObjects[0].lapArray[self.mainModelView.currentWorkedIndex].endTo = currentIndex
                            }else{
                                routeObjects[0].lapArray[self.mainModelView.currentWorkedIndex].startFrom = fromIndex
                                routeObjects[0].lapArray[self.mainModelView.currentWorkedIndex].endTo = currentIndex
                                
                                routeObjects[0].lapArray[self.mainModelView.currentWorkedIndex+1].startFrom = currentIndex
                            }
                        }
                        //                            }
                        
                        if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == true && self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest == true{
                            
                            print("Lap number: \(self.mainModelView.currentWorkedIndex) Completed both")
                            
                        }else{
                            
                            if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted == true && self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest == true{
                                
                            }else{
                                
                            }
                        }
                    }
                    
                }
            }
        }
        
        //        }
        
        */
    }
    
    
    func automaticallyForRest(){
        
        //Click on next button after rest get update data in Rest
        let activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""

        if activityName == "Run (Outdoor)".lowercased() || activityName == "Cycling (Outdoor)".lowercased(){
            
            if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].duration == nil || self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].duration == ""{
                    
                try? realm?.write{
                    
                    guard let routerArray = realm?.objects(CardioActivityRoute.self) else {
                        return
                    }
                    
                    let routeObjects = Array(routerArray).filter { $0.userId == getUserDetail()?.data?.user?.id?.stringValue && $0.activityId == Int(self.mainModelView.trainingLogId)}
                    
                    if routeObjects.count > 0 {
                        
                        //We cannot Righ last index endTo because user also walk some km afrer complete lap so we have to take start of that repeat and recent value of Index passes
                        //                            let lastIndex = routeObjects[0].lapArray.count - 1
                        //                        routeObjects[0].lapArray[lastIndex].endTo
                        if self.mainModelView.currentWorkedIndex == (self.mainModelView.previewData?.exercise?.count ?? 0) - 1{
                            //                                routeObjects[0].lapArray[self.mainModelView.index+1].startFrom = startingIndex
                            
                        }else{
//                            print("Index:\(self.mainModelView.currentWorkedIndex)")
                            lapCoveredDistance = 0.0
                            self.mainModelView.coverdDistanceOfLapWithPedometer = 0.0
                            
                            routeObjects[0].lapArray[self.mainModelView.currentWorkedIndex + 1].lapCoverDistance = 0.0

                        }
                    }
                }
            }
        }
        
    }
    
}
