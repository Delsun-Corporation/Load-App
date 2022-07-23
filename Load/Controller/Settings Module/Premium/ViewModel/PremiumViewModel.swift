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
    var languages: String = ""
    var languagesId: Int?
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
    
    func setupUI() {
        self.apiCallGetSettingPrimium()
        self.apiCallOAuth2Token(progress: false)
    }
    
    func setupNavigationbar(title:String) {
        self.theController.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.theController.navigationItem.hidesBackButton = true
        
        if let vwnav = ViewNavMedium.instanceFromNib() as? ViewNavMedium {
            
            vwnav.imgBackground.isHidden = true
            vwnav.btnback.isHidden = false
            vwnav.btnSave.isHidden = self.theController.btnSave.isHidden
            
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
//        obj.mainModelView.placeholder = getCommonString(key: "About_key")
//        if self.txtAbout != "" {
//            obj.mainView.txtTextView.text = self.txtAbout
//        }
//        obj.mainModelView.isScreen = 3
        self.theController.navigationController?.pushViewController(obj, animated: true)
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
        obj.mainModelView.cardDetails = self.premiumResponse?.cardDetails ?? []
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }

    
    func btnAutoTopUpClicked() {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "AutoTopUpVC") as! AutoTopUpVC
        obj.mainModelView.delegate = self
        obj.mainModelView.accessToken = self.accessToken
        obj.mainModelView.cardDetails = self.premiumResponse?.cardDetails ?? []
        obj.mainModelView.isAutoTopup = self.premiumResponse?.isAutoTopup ?? false
        obj.mainModelView.autoTopupAmount = self.premiumResponse?.autoTopupAmount?.stringValue ?? nil
        self.theController.navigationController?.pushViewController(obj, animated: true)
    }
    
    func BillingInformationReload(isUpdated: Bool) {
        if isUpdated {
            if self.theController.btnSave.isHidden {
                self.apiCallGetSettingPrimium(isLoading: false)
            }
        }
    }
    
    func ProfessionalRequirementFinish(text: String, isScreen: Int) {
        if self.txtAbout != text {
            self.theController.resetNavigationBar()
        }
        self.txtAbout = text
        
        let _ = validateDetails()
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
        
        self.setupNavigationbar(title: getCommonString(key: "Premium_key"))
        self.theController.navigationController?.setWhiteColor()
        self.theController.navigationController?.addShadow()

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
        
        self.apiCallSettingCreateUpdatePrimium(about: self.txtAbout, specializationIds: self.selectedArray, languageIds: self.languagesId ?? 0)
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
        else if self.languagesId == nil {
            makeToast(strMessage: getCommonString(key: "Please_select_languages_key"))
            return false
        }
        
        return true
    }
    
    func updatePremium() {
        self.theController.resetNavigationBar()
        self.apiCallSettingCreateUpdatePrimium(about: self.txtAbout, specializationIds: self.selectedArray, languageIds: self.languagesId)
    }
    
    func apiCallSettingCreateUpdatePrimium(about: String, specializationIds: [Int], languageIds: Int?, isLoading: Bool = true) {
        
        var param = [
            "about": about,
            "specialization_ids" : specializationIds,
            "language_ids": [languageIds ?? 0],
            "is_auto_topup": self.isAutoTopup ?? false,
            "auto_topup_amount": self.autoTopupAmount ?? "",
            "minimum_balance": self.minimumBalance ?? "" ,
            "is_card_default": self.creditCardIdDefault == nil ? false : true,
            "credit_card_id": self.creditCardIdDefault ?? "",
            "premium_profile_permission" : self.selectedViewMyProfile,
            "feed_permission": self.selectedViewMyFeed
            ] as [String : Any]
        
        if self.isAutoTopup == nil {
            param.removeValue(forKey: "is_auto_topup")
        }
        
        if self.autoTopupAmount == nil {
            param.removeValue(forKey: "auto_topup_amount")
        }
        
        if self.creditCardIdDefault == nil {
            param.removeValue(forKey: "is_card_default")
            param.removeValue(forKey: "credit_card_id")
        }
        print(param)
        let endpointName = newApiConfig ? "setting/\(SETTING_CREATE_UPDATE_PRIMIUM)" : SETTING_CREATE_UPDATE_PRIMIUM
        ApiManager.shared.MakePostAPI(name: endpointName, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
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
                        self.languagesId = data.id?.intValue ?? 0
                        self.languages = data.name ?? ""
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
    
    func apiCallGetSettingPrimium(isLoading: Bool = true) {
        
        let param = ["": ""] as [String : Any]        
        print(param)
        let endpointName = newApiConfig ? "setting/\(GET_SETTING_PRIMIUM)" : GET_SETTING_PRIMIUM
        ApiManager.shared.MakeGetAPI(name: endpointName, params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
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
                        self.languagesId = data.id?.intValue ?? 0
                        self.languages = data.name ?? ""
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

extension PremiumViewModel: CustomNavigationWithSaveButtonDelegate{
    
    func CustomNavigationClose() {
        guard validateDetails() == true else {
            return
        }
        
        updatePremium()
        
        self.theController.btnCloseClicked()
    }
    
    func CustomNavigationSave() {
        print("save")
        guard validateDetails() == true else {
            return
        }
        
        updatePremium()
    }


}
