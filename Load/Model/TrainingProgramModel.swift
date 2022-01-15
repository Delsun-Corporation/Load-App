import Foundation 
import ObjectMapper 

class TrainingProgramModel: Mappable {
    
    var weekWiseWorkoutDetail: WeekWiseWorkoutDetail?
    var isComplete: Bool?
    var date: String?
    var programId: NSNumber?
    var weekWiseWorkoutId: NSNumber?
//    var exercise: [ProgramExercise]?
    var exercise: [WeekWiseWorkoutLapsDetails]?
    var programDetail: ProgramDetail?
    var id: NSNumber?
    var createdAt: String?
    var updatedAt: String?
    var cardioTypeActivityId = 0
    var runAutoPause : Bool?
    var generatedCalculations: GeneratedCalculations?

    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        weekWiseWorkoutDetail <- map["week_wise_workout_detail"]
        isComplete <- map["is_complete"]
        date <- map["date"]
        programId <- map["program_id"]
        weekWiseWorkoutId <- map["week_wise_workout_id"]
        exercise <- map["exercise"]
        programDetail <- map["program_detail"]
        id <- map["id"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        cardioTypeActivityId <- map["cardio_type_activity_id"]
        runAutoPause <- map["run_auto_pause"]
        generatedCalculations <- map["generated_calculations"]
    }
}

class ProgramExercise: Mappable {
    
    var commonProgramsWeeksLapId: String?
    var updatedDuration: String?
    var updatedDistance : CGFloat?
    var updatedRest: String?
    var updatedPercentage: String?
    var completedTime: NSNumber?
    var isCompleted: Bool?
    
    
    var isCompletedRest: Bool?
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
        commonProgramsWeeksLapId <- map["common_programs_weeks_lap_id"]
        updatedDuration <- map["updated_duration"]
        updatedRest <- map["updated_rest"]
        updatedPercentage <- map["updated_percentage"]
        updatedDistance <- map["updated_distance"]
        completedTime <- map["completed_time"]
        isCompleted <- map["is_completed"]
        
        isCompletedRest <- map["is_completed_rest"]
        addedStartTime <- map["added_start_time"]
        startTime <- map["start_time"]
        endTime <- map["end_time"]
        startLat <- map["start_lat"]
        endLat <- map["end_lat"]
        startLong <- map["start_long"]
        endLong <- map["end_long"]
        addedRestTime <- map["added_rest_time"]
        repeatTime <- map["repeat_time"]
        elapsedTime <- map["elapsedTime"]
        isPause <- map["is_pause"]
        pauseTime <- map["pause_time"]
        isCheckMarkAlreadyDone <- map["is_checkmark_done"]
        isClickOnPause <- map["isClickOnPause"]
        lineDraw <- map["lineDraw"]
        lastPauseTime <- map["lastPauseTime"]

    }
}


class ProgramDetail: Mappable {
    
    var endDate: String?
    var presetTrainingProgramsId: NSNumber?
    var date: Any?
    var id: NSNumber?
    var createdAt: String?
    var status: String?
    var updatedAt: String?
    var byDate: Any?
    var userId: NSNumber?
    var days: [String]?
    var phases: Any?
    var type: String?
    var trainingFrequenciesId: NSNumber?
    var startDate: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        endDate <- map["end_date"]
        presetTrainingProgramsId <- map["preset_training_programs_id"]
        date <- map["date"]
        id <- map["id"]
        createdAt <- map["created_at"]
        status <- map["status"]
        updatedAt <- map["updated_at"]
        byDate <- map["by_date"]
        userId <- map["user_id"]
        days <- map["days"]
        phases <- map["phases"]
        type <- map["type"]
        trainingFrequenciesId <- map["training_frequencies_id"]
        startDate <- map["start_date"]
    }
}

class WeekWiseWorkoutDetail: Mappable {
    var THR: String?
    var calculatedTHR: String?
    var trainingGoalId: NSNumber?
    var updatedAt: String?
    var trainingIntensityId: NSNumber?
    var name: String?
    var note: String?
    var trainingActivityId: NSNumber?
    var weekWiseFrequencyMasterId: NSNumber?
    var id: NSNumber?
    var workout: NSNumber?
    var createdAt: String?
    var phaseName = ""
    var weekWiseWorkoutLapsDetails: [WeekWiseWorkoutLapsDetails]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        THR <- map["THR"]
        calculatedTHR <- map["calculated_THR"]
        trainingGoalId <- map["training_goal_id"]
        updatedAt <- map["updated_at"]
        trainingIntensityId <- map["training_intensity_id"]
        name <- map["name"]
        note <- map["note"]
        trainingActivityId <- map["training_activity_id"]
        weekWiseFrequencyMasterId <- map["week_wise_frequency_master_id"]
        id <- map["id"]
        workout <- map["workout"]
        createdAt <- map["created_at"]
        weekWiseWorkoutLapsDetails <- map["week_wise_workout_laps_details"]
        phaseName <- map["phase_name"]

    }
}

class WeekWiseWorkoutLapsDetails: Mappable {
    
    var distance: String?
    var createdAt: String?
    var vDOT: String?
    var weekWiseWorkoutId: NSNumber?
    var updatedAt: String?
    var rest: String?
    var laps: Int? = 0
    var id: NSNumber?
    var duration: String?
    var percent: String?
    var speed: String?
    var pace: String?
    var completeTime:NSNumber?
    var updatedDistance: CGFloat?
    var updatedDuration: String?
    var updatedRest: String?
    var updatedPercent: String?

    var isCompleted: Bool?
    var isCompletedRest: Bool?
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
    var totalDistance : Double = 0.0

    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        distance <- map["distance"]
        createdAt <- map["created_at"]
        vDOT <- map["VDOT"]
        weekWiseWorkoutId <- map["week_wise_workout_id"]
        updatedAt <- map["updated_at"]
        rest <- map["rest"]
        laps <- map["lap"]
        id <- map["id"]
        duration <- map["duration"]
        percent <- map["percent"]
        speed <- map["speed"]
        pace <- map["pace"]
        
        isCompleted <- map["is_completed"]
        isCompletedRest <- map["is_completed_rest"]
        addedStartTime <- map["added_start_time"]
        startTime <- map["start_time"]
        endTime <- map["end_time"]
        startLat <- map["start_lat"]
        endLat <- map["end_lat"]
        startLong <- map["start_long"]
        endLong <- map["end_long"]
        addedRestTime <- map["added_rest_time"]
        repeatTime <- map["repeat_time"]
        elapsedTime <- map["elapsedTime"]
        isPause <- map["is_pause"]
        pauseTime <- map["pause_time"]
        isCheckMarkAlreadyDone <- map["is_checkmark_done"]
        isClickOnPause <- map["isClickOnPause"]
        lineDraw <- map["lineDraw"]
        lastPauseTime <- map["lastPauseTime"]
        
        updatedDuration <- map["updated_duration"]
        updatedRest <- map["updated_rest"]
        updatedPercent <- map["updated_percentage"]
        updatedDistance <- map["updated_distance"]

        totalDistance <- map["total_distance"]

    }
}
