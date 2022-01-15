//
//  CreateLoadCenterVC.swift
//  Load
//
//  Created by Haresh Bhai on 22/06/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CreateLoadCenterVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CreateLoadCenterView = { [unowned self] in
        return self.view as! CreateLoadCenterView
    }()
    
    lazy var mainModelView: CreateLoadCenterViewModel = {
        return CreateLoadCenterViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Load_Center_key"))
        self.navigationController?.setColor()
        self.mainView.setupUI()
        self.mainModelView.setupUI()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnRequstClicked(_ sender: Any) {
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateRequestStepOneVC") as! CreateRequestStepOneVC
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)
    }
    
    @IBAction func btnEventClicked(_ sender: Any) {
        let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "CreateEventStepOneVC") as! CreateEventStepOneVC
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)
    }
}
