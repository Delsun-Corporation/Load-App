import Foundation 
import ObjectMapper 

class LibraryListPreviewModelClass: Mappable { 

	var id: NSNumber? 
	var actionForceId: NSNumber? 
	var bodyPartId: NSNumber? 
	var repetitionMax: [RepetitionMax]? 
	var targetedMusclesIds: [Int]?
    var targetedMuscle: String?
	var mechanicsId: NSNumber? 
	var isFavorite: NSNumber? 
	var regionId: NSNumber? 
	var updatedAt: String? 
	var bodySubPartId: NSNumber? 
	var createdAt: String? 
	var exerciseName: String? 
	var isActive: NSNumber? 
	var equipmentIds: [String]?
	var userId: NSNumber?
    var exerciseLink: String?
    var categoryId: NSNumber?
    var regionsIds: [String] = []
    var selectedRM: String?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		actionForceId <- map["action_force_id"] 
		bodyPartId <- map["body_part_id"] 
		repetitionMax <- map["repetition_max"] 
		targetedMusclesIds <- map["targeted_muscles_ids"]
        targetedMuscle <- map["targeted_muscle"]
		mechanicsId <- map["mechanics_id"] 
		isFavorite <- map["is_favorite"] 
		regionId <- map["region_id"] 
		updatedAt <- map["updated_at"] 
		bodySubPartId <- map["body_sub_part_id"] 
		createdAt <- map["created_at"] 
		exerciseName <- map["exercise_name"] 
		isActive <- map["is_active"] 
		equipmentIds <- map["equipment_ids"]
		userId <- map["user_id"]
        exerciseLink <- map["exercise_link"]
        categoryId <- map["category_id"]
        regionsIds <- map["regions_ids"]
        selectedRM <- map["selected_rm"]
	}
} 

class RepetitionMax: Mappable { 

	var actWeight: String? 
	var name: String? 
	var estWeight: String?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		actWeight <- map["act_weight"] 
		name <- map["name"] 
		estWeight <- map["est_weight"] 
	}
} 
