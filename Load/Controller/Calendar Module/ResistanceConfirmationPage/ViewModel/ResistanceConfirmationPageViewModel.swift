//
//  ResistanceConfirmationPageViewModel.swift
//  Load
//
//  Created by iMac on 12/02/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON
import IQKeyboardManagerSwift

class ResistanceConfirmationPageViewModel: CustomNavigationDelegate {
    
    fileprivate weak var theController:ResistanceConfirmationPageVc!

    init(theController:ResistanceConfirmationPageVc) {
        self.theController = theController
    }
    
    var trainingLogId = ""
    var previewData: TrainingLogResistanceModelClass?
    var isEditRow:Int?
    var isShowDropdown:Bool = true
    //call same delegate as we used in resistance/cardio confirmation
    var delegateConfirmation: dismissConfirmationPageDelegate?

    var intensityId:String = ""
    var trainingGoalId:String = ""
    var resistanceValidationList: [ResistanceValidationListData] = []
    var selectedResistanceValidationList: ResistanceValidationListData?
    var isSelectedDuration:[Bool] = []
    var exercisesMainArray:[LibraryLogList] = [LibraryLogList]()

    //MARK: - SetupUI
    func setupUI(){
        self.apiCallGetCompletedData()
        
    }
    
    //MARK: setupNavigation Bar
    
    func setupNavigationbar(title:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationController?.setColor()
        self.theController.navigationItem.hidesBackButton = true
        self.theController.navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        if let vwnav = ViewNav.instanceFromNib() as? ViewNav {
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 20
            }
            else {
                hightOfView = -4
            }
            
            vwnav.frame = CGRect(x: 0, y: 0, width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height + CGFloat(hightOfView))
            
            vwnav.leadingConstraintLabelConstant.constant = 30
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 20, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            vwnav.btnClose.isHidden = true
            
            vwnav.tag = 1000
            vwnav.delegate = self
            self.theController.navigationController?.view.addSubview(vwnav)
        }
    }
    
    func CustomNavigationClose() {
        self.theController.dismiss(animated: true, completion: nil)
    }
    
    func getValidationFromId() {
        let filter = self.resistanceValidationList.filter { (model) -> Bool in
            
            return model.trainingIntensityId?.stringValue == self.intensityId && model.trainingGoalId?.stringValue == self.trainingGoalId
        }
        self.selectedResistanceValidationList = filter.first
        
        if let view = (self.theController.view as? ResistanceConfirmationPageView){
            view.tableView.reloadData()
        }
    }
    
    
    func setupEditData() {
        let view = (self.theController.view as? ResistanceConfirmationPageView)!
        
        let trainigGoalCustom = self.previewData?.trainingGoalCustom
        
        if self.previewData?.trainingGoalId?.stringValue == "" || self.previewData?.trainingGoalId?.stringValue == nil || self.previewData?.trainingGoalId?.stringValue == "0"{
            
            self.trainingGoalId = String(self.previewData!.trainingGoalCustomId)
//            self.isGoalCustom = true
            self.isShowDropdown = true
        }else{
            self.trainingGoalId = self.previewData?.trainingGoalId?.stringValue ?? ""
//            self.isGoalCustom = false
            if self.previewData?.trainingGoal?.name?.lowercased() == "Muscular Endurance (Medium)".lowercased() || self.previewData?.trainingGoal?.name?.lowercased() == "Muscular Endurance (Short)".lowercased() || self.previewData?.trainingGoal?.name?.lowercased() == "customize".lowercased() {
                self.isShowDropdown = true
            }else{
                self.isShowDropdown = false
            }
        }

        self.intensityId = "\(self.previewData?.trainingIntensityId ?? 0)"
//        self.trainingId = self.previewData?.id?.stringValue ?? ""
        print("TrainingLog id:\(self.trainingLogId)")
        
        print(self.intensityId)
        print(self.trainingGoalId)
        for exerciseData in self.previewData?.exercise ?? [] {
            
            print("ExerciseData:\(exerciseData.toJSON())")
            
            let dict: NSDictionary = ["exercise_name":exerciseData.name!, "Mechanics": "","selected": true,"is_edit" : true,"library_id": exerciseData.libraryId,"common_library_id": exerciseData.commonLibraryId, "exercise_link": exerciseData.exerciseLink]
            self.isSelectedDuration.append(exerciseData.data?.first?.reps != nil &&  exerciseData.data?.first?.reps != "" ? false : true)

            let exercises = LibraryLogList(JSON: JSON(dict).dictionaryObject!)
            var exercisesArray:[ResistanceExerciseModelClass] = [ResistanceExerciseModelClass]()
            
            for exerciseDataSub in exerciseData.data ?? [] {
                let dictSub: NSDictionary = ["Weight":exerciseDataSub.weight ?? "", "Reps": exerciseDataSub.reps ?? "","duration": exerciseDataSub.duration ?? "", "Rest": exerciseDataSub.rest ?? "", "is_completed": exerciseDataSub.isCompleted ?? ""]
                
                let exercisesSub = ResistanceExerciseModelClass(JSON: JSON(dictSub).dictionaryObject!)
                exercisesArray.append(exercisesSub!)
            }
            exercises?.exercisesArray = exercisesArray
            exercises?.repetitionMax = exerciseData.repetitionMax
            self.exercisesMainArray.append(exercises!)
        }
        print(self.isSelectedDuration)
        var count:Int = 0
        for (index, _) in self.exercisesMainArray.enumerated() {
            count += self.exercisesMainArray[index].exercisesArray.count
        }
        
        self.theController.changeColorAccordingToClickable()
        
//        view.btnLogIt.backgroundColor = UIColor.appthemeRedColor
//        view.btnLogIt.isUserInteractionEnabled = true

        self.getValidationFromId()
        view.tableViewHeight.constant = CGFloat((self.exercisesMainArray.count * 127) + (count * 73))
        view.tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
            self.theController.buttonVisibleOrNot()
        }
    }

}

