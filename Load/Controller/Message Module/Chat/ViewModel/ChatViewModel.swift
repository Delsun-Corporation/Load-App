
//
//  ChatViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 29/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import SwiftyJSON
import KRPullLoader

class ChatViewModel: KRPullLoadViewDelegate {

    //MARK:- Variables
    fileprivate weak var theController:ChatVC!
    var isKeyboardOpen = false
    var tableviewTxtviewisClicked = false
    var conversationId:String = ""
    var responseArray: [MessageListData] = [MessageListData]()
    var chatDetails: ConversationData?
    var isFirstTime : Bool = true
    let refreshView = KRPullLoadView()
    var isClientRequest : Bool = false

    init(theController:ChatVC) {
        self.theController = theController
    }
    
    func setupUI() {
        self.setupKeyboard()
        refreshView.delegate = self
        let view = (self.theController.view as? ChatView)
        view?.tableView.addPullLoadableView(refreshView, type: .refresh)
    }
    
    func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .refresh {
            switch state {
            case let .loading(completionHandler):
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    SocketIOHandler.shared.chatUsersList(conversationId: self.conversationId, id: self.responseArray.first?.id?.intValue ?? 0)
                    completionHandler()
                }
            default: break
            }
            return
        }
        
        switch state {
        case .none:
            pullLoadView.messageLabel.text = ""
            
        case .pulling(_, _):
            break
            
        case let .loading(completionHandler):
            pullLoadView.messageLabel.text = ""
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
//                self.getNotifications(page: 1, progress: false)
                completionHandler()
            }
        }
    }
}

extension ChatViewModel {
    @objc func keyboardWillShow(_ notification: NSNotification) {
        
        let view = (self.theController.view as? ChatView)
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
        let view = (self.theController.view as? ChatView)
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
