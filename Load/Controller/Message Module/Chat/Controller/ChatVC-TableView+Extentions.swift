//
//  ChatVC-TableView+Extentions.swift
//  Load
//
//  Created by Haresh Bhai on 29/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

extension ChatVC :UITableViewDataSource, UITableViewDelegate, SocketIOHandlerDelegate, ChatTrainingLogOREventDelegate {
   
    //MARK:- TableView Delegates
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mainModelView.responseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = getUserDetail()?.data?.user?.id
        let model = self.mainModelView.responseArray[indexPath.row]
        if model.type == 0 {
            if model.fromId != id {
                let cell = tableView.dequeueReusableCell(withIdentifier: "LeftChatCell") as! LeftChatCell
                cell.selectionStyle = .none
                cell.setupUI()
                cell.lblMessage.text = model.message
                cell.lblDate.text = convertDateFormater((model.createdAt!), format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",  dateFormat: "HH:mm a")
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightChatCell") as! RightChatCell
                cell.selectionStyle = .none
                cell.setupUI()
                cell.lblMessage.text = model.message
                cell.lblDate.text = convertDateFormater((model.createdAt!), format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",  dateFormat: "HH:mm a")
                return cell
            }
        }
        else if model.type == 1 {
            if model.fromId != id {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTrainingLogCell") as! ChatTrainingLogCell
                cell.selectionStyle = .none
                cell.delegate = self
                cell.tag = indexPath.row
                cell.setupUI(model: model)
                cell.changeIcon()
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTrainingLogCell") as! ChatTrainingLogCell
                cell.selectionStyle = .none
                cell.delegate = self
                cell.tag = indexPath.row
                cell.setupUI(model: model)
                cell.changeIcon(isLeft: false)
                return cell
            }
        }
        else if model.type == 2 {
            if model.fromId != id {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUpcomingEventCell") as! ChatUpcomingEventCell
                cell.selectionStyle = .none
                cell.delegate = self
                cell.tag = indexPath.row
                cell.setupUI(model: model)
                cell.changeIcon()
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUpcomingEventCell") as! ChatUpcomingEventCell
                cell.selectionStyle = .none
                cell.delegate = self
                cell.tag = indexPath.row
                cell.setupUI(model: model)
                cell.changeIcon(isLeft: false)
                return cell
            }
        }
        else {
            if model.fromId != id {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmAvailibiltyChatCell") as! ConfirmAvailibiltyChatCell
                cell.selectionStyle = .none
//                cell.delegate = self
                cell.tag = indexPath.row
                cell.setupUI(model: model)
                cell.changeIcon()
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmAvailibiltyChatCell") as! ConfirmAvailibiltyChatCell
                cell.selectionStyle = .none
//                cell.delegate = self
                cell.tag = indexPath.row
                cell.setupUI(model: model)
                cell.changeIcon(isLeft: false)
                return cell
            }
        }
    }    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func SocketConversationListResponse(model: [ConversationData]) {
        
    }
    
    func SocketChatListResponse(model: [MessageListData]) {
        print(model.count)
        self.mainModelView.responseArray = self.mainModelView.responseArray.reversed()
        for data in model {
            self.mainModelView.responseArray.append(data)
        }
        self.mainModelView.responseArray = self.mainModelView.responseArray.reversed()
        self.mainView.tableView.reloadData {
            if self.mainModelView.isFirstTime {
                self.mainModelView.isFirstTime = false
                if self.mainModelView.responseArray.count != 0 && self.mainModelView.responseArray.count != 1 {
                    self.scrollToBottom()
                    if self.mainModelView.isClientRequest {
                        self.mainModelView.isClientRequest = false
                        SocketIOHandler.shared.SendMessageToReceiver(id: (self.mainModelView.responseArray[self.mainModelView.responseArray.count-2].id?.intValue ?? 0))
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
                            SocketIOHandler.shared.SendMessageToReceiver(id: (self.mainModelView.responseArray[self.mainModelView.responseArray.count-1].id?.intValue ?? 0))
                        }
                    }
                }
            }
        }
    }
    
    func SocketAddChatResponse(model: MessageListData) {
        let id = getUserDetail()?.data?.user?.id
        if model.fromId != id {
            SocketIOHandler.shared.readMsg(conversationId: self.mainModelView.conversationId)
        }

        self.mainModelView.responseArray.append(model)
        self.mainView.tableView.reloadData {
            if self.mainModelView.responseArray.count != 0 && self.mainModelView.responseArray.count != 1 {
                self.scrollToBottom()
            }
        }
    }
    
    func SocketOnlineUserResponse(model: OnlineModelClass) {
        let id = getUserDetail()?.data?.user?.id
        let otherUserId = self.mainModelView.chatDetails?.fromId == id ? self.mainModelView.chatDetails?.toId : self.mainModelView.chatDetails?.fromId
        if otherUserId?.stringValue == model.id {
            self.mainView.setupTitle(title: (model.message?.lowercased().capitalized ?? ""), theController: self)
        }
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                if self.mainModelView.responseArray.count != 0 {
                    let indexPath = IndexPath(row: (self.mainModelView.responseArray.count)-1, section: 0)
                    self.mainView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
    }
    
    func ChatTrainingLogReload(index: Int, trainingLog: ChatTrainingLog) {
        self.mainModelView.responseArray[index].ChatTrainingLog = trainingLog
        self.mainView.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func ChatEventReload(index: Int, event: ChatEvent) {
        self.mainModelView.responseArray[index].ChatEvent = event
        self.mainView.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func SocketUpdatedStatusResponseToReceiver(id: Int) {
        for (index, data) in self.mainModelView.responseArray.enumerated() {
            if data.bookedClientId?.intValue == id {
                self.mainView.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
            }
        }
    }
}
