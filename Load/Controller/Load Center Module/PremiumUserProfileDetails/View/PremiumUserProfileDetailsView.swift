//
//  PremiumUserProfileDetailsView.swift
//  Load
//
//  Created by Yash on 01/07/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class PremiumUserProfileDetailsView: UIView {

    //MARK:- Outlet
    @IBOutlet weak var tblProfile: UITableView!
    
    //MARK:- SetupUI
    func setupUI(){
        
        self.tblProfile.register(UINib(nibName: "IntroductionPremiumCell", bundle: nil), forCellReuseIdentifier: "IntroductionPremiumCell")
        self.tblProfile.register(UINib(nibName: "ChartViewProfileTblCell", bundle: nil), forCellReuseIdentifier: "ChartViewProfileTblCell")
        self.tblProfile.register(UINib(nibName: "EventPremiumUserTblCell", bundle: nil), forCellReuseIdentifier: "EventPremiumUserTblCell")
        
        self.tblProfile.tableFooterView = UIView()
        
        self.tblProfile.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 70, right: 0)
        
    }


}
