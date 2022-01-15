//
//  SocketService-Prifix.swift
//  Load
//
//  Created by Haresh Bhai on 29/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import Foundation

//Server URL
//let SOCKET_SERVER_PATH = "http://192.168.0.127:5000"
let SOCKET_SERVER_PATH = "http://178.128.45.110:8000" //http://178.128.56.249:5000"//http://192.168.0.142:5000"

/****
 * Socket Events Name
 */

let SocketMultipleSendMessage: String = "multiple-send-message"
let SocketConversationList: String = "conversation-list"
let SocketConversationListResponse = "conversation-list-response"
let SocketChatList = "chat-list"
let SocketChatListResponse = "chat-list-response"
let SocketAddMessage = "add-message"
let SocketAddMessageResponse = "add-message-response"
let SocketReadMessage = "read-message"
let SocketCheckStatus = "check-status"
let SocketIsUserOnline = "is-user-online"
let SocketAddLog = "add-log"
let SocketAddEvent = "add-event"
let SocketGetTrainingDetails = "get-training-details"
let SocketGetEventDetails = "get-event-details"
let SocketAddClientRequestMessage = "add-client-request-message"
let SocketGetClientBookDetails = "get-client-Book-details"
let SocketUpdateClientBookingStatus = "update-client-booking-status"
let SocketReceiveUpdatedStatus = "receive-updated-status"
let SocketUpdatedStatusResponseToReceiver = "updated-status-response-to-receiver"
let SocketSendMessageToReceiver = "send-message-to-receiver"
