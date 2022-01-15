//
//  ProfessionalRequirementVC.swift
//  Load
//
//  Created by Haresh Bhai on 02/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfessionalRequirementVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: ProfessionalRequirementView = { [unowned self] in
        return self.view as! ProfessionalRequirementView
    }()
    
    lazy var mainModelView: ProfessionalRequirementViewModel = {
        return ProfessionalRequirementViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI()
        self.mainModelView.setupUI()
        self.mainView.txtTextView.placeholder = self.mainModelView.placeholder
        self.mainView.txtTextView.delegate = self
        self.mainView.txtTextView.text = self.mainModelView.text
        self.countCharachter()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: self.mainModelView.navigationHeader)

        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(1002) {
            viewWithTag.removeFromSuperview()
        }

    }
    
    //MARK:- @IBAction
    func btnBackClicked() {
        self.navigationController?.popViewController(animated: true)
        self.mainModelView.delegate?.ProfessionalRequirementFinish(text: self.mainView.txtTextView.text.toTrim(), isScreen: self.mainModelView.isScreen)
    }
    
    func countCharachter(){
        
        if self.mainModelView.isScreen == 0 { // Requirement
            let newText = self.mainView.txtTextView.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
            let numberOfChars = newText.count
            self.mainView.lblCount.text = "\(numberOfChars) / 500"

        } else if self.mainModelView.isScreen == 1 { // profession
            
            let newText = self.mainView.txtTextView.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
            let numberOfChars = newText.count
            self.mainView.lblCount.text = "\(numberOfChars) / 80"

            
        } else if self.mainModelView.isScreen == 2 { // Introduction   // Word limit 300
            let newText = self.mainView.txtTextView.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
            let numberOfChars = newText.count
            self.mainView.lblCount.text = "\(numberOfChars) / 300"
            
        } else if self.mainModelView.isScreen == 3 { // About me   // Word limimt 140
            
            let newText = self.mainView.txtTextView.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
            let numberOfChars = newText.count
            self.mainView.lblCount.text = "\(numberOfChars) / 140"
        }
        
    }
}

//MARK:- TextView delegate

extension ProfessionalRequirementVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if self.mainModelView.isScreen == 0 { // Requirement
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
            let numberOfChars = newText.count
            
            if numberOfChars <= 500 {
                self.mainView.lblCount.text = "\(numberOfChars) / 500"
                return true
            } else {
                return false
            }
            
        } else if self.mainModelView.isScreen == 1 { // profession
            
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
            let numberOfChars = newText.count
            
            if numberOfChars <= 80 {
                self.mainView.lblCount.text = "\(numberOfChars) / 80"
                return true
            } else {
                return false
            }

        } else if self.mainModelView.isScreen == 2 { // Introduction   // Word limit 300
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
            let numberOfChars = newText.count
            
            if numberOfChars <= 300 {
                self.mainView.lblCount.text = "\(numberOfChars) / 300"
                return true
            } else {
                return false
            }
            
        } else if self.mainModelView.isScreen == 3 { // About me   // Word limimt 140
            
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text).replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
            let numberOfChars = newText.count
            
            if numberOfChars <= 140 {
                self.mainView.lblCount.text = "\(numberOfChars) / 140"
                return true
            } else {
                return false
            }
            
        }
        
        return true
    }
    
}

