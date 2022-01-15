//
//  FilterViewModel.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FilterViewModel {

    //MARK:- Variables
    fileprivate weak var theController:FilterVC!
    var FilterSection: [String] = ["Location", "Language", "Gender", "Specialization", "Service", "Rating", "Years of Experience", "Rate"]
    var isFilterSelected:Bool = false
    var filterSpecialization:String = ""
    var selectedArray:[Int] = [Int]()
    var selectedNameArray:[String] = [String]()
    var isFilterClear:Bool = false
    
    var LocationName: String?
    var Location: String?
    var LanguageName: String?
    var Language: String?
    var Gender: String?
    var ServiceName: String?
    var Service: String?
    var Rating: Double?
    var YOEStart: CGFloat?
    var YOEEnd: CGFloat?
    var RateStart: CGFloat?
    var RateEnd: CGFloat?
        
    init(theController:FilterVC) {
        self.theController = theController
    }
}
