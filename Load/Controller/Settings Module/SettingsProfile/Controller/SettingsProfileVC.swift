//
//  SettingsProfileVC.swift
//  Load
//
//  Created by Haresh Bhai on 22/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON

class SettingsProfileVC: UIViewController, CountryCodeDelegate {

    //MARK:- Variables
    lazy var mainView: SettingsProfileView = { [unowned self] in
        return self.view as! SettingsProfileView
    }()
    
    lazy var mainModelView: SettingsProfileViewModel = {
        return SettingsProfileViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        
        self.mainModelView.isEdited = true
        self.mainModelView.IsEditable(isEnable: self.mainModelView.isEdited)
        
        self.setUpNavigationBarTitle(strTitle: "",isShadow: false)
        setNavigationForIndoor()

    }
    
    func setNavigationForIndoor(){
        
        let navigationBarHeight: CGFloat = self.navigationController?.navigationBar.frame.height ?? 66
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Topheader")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    }

    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
//        self.navigationController?.popViewController(animated: true)
        self.mainModelView.validateDetails()
    }
    
    @IBAction func btnDOBClicked(_ sender: Any) {
        self.mainView.txtDOB.becomeFirstResponder()
    }
    
    @IBAction func btnLocationClicked(_ sender: Any) {
        if self.mainView.txtLocation.text?.toTrim() == "" {
            let model = GetAllData?.data?.countries?.first
            self.mainView.txtLocation.text =  model?.name
            self.mainModelView.locationId = (model?.id?.stringValue) ?? "0"
        }
        self.mainView.txtLocation.becomeFirstResponder()
    }
    
    @IBAction func btnEditClicked(_ sender: UIButton) {
        if !self.mainModelView.isEdited {
            sender.setTitle(str: "Save")
            sender.setImage(nil, for: .normal)
            sender.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            setUpNavigationBarTitle(strTitle: "Edit Profile", color: UIColor.appthemeRedColor)
            self.mainModelView.addImagePicker()
        }
        else {
            self.mainModelView.validateDetails()
//            sender.setTitle(str: "")
//            sender.setImage(UIImage(named: "ic_edit_red"), for: .normal)
//            sender.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
//            setUpNavigationBarTitle(strTitle: "")
        }
        self.mainModelView.isEdited = true
        self.mainModelView.IsEditable(isEnable: self.mainModelView.isEdited)
    }
    
    @IBAction func btnCountryCodeClicked(_ sender: Any) {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "CountryCodeVC") as! CountryCodeVC
        obj.modalPresentationStyle = .overCurrentContext
        obj.mainModelView.delegate = self
        self.present(obj, animated:  false, completion: nil)
    }
    
    func CountryCodeDidFinish(data: JSON) {
        self.mainModelView.countryDialCode = data["dial_code"].string ?? ""
        self.mainModelView.countryName = data["name"].string ?? ""
        self.mainModelView.countryCode = data["code"].string ?? ""
        self.mainView.txtCode.text = self.mainModelView.countryDialCode
    }
}

//MARK: - Image delegate
extension SettingsProfileVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage]
        self.mainModelView.images = (selectedImage as! UIImage)
        self.mainView.imgProfile.image = selectedImage as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
