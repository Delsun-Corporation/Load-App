import Foundation 
import ObjectMapper 

class SettingProgramModelClass: Mappable {

	var height: NSNumber? 
	var raceTime: String? 
	var raceDistanceDetail: Any? 
	var hrMax: NSNumber?
    var hrRest: NSNumber?
	var createdAt: String? 
	var raceDistanceId: NSNumber?
	var userDetail: SettingProgramUserDetail?
	var userId: NSNumber? 
	var updatedAt: String? 
	var id: NSNumber? 
	var weight: NSNumber? 
    var trainingUnitIds: [String]?
    var runAutoPause : Bool?
    var cycleAutoPause : Bool?
    var isHrMaxIsEstimated : Bool = true
    var physicalAcitivityId = 0
    var VO2Max : NSNumber?
    var isVO2MaxIsEstimated : Bool = true
    
    var bikeWeight: CGFloat = 0.0
    var bikeWheelDiameter: CGFloat = 0.0
    var bikeFrontChainWheel = 0
    var bikeRearFreeWheel = 0
    
	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		height <- map["height"] 
		raceTime <- map["race_time"] 
		raceDistanceDetail <- map["race_distance_detail"] 
		hrMax <- map["hr_max"]
        hrRest <- map["hr_rest"]
		createdAt <- map["created_at"] 
		raceDistanceId <- map["race_distance_id"] 
		userDetail <- map["user_detail"] 
		userId <- map["user_id"] 
		updatedAt <- map["updated_at"] 
		id <- map["id"] 
		weight <- map["weight"]
        trainingUnitIds <- map["training_unit_ids"]
        runAutoPause <- map["run_auto_pause"]
        cycleAutoPause <- map["cycle_auto_pause"]
        isHrMaxIsEstimated <- map["is_hr_max_is_estimated"]
        physicalAcitivityId <- map["training_physical_activity_level_ids"]
        VO2Max <- map["vo2_max"]
        isVO2MaxIsEstimated <- map["is_vo2_max_is_estimated"]
        
        bikeWeight <- map["bike_weight"]
        bikeWheelDiameter <- map["bike_wheel_diameter"]
        bikeFrontChainWheel <- map["bike_front_chainwheel"]
        bikeRearFreeWheel <- map["bike_rear_freewheel"]
	}
} 

class SettingProgramUserDetail: Mappable {

	var isActive: NSNumber? 
	var name: String? 
	var photo: String? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		isActive <- map["is_active"] 
		name <- map["name"] 
		photo <- map["photo"] 
		id <- map["id"] 
	}
} 

