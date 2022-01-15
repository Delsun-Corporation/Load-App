//
//  SavedWorkoutVC.swift
//  Load
//
//  Created by Haresh Bhai on 10/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class SavedWorkoutVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: SavedWorkoutView = { [unowned self] in
        return self.view as! SavedWorkoutView
    }()
    
    lazy var mainModelView: SavedWorkoutViewModel = {
        return SavedWorkoutViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.setWhiteColor()
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Saved_Workout_key"), color:UIColor.black)
        IS_CHAT_SCREEN = true
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func btnPlusClicked(_ sender: Any) {
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.HIDE_NAV_SAVEDWORKOUT_NOTIFICATION.rawValue), object: nil)
////        self.dismiss(animated: false, completion: {
////        })
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_CENTER_LIST.OPEN_SAVEDWORKOUT_NOTIFICATION.rawValue), object: nil)
        
        let obj = AppStoryboard.Calendar.instance.instantiateViewController(withIdentifier: "CreateTrainingLogVC") as! CreateTrainingLogVC
        let nav = UINavigationController(rootViewController: obj)
        nav.modalPresentationStyle = .overFullScreen
        self.present(nav, animated: false, completion: {          
        })
    }
}
