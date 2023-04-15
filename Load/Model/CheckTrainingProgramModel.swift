import Foundation 
import ObjectMapper 

class CheckTrainingProgramModel: Mappable { 

	var data: checkTrainngProgramVisibilityData?
	var message: String = ""
	var success: Bool = false
    var status: Int = 0

	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		data <- map["data"]
        status <- map["status"]
		message <- map["message"] 
		success <- map["success"] 
	}
} 

class checkTrainngProgramVisibilityData: Mappable {

	var isResistanceCustomEdit: Bool = false
	var isResistancePresetDelete: Bool = false
	var isCardioCustomEdit: Bool = false
	var isCardioPresetDelete: Bool = false
	var isResistance: Bool = false
	var isCardio: Bool = false
    var cardioPresetDeleteId = 0
    var resistancePresetDeleteId  = 0
    var cardioCustomEditId = 0
    var resistanceCustomEditId = 0
    
	required init?(map: Map){ 
	} 

	func mapping(map: Map) {
		isResistanceCustomEdit <- map["is_resistance_custom_edit"] 
		isResistancePresetDelete <- map["is_resistance_preset_delete"] 
		isCardioCustomEdit <- map["is_cardio_custom_edit"] 
		isCardioPresetDelete <- map["is_cardio_preset_delete"] 
		isResistance <- map["is_resistance"] 
		isCardio <- map["is_cardio"]
        cardioPresetDeleteId <- map["cardio_preset_delete_id"]
        resistancePresetDeleteId <- map["resistance_preset_delete_id"]
        cardioCustomEditId <- map["cardio_custom_edit_id"]
        resistanceCustomEditId <- map["resistance_custom_edit_id"]
	}
} 

