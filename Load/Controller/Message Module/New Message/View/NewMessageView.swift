//
//  NewMessageView.swift
//  Load
//
//  Created by Haresh Bhai on 27/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit
import VENTokenField

class NewMessageView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var txtName: VENTokenField!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var constantBottomofView: NSLayoutConstraint!

    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var txtMessage: UITextField!
    
    //MARK:- Functions
    func setupUI(theController: NewMessageVC) {
        self.layoutIfNeeded()
        self.setupFont()
        self.setupTagView(theController: theController)
        self.setupTableView(theController: theController)
    }
    
    func setupTagView(theController: NewMessageVC) {
        txtName.layoutIfNeeded()
        txtName.delegate = theController
        txtName.dataSource = theController
        txtName.placeholderText = "Enter names"
        txtName.toLabelText = ""
        txtName.setColorScheme(UIColor.appthemeRedColor)
        txtName.delimiters = [",", ";", "--"]
    }
    
    func setupTableView(theController: NewMessageVC) {
        self.tableView.isHidden = true
        self.tableView.register(UINib(nibName: "FollowingCell", bundle: nil), forCellReuseIdentifier: "FollowingCell")
        self.tableView.register(UINib(nibName: "AddNewContactCell", bundle: nil), forCellReuseIdentifier: "AddNewContactCell")
        self.tableView.delegate = theController
        self.tableView.dataSource = theController
    }
    
    func setupFont() {
        self.lblTo.font = themeFont(size: 9, fontname: .Helvetica)
        self.txtMessage.font = themeFont(size: 14, fontname: .HelveticaBold)
        
        self.lblTo.setColor(color: .appthemeBlackColorAlpha50)
        self.txtMessage.setColor(color: .appthemeBlackColor)        
    }
}
