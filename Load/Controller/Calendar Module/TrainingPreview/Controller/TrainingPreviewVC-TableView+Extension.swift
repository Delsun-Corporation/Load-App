//
//  TrainingPreviewVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 07/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreMotion
import GoogleMaps
import Polyline


extension TrainingPreviewVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return  0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TrainingPreviewCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "TrainingPreviewCell") as! TrainingPreviewCell
        cell.tag = indexPath.row
        cell.isSpeedSelected = self.mainModelView.isSpeedSelected
        cell.raceDistanceId = self.mainModelView.raceDistanceId
        cell.raceTime = self.mainModelView.raceTime
        cell.coverdDistancePedoMeter = self.mainModelView.coverdDistanceOfLapWithPedometer
        cell.delegateOfRest = self
        cell.exerciseArray = self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails as! [WeekWiseWorkoutLapsDetails?]
        let model = self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails
        
        if self.mainModelView.checkIsExerciseStarted(){
            cell.setupDataWithSpecificValueAndAnimation(data: model?[indexPath.row],index: self.mainModelView.currentWorkedIndex , totalCount: self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?.count ?? 0)
        }else{
            cell.setupUI(data: model?[indexPath.row], allLaps: model)
        }
        
        return cell
    }
}

extension TrainingPreviewVC: StartWorkoutDelegate{
 
    func closeViewDismissSelectLocationProgram() {
        self.mainModelView.isTrainingPreviewScreenOpen = true

        allDataConvertToExerciseKey()
        
        self.removeTimerOfMotion()
        self.activityManager = CMMotionActivityManager()
        self.isAutoPauseCheckForAlert = false
        
        AppDelegate.shared?.delegateUpadateLatLong = self
        AppDelegate.shared?.locationManager.startUpdatingLocation()
        
        if let value = Defaults.value(forKey: self.mainModelView.weekdayWiseMainID  + " " + "Program") as? Int{
            self.countForTotalStationaryTime = Int(value)
        }
        
        if self.mainModelView.selectedActivityTypeName == "Outdoor".lowercased(){
            
            if self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex ?? 0].isPause == false{
                
                self.removeTimerOfMotion()
                
                if self.timerForMotion == nil{
                    self.timerForMotion = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.check10secondOrNot), userInfo: nil, repeats: true)
                }
                
            }
            self.getTrackDistance()
            
        } else {
            self.reCallMainCountingStep()
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {
            
            if (self.mainView.scrollView.contentOffset.y >= (self.mainView.scrollView.contentSize.height - self.mainView.scrollView.frame.size.height)) || (self.mainView.scrollView.contentSize.height-102 <= self.mainView.safeAreaHeight) {
                self.mainView.isSetAlphaOrNOt(isSet: true)
            }else{
                self.mainView.isSetAlphaOrNOt(isSet: false)
            }
        }
        
        if self.mainModelView.checkIsExerciseStarted(){
            self.btnEdit.setTitle(str: "Switch View")
            self.btnEdit.setTitleColor(UIColor.appthemeRedColor, for: .normal)
            self.btnEdit.setImage(nil, for: .normal)
            self.btnEdit.contentHorizontalAlignment = .center
            self.btnRightBarButton.width = 200
            self.mainView.vwStartWorkout.isHidden = true
            self.mainView.vwCompleteWorkout.isHidden = true
            self.mainView.vwEndWorkout.isHidden = false
            
        }else{
            self.mainView.vwStartWorkout.isHidden = false
            self.mainView.vwCompleteWorkout.isHidden = false
            self.mainView.vwEndWorkout.isHidden = true
            
            //No edit button now so don't need to write
            
        }
        
    }
    
    func currentWorkedLapIndex(index: Int) {
        print("Index:\(index)")
        self.mainModelView.currentWorkedIndex = index
        self.mainView.tableView.reloadData()
    }
    
    func repeatWokout() {
        print("Repeat Workout")
    }
    
    func reloadTblData() {
        print("Reload table")
    }
    
    func StartWorkoutFinish(isDone: Bool, exerciseArray: [WeekWiseWorkoutLapsDetails]) {
        
        self.mainModelView.previewData?.isComplete = isDone
        self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails = exerciseArray
        self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.weekdayWiseMainID, progress: false)
    }

}

//MARK:- Selection Location program Delegate

extension TrainingPreviewVC: delegateSelectLocationProgram{
    
    func passpedometerDate(startDate:Date){
        print("startdate:\(startDate)")
        self.removeTimerOfMotion()
        if !(self.isCheckForOutdoors()){
            //This is for indoors only
            self.startUpdating(fromDate: startDate)
        }else{
            AppDelegate.shared?.locationManager.startUpdatingLocation()
        }

    }
    
    func pedometerDistancePace(distance: Double, Pace: Double) {
        print("Distance check in location screen:\(distance)")
        self.mainModelView.totalDistanceWithPedometer = distance
        self.totalDistancConverted = distance
        self.mainModelView.totalAverageActivePacePedometer = Pace
    }
    
    func passDataOfParticularLapWithPolyline(strPolyline:String ,lapDistance:Double){
        self.lapCoveredDistance = lapDistance
        self.mainModelView.coverdDistanceOfLapWithPedometer = CGFloat(lapDistance)
        self.mainModelView.isTrainingPreviewScreenOpen = false

        self.mainView.tableView.reloadData()
    }
    
