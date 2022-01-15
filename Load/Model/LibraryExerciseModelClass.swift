import Foundation 
import ObjectMapper 

class LibraryExerciseModelClass: Mappable { 

	var exercise: String? 
	var mechanics: String? 
	var selected: Bool? 
    var exercisesArray:[ResistanceExerciseModelClass] = [ResistanceExerciseModelClass]()

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		exercise <- map["Exercise"] 
		mechanics <- map["Mechanics"] 
		selected <- map["selected"] 
	}
} 

