import Foundation 
import ObjectMapper 

class TrainingLogListModelClass: Mappable { 

    var trainingProgramList: [TrainingProgramList]?
    var trainingLogList: [TrainingLogList]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        trainingProgramList <- map["training_program_list"]
        trainingLogList <- map["training_log_list"]
    }
}

class TrainingLogList: Mappable {
    
    var isComplete: Int = 0
    var workoutName: String?
    var comments: Any?
    var notes: String?
    var isLog: NSNumber?
    var trainingIntensityId: NSNumber?
    var status: String?
    var userDetail: TrainingLogUserDetail?
    var userId: NSNumber?
    var date: String?
    var createdAt: String?
    var updatedAt: String?
    var trainingIntensity: TrainingLogIntensity?
    var trainingGoalId: NSNumber?
    var exercise: [TrainingLogExercise]?
    var id: NSNumber?
    var trainingActivity: TrainingLogActivity?
    var trainingActivityId: NSNumber?
    var targetedHr: String?
    var trainingGoal: TrainingLogGoal?
    var userOwnReview: Any?
    var trainingGoalCustom: String = ""
    var generatedCalculations: GeneratedCalculations?

    
    // add two keys of Resistance only for Calendar show purpose
    
    var completedVolume: Int = 0
    var targetedVolume: Int = 0
    var targetedVolumeUnit: String = ""
    var completedVolumeUnit: String = ""

    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        isComplete <- map["is_complete"]
        workoutName <- map["workout_name"]
        comments <- map["comments"]
        notes <- map["notes"]
        isLog <- map["is_log"]
        trainingIntensityId <- map["training_intensity_id"]
        status <- map["status"]
        userDetail <- map["user_detail"]
        userId <- map["user_id"]
        date <- map["date"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        trainingIntensity <- map["training_intensity"]
        trainingGoalId <- map["training_goal_id"]
        exercise <- map["exercise"]
        id <- map["id"]
        trainingActivity <- map["training_activity"]
        trainingActivityId <- map["training_activity_id"]
        targetedHr <- map["targeted_hr"]
        trainingGoal <- map["training_goal"]
        userOwnReview <- map["user_own_review"]
        trainingGoalCustom <- map["training_goal_custom"]
        
        targetedVolume <- map["targated_volume"]
        completedVolume <- map["completed_volume"]
        targetedVolumeUnit <- map["targated_volume_unit"]
        completedVolumeUnit <- map["completed_volume_unit"]
        generatedCalculations <- map["generated_calculations"]

    }
}

class TrainingLogGoal: Mappable {
    
    var isActive: Bool?
    var name: String?
    var id: NSNumber?
    var code: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        isActive <- map["is_active"]
        name <- map["name"]
        id <- map["id"]
        code <- map["code"]
    }
}

class TrainingLogActivity: Mappable {
    
    var isActive: Bool?
    var name: String?
    var id: NSNumber?
    var iconPath: String?
    var code: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        isActive <- map["is_active"]
        name <- map["name"]
        id <- map["id"]
        iconPath <- map["icon_path"]
        code <- map["code"]
    }
}

class TrainingLogExercise: Mappable {
    
    var isCompleted: Bool?
    var speed: String?
    var pace: String?
    var laps: String?
    var percentage: String?
    var duration: String?
    var distance: CGFloat?
    var rest: String?
    var rpm: String?
//    var InCalendarShowPurposeResistancedata: [DataExercise]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        isCompleted <- map["is_completed"]
        speed <- map["speed"]
        pace <- map["pace"]
        laps <- map["laps"]
        percentage <- map["percentage"]
        duration <- map["duration"]
        distance <- map["distance"]
        rest <- map["rest"]
        rpm <- map["rpm"]
//        InCalendarShowPurposeResistancedata <- map["data"]
    }
}

class TrainingLogIntensity: Mappable {
    
    var isActive: Bool?
    var name: String?
    var id: NSNumber?
    var code: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        isActive <- map["is_active"]
        name <- map["name"]
        id <- map["id"]
        code <- map["code"]
    }
}

class TrainingProgramList: Mappable {
    
    var presetTrainingProgramsId: NSNumber?
    var status: String?
    var startDate: String?
    var presetTrainingProgram: PresetTrainingProgram?
    var trainingFrequenciesId: NSNumber?
    var createdAt: String?
    var phases: Any?
    var userId: NSNumber?
    var type: String?
    var date: String?
    var trainingFrequency: TrainingLogFrequency?
    var byDate: Any?
    var id: NSNumber?
    var updatedAt: String?
    var endDate: String?
    var days: [String]?
    var userDetail: TrainingLogUserDetail?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        presetTrainingProgramsId <- map["preset_training_programs_id"]
        status <- map["status"]
        startDate <- map["start_date"]
        presetTrainingProgram <- map["preset_training_program"]
        trainingFrequenciesId <- map["training_frequencies_id"]
        createdAt <- map["created_at"]
        phases <- map["phases"]
        userId <- map["user_id"]
        type <- map["type"]
        date <- map["date"]
        trainingFrequency <- map["training_frequency"]
        byDate <- map["by_date"]
        id <- map["id"]
        updatedAt <- map["updated_at"]
        endDate <- map["end_date"]
        days <- map["days"]
        userDetail <- map["user_detail"]
    }
}

class TrainingLogUserDetail: Mappable {
    
    var gender: String?
    var email: String?
    var weight: NSNumber?
    var height: NSNumber?
    var id: NSNumber?
    var name: String?
    var isActive: NSNumber?
    var mobile: Any?
    var photo: String?
    var dateOfBirth: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        gender <- map["gender"]
        email <- map["email"]
        weight <- map["weight"]
        height <- map["height"]
        id <- map["id"]
        name <- map["name"]
        isActive <- map["is_active"]
        mobile <- map["mobile"]
        photo <- map["photo"]
        dateOfBirth <- map["date_of_birth"]
    }
}

class TrainingLogFrequency: Mappable {
    
    var maxDays: NSNumber?
    var id: NSNumber?
    var title: String?
    var isActive: Bool?
    var updatedAt: Any?
    var createdAt: Any?
    var code: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        maxDays <- map["max_days"]
        id <- map["id"]
        title <- map["title"]
        isActive <- map["is_active"]
        updatedAt <- map["updated_at"]
        createdAt <- map["created_at"]
        code <- map["code"]
    }
}

class PresetTrainingProgram: Mappable {
    
    var status: String?
    var id: NSNumber?
    var title: String?
    var isActive: NSNumber?
    var subtitle: String?
    var weeks: NSNumber?
    var updatedAt: String?
    var createdAt: String?
    var type: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        id <- map["id"]
        title <- map["title"]
        isActive <- map["is_active"]
        subtitle <- map["subtitle"]
        weeks <- map["weeks"]
        updatedAt <- map["updated_at"]
        createdAt <- map["created_at"]
        type <- map["type"]
    }
} 
