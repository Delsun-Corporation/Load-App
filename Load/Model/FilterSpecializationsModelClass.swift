//
//  FIlterSpecializationsModelClass.swift
//  Load
//
//  Created by Haresh Bhai on 17/07/19.
//  Copyright © 2019 Haresh Bhai. All rights reserved.
//

import UIKit

class FilterModelClass: NSObject {
    var LocationName: String?    
    var Location: String?
    var Language: String?
    var LanguageName: String?
    var Gender: String?
    var Specialization: [Int]?
    var SpecializationNameArray:[String]?
    var ServiceName: String?
    var Service: String?
    var Rating: Double?
    var YOEStart: CGFloat?
    var YOEEnd: CGFloat?
    var RateStart: CGFloat?
    var RateEnd: CGFloat?
}

class FilterSpecializationsModelClass: NSObject {
    var title: String?
    var specializations: [Specializations]?
}

class EventTypeModelClass: NSObject {
    var title: String?
    var specializations: [EventTypesModel]?
}

class RegionSelectionModelClass: NSObject {
    var title: String?
    var activity: [Regions]?
}

class TrainingTypesModelClass: NSObject {
    var title: String?
    var activity: [TrainingTypes]?
}

class FilterActivityModelClass: NSObject {
    var title: String?
    var activity: [Specializations]?
}

class EquipmentsModelClass: NSObject {
    var title: String?
    var activity: [Equipments]?
}
