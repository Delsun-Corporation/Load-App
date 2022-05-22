//
//  MessagesVC-TableView+Extension.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension MessagesVC :UITableViewDataSource, UITableViewDelegate, SocketIOHandlerDelegate {
    
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.responseArary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell") as! MessagesCell
        cell.selectionStyle = .none
        let model = self.mainModelView.responseArary[indexPath.row]
        cell.setupUI(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj: ChatVC = AppStoryboard.Messages.instance.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        let model = self.mainModelView.responseArary[indexPath.row]
        obj.mainModelView.chatDetails = model
        obj.mainModelView.conversationId = model.id?.stringValue ?? ""
        obj.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(obj, animated: true)
    }
    
    //Scoket Functions    
    func SocketConversationListResponse(model: [ConversationData]) {
        self.mainModelView.responseArary = model
        self.mainView.tableView.reloadData()
        
        var count:Int = 0
        for data in model {
            let id = getUserDetail()?.data?.user?.id
            count += id == data.fromId ? 0 : data.unreadCount!.intValue
        }
        self.mainModelView.delegate?.ChangeBadge(badgeValue: "\(count)")
    }
    
    func SocketChatListResponse(model: [MessageListData]) {
    }
    
    func SocketAddChatResponse(model: MessageListData) {
        self.mainView.loadConversation()
    }
    
    func SocketOnlineUserResponse(model: OnlineModelClass) {        
    }
    
    func SocketUpdatedStatusResponseToReceiver(id: Int) {
    }    
}
