import Foundation 
import ObjectMapper 

class LibraryFavoriteListModelClass: Mappable { 

	var count: NSNumber? 
	var list: [FavoriteList]?
    var index:NSNumber?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		count <- map["count"] 
		list <- map["list"] 
	}
} 

class FavoriteList: Mappable {

    var categoryId: NSNumber?
    var createdAt: String?
    var mechanicsId: NSNumber?
    var actionForceId: NSNumber?
    var equipmentIds: [Int]?
    var targetedMusclesIds: [String]?
    var id: NSNumber?
    var userId: NSNumber?
    var exerciseName: String?
    var mechanicDetail: LibraryLogListMechanicDetail?
    var isActive: NSNumber?
    var bodyImageType: String?
    var updatedAt: String?
    var regionsIds: [String]?
    var subHeaderId: NSNumber?
    var isFavorite: NSNumber?
    var selected:Bool = false


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
	}
} 

class MechanicDetailFavorite: Mappable {

	var id: NSNumber? 
	var createdAt: Any? 
	var name: String? 
	var updatedAt: Any? 
	var isActive: Bool? 
	var code: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		createdAt <- map["created_at"] 
		name <- map["name"] 
		updatedAt <- map["updated_at"] 
		isActive <- map["is_active"] 
		code <- map["code"] 
	}
} 