//MARK: - API calling

extension ResistanceConfirmationPageViewModel{
    
    
    func apiCallUpdateLibraryAfterAlert(id:String, repetitionMax: NSMutableArray,isMsgShowAgain:Bool,userId:Int,atIndex : Int) {
        
        var param = [
            "repetition_max": repetitionMax,
            "is_show_again_message" : isMsgShowAgain
            ] as [String : Any]
        
        if userId == 0{
            param["common_libraries_id"] = Int(id)
        }else{
            param["libraries_id"] = Int(id)
        }
        
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CREATE_UPDATE_COMMON_LIBRARY_DETAILS, params: param as [String : Any],progress: false, vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                let message = json.getString(key: .message)
                 let data = json.getDictionary(key: .data)
                
                let model = CommonRepetitionMax(JSON: data.dictionaryObject!)
                
                if success {
                    
                    print("index : \(atIndex)")
                    
                    self.exercisesMainArray[atIndex].isShowAlertOrNot = isMsgShowAgain
                    self.exercisesMainArray[atIndex].repetitionMax = model?.repetitionMax
                }
                else {
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    func apiCallGetValidation() {
        let param = ["is_active": true,
                     "relation": [
                        "training_intensity_detail",
                        "training_goal_detail"
            ],
//                     "list": [
//                        "id",
//                        "training_intensity_id",
//                        "training_goal_id",
//                        "weight_range",
//                        "reps_range",
//                        "reps_time_range",
//                        "rest_range",
//                        "is_active"
//            ],
                     "training_intensity_detail_list": [
                        "id",
                        "name",
                        "is_active"
            ],
                     "training_goal_detail_list": [
                        "id",
                        "name",
                        "display_at",
                        "is_active"
            ]
        ] as [String : Any]
        
        print(JSON(param))
        ApiManager.shared.MakeGetAPI(name: LOG_RESISTANCE_VALIDATION_LIST, params: param as [String : Any], vc: self.theController) { response, error in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let model = ResistanceValidationList(JSON: json.dictionaryObject!)
                self.resistanceValidationList = model?.data ?? []
                self.getValidationFromId()
                let view = (self.theController.view as? ResistanceConfirmationPageView)
                view?.tableView.reloadData()
            }
        }
    }
    
    func apiCallGetCompletedData() {
        
        ApiManager.shared.MakeGetAPI(name: GET_RESISTANCE_CONFIRMATION_DATA + "/" + "\(trainingLogId)", params: [:], progress: true, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let data = json.getDictionary(key: .data)

                let success = json.getBool(key: .success)
                if success {
                    
                    self.apiCallGetValidation()
                    
                    let model = TrainingLogResistanceModelClass(JSON: data.dictionaryObject!)
                    self.previewData = model
                    self.setupEditData()
                    self.dataFillUp()
                    self.theController.changeColorAccordingToClickable()
                }
                else {
                    self.theController.changeColorAccordingToClickable()
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            } else {
                self.theController.changeColorAccordingToClickable()
            }
        })
    }
    
