//
//  PhysicalActivityInfoViewModel.swift
//  Load
//
//  Created by Yash on 09/04/21.
//  Copyright © 2021 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireSwiftyJSON

class PhysicalActivityInfoViewModel {
    
    //MARK:- Variables
    fileprivate weak var theController:PhysicalActivityInfoVc!
    var profileDetails: PhysicalActivityModelClass?

    //MARK:- Functions
    init(theController:PhysicalActivityInfoVc) {
        self.theController = theController
    }
    
    //MARK: - SetupUI
    func setupUI(){
        
    }
}
