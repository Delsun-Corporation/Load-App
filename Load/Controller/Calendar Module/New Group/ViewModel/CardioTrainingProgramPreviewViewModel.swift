//
//  CardioTrainingProgramPreviewViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 17/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class CardioTrainingProgramPreviewViewModel {

    fileprivate weak var theController: CardioTrainingProgramPreviewVC!
    
    var titleValue: String = ""
    var titleSubValue: String = ""
    var selectedDate: Date = Date()
    var startDate: Date = Date()
    var endDate: Date = Date()
    var frequencyValue: String = ""
    var frequencySelectedValue: String = ""
    var isStartDate:Bool?
    var frequencyId:String = ""
    var presetTrainingProgramsId:String = ""
    var customArray:[String] = []

    init(theController:CardioTrainingProgramPreviewVC) {
        self.theController = theController
    }
    
    func setupUI() {
        let view = (self.theController.view as? CardioTrainingProgramPreviewView)
        view?.lblTitle.text = self.titleValue
        view?.lblSubTitle.text = self.titleSubValue
        view?.txtStartDate.text = self.startDate.toString(dateFormat: "dd MMMM yyyy")
        view?.txtEndate.text = self.endDate.toString(dateFormat: "dd MMMM yyyy")
        view?.txtFrequency.text = self.frequencyValue
        view?.lblFrequencySelected.text = self.frequencySelectedValue
    }
    
    func validateDetails() {
        self.apiCallMessagesUserList(trainingFrequenciesId: self.frequencyId, presetTrainingProgramsId: self.presetTrainingProgramsId, startDate: self.startDate, endDate: self.endDate, days: self.customArray)
    }
    
    func apiCallMessagesUserList(trainingFrequenciesId:String, presetTrainingProgramsId:String, startDate:Date, endDate:Date, days:[String]) {
        let param = ["status": TRAINING_LOG_STATUS.CARDIO.rawValue,
                      "type": TRAINING_LOG_STATUS.PRESET.rawValue,
                     "user_id": getUserDetail()?.data?.user?.id?.stringValue ?? "",
                      "training_frequencies_id": trainingFrequenciesId,
                      "preset_training_programs_id": presetTrainingProgramsId,
                      "start_date": startDate.iso8601,
                      "end_date": endDate.iso8601,
                      "days": days] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CREATE_TRAINING_PROGRAM , params: param as [String : Any], vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let message = json.getString(key: .message)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.CALENDAR_RELOADING.rawValue), object: nil)
                    self.theController.navigationController?.popToRootViewController(animated: true)
                    self.theController.delegateDismissCardioTrainingProgram?.dismissCreateCardioTrainingProgram()
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                        makeToast(strMessage: message)
                    }
                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        })
    }
}
