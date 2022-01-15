//
//  TimeUnderTensionView.swift
//  Load
//
//  Created by iMac on 01/08/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class TimeUnderTensionView: UIView {

    //MARK: - IBOutlet
    
    @IBOutlet weak var lblTrainingIntensity: UILabel!
    @IBOutlet weak var lblTimeToComplete: UILabel!
    @IBOutlet weak var vwHeader: UIView!
    @IBOutlet weak var tblTimeUnderTension: UITableView!
    
    //MARK: - SetupUI
    
    func setupUI(){
        
        tblTimeUnderTension.tableHeaderView = vwHeader
        tblTimeUnderTension.tableFooterView = UIView()
        self.tblTimeUnderTension.register(UINib(nibName: "TimeUndertensionHeaderView", bundle: nil), forCellReuseIdentifier: "TimeUndertensionHeaderView")
        
        [lblTrainingIntensity,lblTimeToComplete].forEach { (lbl) in
            lbl?.font = themeFont(size: 15, fontname: .ProximaNovaRegular)
        }
        
    }
    
}
