import Foundation 
import ObjectMapper 

class GetAllDataModelClass: Mappable { 

	var status: NSNumber? 
	var data: DataGetAllDataModelClass?
	var success: Bool? 
	var message: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		status <- map["status"] 
		data <- map["data"] 
		success <- map["success"] 
		message <- map["message"] 
	}
} 

class DataGetAllDataModelClass: Mappable {

    var regions: [Regions]?
	var resistancePresetTrainingProgram: [ResistancePresetTrainingProgram]? 
	var trainingActivity: [TrainingActivity]?
    var trainingProgramActivity: [TrainingActivity]?
	var cardioPresetTrainingProgram: [CardioPresetTrainingProgram]? 
	var accounts: [Accounts]? 
    var trainingGoal: [TrainingGoal]?
    var trainingGoalLogCardio: [TrainingGoalLogCardio]?
    var trainingGoalLogResistance: [TrainingGoalLogResistance]?
    var trainingGoalProgramCardio: [TrainingGoalProgramCardio]?
    var trainingGoalProgramResistance: [TrainingGoalProgramResistance]?
	var trainingIntensity: [TrainingIntensity]?
    var trainingLogStyle: [TrainingLogSwimmingStyle]?
//    var bodyParts: [BodyParts]?
    var category: [Category]?
    var actionForce: [ActionForce]?
    var mechanics: [Mechanics]?
    var ac: [Mechanics]?
    var equipments: [Equipments]?
    var targetedMuscles: [TargetedMuscles]?
    var countries: [Countries]?
    var trainingTypes: [TrainingTypes]?
    var specializations: [Specializations]?
    var services: [Services]?
    var languages: [Languages]?
    var currency: [Currency]?
    var cancellationPolicy: [CancellationPolicy]?
    var availableTimes: [AvailableTimes]?
    var paymentOptions: [PaymentOptions]?
    var professionalTypes: [ProfessionalTypes]?
    var raceDistance: [RaceDistance]?
    var trainingFrequencies: [TrainingFrequencies]?
    var defaultBodyPartImageUrlFront: String?
    var defaultBodyPartImageUrlBack: String?
    var professionalScheduleAdvanceBooking: [ProfessionalScheduleAdvanceBooking]?
    var timeInAdvance: [TimeInAdvance]?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
        regions <- map["regions"]
		resistancePresetTrainingProgram <- map["resistance_preset_training_program"] 
		trainingActivity <- map["training_activity"]
        trainingProgramActivity <- map["training_program_activity"]
		cardioPresetTrainingProgram <- map["cardio_preset_training_program"] 
		accounts <- map["accounts"] 
		trainingGoal <- map["training_goal"]
        trainingGoalLogCardio <- map["training_goal_log_cardio"]
        trainingGoalLogResistance <- map["training_goal_log_resistance"]
        trainingGoalProgramCardio <- map["training_goal_program_cardio"]
        trainingGoalProgramResistance <- map["training_goal_program_resistance"]
		trainingIntensity <- map["training_intensity"]
        trainingLogStyle <- map["training_log_styles"]
//        bodyParts <- map["body_parts"]
        category <- map["category"]
        mechanics <- map["mechanics"]
        actionForce <- map["action_force"]
        equipments <- map["equipments"]
        targetedMuscles <- map["targeted_muscles"]
        countries <- map["countries"]
        trainingTypes <- map["training_types"]
        specializations <- map["specializations"]
        services <- map["services"]
        languages <- map["languages"]
        currency <- map["currency"]
        cancellationPolicy <- map["cancellation_policy"]
        availableTimes <- map["available_times"]
        paymentOptions <- map["payment_options"]
        professionalTypes <- map["professional_types"]
        raceDistance <- map["race_distance"]
        trainingFrequencies <- map["training_frequencies"]
        defaultBodyPartImageUrlFront <- map["default_body_part_image_url_front"]
        defaultBodyPartImageUrlBack <- map["default_body_part_image_url_back"]
        professionalScheduleAdvanceBooking <- map["professional_schedule_advance_booking"]
        timeInAdvance <- map["time_in_advance"]
	}
    
    func getSortedCategory() -> [Category] {
        let sortedCategory = category?.sorted(by: { lhs, rhs in
            return lhs.sequence ?? 0 < rhs.sequence ?? 0
        })
        return sortedCategory ?? []
    }
}

class TimeInAdvance: Mappable {
    required init?(map: Map) {
        //
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
    }
    
    var id: String?
    var name: String?
    var code: String?
    var isActive: Bool?
    
    
}

class Regions: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var createdAt: String?
    var updatedAt: String?
    var parentId: NSNumber?
    var type: String?
    var image: String?
    var secondaryImage: String?
    var sequence : Int?
    var is_region : Int?

    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
        parentId <- map["parent_id"]
        type <- map["type"]
        image <- map["image"]
        secondaryImage <- map["secondary_image"]
        sequence <- map["sequence"]
        is_region <- map["is_region"]
        
    }
}

