//
//  RegionSelectionVC.swift
//  Load
//
//  Created by Haresh Bhai on 26/11/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol TypesOfTrainingSelectedDelegate: class {
    func TypesOfTrainingSelectedDidFinish(ids:[Int], names:[String])
}

class TypesOfTrainingSelectionVC: UIViewController {
    
    @IBOutlet weak var btnSelect: UIButton!
    
    //MARK:- Variables
    lazy var mainView: TypesOfTrainingSelectionView = { [unowned self] in
        return self.view as! TypesOfTrainingSelectionView
        }()
    
    lazy var mainModelView: TypesOfTrainingSelectionViewModel = {
        return TypesOfTrainingSelectionViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSelect.setTitle(str: getCommonString(key: "Save_key"))
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Types_of_training_provide_key"), color: .black)
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
    }
    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) { 
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectClicked(_ sender: Any) {
        if self.mainModelView.selectedArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_types_of_training_key"))
        }
        else if self.mainModelView.selectedArray.count != 1 {
            makeToast(strMessage: getCommonString(key: "You_need_selected_maximum_1_training_key"))
        }
        else {
            self.mainModelView.delegate?.TypesOfTrainingSelectedDidFinish(ids: self.mainModelView.selectedArray, names: self.mainModelView.selectedNameArray)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

