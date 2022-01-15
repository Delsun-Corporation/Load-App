import Foundation 
import ObjectMapper 

class CommonRepetitionMax: Mappable { 

	var updatedAt: String? 
	var id: NSNumber? 
	var createdAt: String?
    var selectedRM: String?
	var repetitionMax: [RepetitionMax]? 
	var commonLibrariesId: NSNumber? 
	var userId: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		updatedAt <- map["updated_at"] 
		id <- map["id"] 
		createdAt <- map["created_at"]
        selectedRM <- map["selected_rm"]
		repetitionMax <- map["repetition_max"] 
		commonLibrariesId <- map["common_libraries_id"] 
		userId <- map["user_id"] 
	}
}
