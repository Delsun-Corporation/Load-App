//
//  PremiumViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 05/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class PremiumViewModel: ProfessionalRequirementDelegate, FilterActivitySelectedDelegate, AutoTopUpVCDelegate, BillingInformationVCDelegate, PremiumPermissionDelegate {
    
    //MARK:- Variables
    fileprivate weak var theController:PremiumVC!
    let headerArray: [String] = [getCommonString(key: "Profile_key").uppercased(), getCommonString(key: "PAYMENT_key")]
    let titleArray: [[String]] = [[getCommonString(key: "About_me_key"), getCommonString(key: "Activites_key"), getCommonString(key: "Languages_key"), getCommonString(key: "Permissions_key")], [getCommonString(key: "Payment_Method_key"), getCommonString(key: "Auto_top_up_key")]]
    var languages: [String] = []
    var languagesId: [Int] = []
    var txtAbout: String = ""
    var selectedArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    var filterActivity:String = ""
    var premiumResponse: PremiumModelClass?
    var accessToken: String = ""
    var isAutoTopup: Bool?
    var autoTopupAmount: String?
    var minimumBalance: String?
    var creditCardIdDefault: String?
    
    var selectedViewMyProfile = ""
    var selectedViewMyFeed = ""
    
    //MARK:- Functions
    init(theController:PremiumVC) {
        self.theController = theController
    }
    
    func apiCallGet(isLoading: Bool = false) {
        if newApiConfig {
            apiCallGetSettingPrimiumV2(isLoading: isLoading)
            return
        }
        self.apiCallGetSettingPrimium(isLoading: isLoading)
    }
    
    func setupUI() {
        apiCallGet()
        self.apiCallOAuth2Token(progress: false)
    }
    
    func btnAbountMeClicked(titleHeader: String) {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalRequirementVC") as! ProfessionalRequirementVC
        obj.mainModelView.delegate = self
        obj.mainModelView.navigationHeader = titleHeader
        obj.mainModelView.placeholder = getCommonString(key: "Share_us_a_little_bit_about_yourself_key")
        if self.txtAbout != "" {
//            obj.mainView.txtTextView.text = self.txtAbout
            obj.mainModelView.text = self.txtAbout
        }
        obj.mainModelView.isScreen = 3
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func btnPermissionClicked(titleHeader: String) {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "PremiumPermissionVc") as! PremiumPermissionVc
        obj.mainModelView.delegatePermission = self
        obj.mainModelView.navigationHeader = titleHeader
        obj.mainModelView.selectedViewMyProfile = self.selectedViewMyProfile
        obj.mainModelView.selectedViewMyFeed = self.selectedViewMyFeed
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }

    func btnLanguageClicked(titleHeader: String) {
        var dataEntry: [MultiSelectionDataEntry] = [MultiSelectionDataEntry]()
        guard let languages = GetAllData?.data?.languages else { return }
        
        for data in languages {
            guard let langId = data.id?.intValue else { return }
            dataEntry.append(MultiSelectionDataEntry(
                id: "\(langId)", title: data.name ?? "",
                isSelected: languagesId.contains(where: { $0 == langId
                }) ))
        }
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "MultiSelectionVC") as! MultiSelectionVC
        obj.mainModelView.delegate = theController.self
        obj.mainModelView.data = dataEntry
        obj.mainModelView.title = titleHeader
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.theController.navigationController?.present(nav, animated: true, completion: nil)
    }
    
    func btnActivityClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "ProfessionalActivityVC") as! ProfessionalActivityVC
        obj.mainModelView.delegate = self
        obj.mainModelView.selectedArray = self.selectedArray
        obj.mainModelView.selectedNameArray = self.selectedNameArray
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.theController.present(nav, animated: true) {
            self.theController.removeHeaderWhilePresent()
        }
    }
    
    func btnPremiumPaymentMethodClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "PremiumPaymentMethodVc") as! PremiumPaymentMethodVc
        obj.mainModelView.accessToken = self.accessToken
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func btnAutoTopUpClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "AutoTopUpVC") as! AutoTopUpVC
        obj.mainModelView.delegate = self
        obj.mainModelView.accessToken = self.accessToken
        obj.mainModelView.cardDetails = self.premiumResponse?.cardDetails ?? []
        obj.mainModelView.isAutoTopup = isAutoTopup ?? false
        obj.mainModelView.autoTopupAmount = autoTopupAmount
        obj.mainModelView.minimumBalance = minimumBalance
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func BillingInformationReload(isUpdated: Bool) {
        if isUpdated {
            if self.theController.btnSave.isHidden {
                self.apiCallGet(isLoading: false)
            }
        }
    }
    
    func ProfessionalRequirementFinish(text: String, isScreen: Int) {
        if self.txtAbout != text {
            self.theController.resetNavigationBar()
        }
        self.txtAbout = text
        updatePremium()
    }
    
    func FilterActivitySelectedDidFinish(ids: [Int], names: [String]) {
        self.selectedArray = ids
        self.selectedNameArray = names
        let formattedNameString = (names.map{String($0)}).joined(separator: ", ")
        self.filterActivity = formattedNameString
        
        FilterActivityClose()
    }
    
    func FilterActivityClose(){
        
        if let viewWithTag = self.theController.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
        
        updatePremium()
    }
    
    func AutoTopUpFinish(isAutoTopup: Bool?, autoTopupAmount: String?, minimumBalance :String?) {
        if self.isAutoTopup != isAutoTopup || self.autoTopupAmount != autoTopupAmount  || self.minimumBalance != minimumBalance {
             self.theController.resetNavigationBar()
        }
        self.isAutoTopup = isAutoTopup
        self.autoTopupAmount = autoTopupAmount
        self.minimumBalance = minimumBalance
        updatePremium()
    }
    
    //MARK:- Permission delegate
    func selectedPermissionForPremium(viewMyProfile: String, viewMyFeed: String) {
        self.selectedViewMyProfile = viewMyProfile
        self.selectedViewMyFeed = viewMyFeed
        updatePremium()
    }

    
    func validateDetails() -> Bool {
        if self.txtAbout == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_about_key"))
            return false
        }
        else if self.selectedArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_activity_key"))
            return false
        }
        else {
            makeToast(strMessage: getCommonString(key: "Please_select_languages_key"))
            return false
        }
    }
    
    func updatePremium() {
        theController.mainView.tableView.reloadData()
        self.theController.resetNavigationBar()
        if newApiConfig {
            self.apiCallSettingCreateUpdatePrimiumV2(about: self.txtAbout, specializationIds: self.selectedArray, languageIds: self.languagesId)
            return
        }
        self.apiCallSettingCreateUpdatePrimium(about: self.txtAbout, specializationIds: self.selectedArray, languageIds: self.languagesId)
    }
    
    func apiCallSettingCreateUpdatePrimiumV2(about: String, specializationIds: [Int], languageIds: [Int], isLoading: Bool = true) {
        var param = [
            "about": about,
            "specialization_ids" : specializationIds,
            "language_id": languageIds,
            "is_auto_topup": self.isAutoTopup ?? false,
            "is_card_default": self.creditCardIdDefault == nil ? false : true,
            "credit_card_id": self.creditCardIdDefault ?? "",
            "premium_profile_permission" : self.selectedViewMyProfile,
            "feed_permission": self.selectedViewMyFeed
        ] as [String : Any]
        
        if about.isEmpty {
            param.removeValue(forKey: "about")
        }
        
        if self.isAutoTopup == nil {
            param.removeValue(forKey: "is_auto_topup")
        }
        
        if let topupAmount = self.autoTopupAmount?.floatValue {
            param["auto_topup_amount"] = topupAmount
        }
        
        if let minimumBalance = self.minimumBalance?.floatValue {
            param["minimum_balance"] = minimumBalance
        }
        
        if self.creditCardIdDefault == nil {
            param.removeValue(forKey: "is_card_default")
            param.removeValue(forKey: "credit_card_id")
        }
        
        if specializationIds.isEmpty {
            param.removeValue(forKey: "specialization_ids")
        }
        
        if languageIds.isEmpty {
            param.removeValue(forKey: "language_id")
        }
        
        if selectedViewMyFeed.isEmpty {
            param.removeValue(forKey: "feed_permission")
        }
        
        if selectedViewMyProfile.isEmpty {
            param.removeValue(forKey: "premium_profile_permission")
        }
        
        print(param)
        
        ApiManager.shared.MakePostAPI(name: "setting/\(SETTING_CREATE_UPDATE_PRIMIUM)", params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    print(response?["message"] ?? "Success saving premium view model!")
                }
            }
        })
    }
    
    func apiCallSettingCreateUpdatePrimium(about: String, specializationIds: [Int], languageIds: [Int], isLoading: Bool = true) {
        let param = [
            "about": about,
            "specialization_ids" : specializationIds,
            "language_ids": languageIds,
            "is_auto_topup": self.isAutoTopup ?? false,
            "auto_topup_amount": self.autoTopupAmount ?? "",
            "minimum_balance": self.minimumBalance ?? "" ,
            "is_card_default": self.creditCardIdDefault == nil ? false : true,
            "credit_card_id": self.creditCardIdDefault ?? "",
            "premium_profile_permission" : self.selectedViewMyProfile,
            "feed_permission": self.selectedViewMyFeed
            ] as [String : Any]
        
        ApiManager.shared.MakePostAPI(name: SETTING_CREATE_UPDATE_PRIMIUM, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let view = (self.theController.view as? PremiumView)
                    self.premiumResponse = PremiumModelClass(JSON: data.dictionaryObject!)
                    
                    self.txtAbout = self.premiumResponse?.about ?? ""
                    for data in self.premiumResponse?.languageDetails ?? [] {
                        if let id = data.id?.intValue, let name = data.name {
                            self.languagesId.append(id)
                            self.languages.append(name)
                        }
                    }
                    
                    self.isAutoTopup = self.premiumResponse?.isAutoTopup ?? nil
                    self.autoTopupAmount = self.premiumResponse?.autoTopupAmount?.stringValue ?? nil
                    
                    self.selectedViewMyProfile = self.premiumResponse?.viewPremiumProfile ?? ""
                    self.selectedViewMyFeed = self.premiumResponse?.viewPremiumFeed ?? ""
                    
                    self.selectedArray.removeAll()
                    self.selectedNameArray.removeAll()
                    for data in self.premiumResponse?.specializationDetails ?? [] {
                        self.selectedArray.append(data.id?.intValue ?? 0)
                        self.selectedNameArray.append(data.name ?? "")
                    }
                    view?.tableView.reloadData()
                }
            }
        })
    }
    
    func apiCallGetSettingPrimiumV2(isLoading: Bool = true) {
        
        let param = ["": ""] as [String : Any]
        print(param)
        
        ApiManager.shared.MakeGetAPI(name: "setting/\(GET_SETTING_PRIMIUM)", params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let view = (self.theController.view as? PremiumView)
                    self.premiumResponse = PremiumModelClass(JSON: data.dictionaryObject!)
                    
                    self.txtAbout = self.premiumResponse?.about ?? ""
                    self.languagesId = self.premiumResponse?.languageId ?? []
                    for data in GetAllData?.data?.languages ?? [] {
                        for languagesId in self.languagesId where languagesId == (data.id?.intValue) {
                            if let name = data.name {
                                self.languages.append(name)
                            }
                        }
                    }
                    self.languagesId = self.premiumResponse?.languageId ?? []
                    
                    self.isAutoTopup = self.premiumResponse?.isAutoTopup
                    self.autoTopupAmount = self.premiumResponse?.autoTopupAmount?.stringValue
                    self.minimumBalance = self.premiumResponse?.minimumBalance?.stringValue
                    
                    self.selectedViewMyProfile = self.premiumResponse?.viewPremiumProfile ?? ""
                    self.selectedViewMyFeed = self.premiumResponse?.viewPremiumFeed ?? ""
                    
                    self.selectedArray.removeAll()
                    self.selectedNameArray.removeAll()
                    for data in GetAllData?.data?.specializations ?? [] {
                        for id in self.premiumResponse?.specializationIds ?? [] where id == (data.id?.intValue ?? 0) {
                            self.selectedArray.append(id)
                            self.selectedNameArray.append(data.name ?? "")
                        }
                    }
                    view?.tableView.reloadData()
                }
            }
        })
    }
    
    func apiCallGetSettingPrimium(isLoading: Bool = true) {
        
        let param = ["": ""] as [String : Any]        
        print(param)
        
        ApiManager.shared.MakeGetAPI(name: GET_SETTING_PRIMIUM, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    let view = (self.theController.view as? PremiumView)
                    self.premiumResponse = PremiumModelClass(JSON: data.dictionaryObject!)
                    
                    self.txtAbout = self.premiumResponse?.about ?? ""
                    self.languages.removeAll()
                    self.languagesId.removeAll()
                    for data in self.premiumResponse?.languageDetails ?? [] {
                        if let id = data.id?.intValue, let name = data.name {
                            self.languagesId.append(id)
                            self.languages.append(name)
                        }
                    }
                    
                    self.isAutoTopup = self.premiumResponse?.isAutoTopup ?? nil
                    self.autoTopupAmount = self.premiumResponse?.autoTopupAmount?.stringValue ?? nil
                    
                    self.selectedViewMyProfile = self.premiumResponse?.viewPremiumProfile ?? ""
                    self.selectedViewMyFeed = self.premiumResponse?.viewPremiumFeed ?? ""

                    self.selectedArray.removeAll()
                    self.selectedNameArray.removeAll()
                    for data in self.premiumResponse?.specializationDetails ?? [] {
                        self.selectedArray.append(data.id?.intValue ?? 0)
                        self.selectedNameArray.append(data.name ?? "")
                    }
                    view?.tableView.reloadData()
                }
                else {
                }
            }
        })
    }
    
    func apiCallOAuth2Token(progress:Bool = true) {
        let param = [
            "grant_type": "client_credentials"
            ] as [String : Any]
        print(JSON(param))
        
        ApiManager.shared.MakePayPalPostAPI(name: PAYPAL_OAUTH2_TOKEN, params: param as [String : Any], progress: progress, vc: self.theController, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let token_type = json.getString(key: .token_type)
                let access_token = json.getString(key: .access_token)
                self.accessToken = token_type + " " + access_token
                print(self.accessToken)
            }
        })
    }
}