    func apiCallForSaveUpdatedData(totalDuration:String, exercise: NSMutableArray){
        
        let param = ["total_duration":totalDuration, "exercise":exercise, "training_intensity_id": self.intensityId] as [String : Any]

        print(JSON(param))

        ApiManager.shared.MakePutAPI(name: UPDATE_RESISTANCE_CONFIRMATION_TRAINING_LOG + "/" + trainingLogId, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let data = json.getDictionary(key: .data)
                print(data)
                
                let success = json.getBool(key: .success)
                if success {
                    self.theController.redirectToRPEScreen()
                }
            }
        }
    }
    
    
    //MARK:- ActionSheet
    func showActionSheet(row:Int, section:Int) {
        let actionSheet = UIAlertController(title: "Set Number \(row + 1)", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Remove Set", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.exercisesMainArray[section].exercisesArray.remove(at: row)
            var count:Int = 0
            for (index, _) in self.exercisesMainArray.enumerated() {
                count += self.exercisesMainArray[index].exercisesArray.count
            }
            let view = (self.theController.view as? ResistanceConfirmationPageView)
            view?.tableViewHeight.constant = CGFloat((self.exercisesMainArray.count * 127) + (count * 73))
            view?.tableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                self.theController.buttonVisibleOrNot()
            }

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Rearrange Set", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.isEditRow = section
            let view = (self.theController.view as? ResistanceConfirmationPageView)
            view?.tableView.reloadData()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.theController.present(actionSheet, animated: true, completion: nil)
    }
    
    
    func showActionSheetSection(section:Int) {
        
        let actionSheet = UIAlertController(title: self.exercisesMainArray[section].exerciseName, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Duplicate Exercise", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.exercisesMainArray.append(self.exercisesMainArray[section])
            self.isSelectedDuration.append(self.isSelectedDuration[section])
            
            var count:Int = 0
            for (index, _) in self.exercisesMainArray.enumerated() {
                count += self.exercisesMainArray[index].exercisesArray.count
            }
            let view = (self.theController.view as? ResistanceConfirmationPageView)
            view?.tableViewHeight.constant = CGFloat((self.exercisesMainArray.count * 127) + (count * 73))
            view?.tableView.reloadData()
            self.theController.changeColorAccordingToClickable()

            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                self.theController.buttonVisibleOrNot()
            }

            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Rearrange Exercise", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            let view = (self.theController.view as? ResistanceConfirmationPageView)
            view?.tableView.isEditing = true
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Remove Exercise", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.exercisesMainArray.remove(at: section)
            self.isSelectedDuration.remove(at: section)
            
            var count:Int = 0
            for (index, _) in self.exercisesMainArray.enumerated() {
                count += self.exercisesMainArray[index].exercisesArray.count
            }
            let view = (self.theController.view as? ResistanceConfirmationPageView)
            view?.tableViewHeight.constant = CGFloat((self.exercisesMainArray.count * 127) + (count * 73))
            view?.tableView.reloadData()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                self.theController.buttonVisibleOrNot()
            }

            self.theController.changeColorAccordingToClickable()

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.theController.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func dataFillUp(){
        
        if let vw = self.theController.view as? ResistanceConfirmationPageView{
            
            let strColon = self.previewData?.totalDuration
            
            var arrayDuration = strColon?.split(separator: ":")
            var valueOfFirstIndex = ""

            if arrayDuration?.count == 3{
                
                if Int(arrayDuration?[0] ?? "") ?? 0 <= 9 {
                    valueOfFirstIndex = "0\(Int(String(arrayDuration?[0] ?? "0")) ?? 0)"
                }else{
                    valueOfFirstIndex = String(arrayDuration?[0] ?? "00")
                }

                let checkValue = "\(valueOfFirstIndex):\(arrayDuration?[1] ?? "00"):\(arrayDuration?[2] ?? "00")"

                print("Total Duration:\(checkValue)")
                
                vw.txtTotalDuration.text = checkValue.replacingOccurrences(of: ":", with: "  ")

            }
        }
        
    }



}
