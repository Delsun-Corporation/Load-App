//
//  EmergencyVC.swift
//  Load
//
//  Created by iMac on 08/01/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class EmergencyVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var btnSave: UIButton!
    
    //MARK:- Variables
    lazy var mainView: EmergencyView = { [unowned self] in
        return self.view as! EmergencyView
    }()
    
    lazy var mainModelView: EmergencyViewModel = {
        return EmergencyViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.btnSave.isHidden = true
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Emergency_key"), color:UIColor.black)
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        self.view.endEditing(true)
        self.btnSave.isHidden = true
        if self.mainView.txtContact1.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_contact_key"))
        }
        else if self.mainView.txtContact1.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_contact_key"))
        }
        else {
            self.mainModelView.apiCallSaveEmergencyContactDetails(contact1: self.mainView.txtContact1.text?.toTrim() ?? "", contact2: self.mainView.txtContact2.text?.toTrim() ?? "")
        }
    }
    
    //MARK: - TextField Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //           let textFieldText: NSString = (textField.text ?? "") as NSString
        //           let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        //           print(txtAfterUpdate)
        self.btnSave.isHidden = false
        return true
    }
}