class TrainingFrequencies: Mappable {
    
    var id: NSNumber?
    var title: String?
    var code: String?
    var presetTrainingProgramIds: [String]?
    var maxDays: NSNumber?
    var isActive: Bool?
    var createdAt: Any?
    var updatedAt: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        code <- map["code"]
        presetTrainingProgramIds <- map["preset_training_program_ids"]
        maxDays <- map["max_days"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class TrainingIntensity: Mappable { 

	var updatedAt: String? 
	var code: String? 
	var createdAt: String? 
	var id: NSNumber? 
	var isActive: NSNumber? 
	var name: String? 
    var targetHr: String?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		updatedAt <- map["updated_at"] 
		code <- map["code"] 
		createdAt <- map["created_at"] 
		id <- map["id"] 
		isActive <- map["is_active"] 
		name <- map["name"]
        targetHr <- map["target_hr"]
	}
}

class TrainingLogSwimmingStyle: Mappable{
    
    var code: String?
    var isActive: NSNumber?
    var updatedAt: String?
    var name: String?
    var createdAt: String?
    var id: NSNumber?
    
    required init?(map: Map){
    }

    func mapping(map: Map) {
        isActive <- map["is_active"]
        updatedAt <- map["updated_at"]
        name <- map["name"]
        createdAt <- map["created_at"]
        id <- map["id"]
        code <- map["code"]
    }
}

class TrainingGoal: Mappable { 

	var isActive: NSNumber? 
	var updatedAt: String? 
	var name: String? 
	var createdAt: String? 
	var id: NSNumber? 
	var code: String? 
	var targetHr: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		isActive <- map["is_active"] 
		updatedAt <- map["updated_at"] 
		name <- map["name"] 
		createdAt <- map["created_at"] 
		id <- map["id"] 
		code <- map["code"] 
		targetHr <- map["target_hr"] 
	}
}

class TrainingGoalLogCardio: Mappable {
    
    var name: String?
    var isActive: Bool?
    var trainingIntensityIds: [String]?
    var updatedAt: String?
    var targetHr: String?
    var code: String?
    var displayAt: [String]?
    var id: NSNumber?
    var sequence: NSNumber?
    var createdAt: String?
    var trainingActivityIds: [String]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        isActive <- map["is_active"]
        trainingIntensityIds <- map["training_intensity_ids"]
        trainingActivityIds <- map["training_activity_ids"]
        updatedAt <- map["updated_at"]
        targetHr <- map["target_hr"]
        code <- map["code"]
        displayAt <- map["display_at"]
        id <- map["id"]
        sequence <- map["sequence"]
        createdAt <- map["created_at"]
    }
}

class TrainingGoalLogResistance: Mappable {
    
    var isActive: NSNumber?
    var trainingIntensityIds: [String]?
    var updatedAt: String?
    var name: String?
    var createdAt: String?
    var id: NSNumber?
    var code: String?
    var targetHr: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        isActive <- map["is_active"]
        trainingIntensityIds <- map["training_intensity_ids"]
        updatedAt <- map["updated_at"]
        name <- map["name"]
        createdAt <- map["created_at"]
        id <- map["id"]
        code <- map["code"]
        targetHr <- map["target_hr"]
    }
}

class TrainingGoalProgramCardio: Mappable {
    
    var isActive: NSNumber?
    var updatedAt: String?
    var name: String?
    var createdAt: String?
    var id: NSNumber?
    var code: String?
    var targetHr: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        isActive <- map["is_active"]
        updatedAt <- map["updated_at"]
        name <- map["name"]
        createdAt <- map["created_at"]
        id <- map["id"]
        code <- map["code"]
        targetHr <- map["target_hr"]
    }
}

class TrainingGoalProgramResistance: Mappable {
    
    var isActive: NSNumber?
    var updatedAt: String?
    var name: String?
    var createdAt: String?
    var id: NSNumber?
    var code: String?
    var targetHr: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        isActive <- map["is_active"]
        updatedAt <- map["updated_at"]
        name <- map["name"]
        createdAt <- map["created_at"]
        id <- map["id"]
        code <- map["code"]
        targetHr <- map["target_hr"]
    }
}

class Accounts: Mappable { 

	var isActive: NSNumber? 
	var updatedAt: String? 
	var name: String? 
	var createdAt: String? 
	var id: NSNumber?
    var idStr: String?
	var code: String?
	var freeTrialDays: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		isActive <- map["is_active"] 
		updatedAt <- map["updated_at"] 
		name <- map["name"] 
		createdAt <- map["created_at"]
        idStr <- map["_id"]
        id <- map["id"]
		code <- map["code"] 
		freeTrialDays <- map["free_trial_days"] 
	}
} 

