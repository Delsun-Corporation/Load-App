//
//  ProfessionalActivityVC.swift
//  Load
//
//  Created by Haresh Bhai on 03/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol EquipmenSelectedDelegate: class {
    func EquipmenSelectedDidFinish(ids:[Int], names:[String])
}

class EquipmentSelectionVC: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: EquipmentSelectionView = { [unowned self] in
        return self.view as! EquipmentSelectionView
        }()
    
    lazy var mainModelView: EquipmentSelectionViewModel = {
        return EquipmentSelectionViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Equipment_key"), color: .black)
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
    }
    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectClicked(_ sender: Any) {
        if self.mainModelView.selectedArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_equipment_key"))
        }       
        else {
            self.mainModelView.delegate?.EquipmenSelectedDidFinish(ids: self.mainModelView.selectedArray, names: self.mainModelView.selectedNameArray)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
