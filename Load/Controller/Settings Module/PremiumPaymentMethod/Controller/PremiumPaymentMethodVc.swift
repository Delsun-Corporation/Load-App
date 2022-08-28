//
//  PremiumPaymentMethodVc.swift
//  Load
//
//  Created by Yash on 03/06/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class PremiumPaymentMethodVc: UIViewController {
    
    //MARK:- Variables
    lazy var mainView: PremiumPaymentMethodView = { [unowned self] in
        return self.view as! PremiumPaymentMethodView
    }()
    
    lazy var mainModelView: PremiumPaymentMethodViewModel = {
        return PremiumPaymentMethodViewModel(theController: self)
    }()
    
    //MARK:- View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.setupUI()
        self.mainModelView.setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNavigationBarTitle(strTitle: getCommonString(key: "Payment_Method_key"), color: UIColor.black)
        self.navigationController?.setWhiteColor()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.mainModelView.setupUI), name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_UPDATE_ADDED_BANK_CARD_RELOAD.rawValue), object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(NOTIFICATION_CENTER_LIST.LOAD_UPDATE_ADDED_BANK_CARD_RELOAD.rawValue), object: nil)

    }
    
    @IBAction func btnBackAction() {
        mainModelView.updateDefaultPaymentMethod()
    }
    
    @IBAction func btnAddCardTapped(_ sender: UIButton) {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "BillingInformationVC") as! BillingInformationVC
        obj.mainModelView.delegate = self
        obj.mainModelView.premiumPaymentMethodDelegate = mainModelView
        obj.mainModelView.accessToken = self.mainModelView.accessToken
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    @IBAction func btnTopUpTapped(_ sender: UIButton) {
        let obj = AppStoryboard.Settings.instance.instantiateViewController(withIdentifier: "TopUpPaymentPopUpVc") as! TopUpPaymentPopUpVc
        obj.modalPresentationStyle = .overFullScreen
        obj.modalTransitionStyle = .crossDissolve
        self.present(obj, animated: true, completion: nil)
    }
    
}

//MARK:- Billing delegate method

extension PremiumPaymentMethodVc: BillingInformationVCDelegate {
  
    func BillingInformationReload(isUpdated: Bool) {
        if isUpdated {
            //Hidden not needed  herer
//            if self.theController.btnSave.isHidden {
//                self.apiCallGetSettingPrimium(isLoading: false)
//            }
        }
    }
    
}
