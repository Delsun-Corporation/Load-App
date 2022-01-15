import Foundation 
import ObjectMapper 

class ResistanceValidationList: Mappable { 

	var success: Bool? 
	var status: NSNumber? 
	var data: [ResistanceValidationListData]? 
	var message: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		success <- map["success"] 
		status <- map["status"] 
		data <- map["data"] 
		message <- map["message"] 
	}
} 

class ResistanceValidationListData: Mappable {

	var id: NSNumber? 
	var trainingIntensityId: NSNumber? 
	var trainingGoalId: NSNumber? 
	var weightRange: String? 
	var repsRange: String? 
	var restRange: String? 
	var isActive: NSNumber? 
	var trainingIntensityDetail: TrainingIntensityDetail? 
	var trainingGoalDetail: TrainingGoalDetail?
    var repsTimeRange: String?
    var durationRange: String?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		trainingIntensityId <- map["training_intensity_id"] 
		trainingGoalId <- map["training_goal_id"] 
		weightRange <- map["weight_range"] 
		repsRange <- map["reps_range"] 
		restRange <- map["rest_range"] 
		isActive <- map["is_active"] 
		trainingIntensityDetail <- map["training_intensity_detail"] 
		trainingGoalDetail <- map["training_goal_detail"]
        repsTimeRange <- map["reps_time_range"]
        durationRange <- map["duration_range"]
	}
} 

class TrainingGoalDetail: Mappable { 

	var id: NSNumber? 
	var name: String? 
	var displayAt: [String]? 
	var isActive: Bool? 
	var trainingIntensityIds: Any? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		name <- map["name"] 
		displayAt <- map["display_at"] 
		isActive <- map["is_active"] 
		trainingIntensityIds <- map["training_intensity_ids"] 
	}
} 

class TrainingIntensityDetail: Mappable { 

	var id: NSNumber? 
	var name: String? 
	var isActive: Bool? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		name <- map["name"] 
		isActive <- map["is_active"] 
	}
} 

