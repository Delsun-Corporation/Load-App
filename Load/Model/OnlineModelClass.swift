import Foundation 
import ObjectMapper 

class OnlineModelClass: Mappable { 

	var status: NSNumber? 
	var id: String? 
	var message: String? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		status <- map["status"] 
		id <- map["id"] 
		message <- map["message"] 
	}
} 