class CardioPresetTrainingProgram: Mappable {
    
    var id: NSNumber?
    var title: String?
    var subtitle: String?
    var status: String?
    var type: String?
    var isActive: NSNumber?
    var weeks: NSNumber?
    var createdAt: String?
    var updatedAt: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        subtitle <- map["subtitle"]
        status <- map["status"]
        type <- map["type"]
        isActive <- map["is_active"]
        weeks <- map["weeks"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}


class TrainingActivity: Mappable { 

	var isActive: NSNumber? 
	var updatedAt: String? 
	var name: String? 
	var iconPath: String?
    var iconPathRed: String?
    var iconPathWhite: String?
	var createdAt: String? 
	var id: NSNumber? 
	var code: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		isActive <- map["is_active"] 
		updatedAt <- map["updated_at"] 
		name <- map["name"] 
		iconPath <- map["icon_path"]
        iconPathRed <- map["icon_path_red"]
		createdAt <- map["created_at"] 
		id <- map["id"] 
		code <- map["code"]
        iconPathWhite <- map["icon_path_white"]
	}
} 

class ResistancePresetTrainingProgram: Mappable { 

    var id: NSNumber?
    var title: String?
    var subtitle: String?
    var status: String?
    var type: String?
    var isActive: NSNumber?
    var weeks: NSNumber?
    var createdAt: String?
    var updatedAt: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        subtitle <- map["subtitle"]
        status <- map["status"]
        type <- map["type"]
        isActive <- map["is_active"]
        weeks <- map["weeks"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
} 

class BodyParts: Mappable {
    
    var id: NSNumber?
    var parentId: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var updatedAt: Any?
    var createdAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        parentId <- map["parent_id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        updatedAt <- map["updated_at"]
        createdAt <- map["created_at"]
    }
}

class Category: Mappable {
    
    var id: NSNumber?
    var parentId: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var updatedAt: Any?
    var createdAt: Any?
    var sequence: Int?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        parentId <- map["parent_id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        updatedAt <- map["updated_at"]
        createdAt <- map["created_at"]
        sequence <- map["sequence"]
    }
}


class Mechanics: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var createdAt: Any?
    var updatedAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}


class ActionForce: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var createdAt: Any?
    var updatedAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class Equipments: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var updatedAt: Any?
    var createdAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        updatedAt <- map["updated_at"]
        createdAt <- map["created_at"]
    }
}

class TargetedMuscles: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var updatedAt: String?
    var createdAt: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        updatedAt <- map["updated_at"]
        createdAt <- map["created_at"]
    }
}


class Countries: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var countryCode: String?
    var isActive: NSNumber?
    var createdAt: Any?
    var updatedAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        countryCode <- map["country_code"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class TrainingTypes: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var sequence: NSNumber?
    var isActive: NSNumber?
    var createdAt: Any?
    var updatedAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        sequence <- map["sequence"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class Specializations: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var createdAt: Any?
    var updatedAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class Services: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var createdAt: Any?
    var updatedAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class Languages: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var createdAt: Any?
    var updatedAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class Currency: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: Bool?
    var createdAt: Any?
    var updatedAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class CancellationPolicy: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var description: String?
    var isActive: Bool?
    var createdAt: String?
    var updatedAt: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        description <- map["description"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class AvailableTimes: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: Bool?
    var createdAt: String?
    var updatedAt: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class PaymentOptions: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var description: String?
    var isActive: Bool?
    var createdAt: String?
    var updatedAt: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        description <- map["description"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class ProfessionalTypes: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var description: String?
    var isActive: Bool?
    var createdAt: String?
    var updatedAt: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        description <- map["description"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class RaceDistance: Mappable {
    
    var id: NSNumber?
    var name: String?
    var code: String?
    var isActive: NSNumber?
    var createdAt: Any?
    var updatedAt: Any?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        isActive <- map["is_active"]
        createdAt <- map["created_at"]
        updatedAt <- map["updated_at"]
    }
}

class EventTypesModel: Mappable {
    
    var updatedAt: String?
    var code: String?
    var createdAt: String?
    var id: NSNumber?
    var isActive: NSNumber?
    var name: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        updatedAt <- map["updated_at"]
        code <- map["code"]
        createdAt <- map["created_at"]
        id <- map["id"]
        isActive <- map["is_active"]
        name <- map["name"]
    }
}


class ProfessionalScheduleAdvanceBooking: Mappable {
    
    var id: Int?
    var description: String?
    var isActive: NSNumber?
    var selected: Int = 0
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        description <- map["description"]
        id <- map["id"]
        isActive <- map["is_active"]
        selected <- map["selected"]
    }
}
