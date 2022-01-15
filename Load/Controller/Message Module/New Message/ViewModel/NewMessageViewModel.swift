//
//  NewMessageViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 27/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON  

class NewMessageViewModel {

    //MARK:- Variables
    fileprivate weak var theController:NewMessageVC!
    var names: NSMutableArray = NSMutableArray()
    var ids: NSMutableArray = NSMutableArray()
    var delegate: OpenMessagesDelegate?
    var profileDetails:MessageUserList?
    var isKeyboardOpen = false
    var tableviewTxtviewisClicked = false

    init(theController:NewMessageVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.setupKeyboard()
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func apiCallMessagesUserList(search:String = "", isLoading:Bool = true) {
        let param = ["is_current_user": false, "is_except_current_user": true, "search": search, "list": ["id", "name", "photo"]] as [String : Any]
        print(param)
        
        ApiManager.shared.MakePostAPI(name: USER_LIST , params: param as [String : Any], progress: isLoading, vc: self.theController, isAuth: false, completionHandler: { (response, error) in
            if response != nil {
                let json = JSON(response!)
                print(json)
                let success = json.getBool(key: .success)
                if success {
                    let data = json.getDictionary(key: .data)
                    self.profileDetails = MessageUserList(JSON: data.dictionaryObject!)
                    let view = (self.theController.view as? NewMessageView)
                    view?.tableView.reloadData()
                }
                else {
                    self.profileDetails = nil
                    let view = (self.theController.view as? NewMessageView)
                    view?.tableView.reloadData()
                }
            }
        })
    }
}

extension NewMessageViewModel {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        let view = (self.theController.view as? NewMessageView)
        // Do something here
        if let keyboardRectValue = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            let keyboardHeight = keyboardRectValue.height
            isKeyboardOpen = true
            if tableviewTxtviewisClicked {
                view!.tableView.contentInset.bottom = keyboardHeight
                return
            }
            UIView.animate(withDuration: 1.5, animations: {
                var bottomPadding: CGFloat = 0.0
                if #available(iOS 11.0, *) {
                    let window = UIApplication.shared.keyWindow
                    bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
                }
                view?.constantBottomofView.constant = keyboardHeight - bottomPadding
            }, completion: { (status) in
//                self.scrollToBottom()
            })
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let view = (self.theController.view as? NewMessageView)
        isKeyboardOpen = false
        if tableviewTxtviewisClicked {
            tableviewTxtviewisClicked = false
            view!.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return
        }
        UIView.animate(withDuration: 1.5, animations: {
            view?.constantBottomofView.constant = 0.0
            view!.layoutIfNeeded()
        }, completion: nil)
    }
}
