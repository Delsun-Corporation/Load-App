//
//  PremiumVC.swift
//  Load
//
//  Created by Haresh Bhai on 05/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class PremiumVC: UIViewController {

    //MARK:- @IBOutlet
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK:- Variables
    lazy var mainView: PremiumView = { [unowned self] in
        return self.view as! PremiumView
        }()
    
    lazy var mainModelView: PremiumViewModel = {
        return PremiumViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.btnSave.isHidden = true
        
        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
    }   
    
    

    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Premium_key"), color:UIColor.black)
        self.navigationController?.setWhiteColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }

    //MARK:- @IBAction
    
    func removeHeaderWhilePresent(){
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.mainModelView.updatePremium()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        let _ = self.mainModelView.validateDetails()
    }
}
