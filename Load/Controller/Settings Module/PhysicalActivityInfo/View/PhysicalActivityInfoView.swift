//
//  PhysicalActivityInfoView.swift
//  Load
//
//  Created by Yash on 09/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import UIKit

class PhysicalActivityInfoView: UIView {

    //MARK: - Outlet

    @IBOutlet weak var tblActivityInfo: UITableView!
    
    //MARK: - SetupUI
    
    func setupUI(){
        self.tblActivityInfo.register(UINib(nibName: "PhysicalActivityInfoTblCell", bundle: nil), forCellReuseIdentifier: "PhysicalActivityInfoTblCell")
    }
    
}
