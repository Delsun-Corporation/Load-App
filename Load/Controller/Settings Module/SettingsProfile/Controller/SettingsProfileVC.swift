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
        
        self.navigationController?.navigationBar.isHidden = true
        self.setUpNavigationBarTitle(strTitle: "",isShadow: false)
        self.navigationController?.setColor()
        setNavigationForIndoor()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func setNavigationForIndoor(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Topheader")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "")
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
    
    @IBAction func btnDOBClicked(_ sender: Any) {
        self.mainView.txtDOB.becomeFirstResponder()
    }
    
    @IBAction func btnGenderClicked(_ sender: Any) {
        self.mainView.txtGender.becomeFirstResponder()
    }
    
    @IBAction func btnLocationClicked(_ sender: Any) {
        self.mainModelView.cpvInternal.showCountriesList(from: self)
    }
    
    @IBAction func btnEditClicked(_ sender: UIButton) {
        //        if !self.mainModelView.isEdited {
        //            sender.setTitle(str: "Save")
        //            sender.setImage(nil, for: .normal)
        //            sender.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        //            setUpNavigationBarTitle(strTitle: "Edit Profile", color: UIColor.appthemeRedColor)
        //            self.mainModelView.addImagePicker()
        //        }
        //        else {
        //            self.mainModelView.validateDetails()
        ////            sender.setTitle(str: "")
        ////            sender.setImage(UIImage(named: "ic_edit_red"), for: .normal)
        ////            sender.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        ////            setUpNavigationBarTitle(strTitle: "")
        //        }
        //        self.mainModelView.isEdited = true
        //        self.mainModelView.IsEditable(isEnable: self.mainModelView.isEdited)
    }
    
    @IBAction func btnCountryCodeClicked(_ sender: Any) {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "CountryCodeVC") as! CountryCodeVC
        obj.modalPresentationStyle = .overCurrentContext
        obj.mainModelView.delegate = self
        self.present(obj, animated:  false, completion: nil)
    }
    
    @objc func onLabelChangePictureTapped(_ sender: Any) {
        mainModelView.onLabelChangePictureTapped()
    }
    
    @objc func imageTapped(_ sender: Any) {
        mainModelView.onLabelChangePictureTapped()
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
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.mainView.imgProfile.image = selectedImage
        if let picture = selectedImage {
            self.mainModelView.images = picture
            let resizedPicture = picture.resizeImage(image: picture, targetSize: CGSize(width: 400.0, height: 400.0))
            if resizedPicture.jpegData(compressionQuality: 0.2)?.count ?? 5000000 < 5000000 {
                self.mainModelView.images = resizedPicture
            }
            else {
                makeToast(strMessage: "File size should be lower than 5 MB")
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
