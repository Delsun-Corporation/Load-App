//
//  LogPreviewResistanceVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 08/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension LogPreviewResistanceVC: UITableViewDelegate, UITableViewDataSource, ResistanceExercisePreviewStartDelegate, StartWorkoutResistanceDelegate, CountDownViewDelegate {
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        if self.mainModelView.previewData?.exercise?[section].isCompleted == true && self.mainModelView.previewData?.exercise?[section].selectedHeader == 1{
            return 55
        }

        if self.mainModelView.previewData?.exercise?[section].selectedUnit == 0{
            return 95
        }else{
            return 135
        }
        
        return 95
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = ResistanceExercisePreviewHeaderView.instanceFromNib() as? ResistanceExercisePreviewHeaderView
        view?.btnSelectAll.tag = section
        view?.btnExpandExercise.tag = section
        view?.btnUnit.tag = section
        view?.delegate = self
        
        if self.mainModelView.checkIsExerciseStarted(){
            view?.btnSelectAll.isHidden = false
//            self.btnSelectAll.isUserInteractionEnabled = true
        }else{
            view?.btnSelectAll.isHidden = true
//            self.btnSelectAll.isUserInteractionEnabled = false
        }
        
        view?.setupUI()
        view?.setupData(section: section, model: self.mainModelView.previewData?.exercise)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if self.mainModelView.previewData?.exercise?[section].selectedHeader == 0{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0))
            return view
        }else{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 5))
            view.backgroundColor = UIColor.white
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.mainModelView.previewData?.exercise?[section].selectedHeader == 0{
            return 0
        }else{
            return 5
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mainModelView.previewData?.exercise?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.mainModelView.previewData?.exercise?[section].selectedHeader == 1{
            return 0
        }
        
        return self.mainModelView.previewData?.exercise![section].data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ExerciseResistancePreviewCell = self.mainView.tableView.dequeueReusableCell(withIdentifier: "ExerciseResistancePreviewCell") as! ExerciseResistancePreviewCell
        let model = self.mainModelView.previewData?.exercise![indexPath.section].data![indexPath.row]
        
        if indexPath.row == (self.mainModelView.previewData?.exercise![indexPath.section].data?.count ?? 0) - 1{
            cell.vwUnderLine.isHidden = true
        }else{
            cell.vwUnderLine.isHidden = false
        }
        
        cell.sectionIndex = indexPath.section
        cell.txtRest.tag = indexPath.row
        cell.txtReps.tag = indexPath.row
        cell.btnRest.tag = indexPath.row
        
        cell.delegateResistancePreviewCell = self
        
        cell.workingSection = self.findSpecificIndextoShow().section
        cell.workingRowIndex = self.findSpecificIndextoShow().row
        cell.allExerciseArray = self.mainModelView.previewData?.exercise
        
        cell.setDetails(model: model!)
        
        return cell
    }
    
    //MARK: - TableView header delegate
    
    func ResistanceExercisePreviewStartFinish(tag: Int) {
//        let selectedDate = self.mainModelView.expandedDate
//        let currentDate = Date().toString(dateFormat: "yyyy-MM-dd")
//        if currentDate == selectedDate {
            
            // Anil code
            /*
            if self.mainModelView.checkIsCompleted() {
                return
            }*/
        //Updated code
        
        /*
        if self.mainModelView.previewData?.exercise?[tag].isCompleted ?? false {
            if let model = self.mainModelView.previewData?.exercise?[tag]{
                
                print("Height:\(self.mainView.heightTableView.constant)")
                
//                model.selectedUnit = 0
                
                if model.selectedHeader == 0{
                    model.selectedHeader = 1
                    if model.selectedUnit == 0{
                        self.mainView.heightTableView.constant -= 40
                    }else{
                        self.mainView.heightTableView.constant -= 80
                    }
                    model.selectedUnit = 0
                    //-5  for white footer when shrink all set
                    self.mainView.heightTableView.constant -= CGFloat((self.mainModelView.previewData?.exercise?[tag].data?.count ?? 0) * 77)-5
                    
                }else{
                    model.selectedHeader = 0
//                    model.selectedUnit = 1
                    self.mainView.heightTableView.constant += 40
                    //-5  for white footer when show all set
                    self.mainView.heightTableView.constant += CGFloat((self.mainModelView.previewData?.exercise?[tag].data?.count ?? 0) * 77)-5
                }
                
                self.mainModelView.previewData?.exercise?[tag] = model
                print("Updated Height:\(self.mainView.heightTableView.constant)")
                self.mainView.tableView.reloadData()
            }
            return
        }*/
        
        //Yash comment
            /*
            let obj: CountDownVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CountDownVC") as! CountDownVC
            obj.mainModelView.delegate = self
            obj.mainModelView.tag = tag
            obj.modalPresentationStyle = .overFullScreen
            self.present(obj, animated: true, completion: nil)
            */
        
        if self.mainModelView.previewData?.exercise?[tag].isCompleted ?? false{
            
            let lastSelectedSection = findSpecificIndextoShow().section
            let lastSelectedRow = findSpecificIndextoShow().row
            
            self.mainModelView.previewData?.exercise?[tag].isCompleted = false
            
            for i in 0..<(self.mainModelView.previewData?.exercise?[tag].data?.count ?? 0){
                self.mainModelView.previewData?.exercise?[tag].data?[i].isCompleted = false
                self.mainModelView.previewData?.exercise?[tag].data?[i].isCompletedRest = false
                self.mainModelView.previewData?.exercise?[tag].data?[i].isCheckMarkAlreadyDone = false
                self.mainModelView.previewData?.exercise?[tag].data?[i].isCurrentLapWorking = false
                self.mainModelView.previewData?.exercise?[tag].data?[i].isPause = false
                self.mainModelView.previewData?.exercise?[tag].data?[i].pauseTime = ""
                self.mainModelView.previewData?.exercise?[tag].data?[i].addedRestTime = ""
                self.mainModelView.previewData?.exercise?[tag].data?[i].isRepeatSet = true
                self.mainModelView.previewData?.exercise?[tag].isCompleted = false
                
                if i == 0 && tag == 0{
                    self.mainModelView.previewData?.exercise?[tag].data?[i].repeatTime = ""
                }else{
                    self.mainModelView.previewData?.exercise?[tag].data?[i].startTime = ""
                }
            }
            
            self.mainModelView.previewData?.exercise?[lastSelectedSection].data?[lastSelectedRow].isCurrentLapWorking = true

        }else{
            self.mainModelView.previewData?.exercise?[tag].isCompleted = true
            
            for i in 0..<(self.mainModelView.previewData?.exercise?[tag].data?.count ?? 0){
                self.mainModelView.previewData?.exercise?[tag].data?[i].isCompleted = true
                self.mainModelView.previewData?.exercise?[tag].data?[i].isCompletedRest = true
                self.mainModelView.previewData?.exercise?[tag].data?[i].isRepeatSet = false
    //            self.mainModelView.previewData?.exercise?[tag].data?[i].isCheckMarkAlreadyDone = true
                self.mainModelView.previewData?.exercise?[tag].isCompleted = true
            }

        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
        }

//        }
//        else {
//            makeToast(strMessage: getCommonString(key: "You_can't_end_future_workout"))
//        }
    }
    
    func ResistanceExerciseExpandTapped(tag:Int){
        
        if self.mainModelView.previewData?.exercise?[tag].isCompleted ?? false {
            if let model = self.mainModelView.previewData?.exercise?[tag]{
                
                print("Height:\(self.mainView.heightTableView.constant)")
                
//                model.selectedUnit = 0
                
                if model.selectedHeader == 0{
                    model.selectedHeader = 1
                    if model.selectedUnit == 0{
                        self.mainView.heightTableView.constant -= 40
                    }else{
                        self.mainView.heightTableView.constant -= 80
                    }
                    model.selectedUnit = 0
                    //-5  for white footer when shrink all set
                    self.mainView.heightTableView.constant -= CGFloat((self.mainModelView.previewData?.exercise?[tag].data?.count ?? 0) * 77)-5
                    
                }else{
                    model.selectedHeader = 0
//                    model.selectedUnit = 1
                    self.mainView.heightTableView.constant += 40
                    //-5  for white footer when show all set
                    self.mainView.heightTableView.constant += CGFloat((self.mainModelView.previewData?.exercise?[tag].data?.count ?? 0) * 77)-5
                }
                
                self.mainModelView.previewData?.exercise?[tag] = model
                print("Updated Height:\(self.mainView.heightTableView.constant)")
                self.mainView.tableView.reloadData()
            }
        }
    }
    
    func ResistanceExercisePreviewUnitTapped(tag: Int) {
        
        if let model = self.mainModelView.previewData?.exercise?[tag]{
            
            print("Height:\(self.mainView.heightTableView.constant)")
            
            if model.selectedUnit == 0{
                model.selectedUnit = 1
                self.mainView.heightTableView.constant += 40
            }else{
                model.selectedUnit = 0
                self.mainView.heightTableView.constant -= 40
            }
            
            self.mainModelView.previewData?.exercise?[tag] = model
            print("Updated Height:\(self.mainView.heightTableView.constant)")
            self.mainView.tableView.reloadData()
        }
    }

    
     func CountDownViewFinish(tag:Int) {
        
        let section = self.findSpecificIndextoShow().section
        let row = self.findSpecificIndextoShow().row
        
        let obj: StartWorkoutResistanceVC = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "StartWorkoutResistanceVC") as! StartWorkoutResistanceVC
        obj.mainModelView.delegate = self
        obj.mainModelView.arrayIndex = section
        obj.mainModelView.arrayRowIndex = row
        obj.mainModelView.strCommonLibraryId = self.mainModelView.previewData?.exercise?[section].commonLibraryId ?? 0
        obj.mainModelView.strLibraryId = self.mainModelView.previewData?.exercise?[section].libraryId ?? 0
        obj.mainModelView.exerciseAllResistanceArray = self.mainModelView.previewData?.exercise ?? []
        obj.mainModelView.totalLapCount = self.mainModelView.totalLapCount
        obj.mainModelView.targetedVolume = self.mainModelView.targetedVolume
        obj.mainModelView.completedVolume = self.mainModelView.completedVolume
        obj.mainModelView.handlerFinishWorkoutOnEndClick = {[weak self] (image) in
            self?.mainView.imgOfStartWorkout.image = image ?? nil
        }
        obj.modalPresentationStyle = .overFullScreen
        self.present(obj, animated: true, completion: nil)
     }
    
    func StartWorkoutFinish(tag:Int, exerciseAllArray: [ExerciseResistance]) {
        
        self.mainModelView.previewData?.exercise = exerciseAllArray
        self.mainModelView.previewData?.exercise?[tag].isCompleted = checkAllDone(exerciseArray: exerciseAllArray[tag].data)
        self.mainView.tableView.reloadData()
        self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
    }
    
    func finishWorkout(isDone: Bool, tag: Int, exerciseAllArray: [ExerciseResistance]) {
        self.mainModelView.previewData?.exercise = exerciseAllArray
        self.mainModelView.previewData?.exercise?[tag].isCompleted = checkAllDone(exerciseArray: exerciseAllArray[tag].data)
        self.mainView.tableView.reloadData()
        self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId,isEndWorkout: isDone, progress: false)
    }
    
    func afterAddExerciseLink(tag: Int, exerciseLink: String) {
        self.mainModelView.previewData?.exercise?[tag].exerciseLink = exerciseLink
        self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
    }
    
    func checkAllDone(exerciseArray:[DataExercise]?) -> Bool{
        
        guard let array = exerciseArray else { return false}
        
        if array.contains(where: { (data) -> Bool in
            if data.isCompleted == false || data.isCompletedRest == false || data.isCompleted == nil || data.isCompletedRest == nil{
                return true
            }
            return false
        }){
            return false
        }else{
            return true
        }
    }
}

