//
//  CreateEventStepFiveViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 19/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import CoreLocation

class CreateEventStepFiveViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:CreateEventStepFiveVC!
    
    //Step One
    var eventType:String = ""
    var selectedPublicType:Int?
    var maxGuest:String = ""
    
    //Step Two
    var txtEventName: String = ""
    var selectedDate:Date?
    var selectedTime:Date?
    var txtTimeArlier: String = ""
    var eventTime:Int = 0
    var selectedCoordinate : CLLocationCoordinate2D?
    var selectedAddress : String = ""
    var eventPrice:Int = 10
    
    //Step Three
    var txtDescription: String = ""
    var amenitiesArray:[[Any]] = [[Any]]()
    
    var GeneralRules: String = ""
    var CancellationRulesType: String = ""
    var CancellationRules: String = ""
    
    var txtEventPrice: String = ""
    var txtCurrency: String = ""
    var images: UIImage?
    var currencyId: Int = 0

    var CancellationRulesId: Int = 0

    init(theController:CreateEventStepFiveVC) {
        self.theController = theController
    }
    
    let pickerView = UIPickerView()
    
    //MARK:- Functions
    func setupUI() {
        self.setupPicture()
//        let view = (self.theController.view as? CreateEventStepFiveView)
//        pickerView.delegate = theController
//        pickerView.backgroundColor = UIColor.white
//        view?.txtCancellationPolicy.inputView = pickerView
    }
    
    
    func setupPicture() {
        let view = (self.theController.view as? CreateEventStepFiveView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        view?.imgPicture.isUserInteractionEnabled = true
        view?.imgPicture.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.showActionSheet()
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
            myPickerController.allowsEditing = false
            self.theController.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func photoLibrary() {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self.theController
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerController.allowsEditing = false
        self.theController.present(myPickerController, animated: true, completion: nil)
    }
    
    func validateDetails() {
        if self.images == nil {
            makeToast(strMessage: getCommonString(key: "Select_profile_key"))
        }
        else {
            let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateEventFinishVC") as! CreateEventFinishVC
            obj.mainModelView.eventType = self.eventType
            obj.mainModelView.selectedPublicType = self.selectedPublicType
            obj.mainModelView.maxGuest = self.maxGuest
            obj.mainModelView.txtEventName = self.txtEventName
            obj.mainModelView.selectedDate = self.selectedDate
            obj.mainModelView.selectedTime = self.selectedTime
            obj.mainModelView.txtTimeArlier = self.txtTimeArlier
            obj.mainModelView.eventTime = self.eventTime
            obj.mainModelView.selectedCoordinate = self.selectedCoordinate
            obj.mainModelView.selectedAddress = self.selectedAddress
            obj.mainModelView.txtDescription = self.txtDescription
            obj.mainModelView.amenitiesArray = self.amenitiesArray
            obj.mainModelView.txtEventPrice = self.txtEventPrice
            obj.mainModelView.txtCurrency = self.txtCurrency
            obj.mainModelView.currencyId = self.currencyId
            obj.mainModelView.GeneralRules = self.GeneralRules
            obj.mainModelView.CancellationRulesType = self.CancellationRulesType
            obj.mainModelView.CancellationRules = self.CancellationRules
            obj.mainModelView.CancellationRulesId = self.CancellationRulesId
            obj.mainModelView.images = self.images
            obj.mainModelView.eventType = self.eventType
            obj.mainModelView.selectedPublicType = self.selectedPublicType
            obj.mainModelView.maxGuest = self.maxGuest
            self.theController.navigationController?.pushViewController(obj, animated: true)
        }
    }
}
