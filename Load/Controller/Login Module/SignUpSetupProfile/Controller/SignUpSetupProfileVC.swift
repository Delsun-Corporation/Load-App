//
//  SignUpSetupProfileVC.swift
//  Load
//
//  Created by Haresh Bhai on 28/05/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SignUpSetupProfileVC: UIViewController, UITextFieldDelegate {

    //MARK:- Variables
    lazy var mainView: SignUpSetupProfileView = { [unowned self] in
        return self.view as! SignUpSetupProfileView
    }()
    
    lazy var mainModelView: SignUpSetupProfileViewModel = {
        return SignUpSetupProfileViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    //MARK:- Functions
    func setupUI() {
        self.mainView.txtFirstName.delegate = self
        self.mainView.txtLastName.delegate = self
        self.mainView.txtHeight.delegate = self
        self.mainView.txtWeight.delegate = self
        self.mainView.txtLocation.delegate = self
        self.mainView.txtPhoneArea.delegate = self
        self.mainView.txtPhoneNumber.delegate = self

        self.mainModelView.setupDropDown()
        self.mainView.setupUI()
    }

    //MARK:- @IBAction
    @IBAction func btnNextClicked(_ sender: Any) {
        self.mainModelView.ValidateDetails()
    }
    
    @IBAction func btnDOBClicked(_ sender: Any) {
        self.mainView.txtDOB.becomeFirstResponder()
    }
    
    @IBAction func btnSexClicked(_ sender: Any) {
        self.mainModelView.sexDropDown.show()
    }
    
    @IBAction func btnHeightClicked(_ sender: Any) {
        self.mainView.txtHeight.becomeFirstResponder()
    }
    
    @IBAction func btnWeightClicked(_ sender: Any) {
        self.mainView.txtWeight.becomeFirstResponder()
    }
    
    @IBAction func btnLocationClicked(_ sender: Any) {
        self.mainModelView.cpvInternal.showCountriesList(from: self)
    }
}

//MARK:- ImagePickerController
extension SignUpSetupProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let profilePic = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        if let picture = profilePic {
            let resizedPicture = picture.resizeImage(image: picture, targetSize: CGSize(width: 400.0, height: 400.0))
            if resizedPicture.jpegData(compressionQuality: 0.2)?.count ?? 5000000 < 5000000 {
                self.mainView.imgProfile.image = resizedPicture
                self.mainModelView.profileImage = resizedPicture
                self.mainModelView.isProfileSelected = true
                self.mainModelView.showNext()
            }
            else {
                makeToast(strMessage: "File size should be lower than 5 MB")
            }
        }
//        self.mainView.imgProfile.image = profilePic
//        self.mainModelView.profileImage = profilePic
//        self.mainModelView.isProfileSelected = true
//        self.mainModelView.showNext()
//        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
