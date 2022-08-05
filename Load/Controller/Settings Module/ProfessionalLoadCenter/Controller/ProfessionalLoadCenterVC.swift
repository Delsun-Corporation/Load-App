//
//  ProfessionalLoadCenterVC.swift
//  Load
//
//  Created by Haresh Bhai on 31/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfessionalLoadCenterVC: UIViewController {

    //MARK:- @IBOutlet
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK:- Variables
    lazy var mainView: ProfessionalLoadCenterView = { [unowned self] in
        return self.view as! ProfessionalLoadCenterView
    }()
    
    lazy var mainModelView: ProfessionalLoadCenterViewModel = {
        return ProfessionalLoadCenterViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.btnSave.isHidden = true
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Professional_key"), color:UIColor.black)
        self.navigationController?.setWhiteColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }

    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        mainModelView.saveDetails()
        self.navigationController?.popViewController(animated: true)
    }   
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        self.mainModelView.saveDetails()
    }
}
