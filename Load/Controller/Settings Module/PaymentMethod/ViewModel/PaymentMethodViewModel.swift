//
//  PaymentMethodViewModel.swift
//  Load
//
//  Created by Yash on 14/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation

class PaymentMethodViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:PaymentMethodVc!

    //MARK:- Functions
    init(theController:PaymentMethodVc) {
        self.theController = theController
    }
    
}