//MARK: - ExercisePreviewcell Delegate

extension LogPreviewResistanceVC: ResistancePreviewCellDelegate{
    
    func getTextFieldRowSection(section: Int, row: Int, isTextFieldReps: Bool) {

        if !self.mainModelView.checkIsExerciseStarted(){
            makeToast(strMessage: "Please start exercise first")
            return
        }
        
        if findSpecificIndextoShow().section == section && findSpecificIndextoShow().row == row{
            
        }else{
            if isLapisWorking(section: section , row: row){
                return
            }
        }
        
        self.setAllCurrentLapWorkingFalse(section: section, row: row, isTextFieldReps: isTextFieldReps)
//        self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)

    }
    
    func particularSetRepeat(section: Int, row: Int){
        
        let lastSelectedSection = findSpecificIndextoShow().section
        let lastSelectedRow = findSpecificIndextoShow().row
        
        self.mainModelView.previewData?.exercise?[section].data?[row].isCompleted = false
        self.mainModelView.previewData?.exercise?[section].data?[row].isCompletedRest = false
        self.mainModelView.previewData?.exercise?[section].data?[row].isCheckMarkAlreadyDone = false
        self.mainModelView.previewData?.exercise?[section].data?[row].isCurrentLapWorking = false
        self.mainModelView.previewData?.exercise?[section].data?[row].isPause = false
        self.mainModelView.previewData?.exercise?[section].data?[row].pauseTime = ""
        self.mainModelView.previewData?.exercise?[section].data?[row].addedRestTime = ""
        self.mainModelView.previewData?.exercise?[section].data?[row].isRepeatSet = true
        
        //Don't need to add below line it's already set in startWorkoutFinish method
//        self.mainModelView.previewData?.exercise?[section].isCompleted = checkAllDone(exerciseArray: self.mainModelView.previewData?.exercise?[section].data ?? [])
        
        if section == 0 && row == 0{
            self.mainModelView.previewData?.exercise?[section].data?[row].repeatTime = ""
        }else{
            self.mainModelView.previewData?.exercise?[section].data?[row].startTime = ""
        }
        
        self.mainModelView.previewData?.exercise?[lastSelectedSection].data?[lastSelectedRow].isCurrentLapWorking = true
        
        self.StartWorkoutFinish(tag: section, exerciseAllArray: self.mainModelView.previewData?.exercise ?? [])
        
    }
    
