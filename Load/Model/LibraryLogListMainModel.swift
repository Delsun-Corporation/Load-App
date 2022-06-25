import Foundation 
import ObjectMapper 

class LibraryLogListMainModel: Mappable { 

	var count: NSNumber? 
	var list: [LibraryLogList]?
    var index: NSNumber?
    
	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		count <- map["count"] 
		list <- map["list"] 
	}
} 

class LibraryLogList: Mappable {
    var categoryId: NSNumber?
    var createdAt: String?
    var mechanicsId: NSNumber?
    var actionForceId: NSNumber?
    var equipmentIds: [String]?
    var targetedMusclesIds: [String]?
    var id: Int?
    var userId: Int?
    var exerciseName: String?
    var mechanicDetail: LibraryLogListMechanicDetail?
    var isActive: NSNumber?
    var bodyImageType: String?
    var updatedAt: String?
    var regionsIds: [String]?
    var subHeaderId: NSNumber?
    var isFavorite: NSNumber?
    var selected:Bool = false
    var exercisesArray:[ResistanceExerciseModelClass] = [ResistanceExerciseModelClass]()
    var repetitionMax: [RepetitionMax]?
    var isShowAlertOrNot:Bool = false
    var regionsPrimarySelectionIds: [String] = []
    var regionsSecondarySelectionIds: [String] = []
    var exerciseLink: String?
    var commonLibraryId = 0
    var libraryId = 0
    var isEdit = false
    var motion = ""
    var movement = ""
    
	required init?(map: Map){
	} 

	func mapping(map: Map) {
        categoryId <- map["category_id"]
        createdAt <- map["created_at"]
        mechanicsId <- map["mechanics_id"]
        actionForceId <- map["action_force_id"]
        equipmentIds <- map["equipment_ids"]
        targetedMusclesIds <- map["targeted_muscles_ids"]
        id <- map["id"]
        userId <- map["user_id"]
        exerciseName <- map["exercise_name"]
        mechanicDetail <- map["mechanic_detail"]
        isActive <- map["is_active"]
        bodyImageType <- map["body_image_type"]
        updatedAt <- map["updated_at"]
        regionsIds <- map["regions_ids"]
        subHeaderId <- map["sub_header_id"]
        isFavorite <- map["is_favorite"]
        selected <- map["selected"]
        repetitionMax <- map["repetition_max"]
        isShowAlertOrNot <- map["is_show_again_message"]
        regionsPrimarySelectionIds <- map["regions_ids"]
        regionsSecondarySelectionIds <- map["regions_secondary_ids"]
        exerciseLink <- map["exercise_link"]
        commonLibraryId <- map["common_library_id"]
        libraryId <- map["library_id"]
        isEdit  <-  map["is_edit"]
        motion <- map["motion"]
        movement <- map["movement"]
	}
} 

class LibraryLogListMechanicDetail: Mappable {

	var code: String? 
	var id: NSNumber? 
	var isActive: NSNumber? 
	var name: String? 
	var updatedAt: Any? 
	var createdAt: Any? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		code <- map["code"] 
		id <- map["id"] 
		isActive <- map["is_active"] 
		name <- map["name"] 
		updatedAt <- map["updated_at"] 
		createdAt <- map["created_at"] 
	}
} 

