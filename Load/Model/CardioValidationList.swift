import Foundation 
import ObjectMapper 

class CardioValidationList: Mappable { 

	var success: Bool? 
	var status: NSNumber? 
	var data: [CardioValidationListData]?
	var message: String = ""

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		success <- map["success"] 
		status <- map["status"] 
		data <- map["data"] 
		message <- map["message"] 
	}
} 

class CardioValidationListData: Mappable {

	var id: Int = 0
	var trainingActivityId: Int = 0
	var trainingGoalId: Int = 0
	var distanceRange: String = ""
	var durationRange: String = ""
	var speedRange: String = ""
	var paceRange: String = ""
	var percentageRange: String = ""
	var restRange: String = ""
	var isActive: Bool? 
	var createdAt: String = ""
	var updatedAt: String = ""
    var wattRange: String = ""
    var rpmRange: String = ""
    var lvlRange : String = ""
    var HRMax : CGFloat = 0.0
    
	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		trainingActivityId <- map["training_activity_id"] 
		trainingGoalId <- map["training_goal_id"] 
		distanceRange <- map["distance_range"] 
		durationRange <- map["duration_range"] 
		speedRange <- map["speed_range"] 
		paceRange <- map["pace_range"] 
		percentageRange <- map["percentage_range"] 
		restRange <- map["rest_range"] 
		isActive <- map["is_active"] 
		createdAt <- map["created_at"] 
		updatedAt <- map["updated_at"]
        wattRange <- map["watt_range"]
        lvlRange <- map["lvl_range"]
        rpmRange <- map["rpm_range"]
        HRMax <- map["hr_max"]
	}
} 