    func netElevationGain(elevationGain: Double) {
        self.mainModelView.netElevationGain = elevationGain
    }

    func  clickOnPauseOrNot(isPause:Bool){
        self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex].isPause = isPause
        self.mainView.tableView.reloadData()
    }
    
    func indoorParticularLapForReset(distance:Double){
        self.mainModelView.isTrainingPreviewScreenOpen = false

        self.mainModelView.coverdDistanceOfLapWithPedometer = CGFloat(distance)
//        self.mainModelView.getCurrenIndexOfCurrentLap()
        self.mainView.tableView.reloadData()
        
        print("Distance:\(distance)")
        print("CurrentWork Index:\(self.mainModelView.currentWorkedIndex)")
        
        self.removeTimerOfMotion()
        if !(self.isCheckForOutdoors() ?? false){
            //This is for indoors only
            self.startUpdating(fromDate: self.mainModelView.previewData?.exercise?[0].startTime.convertDateFormater() ?? Date())
        }else{
            AppDelegate.shared?.locationManager.startUpdatingLocation()
        }

    }
 
}

//MARK:- Training Preview cell delegate

extension TrainingPreviewVC: restDelegateForTrainingPreview{
    
    func finalLapWithNullRest(){
        
        print("API CALLING HERE FIRST AFTER CALL IN WORKOUT")

        if self.mainModelView.isTrainingPreviewScreenOpen{
            
            self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex].isCompleted = true
            self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex].isCompletedRest = true
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.weekdayWiseMainID, progress: false)
            
        }
    }
    
    func automaticallyCompleteLap(isRestNil: Bool){
        
        print("API CALLING HERE FIRST AFTER CALL IN WORKOUT")
        
        if self.mainModelView.isTrainingPreviewScreenOpen{
            
            self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex].isCompleted = true
            
            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            
            if isRestNil == true{
                self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex].isCompletedRest = true
                
                self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex+1].startTime = date
                
                let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex+1].updatedRest)))
                
                let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                print("convertToStringForRest : \(convertToStringForRest)")
                self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex+1].addedRestTime = convertToStringForRest
                
            }else{
                
                let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex].updatedRest)))
                
                let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex].addedRestTime = convertToStringForRest
            }
            
            self.mainModelView.coverdDistanceOfLapWithPedometer = 0.0
            self.mainView.tableView.reloadData()

            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.weekdayWiseMainID, progress: false)
            
        }
        
    }
    
    func currentWorkoutRestClick() {
        
        print("API CALLING HERE FIRST AFTER CALL IN WORKOUT")

        if self.mainModelView.isTrainingPreviewScreenOpen {
            
            self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex].isCompletedRest = true
            
            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            if self.mainModelView.currentWorkedIndex+1 < self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?.count ?? 0{
                
                let data = self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex+1]
                
                if data?.duration != nil && data?.duration != "" {
                    //Add Duration time in current time and get difference
                    //                               let valueaddingForDuration = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[self.index+1].duration)))
                    //
                    //                                let convertToStringForDuration = valueaddingForDuration.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    //                                self.exerciseArray[self.index+1].addedStartTime = convertToStringForDuration
                    
                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex+1].updatedRest)))
                    
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    print("convertToStringForRest : \(convertToStringForRest)")
                    self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex+1].addedRestTime = convertToStringForRest
                    
                }else{
                    //Add direct time for Distance selection
                    //                                self.exerciseArray[self.index+1].startTime = date
                    
                    //TODO: - Comment for check below portion
                    
                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex+1].updatedRest)))
                    
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    print("convertToStringForRest : \(convertToStringForRest)")
                    self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex+1].addedRestTime = convertToStringForRest
                    
                    self.automaticallyForRest()
                    
                }
                
                self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[self.mainModelView.currentWorkedIndex+1].startTime = date
                
            }else{
                
                self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[(self.mainModelView.previewData?.exercise?.count ?? 0)-1].endTime = date
            }
            
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.weekdayWiseMainID, progress: false)
        }
    }
    
    func checkNextLapDataDistanceDurationRestData(index: Int, isRestNil: Bool,isLastLap:Bool) {
        
        print("API CALLING HERE FIRST AFTER CALL IN WORKOUT")
        
        if self.mainModelView.isTrainingPreviewScreenOpen {
            
            self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[index].isCompleted = true
            self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[index].isCompletedRest = true
            self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[index+1].isCompleted =  true
            
            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            
            if isRestNil == true{
                self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[index+1].isCompletedRest = true
                
                if isLastLap == false{
                    self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[index+1].startTime = date
                    
                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[index+1].updatedRest)))
                    
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    print("convertToStringForRest : \(convertToStringForRest)")
                    self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[index+1].addedRestTime = convertToStringForRest
                }
                
            }else{
                
                self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[index+1].startTime = date
                
                let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[index+1].updatedRest)))
                
                let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                self.mainModelView.previewData?.weekWiseWorkoutDetail?.weekWiseWorkoutLapsDetails?[index+1].addedRestTime = convertToStringForRest
            }
            
            self.mainModelView.coverdDistanceOfLapWithPedometer = 0.0
            self.mainView.tableView.reloadData()
            
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.weekdayWiseMainID, progress: false)
            
        }
        
    }
}

