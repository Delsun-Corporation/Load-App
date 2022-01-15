import Foundation 
import ObjectMapper 

class CardioExerciseModelClass: Mappable { 

	var laps: String? 
	var speed: String?
    var pace: String?
	var percentage: String? 
	var duration: String?
    var distance: String?
	var rest: String?
    var rpm: String?
    var watt: String?
    var lvl: String?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		laps <- map["laps"]
		speed <- map["speed"]
        pace <- map["pace"]
		percentage <- map["percentage"]
		duration <- map["duration"]
        distance <- map["distance"]
		rest <- map["rest"]
        rpm <- map["rpm"]
        watt <- map["watt"]
        lvl <- map["lvl"]
	}
} 

