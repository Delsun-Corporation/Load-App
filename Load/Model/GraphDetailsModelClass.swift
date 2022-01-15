import Foundation 
import ObjectMapper 

class GraphDetailsModelClass: Mappable { 

	var totalVolume: NSNumber? 
	var date: String? 
    var dateConv: String?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		totalVolume <- map["total_volume"] 
		date <- map["date"] 
	}
} 

