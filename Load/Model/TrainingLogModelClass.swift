import Foundation 
import ObjectMapper 

class TrainingLogModelClass: Mappable { 

	var trainingActivity: TrainingActivityLogModel?
	var trainingGoalId: NSNumber? 
	var isLog: NSNumber? 
	var workoutName: String? 
	var exercise: [Exercise]? 
	var createdAt: String? 
	var trainingIntensity: TrainingIntensityLogModel?
	var status: String? 
	var userDetail: UserDetail? 
	var targetedHr: String? 
	var id: String?
	var trainingActivityId: NSNumber?
    var trainingGoalCustom: String?
	var trainingGoal: TrainingGoalLogModel?
	var trainingIntensityId: NSNumber?
	var date: String? 
	var userOwnReview: Any? 
	var notes: String? 
	var userId: NSNumber? 
	var updatedAt: String? 
    var isComplete: Bool?
    var trainingGoalCustomId: Int?
    var trainingStyle : TrainingLogStyle?
    var runAutoPause : Bool?
    var cycleAutoPause : Bool?


	required init?(map: Map){
	} 

	func mapping(map: Map) {
		trainingActivity <- map["training_activity"] 
		trainingGoalId <- map["training_goal_id"] 
		isLog <- map["is_log"] 
		workoutName <- map["workout_name"] 
		exercise <- map["exercise"] 
		createdAt <- map["created_at"] 
		trainingIntensity <- map["training_intensity"] 
		status <- map["status"] 
		userDetail <- map["user_detail"] 
		targetedHr <- map["targeted_hr"] 
		id <- map["_id"] 
		trainingActivityId <- map["training_activity_id"] 
		trainingGoal <- map["training_goal"]
        trainingGoalCustom <- map["training_goal_custom"]
        trainingGoalCustomId <- map["training_goal_custom_id"]
		trainingIntensityId <- map["training_intensity_id"]
		date <- map["date"] 
		userOwnReview <- map["user_own_review"] 
		notes <- map["notes"] 
		userId <- map["user_id"] 
		updatedAt <- map["updated_at"]
        isComplete <- map["is_complete"]
        trainingStyle <- map["training_log_style"]
        runAutoPause <- map["run_auto_pause"]
        cycleAutoPause <- map["cycle_auto_pause"]

	}
} 

class TrainingGoalLogModel: Mappable {

	var code: String? 
	var targetHr: String? 
	var id: NSNumber? 
	var updatedAt: String? 
	var name: String? 
	var isActive: NSNumber? 
	var createdAt: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		code <- map["code"] 
		targetHr <- map["target_hr"] 
		id <- map["id"] 
		updatedAt <- map["updated_at"] 
		name <- map["name"] 
		isActive <- map["is_active"] 
		createdAt <- map["created_at"] 
	}
} 

class UserDetail: Mappable { 

	var updatedAt: String? 
	var dateOfBirth: String? 
	var membershipCode: String?
	var createdAt: String? 
	var gender: String? 
	var isActive: NSNumber? 
	var accountId: Any? 
	var height: NSNumber? 
	var id: NSNumber? 
	var isProfileComplete: NSNumber? 
	var email: String? 
	var mobile: Any? 
	var mobileVerifiedAt: Any? 
	var name: String? 
	var photo: String? 
	var userType: Any? 
	var expiredAt: Any? 
	var weight: NSNumber? 
	var emailVerifiedAt: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		updatedAt <- map["updated_at"] 
		dateOfBirth <- map["date_of_birth"] 
		membershipCode <- map["membership_code"] 
		createdAt <- map["created_at"] 
		gender <- map["gender"] 
		isActive <- map["is_active"] 
		accountId <- map["account_id"] 
		height <- map["height"] 
		id <- map["id"] 
		isProfileComplete <- map["is_profile_complete"] 
		email <- map["email"] 
		mobile <- map["mobile"] 
		mobileVerifiedAt <- map["mobile_verified_at"] 
		name <- map["name"] 
		photo <- map["photo"] 
		userType <- map["user_type"] 
		expiredAt <- map["expired_at"] 
		weight <- map["weight"] 
		emailVerifiedAt <- map["email_verified_at"] 
	}
} 

class TrainingIntensityLogModel: Mappable {

	var id: NSNumber? 
	var createdAt: String? 
	var updatedAt: String? 
	var isActive: NSNumber? 
	var code: String? 
	var name: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		createdAt <- map["created_at"] 
		updatedAt <- map["updated_at"] 
		isActive <- map["is_active"] 
		code <- map["code"] 
		name <- map["name"] 
	}
} 

class Exercise: Mappable { 

	var rest: String? 
	var isCompleted: Bool? 
	var speed: CGFloat?
    var pace: String?
	var percentage: CGFloat?
    var rpm: Int?
	var laps: Int? 
	var duration: String?
    var distance: CGFloat?
    var lvl: Int?
    var watt: Int?
    var isCompletedRest: Bool?
    var isSpeed : Bool = false
    var totalDistance : Double = 0.0
    
    // add variable only when we complete workout
    var addedStartTime = ""
    var startTime = ""
    var endTime = ""
    var startLat: Double?
    var startLong: Double?
    var endLat: Double?
    var endLong: Double?
    var addedRestTime = ""
    var repeatTime = ""
    
    var elapsedTime: TimeInterval = 0
    var isPause : Bool = false
    var pauseTime = ""
    var isCheckMarkAlreadyDone : Bool = false
    var isClickOnPause: Bool = false // While user click on pause and End(Cancel) for that manage use this
    var lineDraw: Bool = false // last lineDraw while clicking on Pause-> When open screen show that lineDraw
    var lastPauseTime = ""
    
	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		rest <- map["rest"] 
		isCompleted <- map["is_completed"] 
		speed <- map["speed"]
        pace <- map["pace"]
		percentage <- map["percentage"]
        rpm <- map["rpm"]
		laps <- map["laps"] 
		duration <- map["duration"]
        distance <- map["distance"]
        lvl <- map["lvl"]
        watt <- map["watt"]
        isCompletedRest <- map["is_completed_rest"]
        startTime <- map["start_time"]
        endTime <- map["end_time"]
        startLat <- map["start_lat"]
        endLat <- map["end_lat"]
        startLong <- map["start_long"]
        endLong <- map["end_long"]
        addedStartTime <- map["added_start_time"]
        addedRestTime <- map["added_rest_time"]
        repeatTime <- map["repeat_time"]
        isSpeed <- map["is_speed"]
        isPause <- map["is_pause"]
        pauseTime <- map["pause_time"]
        isCheckMarkAlreadyDone <- map["is_checkmark_done"]
        elapsedTime <- map["elapsedTime"]
        isClickOnPause <- map["isClickOnPause"]
        lineDraw <- map["lineDraw"]
        lastPauseTime <- map["lastPauseTime"]
        
        totalDistance <- map["total_distance"]
	}
} 

class TrainingActivityLogModel: Mappable {

	var code: String? 
	var id: NSNumber? 
	var iconPath: String?
    var iconPathRed: String?
	var updatedAt: String? 
	var name: String? 
	var isActive: NSNumber? 
	var createdAt: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		code <- map["code"] 
		id <- map["id"] 
		iconPath <- map["icon_path"]
        iconPathRed <- map["icon_path_red"]
		updatedAt <- map["updated_at"] 
		name <- map["name"] 
		isActive <- map["is_active"] 
		createdAt <- map["created_at"] 
	}
} 

