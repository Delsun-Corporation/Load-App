//
//  SignUpSetupProfileViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import DropDown
import CountryPickerView
import SwiftyJSON

class SignUpSetupProfileViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:SignUpSetupProfileVC!
    
    let sexDropDown = DropDown()
    let heightDropDown = DropDown()
    let weightDropDown = DropDown()
    let cpvInternal = CountryPickerView()
    
    var sexArray: [String] = ["Male","Female", "Other"]
    var heightArray: [String] = []
    var weightArray: [String] = []
    
    var isProfileSelected:Bool = false
    var isDOBSelected:Bool = false
    var isSexSelected:Bool = false
    var isHeightSelected:Bool = false
    var isWeightSelected:Bool = false
    var isLocationSelected:Bool = false
    var isPhoneAreaSelected:Bool = false
    var isPhoneNumberSelected:Bool = false
    var userId:String = "1"
    var userEmail: String = ""
    var strDOB:String = ""
    var profileImage:UIImage?
    var isComeLogin:Bool = false

    init(theController:SignUpSetupProfileVC) {
        self.theController = theController
    }
    
    //MARK:- Functions
    func setupDropDown() {
        for i in 120..<201 {
            heightArray.append("\(i)")
        }
        for i in 35..<121 {
            weightArray.append("\(i)")
            if i != 120 {
                weightArray.append("\(i).5")
            }
        }
        self.DOBSetup()
        self.sexDropDownSetupUI()
        self.countryPickerSetupUI()
        let view = (self.theController.view as? SignUpSetupProfileView)

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
        let view = (self.theController.view as? SignUpSetupProfileView)

        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.date
        datePickerView.setValue(UIColor.appthemeOffRedColor, forKeyPath: "textColor")
        datePickerView.maximumDate = Date()
        view?.txtDOB.inputView = datePickerView
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
            //datePickerView.setValue(UIColor.clear, forKey: "magnifierLineColor")
            datePickerView.setValue(false, forKey: "highlightsToday")
        }
        datePickerView.backgroundColor = UIColor.white

        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        self.isDOBSelected = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        let view = (self.theController.view as? SignUpSetupProfileView)
        view?.txtDOB.text = dateFormatter.string(from: sender.date)
        
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.strDOB = dateFormatter.string(from: sender.date)
        
        view?.viewDOB.borderColors = UIColor.appthemeRedColor
        view?.viewDOBDropDown.backgroundColor = UIColor.appthemeRedColor
        view?.txtDOB.textColor = UIColor.appthemeRedColor
        view?.imgDOBDropDown.isHidden = false
        self.showNext(txtFullName: view?.txtFullName.text ?? "", txtPhoneArea: view?.txtPhoneArea.text ?? "", txtPhoneNumber: view?.txtPhoneNumber.text ?? "", txtLocation: view?.txtLocation.text ?? "")
    }
    
    func sexDropDownSetupUI() {
        let view = (self.theController.view as? SignUpSetupProfileView)

        sexDropDown.anchorView = view?.btnSex
        sexDropDown.dataSource = sexArray
        sexDropDown.cellConfiguration = { (index, item) in return "\(item)" }
        
        sexDropDown.selectionAction = { (index: Int, item: String) in
            self.isSexSelected = true
            let view = view
            view?.txtSex.text = item
            view?.viewSex.borderColors = UIColor.appthemeRedColor
            view?.txtSex.textColor = UIColor.appthemeRedColor
            view?.viewSexDropDown.backgroundColor = UIColor.appthemeRedColor
            view?.imgSexDropDown.image = UIImage(named: "ic_right_birthday")
            self.showNext(txtFullName: view?.txtFullName.text ?? "", txtPhoneArea: view?.txtPhoneArea.text ?? "", txtPhoneNumber: view?.txtPhoneNumber.text ?? "", txtLocation: view?.txtLocation.text ?? "")
            
        }
        sexDropDown.backgroundColor = .white
        sexDropDown.width = view?.btnSex.frame.width ?? 0
        sexDropDown.bottomOffset = CGPoint(x: 0, y: sexDropDown.anchorView?.plainView.bounds.height ?? 0)
    }
    
    func countryPickerSetupUI() {
        cpvInternal.delegate = theController.self
        cpvInternal.dataSource = theController.self
    }
    
    func showNext(txtFullName:String, txtPhoneArea: String, txtPhoneNumber: String, txtLocation: String) {
        let view = (self.theController.view as? SignUpSetupProfileView)

        if txtFullName != "" && isProfileSelected && isDOBSelected
             && isSexSelected && isHeightSelected && isWeightSelected && txtPhoneArea != "" && txtPhoneNumber != "" && txtLocation != "" {
            view?.viewNext.backgroundColor = UIColor.appthemeRedColor
            view?.btnNext.isUserInteractionEnabled = true
        }
        else {
            view?.viewNext.backgroundColor = UIColor.appThemeDarkGrayColor
            view?.btnNext.isUserInteractionEnabled = false
        }
    }
    
    func ValidateDetails() {
        let view = (self.theController.view as? SignUpSetupProfileView)

        if !self.isProfileSelected {
            makeToast(strMessage: getCommonString(key: "Select_profile_picture_key"))
        }
        else if (view?.txtFullName.text?.toTrim() ?? "") == "" {
            makeToast(strMessage: getCommonString(key: "Enter_fullname_key"))
        }
        else if !self.isDOBSelected {
            makeToast(strMessage: getCommonString(key: "Select_DOB_key"))
        }
        else if !self.isSexSelected {
            makeToast(strMessage: getCommonString(key: "Select_sex_key"))
        }
        else if !self.isHeightSelected {
            makeToast(strMessage: getCommonString(key: "Select_height_key"))
        }
        else if !self.isWeightSelected {
            makeToast(strMessage: getCommonString(key: "Select_weight_key"))
        }
        else {
           self.apiCall()
        }
    }
    
    //MARK:- API Integration
    func apiCall() {
        let view = (self.theController.view as? SignUpSetupProfileView)
        
        let weightInt: Int = Int(view?.txtWeight.text ?? "0") ?? 0
        let heightInt: Int = Int(view?.txtHeight.text ?? "0") ?? 0

        let param = ["name":view?.txtFullName.text! ?? "", "date_of_birth":self.strDOB, "gender" : self.checkGender(str: (view?.txtSex.text?.toTrim() ?? "")), "weight" : weightInt, "height" : heightInt, "location" : view?.txtLocation.text ?? "", "phone_area" : view?.txtPhoneArea.text ?? "", "phone_number" : view?.txtPhoneNumber.text ?? "", "email": self.userEmail] as [String : Any]
        
        ApiManager.shared.MakePostAPI(name: SIGN_UP_PROFILE, params: param as [String : Any], vc: self.theController) { (response, error) in
            if response != nil {
                let json = JSON(response!)
                let result = LoginModelClass(JSON: json.dictionaryObject!)
                if (result?.success ?? false) {
                    saveJSON(j: json, key: USER_DETAILS_KEY)
//                    let obj: TabbarVC = AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "TabbarVC") as! TabbarVC
//                    self.theController.present(obj, animated: true, completion: nil)
                    AppDelegate.shared?.sidemenu()
                    AppDelegate.shared?.apiCallForDynamicData()
                }
                else {
                    makeToast(strMessage: result?.message ?? "")
                }
            }
        }
    }    
    
    func checkGender(str: String) -> String {
        if str.uppercased() == GENDER_TYPE.MALE.rawValue {
            return GENDER_TYPE.MALE.rawValue
        }
        else if str.uppercased() == GENDER_TYPE.FEMALE.rawValue {
            return GENDER_TYPE.FEMALE.rawValue
        }
        else {
            return GENDER_TYPE.OTHER.rawValue
        }
    }
}

