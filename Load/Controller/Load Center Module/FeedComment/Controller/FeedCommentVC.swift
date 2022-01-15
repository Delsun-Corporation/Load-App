//
//  FeedCommentVC.swift
//  Load
//
//  Created by Haresh Bhai on 21/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class FeedCommentVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: FeedCommentView = { [unowned self] in
        return self.view as! FeedCommentView
    }()
    
    lazy var mainModelView: FeedCommentViewModel = {
        return FeedCommentViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.setWhiteColor()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
        
        self.navigationItem.rightBarButtonItem?.customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
       // IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.placeholderColor = UIColor.clear
       // IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    //MARK:- @IBAction
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendClicked(_ sender: Any) {
        if self.mainView.txtComment.text?.toTrim() == "" {
            makeToast(strMessage: getCommonString(key: "Please_enter_comment_key"))
        }
        else {
            self.mainModelView.apiCallCreateComment(feedId: self.mainModelView.feedId, userId: (getUserDetail().data?.user?.id?.stringValue)!, comment: self.mainView.txtComment.text!.toTrim(), isLoading: false)
            self.mainView.txtComment.text = ""
        }
    }
    
    @IBAction func btnReportFlagTapped(_ sender: UIButton) {
        
    }
}

//MARK: - TextField Delegate

extension FeedCommentVC:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == mainView.txtReportFlag{
            self.mainModelView.reportPickerView.selectRow(0, inComponent: 0, animated: false)
            IQKeyboardManager.shared.enableAutoToolbar = true
            IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
            textField.placeholder = getCommonString(key: "Choose_reason_for_reporting_this_post_key")
            IQKeyboardManager.shared.placeholderColor = UIColor.black
            
        }else{
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == mainView.txtReportFlag{
            textField.placeholder = ""
            self.mainModelView.apiCallForReport(feedId: self.mainModelView.feedId, feed_report_id: self.mainModelView.feedReportId, isLoading: false)
        }

    }

}
