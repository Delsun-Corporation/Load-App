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
    
    let heightPickerView: UIPickerView = UIPickerView()
    let weightPickerView: UIPickerView = UIPickerView()
    var arrayDecimal = Array(stride(from: 0, to: 10, by: 1))
    var sexArray: [String] = ["Male","Female", "Other"]
    var heightArray: [String] = []
    var weightArray: [String] = []
    var firstComponentWeight = "0"
    var secondComponentWeight = "0"
    var firstComponentHeight = "0"
    var secondComponentHeight = "0"
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
        }
        self.DOBSetup()
        self.sexDropDownSetupUI()
        self.countryPickerSetupUI()
        self.heightPickerSetup()
        self.weightPickerSetup()
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
        datePickerView.datePickerMode = .date
        datePickerView.locale = Locale(identifier: "en_GB")
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
        view?.imgDOBDropDown.image = UIImage(named: "ic_right_birthday")
        self.showNext()
    }
    
    func heightPickerSetup() {
        let view = (self.theController.view as? SignUpSetupProfileView)
        let screenRest = UIScreen.main.bounds.width / 2
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 98 : 108
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (heightPickerView.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "."
            }
            else {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (heightPickerView.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "cm"
            }
            label.textColor = .appthemeRedColor
            self.heightPickerView.addSubview(label)
        }
        
        heightPickerView.delegate = theController.self
        heightPickerView.dataSource = theController.self
        view?.txtHeight.inputView = heightPickerView
        
        heightPickerView.backgroundColor = UIColor.white
    }
    
    func weightPickerSetup() {
        let view = (self.theController.view as? SignUpSetupProfileView)
        
        let screenRest = UIScreen.main.bounds.width / 2
        for index in 0..<2 {
            let label = UILabel()
            label.textAlignment = .center
            label.tag = 100 + index
            label.font = themeFont(size: 21, fontname: .Regular) //themeFont(size: 15, fontname: .ProximaNovaRegular)
            if index == 0 {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? 98 : 108
                label.frame = CGRect(x: (screenRest * CGFloat(index)) + CGFloat(x), y: (weightPickerView.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "."
            }
            else {
                let x = DEVICE_TYPE.IS_IPHONE_6 ? -2 : 8
                label.frame = CGRect(x: (screenRest * CGFloat(index)) - CGFloat(x), y: (weightPickerView.frame.height - 30) / 2, width: screenRest, height: 30)
                label.text = "kg"
            }
            label.textColor = .appthemeRedColor
            self.weightPickerView.addSubview(label)
        }
        weightPickerView.delegate = theController.self
        weightPickerView.dataSource = theController.self
        view?.txtWeight.inputView = weightPickerView
        
        weightPickerView.backgroundColor = UIColor.white
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
            self.showNext()
            
        }
        sexDropDown.backgroundColor = .white
        sexDropDown.width = view?.btnSex.frame.width ?? 0
        sexDropDown.bottomOffset = CGPoint(x: 0, y: sexDropDown.anchorView?.plainView.bounds.height ?? 0)
    }
    
    func countryPickerSetupUI() {
        cpvInternal.delegate = theController.self
        cpvInternal.dataSource = theController.self
    }
    
    func showNext() {
        let view = (self.theController.view as? SignUpSetupProfileView)

        let txtFirstName = view?.txtFirstName.text
        let txtLastName = view?.txtLastName.text
        let txtPhoneArea = view?.txtPhoneArea.text
        let txtPhoneNumber = view?.txtPhoneNumber.text
        let txtLocation = view?.txtLocation.text
        
        if txtFirstName != "" && txtLastName != "" && isProfileSelected && isDOBSelected
             && isSexSelected && isHeightSelected && isWeightSelected && txtPhoneArea != "" && txtPhoneNumber != "" && txtLocation != "" {
            view?.viewNext.backgroundColor = UIColor.appthemeRedColor
            view?.btnNext.isUserInteractionEnabled = true
        }
        else {
            view?.viewNext.backgroundColor = UIColor.appthemeGrayColor
            view?.btnNext.isUserInteractionEnabled = false
        }
    }
    
    func ValidateDetails() {
        let view = (self.theController.view as? SignUpSetupProfileView)

        if !self.isProfileSelected {
            makeToast(strMessage: getCommonString(key: "Select_profile_picture_key"))
        }
        else if (view?.txtFirstName.text?.toTrim() ?? "") == "" {
            makeToast(strMessage: getCommonString(key: "Enter_fullname_key"))
        }
        else if (view?.txtLastName.text?.toTrim() ?? "") == "" {
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
        
        let weightInt: Double = Double(view?.txtWeight.text?.replace(target: " kg", withString: "") ?? "0.0") ?? 0.0
        let heightInt: Double = Double(view?.txtHeight.text?.replace(target: " cm", withString: "") ?? "0.0") ?? 0.0
        
        print("This is weight int \(weightInt)")
        print("This is height int \(heightInt)")

        let fullName = (view?.txtFirstName.text ?? "") + " " + (view?.txtLastName.text ?? "")
        
        let param = [
            "name": fullName,
            "date_of_birth": self.strDOB,
            "gender" : self.checkGender(str: (view?.txtSex.text?.toTrim() ?? "")),
            "weight" : weightInt,
            "height" : heightInt,
            "location" : view?.txtLocation.text ?? "",
            "phone_area" : view?.txtPhoneArea.text ?? "",
            "phone_number" : view?.txtPhoneNumber.text ?? "",
            "email": self.userEmail] as [String : Any]
        
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
