//
//  ShowingRouteForTrainingLog.swift
//  Load
//
//  Created by iMac on 03/09/20.
//  Copyright © 2020 Haresh Bhai. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class CardioActivityRoute : Object{
    
    @objc dynamic var id = 0
    @objc dynamic var userId = ""
    @objc dynamic var activityId = 0
    @objc dynamic var allTrackRoute = ""
    @objc dynamic var totalCoveredDistance = 0.0
    @objc dynamic var secondLastIndex = 0
    @objc dynamic var lastIndex = 0
    @objc dynamic var isPauseAfterAllLapCompleted = false
    @objc dynamic var averageSpeed = 0.0
    @objc dynamic var elevationGain = 0.0
    @objc dynamic var isAutomaticallyPause = false
    //Start time for indoor only get valid data for Distnace other wise startime change track data also change
    @objc dynamic var startTimeForIndoor = ""
    
    let lapArray = List<LapDetails>()
    
    override class func primaryKey() -> String {
        return "id"
    }
}

class LapDetails : Object{
    
//    @objc dynamic var id = 0
    @objc dynamic var routeId = 0
    @objc dynamic var lapCoverDistance = 0.0
    @objc dynamic var isCompleted = false
    @objc dynamic var lapTrackRoute = ""
    @objc dynamic var startFrom = 0
    @objc dynamic var endTo = 0
    
//    override class func primaryKey() -> String {
//        return "id"
//    }
}