    func automaticallyCompleteLap(section:Int, row: Int){
        
        self.sectionIndex = section
        self.rowIndex = row
        
        self.mainModelView.previewData?.exercise?[self.sectionIndex].data?[self.rowIndex].isCompleted = true

        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")

         let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.exercise?[self.sectionIndex].data?[self.rowIndex].rest)))

         let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        self.mainModelView.previewData?.exercise?[self.sectionIndex].data?[self.rowIndex].addedRestTime = convertToStringForRest

        self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
        
        /*
        self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].isCompleted = true

        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")

         let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].rest)))

         let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].addedRestTime = convertToStringForRest

        self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
     
//        self.mainModelView.getCurrenIndexOfCurrentLap()

//        self.removeTimer()*/

    }
    
    
    func automaticallyCompletdRestSet(section:Int, row: Int){
        
        print("section:\(section) row:\(row)")
        
        self.sectionIndex = section
        self.rowIndex = row
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        //            if self.isRest{
        /*
         if self.maxValue > 0 {
         self.startCountDownTimer(text: self.makeTimeStringForMMSS(h: h, m: m, s: s))
         }
         else{*/
        
        guard let dataModel = self.mainModelView.previewData?.exercise else{
            return
        }
        
        dataModel[self.sectionIndex].data?[self.rowIndex].isCompletedRest = true
        dataModel[self.sectionIndex].data?[self.rowIndex].isRepeatSet = false
        
        if (self.rowIndex + 1) != dataModel[self.sectionIndex].data?.count {
            
            dataModel[self.sectionIndex].data?[self.rowIndex].isCompletedRest = true
            
            if dataModel[self.sectionIndex].data?[self.rowIndex].reps == "" || dataModel[self.sectionIndex].data?[self.rowIndex].reps == nil{
                //Duration section
                
                print("Duration")
                //check next lap is completed or not
                
                if dataModel[self.sectionIndex].data?[self.rowIndex+1].isCompleted == true && dataModel[self.sectionIndex].data?[self.rowIndex+1].isCompletedRest == true{
                    //Next lap is Completed
                    //No need to assign next lap currentlap working
                    
                    //TODO: - NOT MOVE TO NEXT SET  OR EXERCISE
                    
                    self.setLastLapInCurrentExercise(lastLapIndex: self.rowIndex, isSetNextLapWorking: false)
                }else{
                    
                    //all set currentLapWorkinglap false including current index that's why write currentIndex as currentworkinglap after all done
                    
                    print("Row:\(self.rowIndex)")
                    print("section:\(self.sectionIndex)")
                    
                    self.setLastLapInCurrentExercise(lastLapIndex: self.rowIndex, isSetNextLapWorking: true)
                    
                    print("Row:\(self.rowIndex)")
                    print("After section:\(self.sectionIndex)")
                    
                    let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")

                     let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: dataModel[self.sectionIndex].data?[self.rowIndex].rest)))
                    let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
                    dataModel[self.sectionIndex].data?[self.rowIndex].addedRestTime = convertToStringForRest
                    dataModel[self.sectionIndex].data?[self.rowIndex].startTime = date
                }
                
                //set true because we need last currentworking lap
                dataModel[self.sectionIndex].data?[self.rowIndex].isCurrentLapWorking = true
                
                //MARK: - API calling Comment
                self.StartWorkoutFinish(tag: self.sectionIndex, exerciseAllArray: self.mainModelView.previewData?.exercise ?? [])
