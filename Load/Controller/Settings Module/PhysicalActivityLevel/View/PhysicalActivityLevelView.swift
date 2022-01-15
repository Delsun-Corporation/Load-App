//
//  PhysicalActivityLevelView.swift
//  Load
//
//  Created by iMac on 18/07/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class PhysicalActivityLevelView: UIView {

    @IBOutlet weak var tblPhysicalActivity: UITableView!
    
    //MARK: - SetupUI
    func setupUI(theController: PhysicalActivityLevelVc){
        
        tblPhysicalActivity.delegate = theController
        tblPhysicalActivity.dataSource = theController
        
        tblPhysicalActivity.register(UINib(nibName: "PhyscialActivityTblCell", bundle: nil), forCellReuseIdentifier: "PhyscialActivityTblCell")
        
    }
}
