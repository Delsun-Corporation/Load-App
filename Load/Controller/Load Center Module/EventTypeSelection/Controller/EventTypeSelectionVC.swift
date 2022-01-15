//
//  FilterSpecializationVC.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol EventTypeSelectedDelegate: class {
    func EventTypeSelectedDidFinish(ids:[Int], names:[String])
}

class EventTypeSelectionVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: EventTypeSelectionView = { [unowned self] in
        return self.view as! EventTypeSelectionView
    }()
    
    lazy var mainModelView: EventTypeSelectionViewModel = {
        return EventTypeSelectionViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Event_Type_key"), color: .black)
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
    }

    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSelectClicked(_ sender: Any) {
        if self.mainModelView.selectedArray.count == 0 {
            makeToast(strMessage: getCommonString(key: "Please_select_event_type_key"))
        }
        else {
            self.mainModelView.delegate?.EventTypeSelectedDidFinish(ids: self.mainModelView.selectedArray, names: self.mainModelView.selectedNameArray)
            self.dismiss(animated: true, completion: nil)
        }        
    }
}
