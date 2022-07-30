//
//  ProfessionalLoadCenterViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 31/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProfessionalLoadCenterViewModel: ProfessionalListDelegate, ProfessionalRequirementDelegate, ProfessionalBasicProfileDelegate, SelectAvailabilityDelegate, SelectFormDelegate {
    
    //MARK:- Variables
    fileprivate weak var theController:ProfessionalLoadCenterVC!
    
    let headerArray: [String] = ["",
                                 getCommonString(key: "SESSION_DETAILS_key"),
                                 getCommonString(key: "CLIENT'S_REQUIREMENT_key"),
                                 getCommonString(key: "INFORMATION_key"),
                                 getCommonString(key: "CANCELLATION_POLICY_key"),
                                 getCommonString(key: "RATES_key"),
                                 getCommonString(key: "AVAILABILITY_key")
                                ]
    let titleArray: [[String]] = [[ getCommonString(key: "Basic_Profile_key")],
                                  [ getCommonString(key: "Duration_key"), getCommonString(key: "Types_key") , getCommonString(key: "Number_of_sessions_per_package_key"), getCommonString(key: "Number_of_client(s)_per_session_key")],
                                  [getCommonString(key: "Basic_requirement_key"), getCommonString(key: "PAR-Q_Form_key")],
                                  [getCommonString(key: "Amenities_key")],
                                  [getCommonString(key: "Cancellation_key")],
                                  [getCommonString(key: "Per_Session_key"), getCommonString(key: "Per_package_key")],
                                  ["Select Availibility", getCommonString(key: "Schedule_management_key")
                                  ]]
    
    var textArray: [[String]] = [[""], ["", "", "",""], ["", ""], [""], [""], [ "", ""], ["", ""]]
    
    var placeHolderArray: [[String]] = [[""], ["00", "Select","", "##"], ["", ""], ["Towel and drinks"], [""], ["$", "$"], ["", ""]]
    
    var amenitiesArray:[[Any]] = [["Drinking water",false], ["Air conditioning",false], ["Towel",false], ["Locker",false], ["Shower room",false], ["Soap and shampoo",false], ["Changing Room",false], ["First aid kit",false]]

    var txtDuration:String = ""
    var txtTypes:String = ""
    var txtMaximumClient:String = ""
    var txtNumberOfSessionPerPackage = ""
    var txtTypesId:Int = 0

    var txtBasicRequirement:String = ""
    var txtForm:String = ""

    var txtAmenitiesArray:String = ""

    var txtCancellationId:Int = 0
    var txtCancellation: String = ""

    var txtOptionsId:Int = 0
    var txtOptions:String = ""
    var txtPerSession:String = ""
    var txtPerMultipleSessions:String = ""
    
    var txtSelectAvailibility:String = ""
    var txtAutoAccept:Bool = false

    var ActivityArray:[Int] = [Int]()
    var ActivityNameArray:[String] = [String]()
    var selectedProfession:String = ""
    var selectedLangSpoken:Int = 0
    var selectedLangWriten:Int = 0
    var txtIntroduction:String = ""
    var locationString:String = ""
    var selectedLatitude:Double = 0.0
    var selectedLongitude:Double = 0.0
    var isCustom: Bool = false
    var AvailabilityArray: [String] = []
    var profileDetails:ProfessionalModelClass?
    var CredentialsArray: NSMutableArray = NSMutableArray()
    var isAgreeForm: Bool?
    var isAutoForm: Bool?
    var isSetCompulsory: Bool?
    
    //MARK:- Functions    
    init(theController:ProfessionalLoadCenterVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.getProfessionalDetails()
    }
    
    
    func setupNavigationbar(title:String) {
        
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = false
            vwnav.btnSave.isHidden = true
            
            var hightOfView = 0
            if UIScreen.main.bounds.height >= 812 {
                hightOfView = 44
            }
            else {
                hightOfView = 20
            }
            
            vwnav.frame = CGRect(x: 0, y: CGFloat(hightOfView), width: self.theController.navigationController?.navigationBar.frame.width ?? 320, height: vwnav.frame.height)
            
            let myMutableString = NSMutableAttributedString()
            
            let dict = [NSAttributedString.Key.font: themeFont(size: 16, fontname: .ProximaNovaBold)]
            myMutableString.append(NSAttributedString(string: title, attributes: dict))
            vwnav.lblTitle.attributedText = myMutableString
            
            vwnav.lblTitle.textColor = .black
            
            vwnav.tag = 102
            vwnav.delegate = self
            
            self.theController.navigationController?.view.addSubview(vwnav)
            
        }
    }
    
    
    func BasicProfileClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalBasicProfileVC") as! ProfessionalBasicProfileVC
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedArray = self.ActivityArray
        obj.mainModelView.selectedNameArray = self.ActivityNameArray
        obj.mainModelView.selectedProfession = self.selectedProfession
        obj.mainModelView.selectedLangSpoken = self.selectedLangSpoken
        obj.mainModelView.selectedLangWriten = self.selectedLangWriten
        obj.mainModelView.txtIntroduction = self.txtIntroduction
        obj.mainModelView.selectedAddress = self.locationString
        obj.mainModelView.selectedLatitude = self.selectedLatitude
        obj.mainModelView.selectedLongitude = self.selectedLongitude
        obj.mainModelView.CredentialsArray = self.CredentialsArray
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func TypeClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalListVC") as!ProfessionalListVC
        obj.mainModelView.isScreenFor = .TYPE
        obj.mainModelView.navHeader = getCommonString(key: "Types_key")
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedId = self.txtTypesId
        obj.mainModelView.selectedTitle = self.txtTypes
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func BasicRequirementClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalRequirementVC") as! ProfessionalRequirementVC
        obj.mainModelView.delegate = self
        obj.mainModelView.isScreen = 0
        obj.mainModelView.navigationHeader = getCommonString(key: "Basic_requirement_key")
        obj.mainModelView.placeholder = getCommonString(key: "Requirement_placeholder_key")
        if txtBasicRequirement != "" {
//            obj.mainView.txtTextView.text = self.txtBasicRequirement
            obj.mainModelView.text = self.txtBasicRequirement
        }
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func FormsClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "SelectFormVC") as! SelectFormVC
        obj.mainModelView.delegate = self
        obj.mainModelView.isAgree = isAgreeForm
        obj.mainModelView.isAuto = isAutoForm
        obj.mainModelView.isSetCompulsory = txtAutoAccept
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.theController.present(nav, animated: true, completion: nil)
    }
    
    func CancellationClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalListVC") as!ProfessionalListVC
        obj.mainModelView.isScreenFor = .CANCELLATION
        obj.mainModelView.navHeader = getCommonString(key: "Cancellation_key")
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedId = self.txtCancellationId
        obj.mainModelView.selectedTitle = self.txtCancellation
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func PaymentClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalListVC") as!ProfessionalListVC
        obj.mainModelView.isScreenFor = .PAYMENT
        obj.mainModelView.navHeader = getCommonString(key: "Payment_Options_key")
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedId = self.txtOptionsId
        obj.mainModelView.selectedTitle = self.txtOptions
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func SelectAvailibilityClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalSelectAvailabilityVC") as!ProfessionalSelectAvailabilityVC
        obj.mainModelView.delegate = self
        obj.mainModelView.nameArray = self.AvailabilityArray
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func scheduleManagment(){
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ScheduleManagmentVc") as! ScheduleManagmentVc
//        obj.mainModelView.delegate = self
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func ProfessionalListFinish(id: Int, title: String, isScreenFor: PROFESSIONAL_LIST_TYPE) {
        let view = (self.theController.view as? ProfessionalLoadCenterView)
        if isScreenFor == .TYPE {
            if self.txtTypesId != id {
                self.theController.btnSave.isHidden = false
            }
            self.textArray[1][1] = title
            self.txtTypes = title
            self.txtTypesId = id
            view?.tableView.reloadSections([1], with: .none)
            
        }
        else if isScreenFor == .CANCELLATION {
            if self.txtCancellationId != id {
                self.theController.btnSave.isHidden = false
            }
            self.textArray[4][0] = title
            self.txtCancellation = title
            self.txtCancellationId = id
        }
        else if isScreenFor == .PAYMENT {
            /*
            if self.txtOptionsId != id {
                self.theController.btnSave.isHidden = false
            }
            self.textArray[5][0] = title
            self.txtOptions = title
            self.txtOptionsId = id
            view?.tableView.reloadSections([5], with: .none)
            */
        }
        
        saveDetails()
    }
    
    func ProfessionalRequirementFinish(text: String, isScreen:Int) {
        if self.txtBasicRequirement != text {
            self.theController.btnSave.isHidden = false
        }
        self.txtBasicRequirement = text
        
        saveDetails()
    }
    
    func saveDetails() {
        self.theController.btnSave.isHidden = true
       
        let amenitiesArray:NSMutableArray = NSMutableArray()
        
        for data in self.amenitiesArray {
            let dict: NSDictionary = ["name": data[0] as! String, "value": data[1] as! Bool]
            amenitiesArray.add(dict)
        }
        print(JSON(amenitiesArray))
        self.apiCallUpdateList(
            profession: self.selectedProfession,
            introduction: self.txtIntroduction,
            rate: 0,
            specializationIds: self.ActivityArray,
            experienceAndAchievements: "",
            languagesSpokenIds: [self.selectedLangSpoken],
            languagesWrittenIds: [self.selectedLangWriten],
            sessionDuration: self.txtDuration,
            professionalTypeId: self.txtTypesId,
            sessionPerPackage: Int(self.txtNumberOfSessionPerPackage) ?? 0,
            sessionMaximumClients: Int(self.txtMaximumClient) ?? 0,
            basicRequirement: self.txtBasicRequirement,
            amenities: amenitiesArray,
            paymentOptionId: self.txtOptionsId,
            perSessionRate: self.txtPerSession,
            perMultipleSessionRate: self.txtPerMultipleSessions,
            isCustom: self.isCustom,
            days: self.AvailabilityArray,
            isAutoAccept: self.txtAutoAccept,
            latitude: self.selectedLatitude,
            longitude: self.selectedLongitude,
            locationName: self.locationString,
            CredentialsArray: self.CredentialsArray,
            isForms: self.isAutoForm,
            isAnswerd: self.isAgreeForm
        )
    }
    
    func ProfessionalBasicProfileFinish(Profession: String, locationString:String, Latitude: Double, Longitude: Double, Introduction: String, ActivityArray: [Int], LangSpoken: Int, LangWriten: Int, CredentialsArray: NSMutableArray) {
        if self.selectedProfession != Profession || self.locationString != locationString || self.selectedLatitude != Latitude || self.selectedLongitude != selectedLongitude || self.txtIntroduction != Introduction || self.ActivityArray != ActivityArray ||  self.selectedLangSpoken != LangSpoken || self.selectedLangWriten != LangWriten || self.CredentialsArray != CredentialsArray {
            self.theController.btnSave.isHidden = false
        }
        self.selectedProfession = Profession
        self.locationString = locationString
        self.selectedLatitude = Latitude
        self.selectedLongitude = Longitude
        self.txtIntroduction = Introduction
        self.ActivityArray = ActivityArray
        self.selectedLangSpoken = LangSpoken
        self.selectedLangWriten = LangWriten
        self.CredentialsArray = CredentialsArray
        
        saveDetails()
    }
    
    func SelectAvailabilityFinish(isCustom: Bool, AvailabilityArray: [String]) {
        if self.AvailabilityArray != AvailabilityArray {
            self.theController.btnSave.isHidden = false
        }

        self.isCustom = isCustom
        self.AvailabilityArray = AvailabilityArray
        
        saveDetails()
    }
    
    func getProfessionalDetails() {
        let param = ["": ""] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakeGetAPI(name: GET_PROFESSIONAL_PROFILE_DETAILS , params: param as [String : Any], progress: true, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.profileDetails = ProfessionalModelClass(JSON: data.dictionaryObject!)
                    self.showDetails()
                }
                else {
                    
                }
            }
        })
    }
    
    func showDetails() {
        // 0
        self.selectedProfession = self.profileDetails?.profession ?? ""
        self.locationString = self.profileDetails?.locationName ?? ""
        self.selectedLatitude = Double(self.profileDetails?.userDetail?.latitude ?? "0.0") ?? 0.0
        self.selectedLongitude = Double(self.profileDetails?.userDetail?.longitude ?? "0.0") ?? 0.0
        self.txtIntroduction = self.profileDetails?.introduction ?? ""
        
        
        let activity = self.profileDetails?.specializationDetails?.filter({ (model) -> Bool in
            if newApiConfig {
                return model.isActiveV2 == "1"
            }
            else {
                return model.isActive == true
            }
        })
        self.ActivityArray = self.getSpecializationDetails(list: activity ?? [])
        self.ActivityNameArray = self.getSpecializationNameDetails(list: activity ?? [])
        
        self.selectedLangSpoken = Int(self.profileDetails?.languagesSpokenIds?.first ?? "0") ?? 0
        self.selectedLangWriten = Int(self.profileDetails?.languagesWrittenIds?.first ?? "0") ?? 0
        self.CredentialsArray.removeAllObjects()
        for data in self.profileDetails?.academicCredentials ?? [] {
            let dict: NSDictionary = ["AwardingInstitution":data.awardingInstitution ?? "", "CourseOfStudy": data.courseOfStudy ?? ""]
            self.CredentialsArray.add(dict)
        }
        
        self.isAgreeForm = self.profileDetails?.isForms
        self.isAutoForm = self.profileDetails?.isAnswerd
        
        // 1
        self.txtDuration = self.profileDetails?.sessionDuration ?? ""
        let typeId = self.profileDetails?.professionalTypeId?.intValue ?? 0
        self.txtTypesId = typeId
        
        if newApiConfig {
            for (_, data) in (GetAllData?.data?.professionalTypes?.enumerated())! {
                if typeId == data.id?.intValue {
                    self.txtTypes = data.name ?? ""
                }
            }
        } else {
            self.txtTypes = self.profileDetails?.professionalTypeDetail?.name ?? ""
        }
        self.txtNumberOfSessionPerPackage = self.profileDetails?.sessionPerPackage?.stringValue ?? ""
        self.txtMaximumClient = self.profileDetails?.sessionMaximumClients?.stringValue ?? ""
        self.textArray[1][0] = self.txtDuration
        self.textArray[1][1] = self.txtTypes
        self.textArray[1][2] = self.txtNumberOfSessionPerPackage
        self.textArray[1][3] = self.txtMaximumClient
        
        // 2
        self.txtBasicRequirement = self.profileDetails?.basicRequirement ?? ""
        
        //3
        if newApiConfig, let rawArray = profileDetails?.amenitiesV2 {
            for data in rawArray {
                for (index, dataValue) in self.amenitiesArray.enumerated() {
                    if data == (dataValue[0] as? String) {
                        self.amenitiesArray[index][1] = true
                    }
                }
            }
            self.txtAmenitiesArray = rawArray.joined(separator: ", ")
        } else {
            for data in self.profileDetails?.amenities ?? [] {
                for (index, dataValue) in self.amenitiesArray.enumerated() {
                    if data.name == (dataValue[0] as! String) {
                        self.amenitiesArray[index][1] = data.value ?? false
                    }
                }
            }
            
            let array = amenitiesArray.filter({ (data) -> Bool in
                return (data[1] as? Bool) == true
            })
            var str: [String] = []
            for data in array {
                str.append(data[0] as! String)
            }
            self.txtAmenitiesArray = str.joined(separator: ", ")
        }
        
        self.textArray[3][0] = self.txtAmenitiesArray

        // 4
        self.txtCancellationId = self.profileDetails?.cancellationPolicyId?.intValue ?? 0
        self.txtCancellation = self.profileDetails?.cancellationPolicyDetail?.name ?? ""
        
        // 5
        self.txtOptionsId = self.profileDetails?.paymentOptionId?.intValue ?? 0
        self.txtOptions = self.profileDetails?.paymentOptionDetail?.name ?? ""
        self.txtPerSession = self.profileDetails?.perSessionRate?.stringValue ?? ""
        self.txtPerMultipleSessions = self.profileDetails?.perMultipleSessionRate?.stringValue ?? ""
        
        //Remove payment
        //        self.textArray[5][0] = self.txtOptions
        self.textArray[5][0] = self.txtPerSession
        self.textArray[5][1] = self.txtPerMultipleSessions
        
        // 6
        self.txtAutoAccept = self.profileDetails?.isAutoAccept?.boolValue ?? false
        self.AvailabilityArray = self.profileDetails?.days ?? []
        let view = (self.theController.view as? ProfessionalLoadCenterView)
        view?.tableView.reloadData()
    }
    
    func getSpecializationDetails(list:[ProfessionalSpecializationDetails]) -> [Int] {
        var ids: [Int] = []
        for data in list {
            ids.append(data.id?.intValue ?? 0)
        }
        return ids
    }
    
    func getSpecializationNameDetails(list:[ProfessionalSpecializationDetails]) -> [String] {
        var names: [String] = []
        for data in list {
            names.append(data.name ?? "")
        }
        return names
    }
    
    // V2 amenities convertion
    func convertAmenitiesToStringArray(_ amenityArray: NSMutableArray) -> [String] {
        var newArray: [String] = []
        for amenity in amenityArray {
            
            if let amenity = amenity as? NSDictionary {
               if let value = amenity["value"] as? Int, value == 1,
               let name = amenity["name"] as? String {
                   newArray.append(name)
               }
            }
        }
        
        return newArray
    }
    
    func apiCallUpdateList(profession:String,
                           introduction: String,
                           rate:Int,
                           specializationIds:[Int],
                           experienceAndAchievements:String,
                           languagesSpokenIds:[Int],
                           languagesWrittenIds:[Int],
                           sessionDuration:String,
                           professionalTypeId:Int,
                           sessionPerPackage: Int,
                           sessionMaximumClients: Int,
                           basicRequirement:String,
                           amenities: NSMutableArray,
                           paymentOptionId:Int,
                           perSessionRate:String,
                           perMultipleSessionRate:String,
                           isCustom:Bool,
                           days:[String],
                           isAutoAccept:Bool,
                           latitude:Double,
                           longitude:Double,
                           locationName:String,
                           CredentialsArray: NSMutableArray,
                           isForms:Bool?,
                           isAnswerd:Bool?) {
        print(amenities)
        print(CredentialsArray)
        
        var param = ["profession": profession,
                     "introduction": introduction,
                     "rate": rate,
                     "specialization_ids": specializationIds,
                     "experience_and_achievements": experienceAndAchievements,
                     "languages_spoken_ids": languagesSpokenIds,
                     "languages_written_ids": languagesWrittenIds,
                     "session_duration": sessionDuration,
                     "professional_type_id": professionalTypeId,
                     "session_per_package": sessionPerPackage,
                     "session_maximum_clients": sessionMaximumClients,
                     "basic_requirement": basicRequirement,
                     "amenities": newApiConfig ? convertAmenitiesToStringArray(amenities) : amenities,
//                     "payment_option_id": paymentOptionId,
                     "per_session_rate": perSessionRate,
                     "per_multiple_session_rate": perMultipleSessionRate,
                     "is_custom": isCustom,
                     "days": days,
                     "is_auto_accept": isAutoAccept,
                     "latitude": latitude,
                     "longitude": longitude,
                     "location_name": locationName,
                     "academic_credentials" : CredentialsArray,
                     "is_forms" : isForms ?? false,
                     "is_answerd" : isAnswerd ?? false
            ] as [String : Any]
            
        if profession == "" {
            param.removeValue(forKey: "profession")
        }

        if introduction == "" {
            param.removeValue(forKey: "introduction")
        }

        if rate == 0 {
            param.removeValue(forKey: "rate")
        }

        if specializationIds.count == 0 {
            param.removeValue(forKey: "specialization_ids")
        }

        if experienceAndAchievements == "" {
            param.removeValue(forKey: "experience_and_achievements")
        }

        if languagesSpokenIds.first == 0 {
            param.removeValue(forKey: "languages_spoken_ids")
        }

        if languagesWrittenIds.first == 0 {
            param.removeValue(forKey: "languages_written_ids")
        }

        if sessionDuration == "" {
            param.removeValue(forKey: "session_duration")
        }

        if professionalTypeId == 0 {
            param.removeValue(forKey: "professional_type_id")
        }
        
        if basicRequirement == "" {
            param.removeValue(forKey: "basic_requirement")
        }

        if paymentOptionId == 0 {
            param.removeValue(forKey: "payment_option_id0")
        }

        if perSessionRate == "" {
            param.removeValue(forKey: "per_session_rate")
        }

        if perMultipleSessionRate == "" {
            param.removeValue(forKey: "per_multiple_session_rate")
        }

        if days.count == 0 {
            param.removeValue(forKey: "days")
        }
        
//        if latitude == 0 {
//            param.removeValue(forKey: "latitude")
//        }
//
//        if latitude == 0 {
//            param.removeValue(forKey: "latitude")
//        }
//
//        if longitude == 0 {
//            param.removeValue(forKey: "longitude")
//        }
        
        if locationName == "" {
            param.removeValue(forKey: "location_name")
        }

        if CredentialsArray.count == 0 {
            param.removeValue(forKey: "academic_credentials")
        }

        if isForms == nil {
            param.removeValue(forKey: "is_forms")
        }

        if isAnswerd == nil {
            param.removeValue(forKey: "is_answerd")
        }
        
        print(JSON(param))
        
        ApiManager.shared.MakePostAPI(name: CREATE_OR_UPDATE_PROFESSIONAL_PROFILE , params: param as [String : Any], progress: true, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.profileDetails = ProfessionalModelClass(JSON: data.dictionaryObject!)
//                    let view = (self.theController.view as? ProfessionalLoadCenterView)
//                    view?.tableView.reloadData()
                }
                else {

                }
            }
        })
    }
    
    func SelectFormFinish(isAgree: Bool?, isAuto: Bool?, isSetCompulsory: Bool?) {
        
        if let viewWithTag = self.theController.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }

        self.setupNavigationbar(title: getCommonString(key: "Professional_key"))

        if self.isAgreeForm != isAgree || self.isAutoForm != isAuto {
            self.theController.btnSave.isHidden = false
        }
        self.isAgreeForm = isAgree
        self.isAutoForm = isAuto
        self.txtAutoAccept = isSetCompulsory ?? false
        
        saveDetails()
    }
}

//MARK: - Navigation delegate
extension ProfessionalLoadCenterViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        self.theController.btnBackClicked()
    }
    
    func CustomNavigationSave() {
        self.saveDetails()
    }

}
