//
//  BillingInformationVC.swift
//  Load
//
//  Created by Haresh Bhai on 11/09/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class BillingInformationVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: BillingInformationView = { [unowned self] in
        return self.view as! BillingInformationView
        }()
    
    lazy var mainModelView: BillingInformationViewModel = {
        return BillingInformationViewModel(theController: self)
    }()
    
    //MARK:- ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainModelView.setupUI()
        self.mainView.setupUI(theController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.mainModelView.setupNavigationbar(title: getCommonString(key: "Billing_information_key"))
        self.navigationController?.setWhiteColor()
        self.navigationController?.addShadow()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let viewWithTag = self.navigationController!.view.viewWithTag(102) {
            viewWithTag.removeFromSuperview()
        }
    }

}

//MARK:- IBAction method

extension BillingInformationVC {
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.mainModelView.delegate?.BillingInformationReload(isUpdated: self.mainModelView.isUpdated)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        guard self.mainModelView.validateDetails() else {
            return
        }
        
        mainModelView.saveCard()
    }
    
}

//MARK:- Other functions
extension BillingInformationVC {
}

//MARK:- Table scroll delegate method

extension BillingInformationVC : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height + 176  <= mainView.safeAreaHeight{
            return
        }
        
        if self.mainView.tableView.panGestureRecognizer.translation(in: scrollView).y > 0{

            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
                
                self.mainView.vwBottom.alpha = 0.0
                self.mainView.vwBottom.isUserInteractionEnabled = false
                
                self.mainView.layoutIfNeeded()

            }, completion: nil)
            
        }
        else{
            
            if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            }else{
                
                if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
                    scrollEndMethod()
                }

            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        scrollEndMethod()
    }
    
    func scrollEndMethod(){
        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            
            self.mainView.vwBottom.alpha = 1.0
            self.mainView.vwBottom.isUserInteractionEnabled = true
            
            self.mainView.layoutIfNeeded()
        }, completion: nil)

    }
    
}
