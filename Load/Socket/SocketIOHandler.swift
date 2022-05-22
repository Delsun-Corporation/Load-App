//
//  SocketHandler.swift
//  Load
//
//  Created by Haresh Bhai on 29/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

protocol SocketIOHandlerDelegate: class {
    func SocketConversationListResponse(model:[ConversationData])
    func SocketChatListResponse(model:[MessageListData])
    func SocketAddChatResponse(model:MessageListData)
    func SocketOnlineUserResponse(model:OnlineModelClass)
    func SocketUpdatedStatusResponseToReceiver(id:Int)
}

class SocketIOHandler: NSObject {
    
    static let shared = SocketIOHandler()
    var manager: SocketManager?
    var socket: SocketIOClient?
    var isHandlerAdded:Bool = false
    var isJoinSocket:Bool = false
    var userId : String = ""
    var oppUserId : String = ""
    weak var delegate: SocketIOHandlerDelegate?
    
    override init() {
        super.init()
    }
    
    func Connect() {
        if manager==nil && socket == nil {
            self.userId = getUserDetail()?.data?.user?.id?.stringValue ?? ""
            let headers = ["id": self.userId]
            
            manager = SocketManager(socketURL: URL(string: SOCKET_SERVER_PATH)!, config: [.log(true), .compress, .connectParams(headers)])
            
            socket = manager?.defaultSocket
        }
        
        self.socket?.connect()
        if(self.isSocketConnected()) {
            self.addHandlers()
            self.connectSocketWithStatus()
        }
        else {
            print("Socket Not Connected")
        }        
    }
    
    //MARK:- ConnectWithSocket
    func connectWithSocket() {
        if manager==nil && socket == nil {
            manager = SocketManager(socketURL: URL(string: SOCKET_SERVER_PATH)!, config: [.log(true), .compress, .forceNew(true)])
            socket = manager?.defaultSocket
        }
        
        socket?.connect()
        if(!isSocketConnected()) {
            connectSocketWithStatus()
        }
    }
    
    func isSocketConnected() -> Bool {
        if(socket != nil) {
            if(self.socket?.status == .connected || self.socket?.status == .connecting) {
                return true;
            }
            else{
                return false;
            }
        }
        return false;
    }
    
    func isSocketConnecting() -> Bool {
        if(socket != nil) {
            if self.socket?.status == .connecting {
                return true;
            }
            else{
                return false;
            }
        }
        return true;
    }
    
    func connectSocketWithStatus() {
        socket?.on(clientEvent: .connect) {data, ack in
            print(data)
            print(self.userId)
            if self.userId != "" {
//                self.joinRoom(data: self.userId)
            }
        }
        socket?.connect()
    }
    
    func disconnectSocket() {
        socket?.disconnect()
        socket = nil
        manager = nil
    }
    
    func conversationList() {
        if(isSocketConnected()) {
            socket?.emit(SocketConversationList, self.userId)
        }
    }
    
    func sendMultipleUser(message:String, to_ids:NSMutableArray) {
        if(isSocketConnected()) {
            let param: NSDictionary = ["message": message, "from_id":self.userId, "to_ids":to_ids]
            print(JSON(param))
            socket?.emit(SocketMultipleSendMessage, param)
        }
    }
    
    func sendMessage(conversationId:String, message:String, toId:String) {
        if(isSocketConnected()) {
            let param: NSDictionary = ["message": message, "from_id":self.userId, "to_id":toId, "conversation_id":conversationId]
            print(JSON(param))
            socket?.emit(SocketAddMessage, param)
        }
    }
    
    func shareFriendTrainingLog(toIds:[Int], trainingLogId:Int) {
        if(isSocketConnected()) {
            let param: NSDictionary = ["from_id": Int(self.userId)!, "to_ids":toIds, "training_log_id":trainingLogId]
             print(JSON(param))
            socket?.emit(SocketAddLog, param)
        }
    }
    
    func shareFriendEvent(toIds:[Int], eventId:Int) {
        if(isSocketConnected()) {
            let param: NSDictionary = ["from_id": Int(self.userId)!, "to_ids":toIds, "event_id":eventId]
            print(JSON(param))
            socket?.emit(SocketAddEvent, param)
        }
    }
    
    func readMsg(conversationId:String) {
        if(isSocketConnected()) {
            socket?.emit(SocketReadMessage, conversationId,self.userId)
        }
    }

    func chatUsersList(conversationId:String, id:Int) {
        if(isSocketConnected()) {
            let param: NSDictionary = ["id": id, "limit":30]
            print(param)
            socket?.emit(SocketChatList, conversationId, param)
        }
    }
    
