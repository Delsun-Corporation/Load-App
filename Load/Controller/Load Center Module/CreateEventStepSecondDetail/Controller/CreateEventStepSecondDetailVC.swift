//
//  CreateEventStepSecondDetailVC.swift
//  Load
//
//  Created by Haresh Bhai on 25/12/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateEventStepSecondDetailVC: UIViewController, UITextViewDelegate {

    //MARK:- Variables
    lazy var mainView: CreateEventStepSecondDetailView = { [unowned self] in
        return self.view as! CreateEventStepSecondDetailView
        }()
    
    lazy var mainModelView: CreateEventStepSecondDetailViewModel = {
        return CreateEventStepSecondDetailViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewWithTag = self.navigationController!.view.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        self.mainModelView.validateDetails()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.mainModelView.txtDescription = newText
        return true
    }
}
