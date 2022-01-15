//
//  FilterVC.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: FilterView = { [unowned self] in
        return self.view as! FilterView
    }()
    
    lazy var mainModelView: FilterViewModel = {
        return FilterViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Load_Center_key"), color: .black)
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
    }
    
    //MARK:- @IBActionIBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_FILTER_NOTIFICATION.rawValue), object: nil)
    }
    
    @IBAction func btnClearAllClicked(_ sender: Any) {
        let alertController = UIAlertController(title: getCommonString(key: "Load_key"), message: getCommonString(key: "Are_you_sure_want_to_clear_key"), preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: getCommonString(key: "Yes_key"), style: UIAlertAction.Style.default) { (result : UIAlertAction) -> Void in
            self.mainModelView.filterSpecialization = ""
            self.mainModelView.selectedArray.removeAll()
            self.mainModelView.selectedNameArray.removeAll()
            self.mainModelView.isFilterClear = true
            
            self.mainModelView.LocationName = nil
            self.mainModelView.Location = nil
            self.mainModelView.LanguageName = nil
            self.mainModelView.Language = nil
            self.mainModelView.Gender = nil
            self.mainModelView.ServiceName = nil
            self.mainModelView.Service = nil
            self.mainModelView.Rating = 0
            self.mainModelView.YOEStart = nil
            self.mainModelView.YOEEnd = nil
            self.mainModelView.RateStart = nil
            self.mainModelView.RateEnd = nil
            FILTER_MODEL = nil
            self.mainView.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: getCommonString(key: "No_key"), style: UIAlertAction.Style.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func btnApplyClicked(_ sender: Any) {
        let model = FilterModelClass()
        model.LocationName = self.mainModelView.LocationName
        model.Location = self.mainModelView.Location
        model.LanguageName = self.mainModelView.LanguageName
        model.Language = self.mainModelView.Language
        model.Gender = self.mainModelView.Gender
        model.Specialization = self.mainModelView.selectedArray
        model.SpecializationNameArray = self.mainModelView.selectedNameArray
        model.ServiceName = self.mainModelView.ServiceName
        model.Service = self.mainModelView.Service
        model.Rating = self.mainModelView.Rating
        model.YOEStart = self.mainModelView.YOEStart
        model.YOEEnd = self.mainModelView.YOEEnd
        model.RateStart = self.mainModelView.RateStart
        model.RateEnd = self.mainModelView.RateEnd
        
        FILTER_MODEL = model
        
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.LOAD_CENTER_FILTER_NOTIFICATION.rawValue), object: nil)
    }
}
