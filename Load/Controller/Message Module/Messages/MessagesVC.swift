//
//  MessagesVC.swift
//  Load
//
//  Created by Haresh Bhai on 26/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class MessagesVC: UIViewController {

    //MARK:- Variables
    lazy var mainView: MessagesView = { [unowned self] in
        return self.view as! MessagesView
    }()
    
    lazy var mainModelView: MessagesViewModel = {
        return MessagesViewModel(theController: self)
    }()
    
    //MARK:- Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.mainView.setupUI(theController: self)
        self.mainModelView.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SocketIOHandler.shared.delegate = self
        self.mainView.loadConversation()
    }
}
