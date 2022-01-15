//
//  EmergencyView.swift
//  Load
//
//  Created by iMac on 08/01/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import UIKit

class EmergencyView: UIView {

    //MARK:- @IBOutlet
    @IBOutlet weak var txtContact1: UITextField!
    @IBOutlet weak var txtContact2: UITextField!
    
    //MARK:- Functions
    func setupUI(theController: EmergencyVC) {
        self.txtContact1.delegate = theController
        self.txtContact2.delegate = theController
    }
}
