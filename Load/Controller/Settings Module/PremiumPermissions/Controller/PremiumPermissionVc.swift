//
//  PremiumPermissionVc.swift
//  Load
//
//  Created by Yash on 13/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class PremiumPermissionVc: UIViewController {

    
    //MARK:- Variables
    lazy var mainView: PremiumPermissionView = { [unowned self] in
        return self.view as! PremiumPermissionView
        }()
    
    lazy var mainModelView: PremiumPermissionViewModel = {
        return PremiumPermissionViewModel(theController: self)
    }()

    var arrayViewProfile = ["Public","Followers","Private"]
    var arrayViewFeeds = ["Public","Followers","Private"]
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainModelView.setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBarTitle(strTitle: self.mainModelView.navigationHeader, color: UIColor.black)
        self.navigationController?.setWhiteColor()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(1002) {
            viewWithTag.removeFromSuperview()
        }

    }
    
}

//MARK:- IBAction method
extension PremiumPermissionVc {
    
    @IBAction func btnBackClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSwitchSessionFeed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func btnPremiumProfileViewTapped(_ sender: UIButton) {
        
        let index = self.arrayViewProfile.firstIndex(of: self.mainModelView.selectedViewMyProfile) ?? 0
        self.mainModelView.pickerViewPremiumProfile.selectRow(index, inComponent: 0, animated: false)
        self.mainView.txtPremiumProfileAnswer.becomeFirstResponder()
    }
    
    @IBAction func btnFeedViewTapped(_ sender: UIButton) {
        
        let index = self.arrayViewFeeds.firstIndex(of: self.mainModelView.selectedViewMyFeed) ?? 0
        self.mainModelView.pickerViewMyFeed.selectRow(index, inComponent: 0, animated: false)
        self.mainView.txtFeedViewAnswer.becomeFirstResponder()
    }
    
    func passData(){
        self.mainModelView.delegatePermission?.selectedPermissionForPremium(viewMyProfile: self.mainView.txtPremiumProfileAnswer.text ?? "", viewMyFeed: self.mainView.txtFeedViewAnswer.text ?? "")
    }
    
}
