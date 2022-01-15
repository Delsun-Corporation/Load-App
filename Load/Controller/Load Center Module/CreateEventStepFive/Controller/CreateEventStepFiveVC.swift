//
//  CreateEventStepFiveVC.swift
//  Load
//
//  Created by Haresh Bhai on 19/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventStepFiveVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CreateEventStepFiveView = { [unowned self] in
        return self.view as! CreateEventStepFiveView
    }()
    
    lazy var mainModelView: CreateEventStepFiveViewModel = {
        return CreateEventStepFiveViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        self.mainModelView.setupUI()
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnUploadClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
//        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateEventFinishVC") as! CreateEventFinishVC
//        self.navigationController?.pushViewController(obj, animated: true)
    }
}


extension CreateEventStepFiveVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        let selectedImage = info[UIImagePickerController.InfoKey.originalImage]
        self.mainModelView.images = (selectedImage as! UIImage)
        self.mainView.imgPicture.image = selectedImage as? UIImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
