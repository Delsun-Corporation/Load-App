//
//  CheckAvailibityVC.swift
//  Load
//
//  Created by Haresh Bhai on 23/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class CheckAvailibityVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: CheckAvailibityView = { [unowned self] in
        return self.view as! CheckAvailibityView
    }()
    
    lazy var mainModelView: CheckAvailibityViewModel = {
        return CheckAvailibityViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: self.mainModelView.profileDetails?.userDetail?.name ?? "", type: "Sport physiologist", image: self.mainModelView.profileDetails?.userDetail?.photo ?? "")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(1000) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectDateClicked(_ sender: Any) {
        if self.mainModelView.selectedTime == "" {
            makeToast(strMessage: getCommonString(key: "Please_select_date_key"))
        }
        else {
            let obj = AppStoryboard.LoadCenter.instance.instantiateViewController(withIdentifier: "SendAvailibityVC") as! SendAvailibityVC
            obj.mainModelView.profileDetails = self.mainModelView.profileDetails
            obj.mainModelView.userId = self.mainModelView.profileDetails?.id?.stringValue ?? "0"
            obj.mainModelView.txtDate = self.mainModelView.expandedDate
            obj.mainModelView.txtTime = self.mainModelView.selectedTime
            obj.mainModelView.txtTimeId = self.mainModelView.selectedTimeId
            self.navigationController?.pushViewController(obj, animated: true)
        }
    }
}
