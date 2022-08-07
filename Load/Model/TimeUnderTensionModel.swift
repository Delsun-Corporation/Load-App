import Foundation 
import ObjectMapper 

class TimeUnderTensionModel: Mappable { 

	var success: Bool? 
	var status: NSNumber? 
	var data: [TimeUnderTensionList]?
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

class TimeUnderTensionList: Mappable {

	var id: String?
	var intensity: String = ""
	var description: String = ""
	var tempo: String = ""
	var userUpdatedTempo: String = ""
    var selectedIndex = 0
    //add time under tension id for update
    var timeUnderTensionId: String = ""

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		id <- map["_id"]
		intensity <- map["intensity"]
		description <- map["description"] 
		tempo <- map["tempo"]
		userUpdatedTempo <- map["user_updated_tempo"]
        selectedIndex <- map["selected"]
        timeUnderTensionId <- map["time_under_tention_id"]
	}
}

struct TimeUnderTensionPostViewModel {
    let id: String
    let userUpdatedTempo: String
}

