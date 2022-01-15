//
//  LogPreviewVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 07/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension LogPreviewVC: UITableViewDelegate, UITableViewDataSource, StartWorkoutCardioDelegate {
    
    
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
        return self.mainModelView.previewData?.exercise?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LogPreviewCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "LogPreviewCell") as! LogPreviewCell
        let model = self.mainModelView.previewData?.exercise![indexPath.row]
        cell.activityId = self.mainModelView.previewData?.trainingActivity?.id?.stringValue ?? ""
        cell.activityName = self.mainModelView.previewData?.trainingActivity?.name?.lowercased() ?? ""
        cell.coverdDistancePedoMeter = self.mainModelView.coverdDistanceOfLapWithPedometer
        cell.tag = indexPath.row
        cell.delegateOfRest = self
        cell.setupUI()
        cell.setPreviewDetails(model: model!,index:self.mainModelView.currentWorkedIndex,totalCount:self.mainModelView.previewData?.exercise?.count ?? 0)
        
        return cell
    }
    
    func StartWorkoutFinish(isDone: Bool, exerciseArray: [Exercise]) {
        print("isDone : \(isDone)")
        self.mainModelView.previewData?.isComplete = isDone
        self.mainModelView.previewData?.exercise = exerciseArray
        self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
    }
    
    func currentWorkedLapIndex(index: Int) {
        self.mainModelView.currentWorkedIndex = index
        self.mainView.tableView.reloadData()
        self.mainModelView.checkRepeatClickableOrNot()
    }
    
    func repeatWokout(){
        self.mainModelView.isRepeatExercise = true
        self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, isEndWorkout: false)
//        self.removeTimer()
    }

}

extension LogPreviewVC: restDelegateForLogPreview{
   
    func finalLapWithNullRest(){
        
        print("API CALLING HERE FIRST AFTER CALL IN WORKOUT")
        
        if self.mainModelView.isLogPreviewScreenOpen {
            
            self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted = true
            self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest = true
            self.mainModelView.checkRepeatClickableOrNot()
            
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
        }
        //        self.removeTimer()
        
    }
    
    func automaticallyCompleteLap(isRestNil: Bool){
        
        print("API CALLING HERE FIRST AFTER CALL IN WORKOUT")
        
        if self.mainModelView.isLogPreviewScreenOpen {
            
            self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompleted = true

            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")

            if isRestNil == true{
                self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest = true
                
                self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex+1].startTime = date
                
                let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex+1].rest)))
                
                let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                print("convertToStringForRest : \(convertToStringForRest)")
                self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex+1].addedRestTime = convertToStringForRest

            }else{

                 let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].rest)))

                 let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                 self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].addedRestTime = convertToStringForRest
            }
            
            //ADD TODAY
            self.mainModelView.coverdDistanceOfLapWithPedometer = 0.0
            self.mainView.tableView.reloadData()
            
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
    //        self.mainModelView.getCurrenIndexOfCurrentLap()

    //        self.removeTimer()
            
        }

    }
    
    func currentWorkoutRestClick() {
        
        print("API CALLING HERE FIRST AFTER CALL IN WORKOUT")
        
        if self.mainModelView.isLogPreviewScreenOpen{
            
            self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex].isCompletedRest = true
            
            let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
            if self.mainModelView.currentWorkedIndex+1 < self.mainModelView.previewData?.exercise?.count ?? 0{
                
                let data = self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex+1]
                
                if data?.duration != nil && data?.duration != "" {
                    //Add Duration time in current time and get difference
                    //                               let valueaddingForDuration = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseArray[self.index+1].duration)))
                    //
                    //                                let convertToStringForDuration = valueaddingForDuration.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    //                                self.exerciseArray[self.index+1].addedStartTime = convertToStringForDuration
                    
                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex+1].rest)))
                    
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    print("convertToStringForRest : \(convertToStringForRest)")
                    self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex+1].addedRestTime = convertToStringForRest
                    
                }else{
                    //Add direct time for Distance selection
                    //                                self.exerciseArray[self.index+1].startTime = date
                    
                    //TODO: - Comment for check below portion
                    
                    let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex+1].rest)))
                    
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    print("convertToStringForRest : \(convertToStringForRest)")
                    self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex+1].addedRestTime = convertToStringForRest
                    
                    self.automaticallyForRest()
                    
                }
                
                self.mainModelView.previewData?.exercise?[self.mainModelView.currentWorkedIndex+1].startTime = date
                
            }else{
                
                self.mainModelView.previewData?.exercise?[(self.mainModelView.previewData?.exercise?.count ?? 0)-1].endTime = date
                self.mainModelView.checkRepeatClickableOrNot()
            }
            
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
        }
        
        //        self.mainModelView.getCurrenIndexOfCurrentLap()
        
    }
    
    func reloadTblData() {
        self.mainView.tableView.reloadData()
    }
    
}
