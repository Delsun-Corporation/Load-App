//
//  ProfessionalActivityVC.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol FilterActivitySelectedDelegate: class {
    func FilterActivitySelectedDidFinish(ids:[Int], names:[String])
    func FilterActivityClose()
}

class ProfessionalActivityVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: ProfessionalActivityView = { [unowned self] in
        return self.view as! ProfessionalActivityView
        }()
    
    lazy var mainModelView: ProfessionalActivityViewModel = {
        return ProfessionalActivityViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI(theController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Activites_key"))
        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(1002) {
            viewWithTag.removeFromSuperview()
        }

    }
    
    private func saveData() {
        if self.mainModelView.selectedArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_categories_key"))
        }
        else if self.mainModelView.selectedArray.count > 3 {
            makeToast(strMessage: getCommonString(key: "Please_select_maximum_3_categories_key"))
        }
        else {
            self.mainModelView.delegate?.FilterActivitySelectedDidFinish(ids: self.mainModelView.selectedArray, names: self.mainModelView.selectedNameArray)
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    //MARK:- @IBAction
    func btnCloseClicked() {
        if mainView.isViewValid {
            saveData()
        }
    }
    
    func btnSelectClicked() {
        // Hidden in ticket LOAD-29
    }
}
