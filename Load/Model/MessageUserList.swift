import Foundation 
import ObjectMapper 

class MessageUserList: Mappable { 

	var list: [MessageList]? 
	var count: NSNumber? 

	required init?(map: Map){
	} 

	func mapping(map: Map) {
		list <- map["list"] 
		count <- map["count"] 
	}
} 

class MessageList: Mappable {

	var id: NSNumber? 
	var name: String? 
	var photo: String? 
    var isSelected: Bool = false

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["id"] 
		name <- map["name"] 
		photo <- map["photo"] 
	}
} 

