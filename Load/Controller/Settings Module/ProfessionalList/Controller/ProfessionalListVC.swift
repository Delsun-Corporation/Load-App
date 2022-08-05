//
//  ProfessionalListVC.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class ProfessionalListVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: ProfessionalListView = { [unowned self] in
        return self.view as! ProfessionalListView
    }()
    
    lazy var mainModelView: ProfessionalListViewModel = {
        return ProfessionalListViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBarTitle(strTitle: self.mainModelView.navHeader, color: UIColor.black)
        self.navigationController?.setWhiteColor()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked() {
        self.navigationController?.popViewController(animated: true)
        if self.mainModelView.selectedId != 0 {
            self.mainModelView.delegate?.ProfessionalListFinish(id: self.mainModelView.selectedId, title: self.mainModelView.selectedTitle, isScreenFor: self.mainModelView.isScreenFor)
        }
    }
}
