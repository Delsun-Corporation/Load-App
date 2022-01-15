//
//  CreateRequestFinishViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 24/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class CreateRequestFinishViewModel {
  
    //MARK:- Variables
    fileprivate weak var theController:CreateRequestFinishVC!
    
    //First step valiables
    var requestTitle:String = ""
    var selectedDateStartTraining:Date?
    var requestDescription:String = ""
    
    //Second step valiables
    var selectedSpecialization: [Int] = [Int]()
    var coachExperience:String = ""
    var typesOfTraining:[Int] = [Int]()
    var location:String = ""
    var rate:Double = 0.0
    var txtTypesOfTraining:String = ""
    var txtLocation:String = ""
    
    var isEdit = false
    var requestId = ""
    
    init(theController:CreateRequestFinishVC) {
        self.theController = theController
    }
    
    //MARK:- Functions
    func setupUI() {
        self.setupData()
    }
    
    func setupData() {
        let view = (self.theController.view as? CreateRequestFinishView)
        view?.lblTitle.text = self.requestTitle        
        
        let str1 = getUserDetail().data!.user!.name
        let str2 = "\(getUserDetail().data!.user!.dateOfBirth!.getYear())" + " year old"
        let str3 = getUserDetail().data!.user!.gender
        
        var countryName = ""
        
        var str4 = ""
        
        getCountryName(forLocation: CLLocation(latitude: userCurrentLocation?.coordinate.latitude ?? 0.0, longitude: userCurrentLocation?.coordinate.longitude ?? 0.0)) { (placemark, name) in
            if placemark != nil{
                countryName = name ?? ""
                str4 = str1! + ", " + str2 + ", " + str3!.lowercased().capitalized + ", " + "\(countryName)"
                view?.lblYears.text = str4
            }
        }
        
        str4 = str1! + ", " + str2 + ", " + str3!.lowercased().capitalized + ", " + "\(countryName)"
        view?.lblYears.text = str4
        view?.lblDescription.text = self.requestDescription
        view?.lblStartDate.text = (self.selectedDateStartTraining?.toString(dateFormat: "dd MMMM yyyy"))!
        view?.lblExperience.text = "Minimum \(self.coachExperience) year"
        view?.lblSportSpecialization.text = self.getSportSpecialization()
        view?.lblTypesOfTraining.text = self.txtTypesOfTraining
        view?.lblLocation.text = self.txtLocation
        view?.rateView.rating = self.rate
        view?.rateView.editable = false
    }
    
    func getSportSpecialization() -> String {
        var str = ""
        for data in (GetAllData?.data?.specializations)! {
            for subData in self.selectedSpecialization {
                if data.id?.intValue == subData {
                    str += data.name! + ", "
                }
            }
        }
        str.removeLast()
        str.removeLast()
        return str
    }
    
    func saveDetails() {
        if isEdit{
            updateRequest()
        }else{
            self.apiCallLibraryList(status: LOAD_CENTER_TYPE.REQUEST.rawValue, userId: (getUserDetail().data?.user?.id?.stringValue)!, title: requestTitle, startDate: DateToString(Formatter: "yyyy-MM-dd HH:mm:ss", date: selectedDateStartTraining ?? Date()), birthDate: getUserDetail().data?.user?.dateOfBirth ?? "", yourself: requestDescription, countryId: location, trainingTypeIds: typesOfTraining, specializationIds: self.selectedSpecialization, experienceYear: coachExperience, rating: rate)
        }
    }
    
    func apiCallLibraryList(status: String, userId: String, title:String, startDate:String, birthDate:String, yourself:String, countryId:String, trainingTypeIds:[Int], specializationIds:[Int], experienceYear:String, rating:Double) {
        let param = [
            "status": status,
            "user_id": userId,
            "title": title,
            "start_date": startDate,
            "birth_date": birthDate,
            "yourself": yourself,
            "country_id": countryId,
            "training_type_ids" : trainingTypeIds,
            "experience_year": experienceYear,
            "specialization_ids": specializationIds,
            "rating": rating
            ] as [String : Any]
        print(param)
        ApiManager.shared.MakePostAPI(name: LOAD_CENTER_CREAT, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    self.theController.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_CLOSE_CREATE_SCREEN.rawValue), object: nil)
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_REQUEST_LIST_UPDATE.rawValue), object: nil)

                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
    func updateRequest() {
        self.apiCallUpdateRequest(title: requestTitle, startDate: DateToString(Formatter: "yyyy-MM-dd HH:mm:ss", date: selectedDateStartTraining ?? Date()), yourself: requestDescription, countryId: location, trainingTypeIds: typesOfTraining, specializationIds: self.selectedSpecialization, experienceYear: coachExperience, rating: rate)
    }
    
    func apiCallUpdateRequest(title:String, startDate:String, yourself:String, countryId:String, trainingTypeIds:[Int], specializationIds:[Int], experienceYear:String, rating:Double) {
        
        let param = [
                   "title": title,
                   "start_date": startDate,
                   "yourself": yourself,
                   "country_id": countryId,
                   "training_type_ids" : trainingTypeIds,
                   "experience_year": experienceYear,
                   "specialization_ids": specializationIds,
                   "rating": rating
                   ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePutAPI(name: LOAD_CENTER_REQUEST_UPDATE + "/" + requestId, params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let success = json.getBool(key: .success)
                let message = json.getString(key: .message)
                
                if success {
                    self.theController.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_CLOSE_CREATE_SCREEN.rawValue), object: nil)

                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_REQUEST_LIST_UPDATE.rawValue), object: nil)

                }
                else {
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
}
