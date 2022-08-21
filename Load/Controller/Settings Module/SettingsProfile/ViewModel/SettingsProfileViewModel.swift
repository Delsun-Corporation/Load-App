//
//  SettingsProfileViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 22/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import CountryPickerView
import Foundation

class SettingsProfileViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:SettingsProfileVC!
    var profileDetails: ProfileModelClass?
    var strDOB:String = ""
    var isEdited:Bool = false
    var locationId: String = ""
    var images: UIImage?
    
    var countryDialCode: String = "+1"
    var countryName: String = "United States"
    var countryCode: String = "US"
    let genderPickerView = UIPickerView()
    let cpvInternal = CountryPickerView()
    
    lazy var genderArr: [String] = {
        return genderArray()
    }()
    
    //MARK:- Functions
    init(theController:SettingsProfileVC) {
        self.theController = theController
    }
    func setupUI() {
        let view = (self.theController.view as? SettingsProfileView)
        view?.txtEmail.isUserInteractionEnabled = false
        view?.txtMobile.isUserInteractionEnabled = false
        view?.txtCode.isUserInteractionEnabled = false
        view?.btnCountryCode.isUserInteractionEnabled = false
        
        self.apiCallGetUserDetail()
        self.countryPickerSetupUI()
        self.genderPickerSetupUI()
        self.addImagePicker()
    }
    
    func onLabelChangePictureTapped() {
        showActionSheet()
    }
    
    func addImagePicker() {
        let view = (self.theController.view as? SettingsProfileView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        view?.imgProfile.addGestureRecognizer(tapGesture)
        view?.imgProfile.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture:UIGestureRecognizer) {
        showActionSheet()
    }
    
    //MARK:- ActionSheet
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.theController.present(actionSheet, animated: true, completion: nil)
    }
    
    func camera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self.theController
            myPickerController.sourceType = UIImagePickerController.SourceType.camera
            myPickerController.allowsEditing = true
            self.theController.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self.theController
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerController.allowsEditing = true
        self.theController.present(myPickerController, animated: true, completion: nil)
    }
    
    func DOBSetup() {
        let view = (self.theController.view as? SettingsProfileView)
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
            //datePickerView.setValue(UIColor.clear, forKey: "magnifierLineColor")
            datePickerView.setValue(false, forKey: "highlightsToday")
        }
        
        datePickerView.backgroundColor = UIColor.white
        
        datePickerView.setValue(UIColor.appthemeOffRedColor, forKeyPath: "textColor")
        let convertToDate = convertDate(self.profileDetails?.dateOfBirth ?? "", dateFormat:  "dd-MM-yyyy")
        datePickerView.setDate(convertToDate, animated: false)
        datePickerView.maximumDate = Date()
        view?.txtDOB.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        let view = (self.theController.view as? SettingsProfileView)
        dateFormatter.dateFormat = "dd / MM / yyyy"
        view?.txtDOB.text = dateFormatter.string(from: sender.date)
        self.strDOB = dateFormatter.string(from: sender.date)
    }
    
    func countryPickerSetupUI() {
        cpvInternal.delegate = theController.self
        cpvInternal.dataSource = theController.self
    }
    
    func genderPickerSetupUI() {
        let view = (self.theController.view as? SettingsProfileView)
        
        genderPickerView.delegate = theController.self
        genderPickerView.dataSource = theController.self
        view?.txtGender.inputView = genderPickerView
        
        genderPickerView.backgroundColor = UIColor.white
    }
    
    func apiCallGetUserDetail() {
        var param = ["": ""] as [String : Any]
        
        if newApiConfig {
            if let id = getUserDetail()?.data?.user?.id?.intValue {
                param = ["id": id] as [String : Any]
            }
            ApiManager.shared.MakeGetAPI(name: USER, params: param as [String : Any], vc: self.theController, isAuth: false, completionHandler: { (response, error) in
                if response != nil {
                    let json = JSON(response!)
                    print("This is json \(json)")
                    let success = json.getBool(key: .success)
                    if success {
                        let data = json.getDictionary(key: .data)
                        self.profileDetails = ProfileModelClass(JSON: data.dictionaryObject!)
                        self.DOBSetup()
                        self.showUserDetails()
                        self.updateData()
                    }
                    else {
                        let message = json.getString(key: .message)
                        makeToast(strMessage: message)
                    }
                }
            })
        }
        else {
            ApiManager.shared.MakeGetAPI(name: USER + "/" + (getUserDetail()?.data?.user?.id?.stringValue)!, params: param as [String : Any], vc: self.theController, isAuth: false, completionHandler: { (response, error) in
                if response != nil {
                    let json = JSON(response!)
                    print(json)
                    let success = json.getBool(key: .success)
                    if success {
                        let data = json.getDictionary(key: .data)
                        self.profileDetails = ProfileModelClass(JSON: data.dictionaryObject!)
                        self.DOBSetup()
                        self.showUserDetails()
                        self.updateData()
                    }
                    else {
                        let message = json.getString(key: .message)
                        makeToast(strMessage: message)
                    }
                }
            })
        }
    }
    
    func validateDetails() {
        let view = (self.theController.view as? SettingsProfileView)
        
        let fName = view?.txtFirstName.text?.toTrim() ?? ""
        let lName = view?.txtLastName.text?.toTrim() ?? ""
        let DOB = view?.txtDOB.text?.toTrim() ?? ""
        let gender = view?.txtGender.text?.toTrim() ?? ""
        let code = view?.txtCode.text?.toTrim() ?? ""
        let mobile = view?.txtMobile.text?.toTrim() ?? ""
        let email = view?.txtEmail.text?.toTrim() ?? ""
        
        let img = self.images == nil ? [] : [self.images!]
        apiCallUpdateUserDetail(name: fName + " " + lName, email: email, gender: gender, countryCode: code, mobile: mobile, dateOfBirth: DOB, countryId: self.locationId, images: img)
    }
    
    func apiCallUpdateUserDetail(name:String, email:String, gender: String, countryCode:String, mobile:String, dateOfBirth:String, countryId:String, images:[UIImage]) {
        
        var param = ["name": name, "email": email, "country_code": countryCode, "gender": gender, "mobile": mobile, "date_of_birth": convertDateFormater(dateOfBirth, format: "dd / MM / yyyy", dateFormat: "dd-MM-yyyy"), "country_id": countryId] as [String : Any]
        print(param)
        
        if (newApiConfig) {
            if let id = getUserDetail()?.data?.user?.id?.intValue {
                param["id"] = id
            }
            print("This is param for edit profile \(param)")
            ApiManager.shared.MakePostAPI(name: USER_UPDATE, params: param as [String : Any], progress: false, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
                if response != nil {
                    let json = JSON(response!)
                    print(json)
                    let success = json.getBool(key: .success)
                    if success {
                        let data = json.getDictionary(key: .data)
                        self.profileDetails = ProfileModelClass(JSON: data.dictionaryObject!)
                        self.updateData(isBack: false)
                    }
                    else {
                        let message = json.getString(key: .message)
                        makeToast(strMessage: message)
                    }
                }
            })
        }
        else {
            ApiManager.shared.MakePostWithImageAPI(name: USER_UPDATE + "/" + (getUserDetail()?.data?.user?.id?.stringValue)!, params: param as [String : Any], images: images, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
                if response != nil {
                    let json = JSON(response!)
                    print(json)
                    let success = json.getBool(key: .success)
                    if success {
                        let data = json.getDictionary(key: .data)
                        self.profileDetails = ProfileModelClass(JSON: data.dictionaryObject!)
                        self.updateData(isBack: true)
                    }
                    else {
                        let message = json.getString(key: .message)
                        makeToast(strMessage: message)
                    }
                }
            })
        }
    }
    
    func showUserDetails() {
        let view = (self.theController.view as? SettingsProfileView)
        view?.imgProfile.sd_setImage(with: self.profileDetails?.photo?.toURL(), placeholderImage: UIImage(named: "ic_placeholder"))
        view?.lblNameTitle.text = self.profileDetails?.name ?? ""
        let fullNameArr = self.profileDetails?.name!.split{$0 == " "}.map(String.init)
        if (fullNameArr?.count)! > 0 {
            var firstName = ""
            var lastName = ""
            for (index, data) in (fullNameArr?.enumerated())! {
                if index == ((fullNameArr?.count)! - 1) && fullNameArr?.count != 1 {
                    lastName = data
                }
                else {
                    firstName += " \(data)"
                }
            }
            view?.txtFirstName.text = firstName.toTrim()
            view?.txtLastName.text = lastName.toTrim()
        }
        
        let date = (self.profileDetails?.dateOfBirth!)!
        
        view?.txtDOB.text = convertDateFormater(date, format: "dd-MM-yyyy", dateFormat: "dd / MM / yyyy")
        view?.txtLocation.text = self.profileDetails?.location
        view?.txtGender.text = self.profileDetails?.gender
        self.locationId = self.profileDetails?.countryDetail?.id?.stringValue ?? ""
        
        view?.txtCode.text = self.profileDetails?.countryCode
        view?.txtMobile.text = self.profileDetails?.mobile
        view?.txtEmail.text = self.profileDetails?.email
        let format = newApiConfig ? "yyyy-MM-dd'T'HH:mm:ss.SZ" : "yyyy-MM-dd HH:mm:ss"
        view?.lblMemberSince.text = convertDateFormater((self.profileDetails?.createdAt) ?? Date().iso8601, format: format, dateFormat: "MMM yyyy")
        view?.lblAccountType.text = self.profileDetails?.accountDetail?.name
        if self.profileDetails?.emailVerifiedAt == nil {
            view?.imgEmail.isHidden = true
        }
        
        if self.profileDetails?.mobileVerifiedAt == nil {
            view?.imgPhone.isHidden = true
        }
        
        if self.profileDetails?.facebook == "" {
            view?.imgPhone.isHidden = true
        }
    }
    
    func IsEditable(isEnable:Bool = true) {
        let view = (self.theController.view as? SettingsProfileView)
        view?.txtFirstName.isUserInteractionEnabled = isEnable
        view?.txtLastName.isUserInteractionEnabled = isEnable
        view?.txtDOB.isUserInteractionEnabled = isEnable
        view?.txtLocation.isUserInteractionEnabled = isEnable
        view?.btnLocation.isUserInteractionEnabled = isEnable
    }
    
    func updateData(isBack:Bool = false) {
        var json = getUserDetailJSON()
        print(json)
        json["data"]["user"].setValue(key: .name, value: self.profileDetails?.name ?? "")
        json["data"]["user"].setValue(key: .photo, value: self.profileDetails?.photo ?? "")
        json["data"]["user"].setValue(key: .country_code, value: self.profileDetails?.countryCode ?? "+1")
        json["data"]["user"].setValue(key: .mobile, value: self.profileDetails?.mobile ?? "")
        json["data"]["user"].setValue(key: .gender, value: self.profileDetails?.gender ?? "")
        json["data"]["user"].setValue(key: .date_of_birth, value: self.profileDetails?.dateOfBirth ?? "")
        json["data"]["user"].setNumberValue(key: .country_id, value: self.profileDetails?.countryId ?? 0)
        json["data"]["user"].setIntValue(key: .account_id, value: self.profileDetails?.accountDetail?.id?.intValue ?? 0)
        
        json["data"]["user"].setIntValue(key: .is_snooze, value: self.profileDetails?.isSnooze?.intValue ?? 0)
        json["data"]["user"].setIntValue(key: .country_id, value: self.profileDetails?.countryId?.intValue ?? 0)
        
        if self.profileDetails?.isSnooze?.intValue == 1 {
            if json["data"]["user"]["user_snooze_detail"].isEmpty {
                json["data"]["user"]["user_snooze_detail"] = JSON()
                json["data"]["user"]["user_snooze_detail"].setValue(key: .start_date, value: self.profileDetails?.userSnoozeDetail?.startDate ?? "")
                json["data"]["user"]["user_snooze_detail"].setValue(key: .end_date, value: self.profileDetails?.userSnoozeDetail?.endDate ?? "")
            }
            else {
                json["data"]["user"]["user_snooze_detail"].setValue(key: .start_date, value: self.profileDetails?.userSnoozeDetail?.startDate ?? "")
                json["data"]["user"]["user_snooze_detail"].setValue(key: .end_date, value: self.profileDetails?.userSnoozeDetail?.endDate ?? "")
            }
        }
        else {
            json["data"]["user"]["user_snooze_detail"] = JSON()
        }
        print(json)
        saveJSON(j: json, key: USER_DETAILS_KEY)
        
        if isBack {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.theController.navigationController?.popViewController(animated: true)
            }
        }
    }
}
