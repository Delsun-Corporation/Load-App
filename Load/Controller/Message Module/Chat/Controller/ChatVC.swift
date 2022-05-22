//
//  ChatVC.swift
//  Load
//
//  Created by Haresh Bhai on 29/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

var CHAT_CONVERSATION_ID:String = ""
var IS_CHAT_SCREEN:Bool = false

class ChatVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: ChatView = { [unowned self] in
        return self.view as! ChatView
    }()
    
    lazy var mainModelView: ChatViewModel = {
        return ChatViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.navigationController?.setColor()
        IS_CHAT_SCREEN = true
        self.mainView.setupUI(theController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainModelView.setupUI()
        IQKeyboardManager.shared.enable = false        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.placeholderColor = UIColor.clear
        CHAT_CONVERSATION_ID = ""
        IS_CHAT_SCREEN = false
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendClicked(_ sender: Any) {
        if self.mainView.txtMessage.text?.toTrim() == "" {
            makeToast(strMessage: "Please enter message")
        }
        else {
            let id = getUserDetail()?.data?.user?.id
            let toID = self.mainModelView.chatDetails?.fromId == id ? self.mainModelView.chatDetails?.toId : self.mainModelView.chatDetails?.fromId
            
            SocketIOHandler.shared.sendMessage(conversationId: self.mainModelView.conversationId, message: (self.mainView.txtMessage.text?.toTrim() ?? ""), toId: toID?.stringValue ?? "")
            self.mainView.txtMessage.text = ""
        }
    }
}
