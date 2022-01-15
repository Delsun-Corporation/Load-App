import Foundation 
import ObjectMapper 

class ProfessionUserListModel: Mappable { 

	var success: Bool? 
	var status: NSNumber? 
	var data: [ProfessionalList]?
	var message: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		success <- map["success"] 
		status <- map["status"] 
		data <- map["data"] 
		message <- map["message"] 
	}
} 

class ProfessionalList: Mappable {

	var id: Int?
	var userId: Int? 
	var profession: String? 
	var introduction: String? 
	var specializationIds: [SpecializationDetails]?
	var rate: String? 
	var isBookmarked: Bool? 
	var userDetail: UserDetail? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		userId <- map["user_id"] 
		profession <- map["profession"] 
		introduction <- map["introduction"] 
		specializationIds <- map["specialization_details"]
		rate <- map["rate"] 
		isBookmarked <- map["is_bookmarked"] 
		userDetail <- map["user_detail"] 
	}
} 
