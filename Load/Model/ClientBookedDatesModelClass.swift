import Foundation 
import ObjectMapper 

class ClientBookedDatesModelClass: Mappable { 

	var count: NSNumber? 
	var list: [ClientBookedDatesList]?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		count <- map["count"] 
		list <- map["list"] 
	}
} 

class ClientBookedDatesList: Mappable { 

	var notes: String? 
	var id: NSNumber? 
	var confirmedStatus: NSNumber? 
	var toId: NSNumber? 
	var updatedAt: String? 
	var availableTimeDetail: AvailableTimeDetail? 
	var availableTimeId: NSNumber? 
	var createdAt: String? 
	var fromId: NSNumber? 
	var fromUserDetail: FromUserDetail? 
	var selectedDate: String? 
	var toUserDetail: ToUserDetail? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		notes <- map["notes"] 
		id <- map["id"] 
		confirmedStatus <- map["confirmed_status"] 
		toId <- map["to_id"] 
		updatedAt <- map["updated_at"] 
		availableTimeDetail <- map["available_time_detail"] 
		availableTimeId <- map["available_time_id"] 
		createdAt <- map["created_at"] 
		fromId <- map["from_id"] 
		fromUserDetail <- map["from_user_detail"] 
		selectedDate <- map["selected_date"] 
		toUserDetail <- map["to_user_detail"] 
	}
} 

class ToUserDetail: Mappable { 

	var name: String? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		name <- map["name"] 
		id <- map["id"] 
	}
} 

class FromUserDetail: Mappable { 

	var name: String? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		name <- map["name"] 
		id <- map["id"] 
	}
} 

class AvailableTimeDetail: Mappable { 

	var isActive: NSNumber? 
	var updatedAt: Any? 
	var name: String? 
	var code: String? 
	var createdAt: Any? 
	var id: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		isActive <- map["is_active"] 
		updatedAt <- map["updated_at"] 
		name <- map["name"] 
		code <- map["code"] 
		createdAt <- map["created_at"] 
		id <- map["id"] 
	}
} 

