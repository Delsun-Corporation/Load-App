//
//  OwnRequestListingDetailScreenViewModel.swift
//  Load
//
//  Created by iMac on 09/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON
import CoreLocation


class OwnRequestListingDetailScreenViewModel {
    
    fileprivate weak var theController:OwnRequestListingDetailScreenVc!
    
    init(theController:OwnRequestListingDetailScreenVc) {
        self.theController = theController
    }

    var requestId = 0
    var requestDetailsData : RequestData?
    
    
    //MARKL: - SetupData
    
    func setUpData(){
        
        self.apiGetData()
        
        if let view = self.theController.view as? OwnRequestListingDetailScreenView{
        }
    }
    
}

//MARK: - API calling

extension OwnRequestListingDetailScreenViewModel{
    
    func apiGetData(){
        
        let param = ["":""]
        
        ApiManager.shared.MakeGetAPI(name: LOAD_CENTER_REQUEST_SHOW + "/" + (String(self.requestId)), params: param, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.requestDetailsData = RequestData(JSON: data.dictionaryObject!)
                    
                    self.dataFillUp()
                }
                else {
                    self.requestDetailsData = nil
                }

            }
        })
        
    }
    
    func dataFillUp(){
        
        if let view = self.theController.view as? OwnRequestListingDetailScreenView{
            
            self.theController.setNavigationWithtitle(name: self.requestDetailsData?.userDetail?.name ?? "")
            
            view.imgProfile.sd_setImage(with: self.requestDetailsData?.userDetail?.photo.toURL(), completed: nil)
            view.lblTitle.text = self.requestDetailsData?.title
            view.lblDescription.text = self.requestDetailsData?.yourself
            
            
            getCountryName(forLocation: CLLocation(latitude: userCurrentLocation?.coordinate.latitude ?? 0.0, longitude: userCurrentLocation?.coordinate.longitude ?? 0.0)) { (placemark, name) in
                if placemark != nil{
                    view.lblCountry.text = name ?? ""
                }
            }
            
            view.lblPreferredStartDayValue.text = convertDateFormater(self.requestDetailsData!.startDate, dateFormat: "dd MMMM yyyy")
            
            view.lblDate.text = convertDateFormater(self.requestDetailsData!.createdAt, dateFormat: "dd MMMM")
            
            view.lblLocationValue.text = self.requestDetailsData?.countryData?.name ?? ""
            
            var selectedSpecializationName : [String] = []
            let arraySpecialization = GetAllData?.data?.specializations ?? []
            let arrayOfSpecializationFromApi = self.requestDetailsData?.specializationIds ?? []
            
            for i in 0..<arraySpecialization.count{
                
                for j in 0..<arrayOfSpecializationFromApi.count{
                    
                    if Int(arrayOfSpecializationFromApi[j]) == Int(arraySpecialization[i].id ?? 0){
                        
                        selectedSpecializationName.append(arraySpecialization[i].name ?? "")
                        break
                    }
                }
            }
            
            print("selectedSpecializationName : \(selectedSpecializationName)")
            view.lblCoachSpecializationValue.text = selectedSpecializationName.joined(separator: ", ")
            
            view.lblCoachExperienceValue.text = "Minimum " + (self.requestDetailsData?.experienceYear ?? "") + " years"
            
            var selectedTrainingType : [String] = []
            let arrayTrainigIds = GetAllData?.data?.trainingTypes ?? []
            let arrayOfSTrainingTypeFromApi = self.requestDetailsData?.trainingTypeIds ?? []

            for i in 0..<arrayTrainigIds.count{
                
                for j in 0..<arrayOfSTrainingTypeFromApi.count{
                    
                    if Int(arrayOfSTrainingTypeFromApi[j]) == Int(arrayTrainigIds[i].id ?? 0){
                        
                        selectedTrainingType.append(arrayTrainigIds[i].name ?? "")
                        break
                    }
                }
            }
            
            print("selectedTrainingType : \(selectedTrainingType)")
            view.lblTypeOfTrainingValue.text = selectedTrainingType.joined(separator: ", ")
            
            view.vwRattingStar.rating = self.requestDetailsData?.rating as! Double
            view.vwRattingStar.editable = false
        }
        
    }
    
    func apiCallRequestDelete() {
        
        let param = [:] as [String : Any]
        
        ApiManager.shared.MakeDeleteAPI(name: LOAD_CENTER_REQUEST_DELETE + "/" + "\(self.requestId)", params: param as [String : Any], vc: self.theController, isAuth:false) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    
                    self.theController.dismiss(animated: true, completion: nil)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_REQUEST_LIST_UPDATE.rawValue), object: nil)

                }
                else {
                    let message = json.getString(key: .message)
                    makeToast(strMessage: message)
                }
            }
        }
    }
    
}
