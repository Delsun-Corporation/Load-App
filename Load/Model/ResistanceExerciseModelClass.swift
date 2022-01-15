import Foundation 
import ObjectMapper 

class ResistanceExerciseModelClass: Mappable { 

	var weight: String? 
	var reps: String?
    var duration: String?
	var rest: String? 
    var isCompleted: Bool?

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		weight <- map["Weight"] 
		reps <- map["Reps"]
        duration <- map["duration"]
		rest <- map["Rest"]
        isCompleted <- map["is_completed"]
	}
} 
