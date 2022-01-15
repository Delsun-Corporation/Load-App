//
//  ScheduleManagmentVc.swift
//  Load
//
//  Created by Yash on 14/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class ScheduleManagmentVc: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: ScheduleManagementView = { [unowned self] in
        return self.view as! ScheduleManagementView
    }()
    
    lazy var mainModelView: ScheduleManagementViewModel = {
        return ScheduleManagementViewModel(theController: self)
    }()


    var tableHeight: CGFloat = 0.0

    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.mainView.setupUI()
        
        self.mainView.tblAdvacneBooking.delegate = self
        self.mainView.tblAdvacneBooking.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
                
        self.mainView.tblAdvacneBooking.addObserver(self, forKeyPath: "contentSize", options: [.new], context: nil)

        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Schedule_management_key"))
        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.mainView.tblAdvacneBooking.removeObserver(self, forKeyPath: "contentSize")

        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    //MARK:- Overide Method
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is UITableView {
            self.tableHeight = self.mainView.tblAdvacneBooking.contentSize.height
        }
    }

    
    //MARK: - IBAction method
    
    @IBAction func btnAdvanceBookingTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.mainView.ConstraintHeightTblAdvance.constant = self.tableHeight
                self.mainView.tblAdvacneBooking.reloadData()
                self.mainView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            
            for i in 0..<self.mainModelView.array.count {
                self.mainModelView.array[i]["selected"].intValue = 0
            }

            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                self.mainView.ConstraintHeightTblAdvance.constant = 0
                self.mainView.layoutIfNeeded()
            }, completion: nil)
        }
        
    }
    
    @IBAction func btnAutoAcceptTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

    }
}
