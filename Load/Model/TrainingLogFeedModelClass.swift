import Foundation 
import ObjectMapper 

class TrainingLogFeedModelClass: Mappable { 

	var count: NSNumber? 
	var list: [FeedList]?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		count <- map["count"] 
		list <- map["list"] 
	}
} 

class FeedList: Mappable {

	var status: String? 
	var trainingActivityId: NSNumber? 
	var userId: NSNumber? 
	var targetedHr: Any? 
	var notes: String? 
	var isLog: NSNumber? 
	var updatedAt: String? 
	var userDetail: FeedListUserDetail?
	var trainingGoalId: NSNumber? 
	var exercise: [FeedListExercise]?
	var workoutName: String? 
	var trainingIntensityId: NSNumber? 
	var userOwnReview: NSNumber? 
	var isComplete: NSNumber? 
	var comments: String? 
	var trainingGoal: FeedListTrainingGoal?
	var date: String? 
	var createdAt: String? 
	var id: NSNumber? 
    var trainingActivity: FeedTrainingActivity?
    var likedDetail: LikedDetail?
    var commentCount: NSNumber?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		status <- map["status"] 
		trainingActivityId <- map["training_activity_id"] 
		userId <- map["user_id"] 
		targetedHr <- map["targeted_hr"] 
		notes <- map["notes"] 
		isLog <- map["is_log"] 
		updatedAt <- map["updated_at"] 
		userDetail <- map["user_detail"] 
		trainingGoalId <- map["training_goal_id"] 
		exercise <- map["exercise"] 
		workoutName <- map["workout_name"] 
		trainingIntensityId <- map["training_intensity_id"] 
		userOwnReview <- map["user_own_review"] 
		isComplete <- map["is_complete"] 
		comments <- map["comments"] 
		trainingGoal <- map["training_goal"] 
		date <- map["date"] 
		createdAt <- map["created_at"] 
		id <- map["id"]
        trainingActivity <- map["training_activity"]
        likedDetail <- map["liked_detail"]
        commentCount <- map["comment_count"]
	}
} 

class FeedListTrainingGoal: Mappable {

	var name: String? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		name <- map["name"] 
		id <- map["id"] 
	}
} 

class FeedListExercise: Mappable {

	var rest: String? 
	var duration: String? 
	var laps: String? 
	var speed: String? 
	var persant: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		rest <- map["rest"] 
		duration <- map["duration"] 
		laps <- map["laps"] 
		speed <- map["speed"] 
		persant <- map["persant"] 
	}
} 

class FeedListUserDetail: Mappable {

	var name: String? 
	var id: NSNumber? 
    var photo: String?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		name <- map["name"] 
		id <- map["id"]
        photo <- map["photo"]
	}
} 

class FeedTrainingActivity: Mappable {
    
    var id: NSNumber?
    var code: String?
    var iconPath: String?
    var name: String?
    var createdAt: String?
    var updatedAt: String?
    var isActive: Bool?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        code <- map["code"]
        iconPath <- map["icon_path"]
        name <- map["name"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        isActive <- map["is_active"]
    }
}


class LikedDetail: Mappable {
    
    var feedId: NSNumber?
    var isLiked: Bool?
    var userIds: [String]?
    var images: [LikedImages]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        feedId <- map["feed_id"]
        isLiked <- map["is_liked"]
        userIds <- map["user_ids"]
        images <- map["images"]
    }
}

class LikedImages: Mappable {
    
    var photo: String?
    var id: NSNumber?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        photo <- map["photo"]
        id <- map["id"]
    }
}