    func checkOnline(otherUserId:String) {
        if(isSocketConnected()) {
            socket?.emit(SocketIsUserOnline, otherUserId)
        }
    }
    
    func receiveUpdatedStatus(bookedClientId:Int) {
        if(isSocketConnected()) {
            let param: NSDictionary = ["booked_client_id": bookedClientId, "user_id":self.userId]
            print(param)
            socket?.emit(SocketReceiveUpdatedStatus, param)
        }
    }
    
    func getTrainingDetails(id:Int = 1, completionHandler: @escaping (JSON?)-> Void) {
        if(isSocketConnected()) {
            socket?.emitWithAck(SocketGetTrainingDetails, id).timingOut(after: 0) {data in
                print(data)
                completionHandler(JSON(data))
            }
        }
    }
    
    func getEventDetails(id:Int = 44, completionHandler: @escaping (JSON?)-> Void) {
        if(isSocketConnected()) {
            socket?.emitWithAck(SocketGetEventDetails, id).timingOut(after: 1) {data in
                print(data)
                completionHandler(JSON(data))
            }
        }
    }
    
    func getAddClientRequestMessage(id:Int = 1, completionHandler: @escaping (JSON?)-> Void) {
        if(isSocketConnected()) {
            let param: NSDictionary = ["booked_client_id": id]
            socket?.emitWithAck(SocketAddClientRequestMessage, param).timingOut(after: 0) {data in
                print(data)
                completionHandler(JSON(data))
            }
        }
    }
    
    func getClientBookDetails(id:Int, completionHandler: @escaping (JSON?)-> Void) {
        if(isSocketConnected()) {
            socket?.emitWithAck(SocketGetClientBookDetails, id).timingOut(after: 0) {data in
                print(data)
                completionHandler(JSON(data))
            }
        }
    }
    
    func UpdateClientBookingStatus(id:Int, status:String, completionHandler: @escaping (JSON?)-> Void) {
        if(isSocketConnected()) {
            let param: NSDictionary = ["id": id, "status":status]

            socket?.emitWithAck(SocketUpdateClientBookingStatus, param).timingOut(after: 0) {data in
                print(data)
                completionHandler(JSON(data))
            }
        }
    }
    
    func SendMessageToReceiver(id:Int) {
        if(isSocketConnected()) {
            let param: NSDictionary = ["message_id": id, "user_id":self.userId]
            socket?.emit(SocketSendMessageToReceiver, param)
        }
    }
    
    //Revecing handlers
    func addHandlers() {        
        //This will get all All New and update friends object
        if(isSocketConnected()) {
            //SocketConversationListResponse
            socket?.on(SocketConversationListResponse, callback: { (data, ack) in
                print("Updated message:::: \(data)")
                let json = JSON(data.first!)
                print(json)
                let model = ConversationListModelClass(JSON: json.dictionaryObject!)
                self.delegate?.SocketConversationListResponse(model: model?.data ?? [])
            })
            
            //SocketChatListResponse
                socket?.on(SocketChatListResponse, callback: { (data, ack) in
                    print("Updated message:::: \(data)")
                    let json = JSON(data.first!)
                print(json)
                let model = MessageListModelClass(JSON: json.dictionaryObject!)
                self.delegate?.SocketChatListResponse(model: model?.data ?? [])
            })
            
            //SocketAddMessageResponse
            socket?.on(SocketAddMessageResponse, callback: { (data, ack) in
                print("Updated message:::: \(data)")
                let json = JSON(data.first!)
                print(json)
                var model: MessageListData?

                if json.dictionaryObject == nil {
                    model = MessageListData(JSON: json[0].dictionaryObject!)
                }
                else {
                    model = MessageListData(JSON: json.dictionaryObject!)
                }
                if CHAT_CONVERSATION_ID == model?.conversationId?.stringValue {
                    self.delegate?.SocketAddChatResponse(model: model!)
                }

                if IS_CHAT_SCREEN == false {
                    self.delegate?.SocketAddChatResponse(model: model!)
                }
            })
            
            socket?.on(SocketCheckStatus, callback: { (data, ack) in
                print("Updated message:::: \(data)")
                let json = JSON(data.first!)
                print(json)
                let model = OnlineModelClass(JSON: json.dictionaryObject!)
                self.delegate?.SocketOnlineUserResponse(model: model!)
            })
            
            socket?.on(SocketUpdatedStatusResponseToReceiver, callback: { (data, ack) in
                print("Updated message:::: \(data)")
                let json = JSON(data.first!)
                print(json)
                let id = json.getInt(key: .id)
                self.delegate?.SocketUpdatedStatusResponseToReceiver(id: id)
            })
        }
        else {
            print("Socket not connected")
        }
    }
}
