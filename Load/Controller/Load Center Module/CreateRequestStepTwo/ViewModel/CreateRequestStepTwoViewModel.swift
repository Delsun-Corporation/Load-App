//
//  CreateRequestStepTwoViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 24/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateRequestStepTwoViewModel {

    //MARK:- Variables
    fileprivate weak var theController:CreateRequestStepTwoVC!
    
    //First step valiables
    var requestTitle:String = ""
    var selectedDateStartTraining:Date?
    var requestDescription:String = ""

    //Second step valiables
    var selectedSpecialization: [String] = [String]()
    let coachExperiencePickerView = UIPickerView()
    let typesOfTrainingPickerView = UIPickerView()
    let locationPickerView = UIPickerView()
    var coachExperience:String = ""
//    var typesOfTraining:[String] = [String]()
    var selectedArraySpecialization:[Int] = [Int]()
    var selectedNameArraySpecialization:[String] = [String]()
    var selectedArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    
    var location:String = ""
    
    var isEdit = false
    var editRequestData : RequestData?

    init(theController:CreateRequestStepTwoVC) {
        self.theController = theController
    }
    
    //MARK:- Functions
    func setupUI() {
        let view = (self.theController.view as? CreateRequestStepTwoView)

        coachExperiencePickerView.delegate = theController
        coachExperiencePickerView.backgroundColor = UIColor.white
        view?.txtCoachExperience.inputView = coachExperiencePickerView
        
        typesOfTrainingPickerView.delegate = theController
        typesOfTrainingPickerView.backgroundColor = UIColor.white
        view?.txtTypesOfTraining.inputView = typesOfTrainingPickerView
        
        locationPickerView.delegate = theController
        locationPickerView.backgroundColor = UIColor.white
        view?.txtLocation.inputView = locationPickerView
        
        if self.isEdit{
            self.setupEditData()
        }
        
    }
    
    func setupEditData(){
        
        if let view = self.theController.view as? CreateRequestStepTwoView{

            var selectedSpecializationName : [String] = []
            let arraySpecialization = GetAllData?.data?.specializations ?? []
            let arrayOfSpecializationFromApi = self.editRequestData?.specializationIds ?? []
            
            for i in 0..<arraySpecialization.count{
                
                for j in 0..<arrayOfSpecializationFromApi.count{
                    
                    if Int(arrayOfSpecializationFromApi[j]) == Int(arraySpecialization[i].id ?? 0){
                        
                        selectedSpecializationName.append(arraySpecialization[i].name ?? "")
                        break
                    }
                }
            }
            
            print("selectedSpecializationName : \(selectedSpecializationName)")
            view.txtSpecialization.text = selectedSpecializationName.joined(separator: ", ")
            
            self.selectedNameArraySpecialization = selectedSpecializationName
            self.selectedArraySpecialization = arrayOfSpecializationFromApi.map{ Int($0)!}

            print("selectedArray Int : \(self.selectedArraySpecialization)")
            
            view.txtCoachExperience.text = "Minimum " + (self.editRequestData?.experienceYear ?? "") + " years"
            self.coachExperience = self.editRequestData?.experienceYear ?? ""
            view.txtLocation.text = self.editRequestData?.countryData?.name ?? ""
            
            self.location = String(Int(self.editRequestData?.countryData?.id ?? 0) ?? 0)
            
            var selectedTrainingType : [String] = []
            let arrayTrainigIds = GetAllData?.data?.trainingTypes ?? []
            let arrayOfSTrainingTypeFromApi = self.editRequestData?.trainingTypeIds ?? []
            
            for i in 0..<arrayTrainigIds.count{
                
                for j in 0..<arrayOfSTrainingTypeFromApi.count{
                    
                    if Int(arrayOfSTrainingTypeFromApi[j]) == Int(arrayTrainigIds[i].id ?? 0){
                        selectedTrainingType.append(arrayTrainigIds[i].name ?? "")
                        break
                    }
                }
            }
            
            print("selectedTrainingType : \(selectedTrainingType)")
            view.txtTypesOfTraining.text = selectedTrainingType.joined(separator: ", ")
            self.selectedArray = arrayOfSTrainingTypeFromApi.map{ Int($0)!}
            
            view.setupRating(rate: self.editRequestData?.rating ?? 0.0)
            
        }
        
    }
    
    func changeSportType(isMarathone:Bool) {
//        let view = (self.theController.view as? CreateRequestStepTwoView)
//        if isMarathone {
//            self.selectedMarathon = !self.selectedMarathon
//            if self.selectedMarathon {
//                view?.btnMarathon.backgroundColor = .appthemeRedColor
//                view?.btnMarathon.setColor(color: .appthemeWhiteColor)
//            }
//            else {
//                view?.btnMarathon.backgroundColor = .appthemeWhiteColor
//                view?.btnMarathon.setColor(color: .appthemeBlackColor)
//            }            
//        }
//        else {
//            self.selectedUltraMarathon = !self.selectedUltraMarathon
//            if self.selectedUltraMarathon {
//                view?.btnUltraMarathon.backgroundColor = .appthemeRedColor
//                view?.btnUltraMarathon.setColor(color: .appthemeWhiteColor)
//            }
//            else {
//                view?.btnUltraMarathon.backgroundColor = .appthemeWhiteColor
//                view?.btnUltraMarathon.setColor(color: .appthemeBlackColor)
//            }
//        }
    }
    
    func validateDetails() {
        let view = (self.theController.view as? CreateRequestStepTwoView)
        if self.selectedArraySpecialization.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_sport_specialization_key"))
        }
        else if self.coachExperience.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_coach_experience_key"))
        }
        else if self.selectedArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_types_of_training_key"))
        }
        else if self.location.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_location_key"))
        }
        else if view?.rateView.rating == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_rate_key"))
        }
        else {
            let obj: CreateRequestFinishVC = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateRequestFinishVC") as! CreateRequestFinishVC
            obj.mainModelView.isEdit = self.isEdit
            if self.isEdit{
                obj.mainModelView.requestId = String(self.editRequestData?.id ?? 0)
            }
            obj.mainModelView.selectedDateStartTraining = self.selectedDateStartTraining
            obj.mainModelView.requestTitle = self.requestTitle
            obj.mainModelView.requestDescription = self.requestDescription            
            obj.mainModelView.selectedSpecialization = self.selectedArraySpecialization
            obj.mainModelView.coachExperience = self.coachExperience
            obj.mainModelView.typesOfTraining = self.selectedArray
            obj.mainModelView.txtTypesOfTraining = (view?.txtTypesOfTraining.text?.toTrim())!
            obj.mainModelView.location = self.location
            obj.mainModelView.txtLocation = (view?.txtLocation.text?.toTrim())!
            obj.mainModelView.rate = (view?.rateView.rating)!
            self.theController.navigationController?.pushViewController(obj, animated: true)
        }
    }
}
