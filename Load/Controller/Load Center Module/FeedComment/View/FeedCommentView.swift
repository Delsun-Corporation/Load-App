//
//  FeedCommentView.swift
//  Load
//
//  Created by Haresh Bhai on 21/08/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FeedCommentView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var constantBottomofView: NSLayoutConstraint!
    @IBOutlet weak var txtReportFlag:UITextField!
    
    //MARK:- Functions
    func setupUI(theController: FeedCommentVC) {
        self.layoutIfNeeded()
        self.setupFont()
        self.tableView.register(UINib(nibName: "FeedCommentProfileCell", bundle: nil), forCellReuseIdentifier: "FeedCommentProfileCell")
        self.tableView.register(UINib(nibName: "FeedCommentCell", bundle: nil), forCellReuseIdentifier: "FeedCommentCell")
        
        txtReportFlag.tintColor = UIColor.appthemeRedColor
        txtReportFlag.delegate = theController
        txtComment.delegate = theController
        
        txtReportFlag.attributedPlaceholder = NSAttributedString(string: txtReportFlag.placeholder ?? "",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.clear])

    }
    
    func setupFont() {
        self.txtComment.font = themeFont(size: 13, fontname: .ProximaNovaRegular)
        self.btnSend.titleLabel?.font = themeFont(size: 14, fontname: .ProximaNovaRegular)
        
        self.txtComment.setColor(color: .appthemeBlackColor)
        self.btnSend.setColor(color: .appthemeRedColor)
    }
}
