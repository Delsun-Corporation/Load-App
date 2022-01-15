//
//  RaceTimeVC.swift
//  Load
//
//  Created by Haresh Bhai on 05/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class RaceTimeVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: RaceTimeView = { [unowned self] in
        return self.view as! RaceTimeView
        }()
    
    lazy var mainModelView: RaceTimeViewModel = {
        return RaceTimeViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()

        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Running_Time_key"))
        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }

    
    //MARK:- @IBAction
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.mainModelView.delegate?.RaceTimeFinish(raceDistanceId: self.mainModelView.raceDistanceId, raceTime: self.mainModelView.raceTime)
    }

    @IBAction func btnSelectDistanceClicked(_ sender: Any) {
        if self.mainView.txtDistance.text?.toTrim() == "" {
            let activity = GetAllData?.data?.raceDistance?.first
            self.mainView.txtDistance.text = activity?.name
            self.mainModelView.raceDistanceId = activity?.id?.stringValue ?? ""
        }
        self.mainView.txtDistance.becomeFirstResponder()
    }
    
    @IBAction func btnTimeClicked(_ sender: Any) {
        if self.mainView.txtTime.text?.toTrim() == "" {
            self.mainModelView.totalDays = "00"
            self.mainModelView.totalHrs =  "00"
            self.mainModelView.totalMins =  "00"
            self.mainView.txtTime.text = self.mainModelView.totalDays + ":" + self.mainModelView.totalHrs + ":" + self.mainModelView.totalMins
            self.mainModelView.raceTime = self.mainView.txtTime.text!
        }
        self.mainView.txtTime.becomeFirstResponder()
    }
}
