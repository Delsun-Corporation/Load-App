//
//  MessagesViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import KRPullLoader

class MessagesViewModel: KRPullLoadViewDelegate {

    //MARK:- Variables
    fileprivate weak var theController:MessagesVC!
    var responseArary: [ConversationData] = [ConversationData]()
    weak var delegate: ChangeBadgeCarbonkitDelegate?
    let refreshView = KRPullLoadView()
    
    init(theController:MessagesVC) {
        self.theController = theController
    }
    
    func setupUI() {
        refreshView.delegate = self
        let view = (self.theController.view as? MessagesView)
        view?.tableView.addPullLoadableView(refreshView, type: .refresh)
    }
    
    func pullLoadView(_ pullLoadView: KRPullLoadView, didChangeState state: KRPullLoaderState, viewType type: KRPullLoaderType) {
        if type == .refresh {
            switch state {
            case let .loading(completionHandler):
                let view = (self.theController.view as? MessagesView)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                    view?.loadConversation()
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
