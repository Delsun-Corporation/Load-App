import Foundation 
import ObjectMapper 

class GetAndUpdateConfirmationPageModel: Mappable { 

	var message: String? 
	var status: NSNumber? 
	var success: Bool? 
	var data: confirmationDetails?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		message <- map["message"] 
		status <- map["status"] 
		success <- map["success"] 
		data <- map["data"] 
	}
} 

class confirmationDetails: Mappable {

	var trainingActivity: TrainingActivity? 
	var isPaceSelected: Bool? 
	var generatedCalculations: GeneratedCalculations?
    var cardioActivityTypeId = 1

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		trainingActivity <- map["training_activity"] 
		isPaceSelected <- map["is_pace_selected"] 
		generatedCalculations <- map["generated_calculations"]
        cardioActivityTypeId <- map["cardio_type_activity_id"]
	}
} 

class GeneratedCalculations: Mappable { 

	var totalDistanceCode: String? 
    var avgSpeed: CGFloat = 0.0
    var totalDistance: CGFloat = 0.0
	var avgSpeedCode: String? 
	var avgSpeedUnit: String? 
	var totalDurationCode: String? 
	var totalDuration: String? 
	var totalDurationMinutes: NSNumber? 
	var avgPaceCode: Any? 
	var totalDistanceUnit: String? 
	var avgPace: String? 
	var avgPaceUnit: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		totalDistanceCode <- map["total_distance_code"] 
		avgSpeed <- map["avg_speed"] 
		totalDistance <- map["total_distance"] 
		avgSpeedCode <- map["avg_speed_code"] 
		avgSpeedUnit <- map["avg_speed_unit"] 
		totalDurationCode <- map["total_duration_code"] 
		totalDuration <- map["total_duration"] 
		totalDurationMinutes <- map["total_duration_minutes"] 
		avgPaceCode <- map["avg_pace_code"] 
		totalDistanceUnit <- map["total_distance_unit"] 
		avgPace <- map["avg_pace"] 
		avgPaceUnit <- map["avg_pace_unit"] 
	}
} 

