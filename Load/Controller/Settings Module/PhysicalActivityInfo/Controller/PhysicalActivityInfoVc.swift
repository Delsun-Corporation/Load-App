//
//  PhysicalActivityInfoVc.swift
//  Load
//
//  Created by Yash on 09/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class PhysicalActivityInfoVc: UIViewController {

    //MARK:- Variables
    lazy var mainView: PhysicalActivityInfoView = { [unowned self] in
        return self.view as! PhysicalActivityInfoView
    }()
    
    lazy var mainModelView: PhysicalActivityInfoViewModel = {
        return PhysicalActivityInfoViewModel(theController: self)
    }()

    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.setupUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.addShadow()
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Information_Guide_key"))
        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }
    
}

//MARK: - IBAction
extension PhysicalActivityInfoVc {
}
