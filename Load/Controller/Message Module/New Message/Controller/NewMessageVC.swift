//
//  NewMessageVC.swift
//  Load
//
//  Created by Haresh Bhai on 27/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import VENTokenField
import IQKeyboardManagerSwift

protocol OpenMessagesDelegate: class {
    func OpenMessagesDidFinish()
}

class NewMessageVC: UIViewController, VENTokenFieldDelegate, VENTokenFieldDataSource, NewMessageSelectDelegate  {

    //MARK:- Variables
    lazy var mainView: NewMessageView = { [unowned self] in
        return self.view as! NewMessageView
    }()
    
    lazy var mainModelView: NewMessageViewModel = {
        return NewMessageViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setColor()
        self.mainView.setupUI(theController: self)
        setUpNavigationBarTitle(strTitle: getCommonString(key: "New_Message_key"))
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.placeholderColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.placeholderColor = UIColor.clear
    }
    
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnPlusClicked(_ sender: Any) {
        let obj: NewMessageSelectVC
            = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "NewMessageSelectVC") as! NewMessageSelectVC
        obj.mainModelView.delegate = self
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    // MARK: - VENTokenFieldDelegate    
    func tokenField(_ tokenField: VENTokenField, didChangeContentHeight height: CGFloat) {
        print(height + 10)
        self.mainView.viewHeight.constant = height + 10
    }
    
    func tokenField(_ tokenField: VENTokenField, didChangeText text: String?) {        
        if text?.toTrim() == "" {
            self.mainModelView.profileDetails = nil
            self.mainView.tableView.reloadData()
            self.mainView.tableView.isHidden = true
            return
        }
        self.mainView.tableView.isHidden = false
        self.mainModelView.apiCallMessagesUserList(search: (text?.toTrim() ?? ""), isLoading: false)
    }
    
//    func tokenField(_ tokenField: VENTokenField, didEnterText text: String) {
//        self.mainModelView.names.add(text)
//        self.mainView.txtName.reloadData()
//    }

    func tokenField(_ tokenField: VENTokenField, didDeleteTokenAt index: UInt) {
        self.mainModelView.names.removeObject(at: Int(index))
        self.mainModelView.ids.removeObject(at: Int(index))
        self.mainView.txtName.reloadData()        
    }
    
    func tokenField(_ tokenField: VENTokenField, titleForTokenAt index: UInt) -> String {
        return self.mainModelView.names[Int(index)] as! String
    }
    
    func numberOfTokens(in tokenField: VENTokenField) -> UInt {
        return UInt(self.mainModelView.names.count)
    }
    
    func tokenFieldCollapsedText(_ tokenField: VENTokenField) -> String {
        return "\(self.mainModelView.names.count) people"
    }
    
    func NewMessageSelectDidFinish(name: String, id: String) {
        if !self.mainModelView.ids.contains(id) {
            self.mainModelView.names.add(name)
            self.mainModelView.ids.add(id)
        }
        self.mainView.txtName.reloadData()
        self.mainModelView.profileDetails = nil
        self.mainView.tableView.reloadData()
        self.mainView.tableView.isHidden = true
    }
    
    @IBAction func btnSendClicked(_ sender: Any) {
        if self.mainModelView.ids.count == 0 {
            makeToast(strMessage: "Please select user")
        }
        else if self.mainView.txtMessage.text?.toTrim() == "" {
            makeToast(strMessage: "Please enter message")
        }
        else {
            SocketIOHandler.shared.sendMultipleUser(message: (self.mainView.txtMessage.text?.toTrim() ?? ""), to_ids: self.mainModelView.ids)
            
            self.mainView.txtMessage.text = ""
//            if self.mainModelView.ids.count != 1 {
                self.dismiss(animated: false, completion: nil)
            self.mainModelView.delegate?.OpenMessagesDidFinish()
//            }
        }
    }
}
