import Foundation 
import ObjectMapper 

class ResistanceSummaryDataModel: Mappable { 

	var message: String? 
	var data: ResistanceSummaryDetail?
	var success: Bool? 
	var status: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		message <- map["message"] 
		data <- map["data"]
		success <- map["success"] 
		status <- map["status"] 
	}
} 

class ResistanceSummaryDetail: Mappable { 

	var trainingGoalCustom: Any? 
	var averageWeightLifted: CGFloat? 
	var RPE: String = ""
	var averageWeightLiftedUnit: String? 
	var trainingGoal: TrainingGoal? 
	var id: NSNumber? 
	var notes: String? 
	var comments: String = ""
	var targetedVolumeUnit: String = ""
    var completedVolumeUnit: String = ""
	var exercise: [ExerciseResistance]?
    var additionalExercise: [ExerciseResistance]?
    var trainingActivity: Any?
	var trainingIntensity: TrainingIntensity? 
	var date: String? 
	var targetedHr: Any? 
	var workoutName: String? 
	var trainingLogStyle: Any?
    var userDetails: UserDetail?
    var totalDuration = ""
    var completedVolume: CGFloat? = 0.0
    var targetedVolume: CGFloat? = 0.0
    
	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		targetedVolume <- map["targated_volume"]
		trainingGoalCustom <- map["training_goal_custom"] 
		averageWeightLifted <- map["average_weight_lifted"] 
		RPE <- map["RPE"]
		averageWeightLiftedUnit <- map["average_weight_lifted_unit"] 
		trainingGoal <- map["training_goal"] 
		id <- map["id"] 
		notes <- map["notes"] 
		comments <- map["comments"] 
        targetedVolumeUnit <- map["targated_volume_unit"]
        completedVolumeUnit <- map["completed_volume_unit"]
		exercise <- map["exercise"] 
		trainingActivity <- map["training_activity"] 
		trainingIntensity <- map["training_intensity"] 
		date <- map["date"] 
		targetedHr <- map["targeted_hr"] 
		workoutName <- map["workout_name"] 
		trainingLogStyle <- map["training_log_style"]
        userDetails <- map["user_detail"]
        totalDuration <- map["total_duration"]
        completedVolume <- map["completed_volume"]
        additionalExercise <- map["additional_exercise"]
	}
} 


