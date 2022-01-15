//
//  LibraryExercisePreviewRecordsVC.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class LibraryExercisePreviewRecordsVC: UIViewController, UITextFieldDelegate {
    
    //MARK:- Variables
    lazy var mainView: LibraryExercisePreviewRecordsView = { [unowned self] in
        return self.view as! LibraryExercisePreviewRecordsView
        }()
    
    lazy var mainModelView: LibraryExercisePreviewRecordsViewModel = {
        return LibraryExercisePreviewRecordsViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.txtKG.setAsNumericKeyboard(delegate: self,isUseHyphen:false)
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        
        if self.mainView.txtKG.text?.toTrim() == "0" || self.mainView.txtKG.text?.toTrim() == "" || self.mainView.txtKG.text?.toTrim().count == 0{
            makeToast(strMessage: getCommonString(key: "Please_enter_valid_weight_key"))
            return
        }
        
        if self.mainModelView.list != nil {
            self.mainModelView.editCommonLibrary()
        }
        else {
            self.mainModelView.editLibrary()
        }
    }
    
    @IBAction func btnDropDownClicked(_ sender: Any) {
        self.mainView.txtRM.becomeFirstResponder()
    }
    
    
    //shoudChangeCharachterIn method not called so add textFieldDidChange method call
    // MARK: TextFeild Delegates
    /*
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
//        if txtAfterUpdate.count > 6 {
//            return false
//        }
        
        self.mainModelView.showBtnShow()
        return true
    }*/
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index: Int = self.mainModelView.selectedRM == 1 ? 0 : 9
        self.mainModelView.showBtnShow()
        self.AddExerciseFinish(tag: index, data: self.mainView.txtKG.text?.toTrim() ?? "0")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.mainView.txtKG{
            
            if self.mainView.txtKG.text == "0"{
                self.mainView.txtKG.text = ""
            }
        }
        
        return true
    }
    
}

extension LibraryExercisePreviewRecordsVC: NumericKeyboardDelegate {
    
    func numericKeyPressed(key: Int) {
        print("Numeric key \(key) pressed!")
    }
    
    func numericBackspacePressed() {
        print("Backspace pressed!")
    }
    
    func numericSymbolPressed(symbol: String) {
        print("Symbol \(symbol) pressed!")
    }
    
}
