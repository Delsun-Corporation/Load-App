import Foundation 
import ObjectMapper 

class CardioSummaryDetailModel: Mappable { 

	var status: NSNumber? 
	var success: Bool? 
	var message: String? 
	var data: CardioSummaryDetails?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		status <- map["status"] 
		success <- map["success"] 
		message <- map["message"] 
		data <- map["data"]
	}
}

class CardioSummaryDetails: Mappable {

	var date: String = ""
	var trainingLogStyle: TrainingLogStyle?
	var id: Int = 0
	var trainingActivity: TrainingActivity?
    var trainingProgramActivity: TrainingActivity?
	var avgSpeed: CGFloat? 
	var targetedHr: String = ""
	var trainingGoal: TrainingGoal?
	var exercise: [Exercise]?
    var exerciseTrainingProgram: [WeekWiseWorkoutLapsDetails]?
    var userDetails: UserDetail?
	var trainingIntensity: TrainingIntensity? 
    var totalDistance: CGFloat = 0.0
	var totalDuration: String = ""
    var averagePace : String = ""
    var workoutName : String = ""
    var inclination: CGFloat = 0.0
    var notes: String = ""
    var totalKcal : CGFloat = 0.0
    var comment : String = ""
    var totalLevel: CGFloat = 0.0
    var totalRPM : CGFloat = 0.0
    var totalPower = 0
    var totalRelativePower: CGFloat = 0.0
    var RPE : String = ""
    var totalDistaneUnit : String = ""
    var avgSpeedUnit : String = ""
    var totalPowerUnit : String = ""
    var totalRelativePowerUnit : String = ""
    var avgPaceUnit: String = ""
    var totalWatt: CGFloat = 0.0
    var trainingGoalCustom = ""
    var elevationGain = 0
    var elevationGainUnit = ""
    var gradient: CGFloat = 0.0
    var gradientUnit = ""
    var avgRPM = 0
    var avgPower = 0
    var avgPowerUnit = ""
    var activeDuration = ""
    var outdoorRoute = ""
    
	required init?(map: Map){
	}

	func mapping(map: Map) {
		date <- map["date"] 
		trainingLogStyle <- map["training_log_style"] 
		id <- map["id"] 
		trainingActivity <- map["training_activity"]
        trainingProgramActivity <- map["training_program_activity"]
		avgSpeed <- map["avg_speed"] 
		targetedHr <- map["targeted_hr"] 
		trainingGoal <- map["training_goal"] 
		exercise <- map["exercise"]
        exerciseTrainingProgram <- map["exercise"]
		trainingIntensity <- map["training_intensity"] 
		totalDistance <- map["total_distance"] 
		totalDuration <- map["total_duration"]
        averagePace <- map["avg_pace"]
        workoutName <- map["workout_name"]
        inclination <- map["inclination"]
        notes <- map["notes"]
        totalKcal <- map["total_kcal"]
        comment <- map["comments"]
        totalLevel <- map["total_lvl"]
        totalRPM <- map["total_rpm"]
        totalPower <- map["total_power"]
        totalRelativePower <- map["total_relative_power"]
        totalDistaneUnit <- map["total_distance_unit"]
        avgSpeedUnit <- map["avg_speed_unit"]
        totalPowerUnit <- map["total_power_unit"]
        totalRelativePowerUnit <- map["total_relative_power_unit"]
        RPE <- map["RPE"]
        avgPaceUnit <- map["avg_pace_unit"]
        totalWatt <- map["total_watt"]
        userDetails <- map["user_detail"]
        trainingGoalCustom <- map["training_goal_custom"]
        elevationGain <- map["elevation_gain"]
        elevationGainUnit <- map["elevation_gain_unit"]
        gradient <- map["gradient"]
        gradientUnit <- map["gradient_unit"]
        avgRPM <- map["avg_rpm"]
        avgPower <- map["average_power"]
        avgPowerUnit <- map["average_power_unit"]
        activeDuration <- map["active_duration"]
        outdoorRoute <- map["outdoor_route_data"]
	}
}

class TrainingLogStyle: Mappable{
    
    var name: String = ""
    var id : Int = 0
    var mets : Int = 0
    var code: String = ""
    
    required init?(map: Map) {
        
    }
    func mapping(map: Map) {
        name <- map["name"]
        id <- map["id"]
        mets <- map["mets"]
        code <- map["code"]
    }
    
}

