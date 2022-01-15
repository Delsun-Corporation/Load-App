//
//  ChatView.swift
//  Load
//
//  Created by Haresh Bhai on 29/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import KRPullLoader

class ChatView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constantBottomofView: NSLayoutConstraint!
    @IBOutlet weak var txtMessage: UITextField!
    
    //MARK:- Functions
    func setupUI(theController: ChatVC) {
        self.layoutIfNeeded()
        CHAT_CONVERSATION_ID = theController.mainModelView.conversationId
        self.setupTableView(theController: theController)
        theController.navigationItem.titleView = nil

        SocketIOHandler.shared.readMsg(conversationId: theController.mainModelView.conversationId)
        self.setupTitle(title: "", theController: theController)
        let id = getUserDetail().data?.user?.id
        let otherUserId = theController.mainModelView.chatDetails?.fromId == id ? theController.mainModelView.chatDetails?.toId : theController.mainModelView.chatDetails?.fromId
        SocketIOHandler.shared.checkOnline(otherUserId: otherUserId?.stringValue ?? "")
    }
    
    func setupTitle(title:String, theController: ChatVC) {
        let id = getUserDetail().data?.user?.id
        let name = theController.mainModelView.chatDetails?.fromId == id ? theController.mainModelView.chatDetails?.toName : theController.mainModelView.chatDetails?.fromName
        let profile = theController.mainModelView.chatDetails?.fromId == id ? theController.mainModelView.chatDetails?.toPhoto : theController.mainModelView.chatDetails?.fromPhoto
        if profile?.contains("http") ?? false {
            theController.navigationItem.titleView = setChatView(text1: name ?? "", text2: title, image: profile ?? "")
        }
        else {
            theController.navigationItem.titleView = setChatView(text1: name ?? "", text2: title, image: SERVER_URL + (profile ?? ""))
        }
    }
    
    func setupTableView(theController: ChatVC) {
        self.tableView.register(UINib(nibName: "LeftChatCell", bundle: nil), forCellReuseIdentifier: "LeftChatCell")
        self.tableView.register(UINib(nibName: "RightChatCell", bundle: nil), forCellReuseIdentifier: "RightChatCell")
        self.tableView.register(UINib(nibName: "ChatTrainingLogCell", bundle: nil), forCellReuseIdentifier: "ChatTrainingLogCell")
        self.tableView.register(UINib(nibName: "ChatUpcomingEventCell", bundle: nil), forCellReuseIdentifier: "ChatUpcomingEventCell")
        self.tableView.register(UINib(nibName: "ConfirmAvailibiltyChatCell", bundle: nil), forCellReuseIdentifier: "ConfirmAvailibiltyChatCell")
        
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
        
        SocketIOHandler.shared.delegate = theController
        SocketIOHandler.shared.chatUsersList(conversationId: theController.mainModelView.conversationId, id: 0)
    }
    
    func setChatView(text1:String, text2: String, image:String) -> UIView {
        let viewDemo = UIView()
        viewDemo.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 100, height: 50)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 30, height: 30))
        imageView.sd_setImage(with: image.toURL(), completed: nil)
        imageView.setCircle()
        viewDemo.addSubview(imageView)
        
        let width1 = text1.widthOfString(usingFont: themeFont(size: 12, fontname: .Helvetica))
        let lbl1 = UILabel(frame: CGRect(x: 40, y: 2, width: width1, height: 20))
        lbl1.textColor = UIColor.appthemeWhiteColor
        lbl1.font = themeFont(size: 12, fontname: .Helvetica)
        lbl1.text = text1
        viewDemo.addSubview(lbl1)
        
        let width2 = text2.widthOfString(usingFont: themeFont(size: 10, fontname: .Helvetica))
        let lbl2 = UILabel(frame: CGRect(x: 40, y: 17, width: width2, height: 20))
        lbl2.textColor = UIColor.appthemeWhiteColor
        lbl2.font = themeFont(size: 10, fontname: .Helvetica)
        lbl2.text = text2
        viewDemo.addSubview(lbl2)
        return viewDemo
    }    
}
