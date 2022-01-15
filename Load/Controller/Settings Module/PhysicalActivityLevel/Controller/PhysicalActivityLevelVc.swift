//
//  PhysicalActivityLevelVc.swift
//  Load
//
//  Created by iMac on 18/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class PhysicalActivityLevelVc: UIViewController {

    //MARK:- Variables
    lazy var mainView: PhysicalActivityLevelView = { [unowned self] in
        return self.view as! PhysicalActivityLevelView
        }()
    
    lazy var mainModelView: PhysicalActivityLevelViewModel = {
        return PhysicalActivityLevelViewModel(theController: self)
    }()

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Physical_Activity_Level_key"))
        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    func moveToPhysicalActivityInfo() {
        
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "PhysicalActivityInfoVc") as! PhysicalActivityInfoVc
        obj.mainModelView.profileDetails = self.mainModelView.profileDetails
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overCurrentContext
        self.present(nav, animated: true, completion: nil)
        
    }

}
