//
//  UserReviewViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 16/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class UserReviewViewModel {

    //MARK:- Variables
    fileprivate weak var theController:UserReviewVC!
    
    var selectedReadMore: [Int] = []

    init(theController:UserReviewVC) {
        self.theController = theController
    }   
}
