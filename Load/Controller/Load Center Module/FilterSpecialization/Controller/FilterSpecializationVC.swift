//
//  FilterSpecializationVC.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol FilterSpecializationSelectedDelegate: class {
    func FilterSpecializationSelectedDidFinish(ids:[Int], names:[String])
}

class FilterSpecializationVC: UIViewController {

    @IBOutlet weak var btnSelect: UIButton!
    
    //MARK:- Variables
    lazy var mainView: FilterSpecializationView = { [unowned self] in
        return self.view as! FilterSpecializationView
    }()
    
    lazy var mainModelView: FilterSpecializationViewModel = {
        return FilterSpecializationViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.mainModelView.isHideheader {
            setUpNavigationBarTitle(strTitle: getCommonString(key: "Specialization_key"), color: .black)
            self.btnSelect.setTitle(str: getCommonString(key: "Save_key"))
        }
        else {
            setUpNavigationBarTitle(strTitle: getCommonString(key: "Filters_key"), color: .black)
        }
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
    }

    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectClicked(_ sender: Any) {
        if self.mainModelView.selectedArray.count < 3 && !self.mainModelView.isHideheader {
            makeToast(strMessage: getCommonString(key: "Please_select_minimum_3_categories_key"))
        }
        else if self.mainModelView.selectedArray.count == 0 && self.mainModelView.isHideheader {
            makeToast(strMessage: getCommonString(key: "Please_select_at_least_one_specialization_key"))
        }
        else {
            self.mainModelView.delegate?.FilterSpecializationSelectedDidFinish(ids: self.mainModelView.selectedArray, names: self.mainModelView.selectedNameArray)
            self.dismiss(animated: true, completion: nil)
        }        
    }
}
