import Foundation 
import ObjectMapper 

class TrainingLogResistanceModelClass: Mappable { 

	var trainingActivityId: Any? 
	var trainingIntensity: TrainingIntensityResistance?
	var trainingGoal: TrainingGoalResistance?
	var id: NSNumber? 
	var targetedHr: Any? 
	var createdAt: String? 
	var date: String? 
	var userDetail: UserDetailResistance?
	var trainingIntensityId: Int = 0
	var workoutName: String? 
	var userOwnReview: Any? 
	var exercise: [ExerciseResistance]?
	var userId: NSNumber? 
	var isLog: NSNumber? 
	var notes: String?
	var status: String? 
	var trainingGoalId: NSNumber?
    var trainingGoalCustomId: Int = 0
	var updatedAt: String? 
	var trainingActivity: Any?
    var isComplete: Bool?
    var trainingGoalCustom: String?
    var targetedVolume : Int = 0
    var completedVolume: Int = 0
    var totalDuration = ""
    var targetedVolumeUnit: String = ""
    var completedVolumeUnit: String = ""

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		trainingActivityId <- map["training_activity_id"] 
		trainingIntensity <- map["training_intensity"] 
		trainingGoal <- map["training_goal"] 
		id <- map["id"] 
		targetedHr <- map["targeted_hr"] 
		createdAt <- map["created_at"] 
		date <- map["date"] 
		userDetail <- map["user_detail"] 
		trainingIntensityId <- map["training_intensity_id"] 
		workoutName <- map["workout_name"] 
		userOwnReview <- map["user_own_review"] 
		exercise <- map["exercise"] 
		userId <- map["user_id"] 
		isLog <- map["is_log"] 
		notes <- map["notes"] 
		status <- map["status"] 
		trainingGoalId <- map["training_goal_id"]
        trainingGoalCustomId <- map["training_goal_custom_id"]
		updatedAt <- map["updated_at"] 
		trainingActivity <- map["training_activity"]
        isComplete <- map["is_complete"]
        trainingGoalCustom <- map["training_goal_custom"]
        targetedVolume <- map["targated_volume"]
        completedVolume <- map["completed_volume"]
        totalDuration <- map["total_duration"]
        targetedVolumeUnit <- map["targated_volume_unit"]
        completedVolumeUnit <- map["completed_volume_unit"]

	}
} 

class ExerciseResistance: Mappable {

    var name: String?
    var data: [DataExercise]?
    var isCompleted: Bool?
    var libraryId: Int = 0
    var commonLibraryId: Int = 0
    var selectedHeader = 0
    var selectedUnit = 0
    var exerciseLink = ""
    var repetitionMax: [RepetitionMax]?

    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        data <- map["data"]
        isCompleted <- map["is_completed"]
        libraryId <- map["library_id"]
        commonLibraryId <- map["common_library_id"]
        exerciseLink <- map["exercise_link"]
        repetitionMax <- map["repetition_max"]

    }
} 

class DataExercise: Mappable {
    
    var reps: String?
    var duration: String?
    var weight: String?
    var rest: String?
    var isCompleted: Bool?
    var isCompletedRest: Bool?
    var completeTime:NSNumber?
    var startTime: String = ""
    var repeatTime = ""
    var isCheckMarkAlreadyDone : Bool = false
    var isCurrentLapWorking: Bool = false
    var isLastWorkedLap: Bool = false
    var isPause : Bool = false
    var pauseTime = ""
    var addedRestTime = ""
    var isRepeatSet = false  // //isRpeatSet because while a user has completed all laps and among them exercise first check only current working lap so the user can not able to start other laps after incompleted but now with the help of isRepeatSet user can click any other incomplete set
    var endTime = ""
    var isClickOnPause: Bool = false // While user click on pause and End(Cancel) for that manage use this

    var elapsedTime: TimeInterval = 0
    var lineDraw: Bool = false // last lineDraw while clicking on Pause-> When open screen show that lineDraw
    var lastPauseTime = ""

    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        reps <- map["reps"]
        duration <- map["duration"]
        weight <- map["weight"]
        rest <- map["rest"]
        isCompleted <- map["is_completed"]
        isCompletedRest <- map["is_completed_rest"]
        startTime <- map["start_time"]
        repeatTime <- map["repeat_time"]
        isCheckMarkAlreadyDone <- map["is_checkmark_done"]
        isCurrentLapWorking <- map["is_CurrentLapWorking"]
        isLastWorkedLap <- map["is_LastWorkedLap"]
        isPause <- map["is_pause"]
        pauseTime <- map["pause_time"]
        addedRestTime <- map["added_rest_time"]
        isRepeatSet <- map["is_repeat_set"]
        endTime <- map["end_time"]
        isClickOnPause <- map["isClickOnPause"]
        elapsedTime <- map["elapsedTime"]
        lineDraw <- map["lineDraw"]
        lastPauseTime <- map["lastPauseTime"]
    }
}


class UserDetailResistance: Mappable {

	var membershipCode: Any? 
	var weight: NSNumber? 
	var id: NSNumber? 
	var userType: Any? 
	var createdAt: String? 
	var expiredAt: Any? 
	var emailVerifiedAt: String? 
	var mobileVerifiedAt: Any? 
	var isProfileComplete: NSNumber? 
	var email: String? 
	var dateOfBirth: String? 
	var mobile: Any? 
	var name: String? 
	var photo: String? 
	var accountId: Any? 
	var isActive: NSNumber? 
	var updatedAt: String? 
	var height: NSNumber? 
	var gender: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		membershipCode <- map["membership_code"] 
		weight <- map["weight"] 
		id <- map["id"] 
		userType <- map["user_type"] 
		createdAt <- map["created_at"] 
		expiredAt <- map["expired_at"] 
		emailVerifiedAt <- map["email_verified_at"] 
		mobileVerifiedAt <- map["mobile_verified_at"] 
		isProfileComplete <- map["is_profile_complete"] 
		email <- map["email"] 
		dateOfBirth <- map["date_of_birth"] 
		mobile <- map["mobile"] 
		name <- map["name"] 
		photo <- map["photo"] 
		accountId <- map["account_id"] 
		isActive <- map["is_active"] 
		updatedAt <- map["updated_at"] 
		height <- map["height"] 
		gender <- map["gender"] 
	}
} 

class TrainingGoalResistance: Mappable {

	var updatedAt: String? 
	var isActive: NSNumber? 
	var code: String? 
	var createdAt: String? 
	var targetHr: String? 
	var name: String? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		updatedAt <- map["updated_at"] 
		isActive <- map["is_active"] 
		code <- map["code"] 
		createdAt <- map["created_at"] 
		targetHr <- map["target_hr"] 
		name <- map["name"] 
		id <- map["id"] 
	}
} 

class TrainingIntensityResistance: Mappable {

	var createdAt: String? 
	var name: String? 
	var isActive: NSNumber? 
	var code: String? 
	var id: NSNumber? 
	var updatedAt: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		createdAt <- map["created_at"] 
		name <- map["name"] 
		isActive <- map["is_active"] 
		code <- map["code"] 
		id <- map["id"] 
		updatedAt <- map["updated_at"] 
	}
} 

