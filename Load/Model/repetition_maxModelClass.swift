import Foundation 
import ObjectMapper 

class RepetitionMaxModelClass: Mappable { 

	var name: String? 
	var estWeight: NSNumber? 
	var actWeight: NSNumber? 

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		name <- map["name"] 
		estWeight <- map["est_weight"] 
		actWeight <- map["act_weight"] 
	}
} 

