import Foundation 
import ObjectMapper 

class SaveWorkoutListModelClass: Mappable { 

	var list: [SaveWorkoutList]?
	var count: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		list <- map["list"] 
		count <- map["count"] 
	}
} 

class SaveWorkoutList: Mappable {

	var isComplete: NSNumber? 
	var trainingIntensityId: NSNumber? 
	var workoutName: String? 
	var id: NSNumber? 
	var comments: String? 
	var date: String? 
	var isLog: NSNumber? 
	var notes: String??
	var updatedAt: String? 
	var status: String? 
	var createdAt: String? 
	var userOwnReview: Any? 
	var targetedHr: Any? 
	var trainingActivityId: Any? 
	var trainingGoalId: NSNumber? 
	var userId: NSNumber? 
	var exercise: SaveWorkoutListExercise?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		isComplete <- map["is_complete"] 
		trainingIntensityId <- map["training_intensity_id"] 
		workoutName <- map["workout_name"] 
		id <- map["id"] 
		comments <- map["comments"] 
		date <- map["date"] 
		isLog <- map["is_log"] 
		notes <- map["notes"] 
		updatedAt <- map["updated_at"] 
		status <- map["status"] 
		createdAt <- map["created_at"] 
		userOwnReview <- map["user_own_review"] 
		targetedHr <- map["targeted_hr"] 
		trainingActivityId <- map["training_activity_id"] 
		trainingGoalId <- map["training_goal_id"] 
		userId <- map["user_id"] 
		exercise <- map["exercise"] 
	}
} 

class SaveWorkoutListExercise: Mappable {

	var chestPress: [ChestPress]? 
	var seatedRow: [SeatedRow]? 
	var bicepCurls: [BicepCurls]? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		chestPress <- map["chest_press"] 
		seatedRow <- map["seated_row"] 
		bicepCurls <- map["bicep_curls"] 
	}
} 

class BicepCurls: Mappable { 

	var reps: NSNumber? 
	var rest: NSNumber? 
	var weight: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		reps <- map["reps"] 
		rest <- map["rest"] 
		weight <- map["weight"] 
	}
} 

class SeatedRow: Mappable { 

	var reps: NSNumber? 
	var rest: NSNumber? 
	var weight: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		reps <- map["reps"] 
		rest <- map["rest"] 
		weight <- map["weight"] 
	}
} 

class ChestPress: Mappable { 

	var reps: NSNumber? 
	var rest: NSNumber? 
	var weight: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		reps <- map["reps"] 
		rest <- map["rest"] 
		weight <- map["weight"] 
	}
} 