//                self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)

                //                            self.checkAndStart()
                
            }else{
                //Reps section
                print("Reps")
                
                //all set currentLapWorkinglap false including current index that's why write currentIndex as currentworkinglap after all done
                self.setLastLapInCurrentExercise(lastLapIndex: self.rowIndex, isSetNextLapWorking: false)
                
                //set true because we need last currentworking lap
                dataModel[self.sectionIndex].data?[self.rowIndex].isCurrentLapWorking = true
                
                //MARK: - API calling Comment
                self.StartWorkoutFinish(tag: self.sectionIndex, exerciseAllArray: self.mainModelView.previewData?.exercise ?? [])
//                self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
            }
            
        }
        else {
            
            dataModel[self.sectionIndex].data?[self.rowIndex].isCompletedRest = true
            
            if dataModel[self.sectionIndex].data?[self.rowIndex].reps == "" || dataModel[self.sectionIndex].data?[self.rowIndex].reps == nil{
                //Duration section
                
                print("Next Section available : \(checkNextSectionIsAvailableOrNot())")
                
                if checkNextSectionIsAvailableOrNot(){
                    
                    if self.mainModelView.previewData?.exercise?[self.sectionIndex+1].data?[0].reps == "" || self.mainModelView.previewData?.exercise?[self.sectionIndex+1].data?[0].reps == nil{
                        //Duration in next section
                        
                        //check next section is completed or not
                        if self.mainModelView.previewData?.exercise?[self.sectionIndex+1].data?[0].isCompleted == true && self.mainModelView.previewData?.exercise?[self.sectionIndex+1].data?[0].isCompletedRest == true{
                            
                            self.setLastLapInCurrentExercise(lastLapIndex: self.rowIndex, isSetNextLapWorking: false)
                            
                            //set true because we need last currentworking lap
                            self.mainModelView.previewData?.exercise?[self.sectionIndex].data?[self.rowIndex].isCurrentLapWorking = true
                            
                            //    self.theController?.dismiss(animated: true, completion: nil)
                            //MARK: - API calling Comment
                            self.StartWorkoutFinish(tag: self.sectionIndex, exerciseAllArray: self.mainModelView.previewData?.exercise ?? [])
//                            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
                            
                        }else{
                            
                            self.setLastLapInCurrentExercise(lastLapIndex: self.rowIndex, isSetNextLapWorking: true)
                            
                            //set true because we need last currentworking lap
                            
                            print("Before section:\(self.sectionIndex)")
                            
                            dataModel[self.sectionIndex].data?[self.rowIndex].startTime = date
                            dataModel[self.sectionIndex].data?[self.rowIndex].isCurrentLapWorking = true
                            
//                            self.mainModelView.previewData?.exercise?[self.sectionIndex].data?[self.rowIndex].isCurrentLapWorking = true
                            
                            //    self.theController?.dismiss(animated: true, completion: nil)
//                            self.delegate?.StartWorkoutFinish(tag: self.arrayIndex - 1, exerciseAllArray: self.exerciseAllResistanceArray)
                            
                            print("After section:\(self.sectionIndex)")
                            
                            //MARK: - API calling Comment
                            self.StartWorkoutFinish(tag: self.sectionIndex - 1, exerciseAllArray: self.mainModelView.previewData?.exercise ?? [])
//                            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
                            
//                            self.checkAndStart()
                            
                        }
                        
                        return
                        
                    }else{
                        
                        self.setLastLapInCurrentExercise(lastLapIndex: self.rowIndex, isSetNextLapWorking: false)
                        
                    }
                    
                }else{
                    
                    self.setLastLapInCurrentExercise(lastLapIndex: self.rowIndex, isSetNextLapWorking: false)
                }
                
            }else{
                
                print("Reps")
                
                //all set currentLapWorkinglap false including current index that's why write currentIndex as currentworkinglap after all done
                self.setLastLapInCurrentExercise(lastLapIndex: self.rowIndex, isSetNextLapWorking: false)

            }
            
            //set true because we need last currentworking lap
            self.mainModelView.previewData?.exercise?[self.sectionIndex].data?[self.rowIndex].isCurrentLapWorking = true
            
            //    self.theController?.dismiss(animated: true, completion: nil)
            //MARK: - API calling Comment
            self.StartWorkoutFinish(tag: self.sectionIndex, exerciseAllArray: self.mainModelView.previewData?.exercise ?? [])
//            self.mainModelView.apiCallSaveDetails(programId: self.mainModelView.trainingLogId, progress: false)
            
        }
        /*
         view.lblLapsCompleted.text = "\(self.checkCompletedLapsCount())/\(self.totalLapCount)"
         self.checkAndStart()*/
        
        //                }
        //            }
        /*else{
         
         self.timeCount += 1
         
         if self.isDuration
         {
         
         let (h, m, s) = secondsToHoursMinutesSeconds(seconds: Int(self.timeCount))
         self.startCountDownTimer(text: self.makeTimeStringForMMSS(h: h, m: m, s: s))
         
         view.lblDurationtRepsWorkout.text = self.makeTimeStringForMMSS(h: h, m: m, s: s)
         view.lblWeightWorkout.text = "\(self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].weight ?? "")"
         
         //                        setFontOfKg(mainString: "\(self.exerciseArray[self.index].weight ?? "")kg", stringToColor: "kg")
         
         if self.lapTotalDurationManualCalculation < self.timeCount{
         if (self.arrayRowIndex + 1) != self.exerciseAllResistanceArray[self.arrayIndex].data?.count {
         
         self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCompleted = true
         
         let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
         let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].rest)))
         
         let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
         self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].addedRestTime = convertToStringForRest
         
         //check Next button clickable or not
         if self.exerciseAllResistanceArray[self.arrayIndex].data?[arrayRowIndex+1].isCompleted == true && self.exerciseAllResistanceArray[self.arrayIndex].data?[arrayRowIndex+1].isCompletedRest == true{
         ChangeNextWorkOutColorChange(isRedColor: false)
         }else{
         ChangeNextWorkOutColorChange(isRedColor: true)
         }
         
         
         //all set currentLapWorkinglap false including current index that's why write currentIndex as currentworkinglap after all done
         self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: false)
         
         //set true because we need last currentworking lap
         self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCurrentLapWorking = true
         
         self.delegate?.StartWorkoutFinish(tag: self.arrayIndex, exerciseAllArray: self.exerciseAllResistanceArray)
         }
         else {
         self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCompleted = true
         
         //Check next button clickable or not
         if checkNextSectionIsAvailableOrNot(){
         
         if self.exerciseAllResistanceArray[self.arrayIndex+1].data?[0].isCompleted == true && self.exerciseAllResistanceArray[self.arrayIndex+1].data?[0].isCompletedRest == true{
         
         ChangeNextWorkOutColorChange(isRedColor: false)
         
         }else{
         ChangeNextWorkOutColorChange(isRedColor: true)
         }
         }else{
         ChangeNextWorkOutColorChange(isRedColor: false)
         }
         
         //all set currentLapWorkinglap false including current index that's why write currentIndex as currentworkinglap after all done
         self.theController?.setLastLapInCurrentExercise(lastLapIndex: self.arrayRowIndex, isSetNextLapWorking: false)
         
         //set true because we need last currentworking lap
         self.exerciseAllResistanceArray[self.arrayIndex].data?[self.arrayRowIndex].isCurrentLapWorking = true
         
         //                            self.theController?.dismiss(animated: true, completion: nil)
         self.delegate?.StartWorkoutFinish(tag: self.arrayIndex, exerciseAllArray: self.exerciseAllResistanceArray)
         }
         
         self.checkAndStart()
         }
         
         }else{
         
         if (self.arrayRowIndex + 1) != self.exerciseAllResistanceArray[self.arrayIndex].data?.count {
         
         //check Next button clickable or not
         if self.exerciseAllResistanceArray[self.arrayIndex].data?[arrayRowIndex+1].isCompleted == true && self.exerciseAllResistanceArray[self.arrayIndex].data?[arrayRowIndex+1].isCompletedRest == true{
         ChangeNextWorkOutColorChange(isRedColor: false)
         }else{
         ChangeNextWorkOutColorChange(isRedColor: true)
         }
         
         }else{
         ChangeNextWorkOutColorChange(isRedColor: true)
         //                    self.startCountDownTimer(text: "")
         }
         
         }
         }*/
        
    }
    
    func isLapisWorking(section: Int , row: Int) -> Bool {
        
        var isTrue = false
        
        for i in 0..<(self.mainModelView.previewData?.exercise?.count ?? 0){
            
            for j in 0..<(self.mainModelView.previewData?.exercise?[i].data?.count ?? 0){
                
                let dict = self.mainModelView.previewData?.exercise?[i].data?[j]
                
                if self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].isRepeatSet == true {
                    
                    if section == i && row == j{
                        print("dict JSON: \(dict?.toJSON())")
                    }else{
                        continue
                    }
                    
                    if (self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].isCompleted == false || self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].isCompleted == nil){
                        //Current working lap is not start so user can start other lap by clicking
                        print("User can click on other lap")
                        
                        if self.findSpecificIndextoShow().section == 0 && self.findSpecificIndextoShow().row == 0{
                            if self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].repeatTime == ""{
                                
                                isTrue = false
                            }else{
                                isTrue = true
                            }
                        }else{
                            if self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section].data?[self.findSpecificIndextoShow().row].startTime == ""{
                                
                                isTrue = false
                                
                            }else{
                                isTrue = true
                            }
                        }
                    }
                    else{
                        print("User can  not click on XXXXX")
                        isTrue = true
                    }
                    
                }else{
                    
                    if dict?.isCurrentLapWorking == true{
                        if dict?.isCompleted == true && dict?.isCompletedRest == true{
                            print("exercise not working")
                            //                            isTrue = false
                        }else{
                            print("exercise is working")
                            isTrue = true
                        }
                    }
                }
            }
        }
        
        if isTrue{
            makeToast(strMessage: "Exercise is already working. You can not start other set.")
            return true
        }else{
            return false
        }
    }
    
    func checkNextSectionIsAvailableOrNot() -> Bool{
        
        let dataDict = self.mainModelView.previewData?.exercise?[self.findSpecificIndextoShow().section]
        
        if let count = dataDict?.data?.count{
            
            if count - 1 == self.findSpecificIndextoShow().row{
                //Last lap
                
                if (self.mainModelView.previewData?.exercise?.count ?? 0) - 1 == self.findSpecificIndextoShow().section{
                    //Last section
                    return false
                }else{
                    // section next
                    return true
                }
            }
        }
        
        return false
    }

    
    func setLastLapInCurrentExercise(lastLapIndex:Int,isSetNextLapWorking:Bool){
        
        guard let mainArray = self.mainModelView.previewData?.exercise else{
            return
        }

        for i in 0..<mainArray.count{
            
            for j in 0..<(mainArray[i].data?.count ?? 0){
                
                guard let dict = mainArray[i].data?[j] else { return}
                
//                var dict = self.mainModelView.exerciseAllResistanceArray[i].data?[j]
                dict.isCurrentLapWorking = false
                mainArray[i].data?[j] = dict
            }
        }

        if isSetNextLapWorking{
            
            let dataDict = mainArray[self.sectionIndex]
            
            if let count = dataDict.data?.count{
                
                if count - 1 == lastLapIndex{
                    //Last lap
                    
                    if mainArray.count - 1 == self.sectionIndex{
                        //Last section
                        
                    }else{
                        self.sectionIndex += 1
                        self.rowIndex = 0
                        mainArray[self.sectionIndex].data?[0].isCurrentLapWorking = true
                    }
                    
                }else{
                    
                    self.rowIndex += 1
                    
                    mainArray[self.sectionIndex].data?[lastLapIndex+1].isCurrentLapWorking = true
                    print("mainArray:\(mainArray.toJSON())")

                }
            }
        }
    }
    
    func setAllCurrentLapWorkingFalse(section: Int, row: Int, isTextFieldReps: Bool){
        
        for i in 0..<(self.mainModelView.previewData?.exercise?.count ?? 0) {
            
            for j in 0..<(self.mainModelView.previewData?.exercise?[i].data?.count ?? 0){
                
                guard let dict = self.mainModelView.previewData?.exercise?[i].data?[j] else { return}
                
//                var dict = self.mainModelView.exerciseAllResistanceArray[i].data?[j]
                dict.isCurrentLapWorking = false
                self.mainModelView.previewData?.exercise?[i].data?[j] = dict
            }
        }
        
        self.mainModelView.previewData?.exercise?[section].data?[row].isCurrentLapWorking = true
        self.mainModelView.previewData?.exercise?[section].data?[row].isPause = false
        
        let date = Date().toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
        
        if section == 0 && row == 0{
            self.mainModelView.previewData?.exercise?[section].data?[row].repeatTime = date
        }else{
            self.mainModelView.previewData?.exercise?[section].data?[row].startTime = date
        }

//        self.mainView.tableView.reloadRows(at: [IndexPath(row: row, section: section)], with: .none)
        
        if isTextFieldReps == true{
            //Duration
            
            let valueAddigForRest = date.convertDateFormater().addingTimeInterval(TimeInterval(self.getSeconds(data: self.mainModelView.previewData?.exercise?[section].data?[row].rest)))

            let convertToStringForRest = valueAddigForRest.toString(dateFormat: "yyyy-MM-dd HH:mm:ss")
           self.mainModelView.previewData?.exercise?[section].data?[row].addedRestTime = convertToStringForRest

            if let cell = self.mainView.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? ExerciseResistancePreviewCell{
                cell.vwReps.flash(numberOfFlashes: 3)
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.61) {
                self.StartWorkoutFinish(tag: section, exerciseAllArray: self.mainModelView.previewData?.exercise ?? [])
            }

        }else{
            //Rest

            if let cell = self.mainView.tableView.cellForRow(at: IndexPath(row: row, section: section)) as? ExerciseResistancePreviewCell{
                cell.vwRest.flash(numberOfFlashes: 3)
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.61) {
                self.mainModelView.previewData?.exercise?[section].data?[row].isCompleted = true
                self.automaticallyCompleteLap(section: section, row: row)
            }
        }
    }
    
}
