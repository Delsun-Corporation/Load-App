//
//  AddExerciseFinishVC.swift
//  Load
//
//  Created by Haresh Bhai on 13/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class AddExerciseFinishVC: UIViewController, UITextFieldDelegate {

    //MARK:- Variables
    lazy var mainView: AddExerciseFinishView = { [unowned self] in
        return self.view as! AddExerciseFinishView
    }()
    
    lazy var mainModelView: AddExerciseFinishViewModel = {
        return AddExerciseFinishViewModel(theController: self)
    }()
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarTitle(strTitle: "Add Exercise")
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        
        print("Exercise link:\(self.mainModelView.exerciseLink)")
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainView.txtKG.setAsNumericKeyboard(delegate: self,isUseHyphen:false)
    }
    
    // MARK: @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }    
    
    @IBAction func btnDropDownClicked(_ sender: Any) {
//        self.mainModelView.isOpen = !self.mainModelView.isOpen
//        self.mainView.tableView.isHidden = !self.mainModelView.isOpen
        self.mainView.txtRM.becomeFirstResponder()
    }
    
    @IBAction func btnAddClicked(_ sender: Any) {
        self.mainModelView.ValidateDetails()
    }
    
    // MARK: TextFeild Delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        
        if txtAfterUpdate.count > 6 {
            return false
        }
//        let index: Int = self.mainModelView.selectedRM == 1 ? 0 : 9
//        var value = txtAfterUpdate == "" ? "0" : txtAfterUpdate
//        if value.last == "." {
//            value.removeLast()
//        }
//        if self.mainModelView.RepetitionMax.count != 0 {
//            self.mainModelView.RepetitionMax[index].estWeight = NSNumber(value: Int(value) ?? 0)
//            self.mainView.tableView.reloadData()
//        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index: Int = self.mainModelView.selectedRM == 1 ? 0 : 9
        self.AddExerciseFinish(tag: index, data: self.mainView.txtKG.text?.toTrim() ?? "0")
    }
}

extension AddExerciseFinishVC: NumericKeyboardDelegate {
    
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
