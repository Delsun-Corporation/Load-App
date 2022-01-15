//
//  MessagesView.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

protocol ChangeBadgeCarbonkitDelegate: class {
    func ChangeBadge(badgeValue: String)
}

class MessagesView: UIView {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!

    //MARK:- Functions
    func setupUI(theController: MessagesVC) {
        self.layoutIfNeeded()
        self.tableView.register(UINib(nibName: "MessagesCell", bundle: nil), forCellReuseIdentifier: "MessagesCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
        SocketIOHandler.shared.delegate = theController
    }
    
    func loadConversation() {
        SocketIOHandler.shared.conversationList()        
    }
}
