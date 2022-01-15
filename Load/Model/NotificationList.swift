import Foundation 
import ObjectMapper 

class NotificationListModelClass: Mappable { 

	var list: [NotificationList]?
	var count: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		list <- map["list"] 
		count <- map["count"] 
	}
} 

class NotificationList: Mappable { 

	var body: String?
	var title: String? 
	var readAt: String? 
	var userId: NSNumber? 
	var message: String? 
	var updatedAt: String? 
	var id: NSNumber? 
	var createdAt: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		body <- map["body"] 
		title <- map["title"] 
		readAt <- map["read_at"] 
		userId <- map["user_id"] 
		message <- map["message"] 
		updatedAt <- map["updated_at"] 
		id <- map["id"] 
		createdAt <- map["created_at"] 
	}
} 

