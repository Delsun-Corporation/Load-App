//
//  SendAvailibityVC.swift
//  Load
//
//  Created by Haresh Bhai on 27/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SendAvailibityVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: SendAvailibityView = { [unowned self] in
        return self.view as! SendAvailibityView
    }()
    
    lazy var mainModelView: SendAvailibityViewModel = {
        return SendAvailibityViewModel(theController: self)
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
    
    @IBAction func btnSendClicked(_ sender: Any) {
        if self.mainView.txtNotes.text.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_notes_key"))
        }
        else {
            let date: Date = convertDate(self.mainModelView.txtDate, dateFormat: "yyyy-MM-dd")
            let isoDate = date.iso8601
            self.mainModelView.apiCallStoreRequestToMakeClient(toId: Int(self.mainModelView.userId)!, selectedDate: isoDate, availableTimeId: Int(self.mainModelView.txtTimeId)!, notes: self.mainView.txtNotes.text.toTrim(), confirmedStatus: 0)
        }
    }    
}
